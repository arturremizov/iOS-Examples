const WebSocketServer = require('ws');

const wss = new WebSocketServer.WebSocketServer({ port: 8080 })

wss.on('connection', ws => {
    console.log("new client connected");
    ws.send('Connection received');

    ws.on('message', function message(data, isBinary) {
        console.log('received %s', data);
        wss.clients.forEach(function each(client) {
           if (client.readyState === WebSocketServer.WebSocket.OPEN) {
               client.send(data, { binary: isBinary})
           }
        });
    });

    ws.on('close', function close() {
        console.log("received close");
    });

    ws.onerror = function () {
        console.log("Some Error occurred")
    }
});