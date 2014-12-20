// Node-Lindaに接続するクライアントの準備
var LindaClient = require('linda').Client;
var socket = require('socket.io-client').connect('http://babascript-linda.herokuapp.com/');
var linda = new LindaClient().connect(socket);

// タプルスペース(共有メモリ空間)の宣言
var tuplespace = linda.tuplespace('babascript');

// タプルスペースへの書き込み
tuplespace.write({"type": "sensor"});

// タプルスペースからデータを読み込む
tuplespace.read({}, function(err, data){
  //
});

// タプルスペースからデータを読み込んで消す
tuplespace.take({}, function(err, data){

});

// タプルスペースへのデータ書き込みを監視する
tuplespace.watch({}, function(err, data){

});

tuplespace.cancel(cid);
