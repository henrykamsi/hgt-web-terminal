const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const pty = require('node-pty');
const path = require('path');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.static(path.join(__dirname, 'public')));

wss.on('connection', (ws) => {
    // Spawn an interactive bash shell with custom color prompt
    const shell = pty.spawn('bash', [], {
        name: 'xterm-256color',
        cols: 80,
        rows: 24,
        cwd: process.env.HOME || '/app',
        env: {
            ...process.env,
            TERM: 'xterm-256color',
            // Custom prompt: Green path, Bright White text, Red errors, Yellow warnings
            PS1: '\[\033[01;32m\]\u@hgt-cloud:\[\033[01;34m\]\w\[\033[00m\]\$ '
        }
    });

    // Send PTY output directly to WebSocket client
    shell.onData((data) => {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(data);
        }
    });

    // Receive keystrokes/commands from browser client
    ws.on('message', (msg) => {
        try {
            const data = JSON.parse(msg);
            if (data.type === 'input') {
                shell.write(data.data);
            } else if (data.type === 'resize') {
                shell.resize(data.cols, data.rows);
            }
        } catch (e) {
            shell.write(msg.toString());
        }
    });

    ws.on('close', () => {
        shell.kill();
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`[SUCCESS] HGT Web Terminal running on port ${PORT}`);
});
