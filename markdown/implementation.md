\chapter{Babascriptプログラミング環境の実装}
\label{chap:implementation}

本章では、第\ref{chap:design}章で述べたプログラミング環境について述べる。

# Babascriptプログラミング環境

## 概要

## 処理手順

- 人への命令構文を実行する
- 命令がNode-Lindaサーバを経由してクライアントへと配信される
- 命令を受け取ったクライアントがユーザに処理を促す
- 命令実行者が、処理結果を入力する
- Node-Lindaサーバを経由して実行元プログラムに入力された処理結果が送信される
- プログラム側で指定されたコールバック関数が実行され、処理が継続される


# Babascript

プログラムと人とのインタラクションを実現するためには、プログラム上で人間への指示を行える仕組みが必要だ。
そこで、Babascriptという、人間への指示構文を実装したオブジェクト(以下、人間オブジェクト)を宣言できるプログラミングライブラリを実装した。
BabascriptはJavascriptのサーバサイド実行環境であるNode.js及びプログラミング言語Ruby上で動作する。

## 基本仕様

Babascriptでは、通常のメソッド実行とほぼ同じ記法で人間への指示を送ることができる。
例えば、図\ref{fig:babascript_sample}のようなプログラムによって、人間オブジェクトを宣言し、人間へ指示を送ることができる。

\begin{figure}[htbp]
\begin{center}
\includegraphics[width=.8\linewidth,bb=0 0 563 151]{images/babascript_sample.js.png}
\end{center}
\caption{人への命令構文}
\label{fig:babascript_sample}
\end{figure}

人オブジェクトはインスタンス生成時にidを指定する必要がある。
人への命令構文は、このidを元に命令配信先を決定する。
例えば、id=baba に命令を送りたければ、人オブジェクト宣言時の第一引数にはbabaという文字列を指定する。
指定したidに命令が配信されるため、Babascript Client側でも同じidを指定する必要がある。

人間オブジェクトは、人間オブジェクトに定義されていないメソッドが実行されると、エラーを返さずに、人間への指示として解釈する。
そのため、実装されていないメソッド名であれば、あらゆる命令をメソッドとして表現し実行することが可能である。
例えば、「toString」や「call」等のメソッドは、javascriptにおいてはほぼすべてのオブジェクトが持つメソッドだ。
一方で、「clean_up_your_room」や「bake_bread」のようなメソッドは定義しない限りは存在しないメソッドである。
Babascriptは、この定義されていないメソッドをエラーとして評価せず、人への命令構文として評価する。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.8\linewidth,bb=0 0 577 330]{images/methodmissing_sample.js.png}
  \end{center}
  \caption{人への命令構文}
  \label{fig:methodmissing_sample}
\end{figure}

オブジェクトに存在しないメソッドが呼び出された時に、特定のメソッドにその処理を委譲するような仕組みは、プログラミング言語Rubyにおいては
methodmissingと呼ばれる。
各言語によって名称は異なるが、類似する仕組みが存在する言語は複数存在する。

人間への指示として評価されたメソッドは、そのメソッド名と引数を元にしたタスク情報を生成し、タスク配信サーバへと送信する。
この際、メソッド名部分がユーザに命令として提示される文となる。
タスク情報は図\ref{fig:task_format}のように構成される。

\begin{figure}[htbp]
\begin{center}
\includegraphics[width=.6\linewidth,bb=0 0 354 225]{images/task_format.js.png}
\end{center}
\caption{タスク情報}
\label{fig:task_format}
\end{figure}

メソッド名が自由に設定できるため、内容は指示ではなく、質問のようなものもあり得るが、本研究では統一して指示と呼ぶ。
人への命令構文の第一引数にはオプション情報を指定する。
第二引数には人力処理の実行後に実行するコールバック関数を指定する。
このコールバック関数は、指示に対して何かしらの値が返されたときに実行される。

## オプション情報の付加

メソッド名以外に送信したい情報があるときには、第一引数にオプション情報としてオブジェクトを与える。
クライアントアプリケーション側でオプション情報を得ることができるため、このオプション情報に応じて
ユーザに提示する画面を変更するといったことが可能である。

オプション情報の例としては、返り値の型情報や、タイムアウト情報などが考えられる。
オプション情報は図\ref{fig:babascript_option}のように記述する。
図\ref{fig:babascript_option}の場合であれば、返り値の型はstringで、3分後までに返り値を得られなかった場合は、
人力処理を止め、第二引数で指定するコールバック関数を実行し、処理を続行させるといったことをオプション情報として記述している。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.8\linewidth,bb=0 0 563 149]{images/babascript_option_sample.js.png}
  \end{center}
  \caption{オプション情報のサンプルソースコード}
  \label{fig:babascript_option}
\end{figure}

また、図\ref{fig:babascript_option_list}の場合であれば、listで指定した選択肢の中から選んで返り値を返す、といった指定が可能だ。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.8\linewidth,bb=0 0 563 149]{images/babascript_option_list.js.png}
  \end{center}
  \caption{オプション情報のサンプルソースコード}
  \label{fig:babascript_option_list}
\end{figure}

