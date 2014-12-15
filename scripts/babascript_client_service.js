var Client = require('babascript-client');

var client = new Client("takumibaba");
client.on("get_task", function(task){
  // babascriptからの命令を受信した時の挙動を記述
});

client.on("cancel_task", function(task){
  // 命令が何かしらの理由でキャンセルされた時の挙動を記述
});
