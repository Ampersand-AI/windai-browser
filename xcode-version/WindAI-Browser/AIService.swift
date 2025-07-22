import Foundation
import Network

// MARK: - AI Models Configuration
enum AIModel: String, CaseIterable {
    case qwen = "qwen/qwen-2.5-72b-instruct"
    case mistral = "mistralai/mistral-7b-instruct"
    case deepseek = "deepseek/deepseek-r1"
    
    var displayName: String {
        switch self {
        case .qwen: return "Qwen 2.5 72B Instruct"
        case .mistral: return "Mistral 7B Instruct"
        case .deepseek: return "DeepSeek R1"
        }
    }
    
    var priority: Int {
        switch self {
        case .qwen: return 1      // Primary
        case .mistral: return 2   // Fallback 1
        case .deepseek: return 3  // Fallback 2
        }
    }
}

// MARK: - API Response Models
struct OpenRouterResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage?
    
    struct Choice: Codable {
        let index: Int
        let message: Message
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index, message
            case finishReason = "finish_reason"
        }
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

struct OpenRouterError: Codable {
    let error: ErrorDetail
    
    struct ErrorDetail: Codable {
        let code: String
        let message: String
    }
}

// MARK: - AI Service Class
class AIService: ObservableObject {
    static let shared = AIService()
    
    // MARK: - Properties
    private let apiKey: String
    private let baseURL = "https://openrouter.ai/api/v1"
    private let session: URLSession
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true
    @Published var currentModel: AIModel = .qwen
    @Published var isLoading = false
    @Published var lastError: String?
    
    // MARK: - Initialization
    private init() {
        // Your OpenRouter API Key
        self.apiKey = "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"
        
        // Configure URLSession with timeout and retry policies
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
        
        // Start network monitoring
        startNetworkMonitoring()
        
        // Test API connection on initialization
        Task {
            await testConnection()
        }
    }
    
    deinit {
        monitor.cancel()
    }
    
    // MARK: - Network Monitoring
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    // MARK: - API Connection Testing
    func testConnection() async -> Bool {
        print("🔍 Testing OpenRouter API connection...")
        
        guard isConnected else {
            await MainActor.run {
                self.lastError = "No internet connection"
            }
            return false
        }
        
        // Test with a simple request
        let testMessage = "Hello, this is a connection test."
        let result = await sendMessage(testMessage, model: .qwen)
        
        switch result {
        case .success:
            print("✅ OpenRouter API connection successful!")
            await MainActor.run {
                self.lastError = nil
            }
            return true
        case .failure(let error):
            print("❌ OpenRouter API connection failed: \(error.localizedDescription)")
            await MainActor.run {
                self.lastError = error.localizedDescription
            }
            return false
        }
    }
    