オプション情報である第一引数は省略可能である。
省略した場合は、自動的に図\ref{fig:option_default}のようなオブジェクトが代入される。
図\ref{fig:option_default}のオプション情報の場合、返り値の型はBooleanで返すように指定できる。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.4\linewidth,bb=0 0 210 70]{images/option_default.js.png}
  \end{center}
  \caption{デフォルトのオプション情報}
  \label{fig:option_default}
\end{figure}


## コールバック関数の指定

命令構文の第二引数にコールバック関数を指定すると、実行結果を取得した後にこのコールバック関数が呼ばれる
resultの中に処理結果が入ってる

人間は計算機の処理に比べて遅延しがちであるため、非同期を前提とした実装をしている


## コマンドラインでの利用

Babascriptはコマンドラインツールとしても利用可能だ。
babaコマンドは、図\ref{fig:baba_command}のように利用することができる。
オプションeの直後に指示内容を、オプションnの直後に指示先のIDを指定する。
format情報などを付加したい場合は、オプションoの後に<key>=<value>の形で指定することができる。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.6\linewidth,bb=0 0 465 17]{images/baba_command.sh.png}
  \end{center}
  \caption{Babaコマンド}
  \label{fig:baba_command}
\end{figure}

図\ref{fig:baba_command_pipe}のように、pipeして使うなどの利用方法が考えられる。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.4\linewidth,bb=0 0 465 17]{images/baba_command_pipe.sh.png}
  \end{center}
  \caption{Babaコマンドでpipeする}
  \label{fig:baba_command_pipe}
\end{figure}


# Babascript Client

Babascriptによって人への指示をプログラムに記述し、実行することが可能となったが、その指示を人に伝え、
処理結果を返させるためのアプリケーションが必要となる。
そこで、Babascript Clientというアプリケーション群を実装した。
Babascript Clientは、Babascriptとの通信を担うサービス部と返り値の入力等を担うインターフェス部から構成される。
サービス部はJavascript上で動作する。
インタフェース部は、各種アプリケーションに応じて動作環境が異なるが、主にNode.js上とWebブラウザ上で動作する。

## サービス

サービス部は、主にBabascriptとのやりとり、つまり、命令の受け取りや返り値の送信などを担う。

命令を受け取ると、イベントを発行する

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.8\linewidth,bb=0 0 560 253]{images/babascript_client_service.js.png}
  \end{center}
  \caption{Babascript Client サービス部}
  \label{fig:babascript_client_service}
\end{figure}

何かしらの値を実行結果として返すときは、clientオブジェクトに実装されているretrnValueメソッドを用いる。
図\ref{fig:babascript_client_service_returnvalue}のように、第一引数に結果として返すものを指定する。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.8\linewidth,bb=0 0 357 149]{images/babascript_client_service_returnvalue.js.png}
  \end{center}
  \caption{Babascript Client 処理結果を返すメソッド}
  \label{fig:babascript_client_service_returnvalue}
\end{figure}


## インタフェース

ユーザとのインタラクションを行う。
命令をユーザに見せるのと、実際に実行結果を入力させる機能を持つ

例として、Webアプリケーションとして実装した。
% Android wear interaface and slack interaface のどちらか/双方が実装できたら
% 項目を増やして対応する。

### Web Application

### CommandLineInterface

### Slack Interface

\begin{figure}[htbp]
  \begin{center}
    \includegraphics[width=.3\linewidth,bb=0 0 273 402]{images/babacript_client_slack.png}
  \end{center}
  \caption{Babascript Client Slackインタフェース}
  \label{fig:babascript_client_slack}
\end{figure}

# プラグイン機構

Babascript 及びBabascriptClientはその機能を拡張するために、プラグイン機構を持つ。

図\ref{fig:babascript_plugin}の様に使うことで、Babascript及びBabascriptClientによってイベントが発生した時に、
それに応じたデータを受け取り、自由に操作することができる。

\begin{figure}[htbp]
  \begin{center}
  \includegraphics[width=.7\linewidth,bb=0 0 416 226]{images/babascript_plugin.js.png}
  \end{center}
  \caption{Babascript Plugin}
  \label{fig:babascript_plugin}
\end{figure}

Babascript及びBabascriptClientは、以下のイベントを受け取る。

- initialize
- connect
- send
- receive

## 具体例

例えば、以下のようなプラグイン例が考えられる。

- LoggingPlugin
- DatasyncPlugin
- WearableDevicePlugin

### Logger Plugin

LoggerPluginは、

### Datasync Plugin


<!-- % Adapter -->
# 通信手法

BabascriptとBabascript Clientのデータの通信には、Babascript Adapterという切り替え可能なモジュールを用いる。


Babascript及びBabascript Clientは、通信手法を切り替えることが出来る
この通信モジュール部分をBabascript Adapterと呼ぶ。

<!--
  % ここの区分、どうしよ？
  % Node-lidaの利用は前提とする？
  % Node-linda Socket.IO Adapter
  % Node-linda Pushnotification Adapter
  % こんな感じの分け方でいい気がする。
  % 今はnode-lindaを利用してるけど、Adapterは非常に簡単に開発できる、みたいな。
-->

## Node-Linda

## Node-Linda Adapter

Node-Linda Adapterは、Socket.IOを用いてNode-Lindaというプラットフォームに接続する。

構成図は以下のような感じになる。

## PushNotification Adapter

Node-Linda Pushnotification Adapter は、HTTP RequestとPushnotificationを用いて
Node-Linda プラットフォームに接続する。
