import Cocoa
import WebKit
import SwiftUI

class ViewController: NSViewController {
    
    // MARK: - UI Components
    @IBOutlet weak var toolbarView: NSView!
    @IBOutlet weak var addressBar: NSTextField!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBOutlet weak var reloadButton: NSButton!
    @IBOutlet weak var aiButton: NSButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var aiSidebar: NSView!
    @IBOutlet weak var aiChatView: NSTextView!
    @IBOutlet weak var aiInputField: NSTextField!
    @IBOutlet weak var aiSendButton: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!
    
    // MARK: - Properties
    private var aiService = AIService.shared
    private var isSidebarVisible = false
    private var currentURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        setupAI()
        loadHomePage()
    }
    
    override func loadView() {
        // Create the main view programmatically since we don't have a storyboard
        view = NSView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        setupViewsFromCode()
    }
    
    // MARK: - UI Setup
    private func setupViewsFromCode() {
        // Create toolbar
        toolbarView = NSView()
        toolbarView.wantsLayer = true
        toolbarView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarView)
        
        // Create navigation buttons
        backButton = NSButton()
        backButton.title = "←"
        backButton.target = self
        backButton.action = #selector(goBack)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(backButton)
        
        forwardButton = NSButton()
        forwardButton.title = "→"
        forwardButton.target = self
        forwardButton.action = #selector(goForward)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(forwardButton)
        
        reloadButton = NSButton()
        reloadButton.title = "⟳"
        reloadButton.target = self
        reloadButton.action = #selector(reload)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(reloadButton)
        
        // Create address bar
        addressBar = NSTextField()
        addressBar.placeholderString = "Enter URL or search..."
        addressBar.target = self
        addressBar.action = #selector(navigate)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(addressBar)
        
        // Create AI button
        aiButton = NSButton()
        aiButton.title = "🤖 AI"
        aiButton.target = self
        aiButton.action = #selector(toggleAI)
        aiButton.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(aiButton)
        
        // Create web view
        let webConfig = WKWebViewConfiguration()
        webConfig.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Create AI sidebar (initially hidden)
        aiSidebar = NSView()
        aiSidebar.wantsLayer = true
        aiSidebar.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        aiSidebar.isHidden = true
        aiSidebar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aiSidebar)
        
        // Create AI chat view
        let scrollView = NSScrollView()
        aiChatView = NSTextView()
        aiChatView.isEditable = false
        aiChatView.string = "🤖 WindAI Assistant\n\nHello! I'm your AI assistant powered by multiple models:\n• Qwen 2.5 72B Instruct\n• Mistral 7B Instruct\n• DeepSeek R1\n\nHow can I help you today?"
        scrollView.documentView = aiChatView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        aiSidebar.addSubview(scrollView)
        
        // Create AI input field
        aiInputField = NSTextField()
        aiInputField.placeholderString = "Ask AI anything..."
        aiInputField.target = self
        aiInputField.action = #selector(sendAIMessage)
        aiInputField.translatesAutoresizingMaskIntoConstraints = false
        aiSidebar.addSubview(aiInputField)
        
        // Create AI send button
        aiSendButton = NSButton()
        aiSendButton.title = "Send"
        aiSendButton.target = self
        aiSendButton.action = #selector(sendAIMessage)
        aiSendButton.translatesAutoresizingMaskIntoConstraints = false
        aiSidebar.addSubview(aiSendButton)
        
        // Create status label
        statusLabel = NSTextField()
        statusLabel.isEditable = false
        statusLabel.isBordered = false
        statusLabel.backgroundColor = .clear
        statusLabel.stringValue = "Ready"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Toolbar constraints
            toolbarView.topAnchor.constraint(equalTo: view.topAnchor),
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: 60),
            
            // Navigation buttons
            backButton.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            forwardButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            forwardButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 40),
            
            reloadButton.leadingAnchor.constraint(equalTo: forwardButton.trailingAnchor, constant: 10),
            reloadButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 40),
            
            // Address bar
            addressBar.leadingAnchor.constraint(equalTo: reloadButton.trailingAnchor, constant: 20),
            addressBar.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),
            addressBar.trailingAnchor.constraint(equalTo: aiButton.leadingAnchor, constant: -20),
            
            // AI button
            aiButton.trailingAnchor.constraint(equalTo: toolbarView.trailingAnchor, constant: -20),
            aiButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),
            aiButton.widthAnchor.constraint(equalToConstant: 80),
            
            // Web view
            webView.topAnchor.constraint(equalTo: toolbarView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            // Status label
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        // Web view trailing constraint (will be updated when sidebar is shown)
        updateWebViewConstraints()
    }
    
    private func updateWebViewConstraints() {
        webView.trailingAnchor.constraint(equalTo: isSidebarVisible ? aiSidebar.leadingAnchor : view.trailingAnchor).isActive = true
        
        if isSidebarVisible {
            NSLayoutConstraint.activate([
                aiSidebar.topAnchor.constraint(equalTo: toolbarView.bottomAnchor),
                aiSidebar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                aiSidebar.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
                aiSidebar.widthAnchor.constraint(equalToConstant: 350),
            ])
        }
    }
    
    private func setupUI() {
        // Configure toolbar with gradient background
        if let layer = toolbarView.layer {
            let gradient = CAGradientLayer()
            gradient.colors = [
                NSColor(red: 0.545, green: 0.361, blue: 0.965, alpha: 1.0).cgColor, // #8B5CF6
                NSColor(red: 0.024, green: 0.714, blue: 0.831, alpha: 1.0).cgColor  // #06B6D4
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.frame = toolbarView.bounds
            layer.insertSublayer(gradient, at: 0)
        }
        
        // Style buttons
        styleButton(backButton)
        styleButton(forwardButton)
        styleButton(reloadButton)
        styleButton(aiButton)
        styleButton(aiSendButton)
        
        // Style address bar
        addressBar.layer?.cornerRadius = 18
        addressBar.layer?.borderWidth = 1
        addressBar.layer?.borderColor = NSColor.separatorColor.cgColor
        
        // Style AI input field
        aiInputField.layer?.cornerRadius = 8
        aiInputField.layer?.borderWidth = 1
        aiInputField.layer?.borderColor = NSColor.separatorColor.cgColor
    }
    
    private func styleButton(_ button: NSButton) {
        button.layer?.cornerRadius = 8
        button.layer?.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.1).cgColor
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        // Enable developer extras
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    }
    
    private func setupAI() {
        // Observe AI service status
        aiService.$isLoading.sink { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.updateAIStatus()
            }
        }.store(in: &cancellables)
        
        aiService.$lastError.sink { [weak self] error in
            DispatchQueue.main.async {
                self?.updateAIStatus()
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func updateAIStatus() {
        statusLabel.stringValue = aiService.statusDescription
        
        // Update AI button appearance based on status
        if aiService.isReady {
            aiButton.layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.2).cgColor
        } else if aiService.isLoading {
            aiButton.layer?.backgroundColor = NSColor.systemYellow.withAlphaComponent(0.2).cgColor
        } else {
            aiButton.layer?.backgroundColor = NSColor.systemRed.withAlphaComponent(0.2).cgColor
        }
    }
    
    private func loadHomePage() {
        let homeHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>WindAI Browser - Home</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    background: linear-gradient(135deg, #8B5CF6, #06B6D4);
                    color: white;
                    text-align: center;
                    padding: 100px 20px;
                    margin: 0;
                }
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }
                h1 {
                    font-size: 48px;
                    margin-bottom: 20px;
                    text-shadow: 0 2px 10px rgba(0,0,0,0.3);
                }
                .subtitle {
                    font-size: 24px;
                    margin-bottom: 40px;
                    opacity: 0.9;
                }
                .features {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 30px;
                    margin-top: 60px;
                }
                .feature {
                    background: rgba(255,255,255,0.1);
                    padding: 30px;
                    border-radius: 15px;
                    backdrop-filter: blur(10px);
                }
                .feature h3 {
                    font-size: 20px;
                    margin-bottom: 15px;
                }
                .feature p {
                    opacity: 0.8;
                    line-height: 1.6;
                }
                .quick-links {
                    margin-top: 60px;
                }
                .quick-links a {
                    color: white;
                    text-decoration: none;
                    background: rgba(255,255,255,0.2);
                    padding: 15px 30px;
                    border-radius: 25px;
                    margin: 0 10px;
                    display: inline-block;
                    transition: all 0.3s ease;
                }
                .quick-links a:hover {
                    background: rgba(255,255,255,0.3);
                    transform: translateY(-2px);
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🌪️ WindAI Browser</h1>
                <p class="subtitle">AI-Powered Browsing Experience</p>
                <p>Built by Neural Arc Inc</p>
                
                <div class="features">
                    <div class="feature">
                        <h3>🤖 AI Assistant</h3>
                        <p>Powered by Qwen 2.5 72B, Mistral 7B, and DeepSeek R1 models with intelligent fallback system.</p>
                    </div>
                    <div class="feature">
                        <h3>🌐 Smart Browsing</h3>
                        <p>Advanced URL handling, search integration, and seamless navigation experience.</p>
                    </div>
                    <div class="feature">
                        <h3>⚡ Native Performance</h3>
                        <p>Built with Swift and WebKit for optimal macOS integration and performance.</p>
                    </div>
                </div>
                
                <div class="quick-links">
                    <a href="https://google.com">Google</a>
                    <a href="https://github.com/Ampersand-AI/windai-browser">GitHub</a>
                    <a href="https://openrouter.ai">OpenRouter</a>
                </div>
            </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(homeHTML, baseURL: nil)
    }
    
    // MARK: - Actions
    @objc private func navigate() {
        let urlString = addressBar.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !urlString.isEmpty else { return }
        
        var finalURL: URL?
        
        // Check if it's a valid URL
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            finalURL = URL(string: urlString)
        } else if urlString.contains(".") && !urlString.contains(" ") {
            // Looks like a domain
            finalURL = URL(string: "https://\(urlString)")
        } else {
            // Treat as search
            let searchQuery = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            finalURL = URL(string: "https://www.google.com/search?q=\(searchQuery)")
        }
        
        if let url = finalURL {
            currentURL = url
            let request = URLRequest(url: url)
            webView.load(request)
            statusLabel.stringValue = "Loading \(url.host ?? url.absoluteString)..."
        }
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func reload() {
        webView.reload()
    }
    
    @objc private func toggleAI() {
        isSidebarVisible.toggle()
        aiSidebar.isHidden = !isSidebarVisible
        
        // Animate the transition
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            updateWebViewConstraints()
            view.layoutSubtreeIfNeeded()
        }
        
        if isSidebarVisible {
            aiInputField.becomeFirstResponder()
        }
    }
    
    @objc private func sendAIMessage() {
        let message = aiInputField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        
        // Add user message to chat
        appendToChatView("You: \(message)\n\n")
        aiInputField.stringValue = ""
        
        // Show loading indicator
        appendToChatView("🤖 AI is thinking...\n\n")
        
        // Send to AI service
        Task {
            let result = await aiService.chat(message: message)
            
            DispatchQueue.main.async {
                // Remove loading indicator
                self.removeLast
                
                switch result {
                case .success(let response):
                    self.appendToChatView("🤖 AI (\(self.aiService.currentModel.displayName)): \(response)\n\n")
                case .failure(let error):
                    self.appendToChatView("❌ Error: \(error.localizedDescription)\n\n")
                }
            }
        }
    }
    
    private func appendToChatView(_ text: String) {
        let currentText = aiChatView.string
        aiChatView.string = currentText + text
        
        // Scroll to bottom
        let range = NSRange(location: aiChatView.string.count, length: 0)
        aiChatView.scrollRangeToVisible(range)
    }
    
    private func removeLastLine() {
        let lines = aiChatView.string.components(separatedBy: "\n")
        if lines.count > 2 {
            let newText = lines.dropLast(2).joined(separator: "\n") + "\n"
            aiChatView.string = newText
        }
    }
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        statusLabel.stringValue = "Loading..."
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            addressBar.stringValue = url.absoluteString
            statusLabel.stringValue = "Loaded \(url.host ?? "page")"
            currentURL = url
        }
        
        // Update navigation buttons
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        statusLabel.stringValue = "Failed to load: \(error.localizedDescription)"
    }
}

// MARK: - WKUIDelegate
extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Handle popup windows by loading in the same view
        if let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
        }
        return nil
    }
}

// MARK: - Combine Import
import Combine

