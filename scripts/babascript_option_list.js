var Babascript = require('babascript');
var takumibaba = new Babascript('takumibaba');

var option = {
  format: 'string'
  list: ['良い', '普通', '悪い']
};
takumibaba.会場の雰囲気はどうですか(option, function(result){
  // 人が処理した結果が引数に格納される。
  // 返り値に応じて処理を分岐させる
  if(result.value == '良い'){
    // ...
  }else if(result.value == '普通'){
    // ...
  }else if(result.value == '悪い'){
    // ...
  }else{
    // ...
  }
});
