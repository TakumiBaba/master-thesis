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

近年、人間を計算資源としてシステムに組み込み利用するヒューマンコンピュテーションの研究が流行している。
実世界には人間にしかできない処理が多く存在し、その処理をプログラムで実現するためにも、
人間と計算機をより融合させたプログラミング環境が必要である。

そこで、人間とプログラムへの指示を同等な記法によって実現するBabascriptプログラミング環境を提案する。
このプログラミング環境を使うことで、従来のプログラミング言語上でコンピュータに対するプログラムを
記述する記法と同じような記法で人間に指示を送り、実行結果を得ることが出来る。

本論文では、このBabaScriptプログラミング環境の設計や実装、その応用例について述べ、
ユーザインタビューの結果等について考察する

\end{jabstract}

\begin{eabstract}

Researches on ``human computation'' is getting popular these days,
where human resources can be used in computing environments just like
computer resources. Integrating human resources with computing
resources is considered to be very important in the real world, since
there are still many tasks which only humans can perform.

We propose the ``Babascript'' programming environment where we can ask
computers and people to perform tasks in the same manner.  Using the
Babascript environment, users can write programs that can send
instructions to people in the real world and get the results, just
like calling library functions and getting results on the computer.

In this paper, we describe the design, implementation, and application
of BabaScript programming environment, and show the results of
user tests and interviews.

\end{eabstract}
