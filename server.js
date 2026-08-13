const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.static(path.join(__dirname, 'public')));

wss.on('connection', (ws) => {
    console.log('[HGT Terminal] Client connected...');

    // Spawn native bash shell inside Termux / Linux
    const shell = spawn('bash', ['-i'], {
        env: { ...process.env, TERM: 'xterm-256color' },
        cwd: process.env.HOME
    });

    // Send the permanent HGT Header banner directly into the terminal screen buffer
    const banner = [
        "\r\n\x1b[1;36m=====================================================\x1b[0m\r\n",
        "\x1b[1;32m   HENRY GLOBAL TECH INDUSTRY [HGT] LINUX CLOUD v1.2.0 \x1b[0m\r\n",
        "\x1b[1;33m   Owner: Henry Global Tech Industry                   \x1b[0m\r\n",
        "\x1b[1;33m   Contact Email: Kamsih924@gmail.com                  \x1b[0m\r\n",
        "\x1b[1;36m   About HGT: https://henrykamsi.github.io/HGT-ABOUT-US-PAGE/\x1b[0m\r\n",
        "\x1b[1;36m=====================================================\x1b[0m\r\n\r\n"
    ].join("");

    ws.send(banner);

    // Stream shell output -> Frontend terminal screen
    shell.stdout.on('data', (data) => {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(data.toString());
        }
    });

    shell.stderr.on('data', (data) => {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(data.toString());
        }
    });

    // Stream user keystrokes / commands / Enter key -> Shell stdin
    ws.on('message', (message) => {
        shell.stdin.write(message.toString());
    });

    ws.on('close', () => {
        console.log('[HGT Terminal] Client disconnected.');
        shell.kill();
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`\x1b[32m[SUCCESS] HGT Web Terminal running at http://localhost:${PORT}\x1b[0m`);
});
