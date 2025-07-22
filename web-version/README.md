# WindAI Browser - Web Version

🌪️ **AI-powered browser built by Neural Arc Inc** - Now available as a web application!

## 🚀 Quick Start

### Option 1: Run Locally
```bash
npm install
npm start
```
Then open http://localhost:3000

### Option 2: CodeSandbox/Online
This version is specifically designed to work in web environments like CodeSandbox, Replit, or any web browser.

## ✨ Features

- 🌐 **Smart Browsing** - Enter URLs or search terms
- 🤖 **AI Assistant** - Ready for Qwen, Mistral, DeepSeek integration
- 📱 **Responsive Design** - Works on desktop and mobile
- ⚡ **Web Compatible** - No Electron dependencies
- 🎨 **Beautiful UI** - Modern gradient design with Neural Arc branding

## 🛠️ Technology Stack

- **Frontend**: Pure HTML, CSS, JavaScript
- **Backend**: Node.js + Express
- **AI Ready**: OpenRouter API integration prepared
- **Responsive**: Mobile-first design

## 🎯 Usage

1. **Browse Websites**: Enter any URL in the address bar
2. **Search**: Type search terms for Google search
3. **AI Chat**: Click the "🤖 AI Chat" button to open the assistant
4. **Navigation**: Use back/forward buttons like a real browser

## 🤖 AI Integration

The AI features are prepared for integration with:
- **Qwen 2.5 72B** (Primary model)
- **Mistral 7B** (Fallback)
- **DeepSeek R1** (Fallback)

Currently in demo mode - full AI integration coming soon!

## 📁 Project Structure

```
windai-browser-web/
├── index.html          # Main browser interface
├── server.js           # Express server
├── package.json        # Dependencies
└── README.md          # This file
```

## 🔧 Development

### Local Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### Environment Variables
```bash
PORT=3000                    # Server port
OPENROUTER_API_KEY=your_key  # For AI integration
```

## 🌐 Deployment

### Vercel
```bash
npm install -g vercel
vercel
```

### Netlify
```bash
npm run build
# Upload dist folder to Netlify
```

### Heroku
```bash
git init
heroku create windai-browser-web
git push heroku main
```

## 📱 Browser Compatibility

- ✅ Chrome 80+
- ✅ Firefox 75+
- ✅ Safari 13+
- ✅ Edge 80+
- ✅ Mobile browsers

## 🎨 Customization

### Colors
The design uses Neural Arc's brand colors:
- Primary: `#8B5CF6` (Purple)
- Secondary: `#06B6D4` (Cyan)
- Accent: `#84CC16` (Green)

### Themes
- Light mode (default)
- Dark mode support ready

## 🔒 Security

- CORS enabled for cross-origin requests
- Input sanitization
- Secure iframe handling
- No sensitive data storage

## 📊 Performance

- Lightweight: ~50KB total
- Fast loading: <2s initial load
- Responsive: 60fps animations
- Mobile optimized

## 🐛 Troubleshooting

### Common Issues

1. **Iframe not loading**: Some sites block iframe embedding
2. **CORS errors**: Normal for cross-origin requests
3. **Mobile layout**: Use responsive design breakpoints

### Solutions

```bash
# Clear cache
npm run clean

# Restart server
npm start

# Check logs
npm run dev
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🏢 About Neural Arc Inc

WindAI Browser is built by Neural Arc Inc, a leading AI technology company focused on creating intelligent, user-friendly applications.

## 🔗 Links

- **GitHub**: https://github.com/Ampersand-AI/windai-browser
- **Desktop Version**: Available in the main repository
- **Support**: GitHub Issues
- **Website**: Neural Arc Inc

## 🎉 Changelog

### v1.0.0
- Initial web version release
- Core browsing functionality
- AI assistant interface
- Responsive design
- Express server backend

---

**Built with ❤️ by Neural Arc Inc** 🚀

