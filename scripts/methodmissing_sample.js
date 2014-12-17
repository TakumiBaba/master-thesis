var Babascript = require('babascript');
var baba = new Babascript('takumibaba');

baba.exists_method = function(){return true}

// 上記で定義したのメソッド, 人への命令構文ではない
baba.exists_method();

// 既に定義されているメソッド, 人への命令構文ではない
baba.toString();

// 定義されていないメソッド, 人への命令構文として解釈される
baba.not_exists_method();
