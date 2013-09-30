var express = require('express') 
	, app = express()
	, http = require('http')
	, server = http.createServer(app)
	, io = require('socket.io').listen(server)
  , net = require('net')
  , config = require('./config');

app.use(express.static(__dirname + '/www'));
server.listen(config.webServer.port);

/* Kismet Server */
var kismetMessages = {
  BSSID:[
    'bssid', 'type',
    'llcpackets', 'datapackets', 'cryptpackets', 
    'manuf', 'channel', 'firsttime', 'lasttime', 
    'atype', 'rangeip', 'netmaskip',
    'gatewayip', 'gpsfixed',
    'minlat', 'minlon', 'minalt', 'minspd',
    'maxlat', 'maxlon', 'maxalt', 'maxspd',
    'signal_dbm', 'noise_dbm', 
    'minsignal_dbm', 'minnoise_dbm',
    'maxsignal_dbm', 'maxnoise_dbm',
    'signal_rssi', 'noise_rssi', 
    'minsignal_rssi', 'minnoise_rssi',
    'maxsignal_rssi', 'maxnoise_rssi',
    'bestlat', 'bestlon', 'bestalt',
    'agglat', 'agglon', 'aggalt', 'aggpoints',
    'datasize', /*'tcnid', 'tcmode', 'tsat',*/
    'carrierset', 'maxseenrate', 'encodingset',
    'decrypted', /*'dupeiv',*/ 'bsstimestamp',
    'cdpdevice', 'cdpport', 'fragments', 'retries',
    'newpackets', 'freqmhz', 'datacryptset'/*,
    'maxfield'*/
  ],
  CLIENT:[
    'bssid', 'mac', 'type', 'firsttime', 'lasttime',
    'manuf', 'llcpackets', 'datapackets', 'cryptpackets',
    'gpsfixed',
    'minlat', 'minlon', 'minalt', 'minspd',
    'maxlat', 'maxlon', 'maxalt', 'maxspd',
    'agglat', 'agglon', 'aggalt', 'aggpoints',
    'signal_dbm', 'noise_dbm', 
    'minsignal_dbm', 'minnoise_dbm',
    'maxsignal_dbm', 'maxnoise_dbm',
    'signal_rssi', 'noise_rssi', 
    'minsignal_rssi', 'minnoise_rssi',
    'maxsignal_rssi', 'maxnoise_rssi',
    'bestlat', 'bestlon', 'bestalt',
    'atype', 'ip', 'gatewayip', 'datasize', 'maxseenrate', 
    'encodingset', 'carrierset', 'decrypted', 
    'channel', 'fragments', 'retries', 'newpackets',
    'freqmhz', 'cdpdevice', 'cdpport', 'dot11d',
    'dhcphost', 'dhcpvendor', 'datacryptset'/*,
    'maxfield'*/
  ]
};

var isConnected = false
    , leftOver = ''
    , kismetServerSocket;
  

function onConnect() {
  console.log('Kismet Server socket connected');
  
  var index = 0
      , configString = '';

  setIsConnected(true);

  for (var messageType in kismetMessages) {
      if (kismetMessages.hasOwnProperty(messageType)) {
          configString += '!' + index + ' ENABLE ' + messageType + ' ' + kismetMessages[messageType].join() + '\r\n';
          index++;
      }
  }
  kismetServerSocket.write(configString);
}

function onClose() {
  console.log('Kismet Server socket closed');
  setIsConnected(false);
  reconnect();
}

function onError(error) {
  console.log('Kismet Server socket error: ' + error.toString());
}

function onData(data) {
  var strData = leftOver + data.toString()
          , lines = strData.split('\n')
          , type = ''
          , matches = []
          , message = {}
          , messageType = ''
          , messageValues = [];

  leftOver = lines.pop();
  lines.forEach(function(line) {
    console.log(line);
    matches = line.match(/\*([A-Z]+):(.*)/);
    if(matches !== null) {
      try {
        messageType = matches[1];
        if(kismetMessages.hasOwnProperty(messageType)) {
          messageValues = matches[2].trim().split(' ');
          console.log(messageValues);
          message = {};
          var index = 0;
          kismetMessages[messageType].forEach(function(fieldName) {
            message[fieldName] = messageValues[index];
            index++;
          });
          io.sockets.emit(messageType, message);
        }
      }
      catch(err) {
        console.log(err);
      }
    }
    else {
      //io.sockets.emit('log', line);
    }
  });
}

function setIsConnected(value) {
  if(isConnected !== value) {
    isConnected = value;
    io.sockets.emit('kismetServerConnectionStatus', {isConnected: value});
  }
}

function connect() {
  kismetServerSocket = net.connect(config.kismetServer.port, config.kismetServer.address);
  kismetServerSocket
    .on('connect', onConnect)
    .on('close', onClose)
    .on('error', onError)
    .on('data', onData);
}

function reconnect() {
  kismetServerSocket.destroy();
  console.log('Kismet Server socket: reconnecting in 5 seconds');
  setTimeout(function() {
    console.log('Kismet Server socket: reconnecting');
    connect();
  }, 5000);
}


connect();

/* Web client */

io.sockets.on('connection', function (socket) {
  console.log("Web client connected");
  socket.emit('kismetServerConnectionStatus', {isConnected: isConnected});
  socket.on('disconnect', function () {
    console.log('Web client disconnected');
  });
});

