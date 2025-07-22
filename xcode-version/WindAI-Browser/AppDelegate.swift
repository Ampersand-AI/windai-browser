import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the main window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Configure window
        window.title = "WindAI Browser - Built by Neural Arc Inc"
        window.center()
        window.setFrameAutosaveName("WindAI Browser Main Window")
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 800, height: 600)
        
        // Create and set the content view
        let contentView = ViewController()
        window.contentViewController = contentView
        
        // Show window
        window.makeKeyAndOrderFront(nil)
        
        // Test AI service on startup
        Task {
            let aiService = AIService.shared
            let success = await aiService.testConnection()
            
            DispatchQueue.main.async {
                if success {
                    print("✅ WindAI Browser started successfully with AI integration!")
                } else {
                    print("⚠️ WindAI Browser started but AI integration needs attention")
                }
            }
        }
        
        print("🌪️ WindAI Browser launched - Built by Neural Arc Inc")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        print("👋 WindAI Browser shutting down...")
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

