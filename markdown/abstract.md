<!-- % ■ アブストラクトの出力 ■
%	◆書式：
%		begin{jabstract}〜end{jabstract}	：日本語のアブストラクト
%		begin{eabstract}〜end{eabstract}	：英語のアブストラクト
%		※ 不要ならばコマンドごと消せば出力されない。 -->


<!--
- プログラム上で人間と計算機への指示を同じように記述可能なシステムについて述べる。
- 人間を計算資源としてシステムに組み込み利用するヒューマンコンピュテーションの研究が流行している。
- しかし、その多くは人間を演算装置として利用するものであり、入出力装置として利用していない。
- また、例えば自分自身など、具体的な人を指定することができず、実世界におけるタスクの処理などには向いていない。
- 本研究では、センシングやアクチュエーションを含んだ人間への行動指示と指示結果の取得の仕組みを
- 従来のプログラミング言語に組み込んだシステムを提案する。
- よりシンプルな記述法で、人間と計算機への指示が混ざったプログラムを記述・実行することができる。
- このシステムによって、世の中に存在する様々な処理を
- 計算機が得意なことは計算機が、人間が得意なことは人間が実行するというより効率的な人間と計算機の共生を実現する。
-->


<!-- % 日本語のアブストラクト -->
\begin{jabstract}

近年、人間を計算資源としてシステムに組み込み利用するヒューマンコンピュテーションの研究が流行しているが、
その多くは人間の知能を計算資源として利用するものである。
人間の知能だけでない様々な能力を活かし、人間にしかできないことをシステムに組み込むことができれば
非常に有用である。

そこで、人間と計算機の処理を融合させるBabaScriptプログラミング環境を提案する。
BabaScriptプログラミング環境では、従来のプログラミング言語上で
具体的な人間への指示と指示結果の取得を可能にするライブラリ「Babascript」と
指示に対して実行結果を返すことのできるアプリケーション「Babascript Agent」から成る。
このプログラミング環境によって、人間と計算機への指示が混在したプログラムを記述・実行することができるようになり、
計算機が得意なことは計算機が、人間が得意なことは人間が実行するという、人間と計算機の協働を実現する。

本論文では、このBabaScriptプログラミング環境の設計や実装、その応用例について述べ、
ユーザインタビューの結果等について考察する

% 以下、旧版
% プログラム上で人間と計算機への指示を同等に記述可能なシステムについて述べる。
% 人間を計算資源としてシステムに組み込み利用するヒューマンコンピュテーションの研究が流行している。
% しかし、その多くは不特定多数の人間を演算装置として利用するものであり、入出力装置として利用していない。
% 例えば自分自身など、具体的な人物を指定することができず、実世界におけるタスク処理には向いていない。
%
% このような状況を踏まえ、本研究では、人間への行動指示と指示結果の取得を
% 従来のプログラミング言語に組み込んだシステムを提案する。
% このシステムにより、シンプルな記述法で人間と計算機への指示が混在したプログラムを記述・実行することができるようになり、
% 計算機が得意なことは計算機が、人間が得意なことは人間が実行するという、人間と計算機の協働を実現する。

\end{jabstract}



<!-- % 英語のアブストラクト -->
\begin{eabstract}
Recently, research of human computation that is a paradigm for utilizing human processing power to solve problems that computer not yet solve, is becoming popular.
Many of that researches is .
If

We proposed the "BabaScript" programming environment that supports the integration of human resources and compuing resources.
Babascript programming environment consists of Babascript and Babascript Agent.
Babascript is a programming library that  on existing programming language
Babascript Agent is an application that
Using Babascript programming environment, computer activities and human activities can be described
in a programming language, and collabolation between humans and computers will be achived

This paper describe the design, implementation and application of BabaScript programming environment
and the result of user interview and discussion

\end{eabstract}
