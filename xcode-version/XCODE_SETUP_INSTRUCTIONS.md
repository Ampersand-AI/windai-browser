# 🍎 WindAI Browser - Xcode Setup Instructions

## 🚀 Quick Start (2 Minutes)

### **Step 1: Download & Extract**
```bash
# Download the project
git clone https://github.com/Ampersand-AI/windai-browser.git
cd windai-browser/xcode-version

# Or download the ZIP and extract
```

### **Step 2: Open in Xcode**
```bash
# Open the project
open WindAI-Browser.xcodeproj
```

### **Step 3: Build & Run**
1. **Select Target**: Choose "WindAI-Browser" in the scheme selector
2. **Click Run**: Press ▶️ or use ⌘R
3. **Done!** WindAI Browser launches immediately

---

## ✅ **What You'll See**

### **Successful Launch:**
- ✅ Beautiful WindAI Browser window opens
- ✅ Console shows: "✅ WindAI Browser started successfully with AI integration!"
- ✅ Address bar ready for URLs
- ✅ AI button functional

### **If Issues Occur:**
- ⚠️ Console shows: "⚠️ WindAI Browser started but AI integration needs attention"
- 🔧 Browser still works, just AI features limited

---

## 🛠️ **Troubleshooting**

### **Problem: "Project is damaged"**
**Solution:**
```bash
# Clean and rebuild
rm -rf ~/Library/Developer/Xcode/DerivedData/WindAI-Browser-*
# Reopen project in Xcode
```

### **Problem: Build Errors**
**Solution:**
1. **Clean Build Folder**: Product → Clean Build Folder (⌘⇧K)
2. **Reset Package Caches**: File → Packages → Reset Package Caches
3. **Restart Xcode**: Quit and reopen Xcode

### **Problem: AI Not Working**
**Solution:**
1. **Check Internet**: Ensure stable connection
2. **API Key**: Verify OpenRouter API key is valid
3. **Firewall**: Check if firewall blocks requests

---

## 🎯 **System Requirements**

- **macOS**: 13.0+ (Ventura or later)
- **Xcode**: 15.0+ (free from App Store)
- **Internet**: Required for AI features
- **RAM**: 4GB+ recommended

---

## 🤖 **AI Features**

### **Models Available:**
1. **Qwen 2.5 72B Instruct** (Primary)
2. **Mistral 7B Instruct** (Fallback)
3. **DeepSeek R1** (Fallback)

### **Smart Fallback System:**
- If primary model fails → tries Mistral 7B
- If Mistral fails → tries DeepSeek R1
- If all fail → shows helpful error message

### **Testing AI:**
1. Launch WindAI Browser
2. Click "🤖 AI" button
3. Type any question
4. Get instant AI response!

---

## 🔧 **Advanced Configuration**

### **Custom API Key:**
Edit `AIService.swift` line 15:
```swift
private let apiKey = "your-new-api-key-here"
```

### **Different Models:**
Edit `AIService.swift` lines 16-18:
```swift
private let primaryModel = "your-preferred-model"
private let fallbackModel1 = "your-fallback-1"
private let fallbackModel2 = "your-fallback-2"
```

### **Debug Mode:**
Add this to `AppDelegate.swift` in `applicationDidFinishLaunching`:
```swift
print("🐛 Debug mode enabled")
// Add your debug code here
```

---

## 📦 **Building for Distribution**

### **Create Archive:**
1. **Product** → **Archive**
2. **Organizer** opens automatically
3. **Distribute App** → **Copy App**
4. **Save** to desired location

### **Export Options:**
- **Development**: For testing on your Mac
- **App Store**: For App Store submission
- **Developer ID**: For distribution outside App Store

---

## 🎨 **Customization**

### **Change App Name:**
1. Select project in Navigator
2. **Build Settings** → **Product Name**
3. Change to your desired name

### **Change Bundle ID:**
1. **Build Settings** → **Product Bundle Identifier**
2. Use format: `com.yourcompany.yourapp`

### **Add App Icon:**
1. Create 1024x1024 PNG icon
2. **Assets.xcassets** → **AppIcon**
3. Drag icon to appropriate slots

---

## 🚨 **Common Issues & Solutions**

### **Issue: "Cannot find 'AIService' in scope"**
**Solution:** Ensure `AIService.swift` is added to target
1. Select `AIService.swift`
2. **File Inspector** → **Target Membership**
3. Check "WindAI-Browser"

### **Issue: "Module not found"**
**Solution:** Clean and rebuild
```bash
# In Terminal
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### **Issue: Signing Errors**
**Solution:** 
1. **Signing & Capabilities** tab
2. **Team** → Select your Apple ID
3. **Bundle Identifier** → Make unique

---

## 🎉 **Success Checklist**

- ✅ Project opens without errors
- ✅ Build succeeds (⌘B)
- ✅ App launches (⌘R)
- ✅ Window appears with WindAI interface
- ✅ Address bar accepts input
- ✅ AI button responds
- ✅ Console shows success message

---

## 🆘 **Need Help?**

### **Quick Fixes:**
1. **Restart Xcode** (fixes 80% of issues)
2. **Clean Build Folder** (⌘⇧K)
3. **Check Console** for error messages

### **Still Stuck?**
- Check GitHub Issues: https://github.com/Ampersand-AI/windai-browser/issues
- Review error messages in Xcode console
- Ensure all files are present in project

---

## 🎊 **You're Ready!**

Your WindAI Browser should now be running perfectly on macOS with:
- ✅ Native Swift performance
- ✅ Beautiful Neural Arc design
- ✅ AI integration with OpenRouter
- ✅ Smart fallback system
- ✅ Professional macOS integration

**Built by Neural Arc Inc** 🚀

---

*Last updated: January 2025*

