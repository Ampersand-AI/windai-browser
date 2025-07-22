# WindAI Browser - Troubleshooting Guide

## 🔧 Common Issues and Solutions

### Electron Installation Issues

If you encounter "Electron failed to install correctly" error:

```bash
# Clean installation
npm run clean

# Or manually:
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### Graphics/Display Errors

If you see graphics-related errors when starting the app, these are usually harmless warnings in headless environments:

```
ERROR:shared_image_interface_proxy.cc
ERROR:one_copy_raster_buffer_provider.cc
```

**Solution**: These errors don't affect functionality. The app will still work correctly.

### Permission Issues

If you get permission errors:

```bash
# Fix permissions
chmod +x install.sh
sudo chown -R $USER:$USER node_modules
```

### Build Issues

If builds fail:

```bash
# Install build dependencies
npm install -g electron-builder

# For macOS builds on non-Mac systems
npm install --save-dev electron-builder

# For Windows builds
npm install --save-dev electron-builder
```

### Runtime Issues

If the app doesn't start:

```bash
# Try with additional flags
npm run dev

# Or start with debugging
electron src/main.js --enable-logging --no-sandbox
```

### Node.js Version Issues

WindAI Browser requires Node.js 18+:

```bash
# Check version
node --version

# Update if needed (using nvm)
nvm install 18
nvm use 18
```

### Platform-Specific Issues

#### macOS
- **Gatekeeper warnings**: Right-click app → Open, or run `sudo xattr -r -d com.apple.quarantine WindAI\ Browser.app`
- **Code signing**: For distribution, you'll need Apple Developer certificates

#### Windows
- **Antivirus warnings**: Add exception for the app directory
- **Missing Visual C++**: Install Microsoft Visual C++ Redistributable

#### Linux
- **Missing dependencies**: Install `libgtk-3-0 libxss1 libasound2`
- **AppImage permissions**: `chmod +x WindAI-Browser-*.AppImage`

## 🚀 Performance Optimization

### Memory Usage
- Close unused tabs in external browser
- Restart the app periodically for optimal performance

### Startup Speed
- Disable unnecessary startup programs
- Use SSD storage for better performance

## 🔍 Debugging

### Enable Debug Mode
```bash
npm run dev
```

### Check Logs
- **macOS**: `~/Library/Logs/WindAI Browser/`
- **Windows**: `%USERPROFILE%\AppData\Roaming\WindAI Browser\logs\`
- **Linux**: `~/.config/WindAI Browser/logs/`

### Developer Tools
- Press `Ctrl+Shift+I` (or `Cmd+Option+I` on Mac) to open DevTools
- Check Console tab for JavaScript errors
- Network tab for API issues

## 📞 Getting Help

### Before Reporting Issues
1. Check this troubleshooting guide
2. Update to the latest version
3. Try a clean installation
4. Check the GitHub issues page

### Reporting Bugs
Include the following information:
- Operating system and version
- Node.js version (`node --version`)
- Electron version (`npm list electron`)
- Error messages (full text)
- Steps to reproduce

### GitHub Issues
Report issues at: https://github.com/Ampersand-AI/windai-browser/issues

### Community Support
- Check existing GitHub discussions
- Search for similar issues
- Provide detailed information when asking for help

## ✅ Verification Steps

After installation, verify everything works:

```bash
# 1. Check installation
npm list electron

# 2. Test startup
npm start

# 3. Test build system
npm run build-mac  # or build-win, build-linux

# 4. Run tests
npm test
```

## 🔄 Reset to Default

If all else fails, complete reset:

```bash
# 1. Backup any custom changes
cp -r windai-browser windai-browser-backup

# 2. Fresh clone
git clone https://github.com/Ampersand-AI/windai-browser.git
cd windai-browser

# 3. Clean install
npm install

# 4. Test
npm start
```

---

**Built by Neural Arc Inc** 🚀

For additional support, visit our GitHub repository or contact our support team.

