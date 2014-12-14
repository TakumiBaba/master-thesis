var Babascript = require('babascript');
var baba = new Babascript('takumibaba');

baba.exists_method = function(){return true}

// 定義済みのメソッド, 人への命令構文ではない
baba.exists_method()

// 定義されていないメソッド, 人への命令構文として解釈される
baba.not_exists_method()
