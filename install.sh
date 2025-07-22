#!/bin/bash

# WindAI Browser Installation Script
# Built by Neural Arc Inc

set -e

echo "🌪️  WindAI Browser Installation"
echo "Built by Neural Arc Inc"
echo "================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "📦 Node.js not found. Please install Node.js first:"
    echo "   • macOS: brew install node"
    echo "   • Ubuntu/Debian: sudo apt install nodejs npm"
    echo "   • Or visit: https://nodejs.org/"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "⚠️  Node.js 18+ required. Current version: $(node --version)"
    echo "Please update Node.js and try again."
    exit 1
fi

echo "✅ Node.js $(node --version) detected"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

echo ""
echo "🔧 Building WindAI Browser..."

# Build for current platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building for macOS..."
    npm run build-mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Building for Linux..."
    npm run build-linux
else
    echo "🖥️  Building for current platform..."
    npm run build
fi

echo ""
echo "✅ WindAI Browser built successfully!"
echo ""
echo "🚀 To start WindAI Browser:"
echo "   npm start"
echo ""
echo "📁 Built files are in the 'dist' directory"
echo ""
echo "🎉 Installation complete!"
echo "Built by Neural Arc Inc"