    // MARK: - Main Chat Function with Fallback System
    func chat(message: String) async -> Result<String, Error> {
        await MainActor.run {
            self.isLoading = true
            self.lastError = nil
        }
        
        defer {
            Task { @MainActor in
                self.isLoading = false
            }
        }
        
        // Try models in priority order
        let sortedModels = AIModel.allCases.sorted { $0.priority < $1.priority }
        
        for model in sortedModels {
            print("🤖 Trying \(model.displayName)...")
            
            let result = await sendMessage(message, model: model)
            
            switch result {
            case .success(let response):
                await MainActor.run {
                    self.currentModel = model
                }
                print("✅ Success with \(model.displayName)")
                return .success(response)
                
            case .failure(let error):
                print("❌ Failed with \(model.displayName): \(error.localizedDescription)")
                
                // If this is the last model, return the error
                if model == sortedModels.last {
                    await MainActor.run {
                        self.lastError = "All AI models failed. Last error: \(error.localizedDescription)"
                    }
                    return .failure(error)
                }
                
                // Continue to next model
                continue
            }
        }
        
        // This should never be reached, but just in case
        let fallbackError = NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "All AI models failed"])
        return .failure(fallbackError)
    }
    
    // MARK: - Send Message to Specific Model
    private func sendMessage(_ message: String, model: AIModel) async -> Result<String, Error> {
        guard !apiKey.isEmpty else {
            return .failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not configured"]))
        }
        
        guard isConnected else {
            return .failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
        }
        
        // Prepare request
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            return .failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("WindAI-Browser/1.0 (Neural Arc Inc)", forHTTPHeaderField: "User-Agent")
        request.setValue("https://github.com/Ampersand-AI/windai-browser", forHTTPHeaderField: "HTTP-Referer")
        
        // Prepare request body
        let requestBody: [String: Any] = [
            "model": model.rawValue,
            "messages": [
                [
                    "role": "user",
                    "content": message
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.7,
            "top_p": 1.0,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.0
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            return .failure(error)
        }
        
        // Send request with retry logic
        return await sendRequestWithRetry(request: request, retries: 3)
    }
    
    // MARK: - Request with Retry Logic
    private func sendRequestWithRetry(request: URLRequest, retries: Int) async -> Result<String, Error> {
        for attempt in 1...retries {
            print("📡 Attempt \(attempt)/\(retries) - Sending request to OpenRouter...")
            
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }
                
                print("📊 HTTP Status: \(httpResponse.statusCode)")
                
                // Handle different status codes
                switch httpResponse.statusCode {
                case 200:
                    // Success - parse response
                    return parseSuccessResponse(data: data)
                    
                case 401:
                    let error = NSError(domain: "AIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key"])
                    return .failure(error)
                    
                case 429:
                    // Rate limited - wait and retry
                    if attempt < retries {
                        print("⏳ Rate limited, waiting 2 seconds before retry...")
                        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                        continue
                    } else {
                        let error = NSError(domain: "AIService", code: 429, userInfo: [NSLocalizedDescriptionKey: "Rate limit exceeded"])
                        return .failure(error)
                    }
                    
                case 500...599:
                    // Server error - retry
                    if attempt < retries {
                        print("🔄 Server error, retrying in 1 second...")
                        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                        continue
                    } else {
                        let error = NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                        return .failure(error)
                    }
                    
                default:
                    // Parse error response
                    return parseErrorResponse(data: data, statusCode: httpResponse.statusCode)
                }
                
            } catch {
                print("❌ Network error: \(error.localizedDescription)")
                
                if attempt < retries {
                    print("🔄 Retrying in 1 second...")
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    continue
                } else {
                    return .failure(error)
                }
            }
        }
        
        // This should never be reached
        let error = NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Max retries exceeded"])
        return .failure(error)
    }
    
    // MARK: - Response Parsing
    private func parseSuccessResponse(data: Data) -> Result<String, Error> {
        do {
            let response = try JSONDecoder().decode(OpenRouterResponse.self, from: data)
            
            guard let firstChoice = response.choices.first else {
                let error = NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response choices"])
                return .failure(error)
            }
            
            let content = firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Log usage if available
            if let usage = response.usage {
                print("📊 Token usage - Prompt: \(usage.promptTokens), Completion: \(usage.completionTokens), Total: \(usage.totalTokens)")
            }
            
            return .success(content)
            
        } catch {
            print("❌ JSON parsing error: \(error)")
            return .failure(error)
        }
    }
    
    private func parseErrorResponse(data: Data, statusCode: Int) -> Result<String, Error> {
        do {
            let errorResponse = try JSONDecoder().decode(OpenRouterError.self, from: data)
            let error = NSError(domain: "AIService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.error.message])
            return .failure(error)
        } catch {
            // If we can't parse the error, return a generic one
            let error = NSError(domain: "AIService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(statusCode) error"])
            return .failure(error)
        }
    }
    
    // MARK: - Specialized AI Functions
    func analyzePage(url: String, content: String) async -> Result<String, Error> {
        let prompt = """
        Please analyze this webpage and provide a helpful summary:
        
        URL: \(url)
        Content: \(content.prefix(2000))...
        
        Provide a concise analysis including:
        1. Main topic/purpose
        2. Key information
        3. Relevance/usefulness
        """
        
        return await chat(message: prompt)
    }
    
    func summarizePage(content: String) async -> Result<String, Error> {
        let prompt = """
        Please provide a concise summary of this webpage content:
        
        \(content.prefix(3000))...
        
        Focus on the main points and key information.
        """
        
        return await chat(message: prompt)
    }
    
    func answerQuestion(question: String, context: String = "") async -> Result<String, Error> {
        let prompt = context.isEmpty ? question : """
        Based on this context: \(context.prefix(1000))...
        
        Question: \(question)
        """
        
        return await chat(message: prompt)
    }
}

// MARK: - Extensions
extension AIService {
    var statusDescription: String {
        if !isConnected {
            return "No internet connection"
        } else if isLoading {
            return "Processing with \(currentModel.displayName)..."
        } else if let error = lastError {
            return "Error: \(error)"
        } else {
            return "Ready - \(currentModel.displayName)"
        }
    }
    
    var isReady: Bool {
        return isConnected && !isLoading && lastError == nil
    }
}

