const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('.'));

// Routes
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        app: 'WindAI Browser Web',
        version: '1.0.0',
        company: 'Neural Arc Inc'
    });
});

// AI API endpoint (placeholder for future OpenRouter integration)
app.post('/api/ai/chat', (req, res) => {
    const { message, model } = req.body;
    
    // Simulated AI response
    const responses = [
        `I understand you asked: "${message}". The AI integration with OpenRouter API is coming soon!`,
        `That's an interesting question about "${message}". Full AI capabilities will be available once the OpenRouter integration is complete.`,
        `Thanks for asking about "${message}". WindAI is being enhanced with Qwen, Mistral, and DeepSeek models.`
    ];
    
    const response = responses[Math.floor(Math.random() * responses.length)];
    
    res.json({
        success: true,
        response: response,
        model: model || 'demo',
        timestamp: new Date().toISOString()
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🌪️ WindAI Browser Web Server running on port ${PORT}`);
    console.log(`🚀 Built by Neural Arc Inc`);
    console.log(`📱 Access at: http://localhost:${PORT}`);
});

module.exports = app;

