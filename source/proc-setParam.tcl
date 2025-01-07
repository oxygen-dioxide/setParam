#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

# paramU(列,i),  i:  0=fid, 1=S, 2=O, 3=P, 4=C, 5=E,6=A, 7=コメント, R=発声リスト上の番号
# ust,           fname=Alias,S,C,E,P,O

# ソース更新時の注意点
# ・グローバル変数、配列を増やしたとき：
#   ・startup(exclusionKeysForInitFile,*)に登録するか検討
#   ・グローバル配列を増やしたなら、saveSettings、doReadInitFileへの登録を検討

# tk_chooseDirectoryのエラー（仕様）。フォルダ名入力欄を編集した内容が正しく反映されない。

#koko,todo
#sndなどをreadするところはcatchを使う
#  if [catch {snd read $fname}] {
#    tk_messageBox -message "error: can not open $fname" \
#      -title $t(.confm.fioErr) -icon warning
#    return 1
#  }
#-----
# キーバインドのカスタマイズ
# utauからの呼び出し

# ust読み込み：メモ欄に音高などを入れる？
# 無音追加
# reclist.txtで""を使えるように("a あ"など。OREMOの実装のことのよう)
# 単独音パラメータ自動推定にmfccを導入するとか。

# oremo: 連続音oto.ini生成。未収録音のエントリがあるのを修正。
# oremo: typelist+連続音のoto.iniで、エイリアスにtypelistを反映させる。

# doEstimateParamではsWorkを使っているが、そこから呼び出すsec2uではsndからv(sndLength)を求めているので値がおかしくなっているかも。sec2uもsWorkからv(sndLength)を取り出すなどすべきではとも思うが、通常の手動操作のときにも呼び出しているので、そのときはsndからv(sndLength)を取り出すべき。

#ver.2.0-b130530まで開発に利用していたactivetclのバージョン=ActiveState ActiveTcl 8.5.8.1.291945。exeにする時は別のもの。

# 先行発声をクリック指定したら次のエントリに移る機能。水音さんのソフトでそうなっているらしい。

# 語尾息(「a R」？）を連続音自動生成に入れる？補完ツールとして。→自動推定に入れるよりも、wav内最後のエントリでショートカットキーを押すと
# 　そのエントリをコピーして語尾音エントリにする方が良さそう。

# 4.0-b190504
# - (修正) 極端に短いwavファイルを単独音自動推定したときにエラーが出る問題を修正した。(preEstimateParam)

# 4.0-b170506
# - (修正) UTAUプラグインモードで、手動で上書き保存してsetParam終了すると編集内容がoto.iniに反映されないバグを修正した。
#          (UTAUプラグインモードでのファイルメニューから「上書き保存」を削除した。保存はsetParam終了時の窓で選択する)(setMenu)。
# - (修正) UTAUプラグインモードで一部のショートカットキー(Ctrl+s、Ctrl+oなど)を無効化した。

# 4.0-b170501
# - (修正) エイリアス一括変換で%rを用い重複音の削除を行った後で、正しくアンドゥが出来なくなる問題を修正した(deleteEntp)。

# 4.0-b170416
# - (修正) Tcl/Tkのライセンスファイルを修正した。以前のバージョンではtclkit等のライセンスファイルでなくactivetclのライセンスファイルを同梱してしまっていた。
# - (修正) ヘルプメニューのURLを更新した(freett→fc2、sourceforge→osdn)。
# - (修正) 2秒未満のwavファイルでスペクトル表示して倍率を大きく上げるとフリーズする問題を修正した(Redraw)。
# - (修正) oto.iniをsetParam.exeにD&Dした際にファイル選択窓が開かずそのoto.iniを開くようにした($startup(autoReadParamFile))。
# - (修正) F0の描画範囲を固定しない場合に、値が最大のF0データが描画されないことがある問題を修正した(Redraw)。
# - (修正) 単独音自動推定等でパワー抽出に失敗したときに処理停止しないようにした(powerコマンドを使っている場所にcatchを入れた)。
# - (修正) 窓を最大化・復元したときに不安定になる問題に対応した(changeWindowBorder)。
# - (修正) Alt-F1、Alt-F3を押したときに位置がずれたり他のエントリの値が変わらないバグを修正した(_changeOtherS)。
# - (修正) 左ブランクに連動して他パラメータも動かすモードのときの動作速度を若干改善させた(setParam)。
# - (修正) 「常にwav全体を表示する」以外の拡大率で短いwavファイルを表示すると以降の波形キャンバスサイズが小さくなってしまう問題を修正した。
# - (修正) wavを拡大表示して時間軸を小節単位にした際にF0の目盛線が途切れる問題を修正した(Redraw)。
# - (変更) ファイル保存仕様を変更し、「上書き保存」「名前を付けて保存」の2種類にした。Ctrl+sは上書き保存に割り当てた。名前を付けて保存はCtrl+Shift+s。
# - (変更) Tcl/Tkのバージョンを8.5.4から8.6.4に変更した。
# - (変更) F0パネルをピアノロール表示にした。(myAxis)
# - (変更) 先行発声に連動して他パラメータも動かすモードのとき、右ブランク値が正の値の場合も動くようにした(setParam, _changeOtherS)。
# - (変更) 左ブランクに連動して他パラメータも動かすモードのとき、右ブランク値が正の値の場合も動くようにした(setParam, _changeOtherS)。
# - (変更) 一覧表の起動時のサイズを小さくした(makeEntParamWindow)。
# - (変更) 一覧表のセル境界でのマウスカーソル表示を変更した(makeEntParamWindow)。
# - (変更) プラグイン関係変数をsetParam-init.tclに保存しないようにした。
# - (変更) エイリアス一括変更の%m、%sの挙動を変更した(parseOtomei)。
# - (変更) 音叉窓、メトロノーム窓を削除した(pitchGuide, tempoGuideなど)。
# - (追加) 常に最前面に表示できるようにした(トップメニュー／右クリックメニューで切替、v(alwaysOnTop))。
# - (追加) 透過表示できるようにした(トップメニュー／右クリックメニューで切替、v(alpha))。
# - (追加) 起動時に一覧表窓がなるべく波形窓の下に来るようにした(時々失敗する)(windowPlacement)。
# - (追加) ウィンドウ境界のドラッグで窓幅変更できるようにした。
# - (追加) 各パネル境界でマウスカーソルの表示が変わるようにした(changeMouseCursor)。
# - (追加) UTAUプラグインとして起動可能。ただし以下の点に注意。
#          *  一部のメニューやボタンは非表示になる。
#          *  一覧表でctrl+iするとエントリを複製できるが、oto.iniに同一内容の重複が有るかどうかはチェックしない。

# 3.0-b150713
# - (追加) プラグインの仕様を変更した。inParam.txtへ2行追加。
# - (追加) 波形窓の右クリックメニューにプラグインを追加した。
# - (追加) nキーでプラグインメニューを表示するようにした。(bind)
# - (変更) プラグイン実行時に実行するかどうかの確認窓を開かないようにした。(runPlugin)
# - (変更) 波形窓の右クリックメニューから「音叉窓の表示」「メトロノームの表示」を削除した。(PopUpMenu)
# - (修正) 日本語フォルダのドラッグ＆ドロップに失敗する問題を改善した。(procDnd)
# - (修正) 数十秒以上のwavでスペクトルを拡大すると画像が途中で途切れる問題に対応した。(Redraw)
# - (修正) エイリアスに"\"が混じっているときのエイリアス一括変換が誤作動するエラーに対応した。(doTransAlias)
# - (修正) 一覧表の窓上で指定範囲再生のショートカット(Control-F1～F5)が効かない問題に対応した。

# 3.0-b150306
# - (追加) ustファイルを読んで編集対象データを絞り込む機能を強化(編集対象にコメントを付与する、重複音の上限設定、対象音の誤検出を低減)した。(readUstFile, doReadUstFile)
#          現状でも未解決の誤検出の例：歌詞=「- あ3」のとき「- あ31」「- あ32」などが検出される。またprefixMapに未対応。
# - (追加) 左ブランクを移動したときに他のパラメータも同時に動かすか否かを大文字Sで切り替えられるようにした。
#          また、先行発声を移動したときに他のパラメータも同時に動かすか否かを大文字Pで切り替えられるようにした。(setParam.tcl)
# - (追加) 矢印キーをhjkl、awsdに割り当てた。また旧版ではwで波形先頭表示になっていたが、qに割り当て直した。(setParam.tcl)
# - (修正) 発声タイミング試聴(F8)中に左クリックすると時々エラーが出る問題を修正した。(setParam.tcl のbindの無名関数内にあったreturnをbreakに変更)

# 3.0-b150201
# - (追加) 波形拡大率を数値で指定できるようにした。(changeZoomX)
# - (修正) 大量のセルをコピーしたときの処理時間を短縮した。大量の貼り付けについてはプログレスバーを表示した。(copyCell、pasteCell)
# - (修正) エイリアス一括変更で、「%m」を使ったとき、元エイリアスの両端に空白があれば削除するようにした。(doTransAlias, parseOtomei)

# 3.0-b140622
# - (追加) 波形を拡大表示して次の音に移るときに、指定したパラメータに自動でフォーカスする機能を追加した。(autoFocusSettings, jumpRec)
# - (修正) 起動直後に一覧表で移動キーを押すとエラーが出る問題を修正した。(setParam.tcl)

# 3.0-b140204
# - (修正) 自動推定時にエラーが出る問題(3.0-b140119実装時に混入したエラー)を修正した。
# - (修正) オーバーラップまたは固定範囲を変更したときに、特定条件下でのアンドゥ処理でエラーが起きる問題を修正した。
# - (変更) 単独音自動推定についての変更：
#          - 発話中とみなされる時間長のデフォルト値を0.1秒から0.05秒に変更した。
#          - 右ブランク推定について、既存方法に加え、末尾から平均パワーを超える位置を探し、
#            そこが既存方法での位置より右側ならそちらを採用するようにした。
#          - 固定範囲の推定について、既存補法に加え、先行発声～右ブランク間がもし0.6秒以上であれば、
#            先行発声と固定範囲との間は最低0.1秒開けるようにした。
#          - オーバーラップ推定対象を前方一致で調べるようにした。対象設定に「うぃ」があるとうぃ.wav、うぃ↑.wavなどが対象に入る。
#            また、推定対象リストをesitimate-ovlPattern.txtから読むようにした。
# - (変更) 連続音自動推定の設定窓で、自動補正のON/OFFに連動して関連パラメータ入力の有効/無効を切り替えるようにした。
# - (追加) ヘルプから公式webページにアクセスできるようにした。
# - (追加) 連続音自動推定で、ファイル名に"_"が含まれる場合の動作を選択できるようにした。選択肢は以下の3つ。(getMorae, genParam)
#          - 無視する (デフォルト)
#          - 1モーラ分の休符とみなす (ver. 2.0-b111007で実装し、それ以降デフォルトだった機能)
#          - 1モーラの区切り記号とみなす (今回追加した機能)

# 3.0-b140119
# - (追加) 合成テスト機能を追加した。(synTestWindow, playSyn)
# - (追加) 画面クリックで近傍パラメータ間再生する機能を追加した。(clickPlayRangeModeなど)

# 3.0-b131022
# - (修正) SoXでフィルタをかけて波形がクリップしたときにwarningが出て処理が止まらないようにした。(doEstimateParam)

# 3.0-b130909
# - (修正) wavファイルやその関連ファイル名の冒頭に「_」を付ける機能で、周波数表に「_」が付かないバグを修正した。(addUnderScore)

# 3.0-b130723
# - (修正) スペクトル表示の色設定がカラーにならないバグを修正した。

# 3.0-b130721
# - (修正) 起動時にoto.iniを読み込めないバグを修正した。

# 3.0-b130713
# - (追加) アンドゥ機能を追加した。(以前実装した手動アンドゥ機能は廃止)
# - (追加) wav再生で現在の再生位置をオレンジ色の実線で示すようにした。(showPlayMark)
# - (追加) 「左」「オ」「先」「子」「右」を中クリックすると、そこまでの音を再生するようにした。「左」はファイル冒頭から「左」まで、他は「左」から各位置までを再生する。
# - (追加) 一覧表の右クリックメニューに行の複製、削除を追加した。(PopUpMenuTable)
# - (変更) oto.iniを読んだときに最初のデータの右ブランク値の符号に合わせてsetParamの設定(オプション→右ブランク値の表現方法)を自動で変えるようにした。(readParamFile)
# - (変更) 各設定の数値入力欄で数字以外の文字を入力できないようにした。
# - (変更) 複数のファイルを処理する際にはファイル名でソートした順で処理するようにした(glob)
# - (変更) 自動推定プラグイン実行時など、パラメータを消去する警告窓をいくつか省略した。
# - (変更) 複数行選択したときに行削除出来ないようにした(以前は先頭行のみ削除していた)。(deleteEntp)
# - (変更) 一覧表で左ブランクにペーストしたときには、マウスで左ブランクを動かしたときの動作設定に関わらず、左ブランク値のみを書き換えるようにした。(pasteCell)
# - (変更) ActiveTclのバージョンを8.5.14.0.296777にした。
# - (修正) 各設定窓でテキスト入力欄などをダブルクリックすると実行ボタンを押したときにエラーが出るケースに対処した。(getCurSelection)
# - (修正) 初期化ファイルに各パラメータ（自動推定、F0・パワー抽出、発生タイミングチェック、ゼロクロス補正）の設定を保存するようにした。(saveSettings, doReadInitFile)
# - (修正) 連続音の自動推定その2で、wavファイル名冒頭以外に「_」を含む場合にエラーが出るバグを修正した。(doGenParam)
# - (修正) 一覧表の数値入力欄で空白入力を無視するようにした。(changeParam)
# - (修正) マウスで先行発声を動かしたとき他パラメータも動かすモードの挙動を変更した（先行発声値が未定義のときにF3を押した場合に各パラメータが動かないようにした）。(setParam)
# - (修正) マウスでパラメータを動かしたときに波形右端より右に動かせてしまうケースに対処した。(setParam)
# - (修正) パラメータ一覧表の行削除(Ctrl+d)実行時に画面が最新の状態に更新されないバグを修正した。(deleteEntp)
# - (修正) フォルダを変更したときに窓タイトルの(*)を消すようにした。(choosesaveDir)
# - (修正) 右ブランク値の符号を一括変更したときに編集済みを示す印(*)が窓タイトルに出ないバグを修正した(changeE)
# - (修正) 右ブランク値がすべて0のときに右ブランクの符号設定を負にした場合、値の変換ダイアログが出ないバグを修正した。(changeE)
# - (修正) 極端に大きな(or小さな)値の入力は無効にした(-1000000 <= x <= -1000000の範囲の値は受け付ける)。(changeParam)
# - (修正) 一覧表をキーボード操作で移動した際に内部変数の現在地が更新されないバグを修正した(bindCellLeft, bindCellRight, leftInCell, rightInCell)
# - (修正) ustの歌詞を読んで原音設定対象を絞り込む機能で、エイリアスやコメントの空欄に0が入力されるエラーを修正した。(readUstFile)
# - (修正) ステレオwavに対してパラメータの自動推定をかけるとエラーを起こすバグを修正した。(doEstimateParam, autoAdjustRen, preEstimateParam)。（set snd [snd convert -channels Mono]のようなコードをsnd convert -channels Monoにした。）
# - (修正) 一覧表で空欄をコピー＆ペーストしたときにエラーが出ないようにした。(pasteCell)
# - (修正) 選択範囲に単独音自動推定を適用した直後に一覧表を編集出来ないバグを修正した。(_estimateParamSel)
# - (修正) パラメータ一括変更(ctrl+m)で入力欄が空欄の場合にエラーが出ないようにした。(changeCell)
# - (修正) 一覧表でCtrl+xするとセルの内容が消えるので、"切り取り"機能を実装した。

# 2.0-b130530
# - (追加) パラメータ一覧を仮名順に並び替える機能を追加した。(sortByVowel, sortByFID)
# - (追加) 単独音自動推定の設定窓に「デフォルト設定に戻す」ボタンを追加した。(estimateParam, defaultEstimateParam)
# - (追加) エイリアス一括変更を指定範囲に対して実行できるようにした。(doTransAlias)
# - (追加) 連続音パラメータ自動生成で、エイリアスに接尾辞を付けられるようにした。(genParam, doGenParam)
# - (追加) 連続音パラメータ自動生成で、エイリアスが重複した場合に優先して残す組み合わせを変更できるようにした。(sortRecList)
# - (変更) 連続音パラメータ自動生成の設定窓の構成を変更した。(genParam)
# - (変更) 単独音自動推定の設定窓で、「～wav毎に自動設定する」がONのときに、固定値の欄を手動で値変更できるようにした。(estimateParam, preEstimateParam)
# - (変更) F0の目盛表示間隔が小数の場合にも対応した(0.2刻み, 0.5刻み)。 (myAxis)
# - (変更) 発声タイミングチェックの試聴中にF8を押すと再生停止するようにした。(playUttTiming)
# - (変更) 関数名変更: f0Axis -> myAxis。関数削除: powerAxis
# - (修正) 起動直後にファンクションキーやスペースキー等を押すとエラーが出る問題を修正した。(playUttTiming, setParam, cutBlank, prevWav, nextWav, prevList, nextList, jumpList, playRange togglePlay)
# - (修正) 初期化ファイルに波形の横幅拡大率が保存されないバグを修正した。(globalVar.tcl)
# - (修正) エイリアス一括変更で、エイリアスの無い欄でエラーの出るケースを修正した。(doTransAlias)
# - (修正) 連続音のパラメータ自動推定でMFCCを利用した場合のエラーを修正した。(autoAdjustRen2)
# - (修正) F0の描画範囲を固定しない場合に目盛表示がずれるバグを修正した。(myAxis)
# - (修正) パワーの目盛表示がずれるバグを修正した。(myAxis)
# - (修正) パワー表示で負の値が表示されないようにした。(Redraw)
# - (修正) 発声タイミング補正モードで、他のパラメータと先行発声が同時に動くバグを修正した。

# 2.0-b130411
# - (追加) wavファイル名冒頭に「_」を付ける機能で、拡張子が.wav以外のファイルにも「_」を付けられるようにした。(addUnderScore)
# - (追加) 時間軸を小節単位で表示できるようにした。
# - (修正) 先行発声の試聴(F8)で、以下の条件が成り立つときに音声の再生が半拍分遅れる不具合を修正した。(playUttTiming)
#          条件：左ブランク～先行発声間の長さが半拍以上一拍未満の場合
# - (修正) パワー曲線の描画処理を高速化した。(Redraw)

# 2.0-b130319
# - (修正) インストールフォルダが"Program Files"など空白を含む場合にプラグインを実行できないエラーを修正した。(runPlugin)
# - (修正) パワー抽出失敗で処理が止まらないようにした。(preEstimateParam)

# 2.0-b130303
# - (修正) エイリアス一括変換で重複の上限値を設けた際に、削除できないエントリがあった場合に、そのエイリアスに"%r"という文字列が付いてしまうバグを修正。(doTransAlias)
# - (変更) 詳細設定の「F0ターゲットに合わせて他のパラメータを変更」したときの最高F0、最低F0の計算方法を変更した。(autoF0Settings)
# - (修正) exitをExitでラッピングしていたのを解除。どうもdestroy .では終了しないケースがある模様。

# 2.0-b130130
# - (追加) コメント欄を追加。データはoto-comment.txtに保存される。(readCommentFile, saveCommentFile)
# - (追加) 主にExcel向け(空白刻み)のコピー＆貼り付け(copyCell、pasteCell)
# - (変更) pluginsフォルダ下の仕様、メニュー表示法等を変更した。(readPlugin, runPlugin, setMenu, saveF0File, savePowerFile)
# - (変更) pluginの仕様変更に伴い、起動時の自動推定ダイアログ窓の構成を変更した。(genParamWizard)
# - (変更) 一覧表のコピー＆貼り付けで、クリップボードにコンマ刻みの文字列を受け渡すようにした(copyCell、pasteCell)
# - (変更) 貼り付け先領域の縦・横幅よりもコピー元領域の縦・横幅を優先した貼り付けを行う(コピー元領域の縦・横幅を保存した貼り付けを行う)(pasteCell)
# - (変更) 一覧表にデータを貼り付ける際に、コピー元の領域と貼り付け先の領域サイズが違う場合に確認窓を表示するようにした。(pasteCell)
# - (変更) exitをExitでラッピング
# - (修正) F0、パワーの描画フラグを修正(起動時にF0が描画されないエラーへの対策)。(Redraw)
# - (修正) autoSaveInitFile=1のときに、起動する度に窓幅が増えるエラーを修正。ただしOS等が変わった場合の挙動は未確認(setParam.tcl)
# - (修正) 複数のセルをコピー＆ペーストしたときに、最後に空欄が貼り付けられるバグを修正(pasteCell)

# 2.0-b121127
# - (追加) インストールフォルダにファイルsetParam-setting-ORG.iniを追加した。万が一setParam-init.tclが壊れた場合はこのファイルをコピーしてsetParam-init.tclファイルを復元する。
# - (追加) setParam-settings.iniに項目autoSaveInitFileを追加した。1ならインストールフォルダのsetParam-init.tclが自動保存される。(readSysIniFile, saveSysInitFile, Exit)
# - (追加) 音源フォルダ内に初期化ファイル(setParam-init.tcl)があれば読み込むようにした(makeRecListFromDir)
# - (変更) 自動バックアップファイル(setParam-backup.ini：旧backup.ini)の保存位置をsetParamインストールフォルダから各音源フォルダ内に変更した(startAutoBackup, stopAutoBackup, makeRecListFromDir, doAutoBackupなど)
# - (変更) 連続音oto.ini自動生成を開くとキャンセルボタンにフォーカスするようにした(genParam)
# - (修正) 左ブランクを動かしたとき他パラメータも移動して左ブランクとの相対位置を保つとき、右ブランク、左ブランクの順に指定するとエラーの出るバグを修正(setParam)
# - (修正) 左ブランクを動かしたとき他パラメータも移動して左ブランクとの相対位置を保つとき、固定範囲が右ブランクを超えないようにした(超えないようにしていたはずが有効になっていなかったバグを修正した)(setParam)
# - (修正) 「オプション」→「右ブランク値の表現方法」で値を負から正に変更するとき、もし右ブランク値がwav長より長かった場合は右ブランク値=0にするようにした(changeE)
# - (修正) 初期化ファイル(setParam-init.tcl)保存の改良。保存するパラメータを若干選別した。"[を含むパラメータ保存に対応した(saveSettings)
# - (修正) マウスで窓横幅を変更した際に、(wav全体を表示するモードのときの)波形横幅が追随しない問題を修正(setParam.tclのbind . <Configure>)
# - (修正) 不要な変数や関数の削除(OREMOでのみ使っていたものをいくつか削除した)

# 2.0-b120930
# - (修正) 連続音パラメータ自動推定のバグ1件を修正した(autoAdjustRen2)。
# - (追加) ローマ字の連続音wavの自動推定に対応した(アルファベットは全て小文字、"ん"のみNを使う必要がある(_naNdesuno.wavなど) (getMoraeRoman)
# - (修正) 自動バックアップのバグ修正。backup.iniのあるフォルダを開く際のバグを修正。(autoBackup)
# - (追加) 「ツール」→「保存フォルダをエクスプローラで開く」を追加した。(runExplorer)

# 2.0-b120813
# - (追加) 単独音パラメータ自動推定に必要な各パラメータ値をwav毎に自動設定できるようにした。(preEstimateParam)
# - (追加) 単独音パラメータ自動推定で、特定の音の先行発声を求める際にsoxコマンドでHPF/LPFをかけて求めるようにした。(preEstimateParam, doEstimateParam)
# - (変更) 単独音パラメータ自動推定の設定窓で「パワー抽出間隔」を削除し、「推定間隔」にした。(estimateParam)
#          この値に合わせてF0とパワーを抽出する。値が小さい方が精度が上がる。
# - (修正) 単独音パラメータ自動推定で子音部がVOTより左にいかないようにした。(doEstimateParam)
# - (修正) 単独音パラメータ自動推定でwavがステレオだった場合に対応した。(doEstimateParam)
# - (修正) 単独音パラメータ自動推定を一度実行し、設定値を変更して再実行した場合に先行発声がずれるバグを修正した。(doEstimateParam)
# - (修正) 詳細設定でパワーやF0の設定値を変更し「OK」「適用」を押した直後に、変更が一部反映されないバグを修正した。(settings)

# 2.0-b120710
# - (追加) 波形画面の右クリックメニューに単独音パラメータ自動推定とゼロクロス補正を追加した。(PopUpMenu)
# - (変更) 単独音パラメータ自動推定を選択範囲に対して実行した場合は設定窓を自動で消さないようにした(estimateParam)
# - (追加) 一覧表の右クリックメニューの随所に水平線（区切り線）を入れた。
# - (追加) 各パラメータをピッチマーク左側の右上がりゼロクロス位置にスナップする機能を追加した(zeroCross、doZeroCross)
# - (追加) オーバーラップの自動推定を追加した(estimateParam, doEstimateParam)
#          自動推定ovl。対象は、、うぃ、うぇ、うぉ、行：さ、ざ、な、は、ま、や、ら、わ
#          これらの音のovlを、先行発声*0.46する。
# - (修正) 推定対象のチェックを外したときに出るバグを修正(doEstimateParam)
# - (変更) wavに"_"を付けた後の通知窓で、oto.iniの保存をうながすようにした。
# - (変更) MacOS、OREMOでも利用できるコードにした（ごく一部）。
# - (変更) 波形表示の縦軸を固定化した。縮尺を変えたり以前の自動縮尺にする場合は
#          「詳細設定」の「縦軸最大値」を変更する。(settings, Redraw)

# 2.0-b120309
# - (修正) 定期バックアップ時の細かい修正（backup.iniを保存したことを最下部に表示しないようにするなど）。(saveParamFile)
# - (修正) 表示文の間違い（FFTの窓長の単位など）を修正した。
# - (追加) 詳細設定で、F0ターゲット値に合わせて他の設定値を自動設定するボタンを追加した。(autoF0settings)
# - (追加) 上部「表示」メニューに「横軸の拡大」「波形を表示」「メトロノームを表示」（右クリックメニューにのみあったもの）を追加した。
# - (変更) 上部メニューの随所に水平線（区切り線）を入れた。
# - (変更) 上部「ツール」メニューに「wavファイルの一括編集」のサブメニューを追加して関係メニューを移動した。
# - (変更) 起動時にbackup.iniがあった場合(前回異常終了した場合)、そのファイルのあるフォルダを表示して終了するようにした。(autoBackup)
# - (変更) 起動時にbackup.iniがあった場合(前回異常終了した場合)、警告窓が出る前に音源フォルダを開かないようにした。
# - (変更) F0最高値のデフォルト値を400から800に引き上げた。

# 2.0-b120301
# - (追加) 簡易な定期バックアップ機能を追加した。5分おきに、setParam.exeのあるフォルダのbackup.iniにその時点の原音設定を上書きする。(autoBackup)
# - (追加) パラメータ検索で完全一致と部分一致を選択できるようにした。(searchParam)
# - (変更) キャッシュファイル名を変更した(パラメータファイル名.oremo-Scache→パラメータファイル名.setParam-Scache) (saveCacheFile, readCacheFile)
# - (修正) 各メッセージを英語に翻訳した場合に起動できなくなるバグ([]があるとエラーを起こす)を修正した(doReadInitFile)

# 2.0-b120124
# - (追加) エイリアス一括変換で、重複上限数を超えたエントリを削除する機能を追加した。(changeAlias, doTransAlias)
# - (追加) プログレスバーのタイトルを引数で指定できるようにした。(updateProgressWindow)
# - (追加) MFCCを用いた連続音の先行発声の自動推定機能を追加した。(autoAdjustRen2)
# - (追加) エイリアス補完に「ぢ」「づ」の補完を追加した。(woComplement)
# - (修正) 連続音のパラメータ自動生成で、ファイル名に平仮名片仮名が無い場合にエントリが消えるバグを修正した。(doGenParam)
# - (修正) 連続音でF0表示が消えるバグを修正した。(Redraw)

# 2.0-b111229
# - (追加) wavファイルを一括モノラル化する機能を追加した(convertMonoAll)。      
# - (修正) ステレオwavの発声タイミングチェック再生(F8)ができないバグを修正した
#          →wavを読み込む際にモノラル化するようにした。

# 2.0-b111201
# - (追加) wav以外の波形形式に対応した。setParam-setting.iniのwaveFileExt=wavをaiffに書き換える。mp3も読めるが現時点ではあまり意味がない。
#          一つのフォルダ内の波形ファイルは一種類のフォーマットで統一されていることが前提。混在していると想定しない動作をする。
# - (追加) ファイルメニューから最近使ったフォルダ等を開く機能を追加した。
# - (追加) メイン窓最下行に幾つ目の音を編集しているかを表示するようにした(jumpRec)
# - (追加) 左右ブランクの移動可能範囲を他パラメータより優先するモードを追加した。デフォルトで有効。(setParam)
# - (追加) エイリアス一括変換の変換規則に音名(%m)、接尾辞(%s)、重複通し番号(%r)を追加した。(doTransAlias)
#          それに伴い設定窓の説明内容を変更した。
# - (変更) オプションメニュー構成を変更した。「マウス、キー操作の設定」という項目にいくつかを移動した。
# - (変更) 先行発声のタイミング試聴で、発声開始がなるべくクリック音の1拍または半拍に合うようにした(playUttTiming)
# - (変更) initProgressWindowのウィジェット参照を修正した（実行内容に変化は無し）
# - (変更) 保存フォルダの初期値を"c:/Program Files/UTAU/voice"または"c:/Program Files (x86)/UTAU/voice"にした。
# - (変更) 起動時にフォルダ選択窓を出さないようにした。 
#          元に戻したい場合はsetParam-init.tclで set startup(makeRecListFromDir) 1; set startup(choosesaveDir) 1する。
# - (修正) オーバーラップ値を負にしない設定で左ブランクを移動させると負にできてしまう不具合を修正した。
# - (修正) oto.iniの読み込みを高速化した(読み込み中に波形描画をしないようにした)
#          ↑波形長をその都度[snd length]で求めず$v(sndLength)を参照するように全体的に変更を行った
# - (修正) tabを押すとF1などのキーバインドが効かなくなるバグを修正(setParam.tcl)
# - (修正) 空のwavファイルを読んだ際にエラー窓が出ないようにした(readWavFile、changeWidth、zoomX)

# 2.0-b111007
# - (追加) 指定した範囲を再生する機能を追加した。Ctrl+F1～F5の5種類を設定可能(playRange)
# - (追加) 連続音のパラメータ自動生成で、wavファイル名の途中に"_"が入っているときは1モーラ分の休符と
#          みなすようにした。「_あ_い.wav」ならエイリアスは「- あ」「- い」になる。(doGenParamなど)

# 2.0-b110727
# - (追加) 連続音のパラメータ自動生成に先行発声位置の自動推定機能を追加した(autoAdjustRen)
# - (追加) 「を」や「a を」等が無い場合「お」で補完する機能(woComplement)
# - (追加) 単独音併用の連続音の際に不足したエイリアスを単独音で補完する機能(aliasComplement)
# - (追加) Alt+マウスホイールで次のwavに移動するようにした(Alt+上下矢印と同じ。連続音向け)
# - (追加) wキーで波形画面の先頭に移動するようにした
# - (変更) ツールメニューの自動推定関係を一つにまとめた
# - (修正) 設定窓等を開いて一覧表のフォーカスが消えた際に、波形画面のホイールスクロールが
#          効かなくなるエラーを修正
# - (修正) 連続音リストを作る際に平仮名片仮名以外の文字(↑など)を無視するようにした
# - (修正) 連続音をモーラに分解する周りの処理を少し書き換えた

# 2.0-b110709
# - (追加) 単独音自動推定を指定したセルのみに適用できるようにした
# - (追加) 単独音自動推定を一覧表の右クリックメニューやフォルダ選択後メニューに追加した
# - (追加) 単独音の先行発声の自動推定を追加した(estimateParam)
# - (追加) 単独音の自動推定でオーバーラップ=0にするようにした(estimateParam)
# - (変更) 単独音自動推定の子音部、右ブランク推定規則を変更した
# - (修正) 一覧表窓でESCを押すと窓が閉じるバグを修正した
# - (修正) タイミングチェック試聴で20より多く指定した場合にエラー窓が出ないエラーを修正した(playUttTiming)

# 2.0-b110629
# - (修正) 各ファイルopenエラーをcatchするようにした。
# - (修正) 日本語フォルダを指定していた際の保存フォルダ変更に関するバグ修正(choosesaveDir)
# - (変更) メッセージ文を若干変更した(message/proc-text.tcl)
# - (修正) オーディオI/O設定窓でエラーが出る問題を修正した(ioSettings)
# - (追加) オーディオI/O設定窓下部に警告文を追加した
# - (追加) ESCで各種設定窓を閉じるようにした

# 2.0-b101009
# - (追加) 配列の手動アンドゥ＆リドゥを追加した(setUndoPoint, undoParam, redoParam)
# - (追加) 値の一括変更機能(changeCell)に、セルの制限条件を付けられるようにした（選択範囲のセルであり、かつ条件を満たすセルのみを一括変更する）。
# - (追加) テスト中の単独音用パラメータ推定に、子音部の最小値を指定できるようにした。
# - (追加) オーバーラップが負になるかどうか選べるようにした(オプションメニュー)。
# - (追加) F9で左右ブランク両側をカットする機能を追加した(cutBlank、オプションメニューでON/OFF)。
# - (変更) 旧バージョンのように「常にwav全体を表示」するモードを
#          右クリックメニューから選べるようにした。
# - (変更) doCutWavを若干修正(処理の無駄を省いた…というほどでもない)。
# - (修正) 単独音のパラメータ自動推定後、保存ファイル名がoto-autoEstimation.iniにならないようにした。
# - (修正) 別の行に移動したときの描画速度を向上した。
# - (追加) 連続音のパラメータ自動生成で、カタカナに対応した。

# 2.0-b100724
# - マウスドラッグでパラメータ位置移動できるようにした
# - (追加) 初期化ファイルの読み込みを追加した(readSettings)
# - (修正) 発声タイミングチェック設定の変数の細かいバグ修正(uttTimingSettings)
# - (変更) 初期化ファイルに保存する内容を増やした(v以外の配列を追加)(saveSettings)
# - (追加) 初期設定ファイルを読み込む際に簡易サニタイジングするようにした(doReadInitFile)
# - (変更) パラメータ線描画を別procにして高速化した(RedrawParam)

# 2.0-b100509
# - (修正) 連続音パラメータ自動生成で重複エイリアスが上限を超えたファイルのパラメータ位置がずれるバグを修正(genParam)。

# 2.0-b100411
# - (追加) マウスでパラメータをずらしたときに移動できる範囲に制限を増やした(setParam)
# - (追加) 右クリックメニューに、マウス操作(オプションメニューと同じ)を追加
# - (追加) 左ブランクや先行発声を動かすとき、他パラメータも動かして
#          相対位置を保つ場合は、各々の線の上にマークを付ける(Redraw)
# - (修正) wav両端カット機能で連続音のように複数エイリアスがある場合に重複数だけ余計にカットするバグを修正。(cutWav)
# - (追加) 連続音のパラメータ自動生成で、エイリアスが重複した場合に通し番号を追記するようにした(genParam)。

# 2.0-b100410
# - (追加) 値の一括変更(ctrl+m)に小数除去機能を追加(changeCell)
# - (修正) 値の一括変更(ctrl+m)でエイリアスの欄を除外するようにした(doChangeCell)
# - (追加) 右クリックメニューに時間拡大指定を追加(PopUpMenu)
# - (変更) 時間方向のスケール拡大縮小をctrl+wheelで行うようにした。
# - (変更) マウスでパラメータをずらしたときに移動できる範囲に制限をかけた(setParam)
# - (修正) 先行発声をずらしたときに左ブランク値の小数点以下が3桁以上になるバグを修正。
# - (修正) オーディオデバイスの文字化け周りのバグ修正(setIODevice)

# 2.0-b100204
# - (追加) 波形の表示/非表示を切り替えられるようにした(toggleWaveなど)
# - (追加) 読み込み済みのパラメータに別の原音パラメータファイルをマージする(mergeParamFile)
# - (追加) 選択中の範囲の値を一括変更する機能(changeCell)
# - (追加) オーディオデバイスのレイテンシを変更する機能(ioSettings)
# - (修正) オーディオドライバ名の文字化けを若干解消(ioSettings)
# - (変更) 原音パラメータを読む際にwavが存在しないエントリは削除するようにした(readParamFile)

# 2.0-b091205
# - (追加) メイン窓にD&Dされたときの処理を追加(procDnd)
# - (追加) 発声タイミング補正切替を追加(timingAdjMode)
# - (修正) 細かいバグの修正。
# - (追加) プログレスバー表示
# - (追加) oto.ini読み込み高速化用のキャッシュ機能
# - (追加) F3やAlt-F3で他パラメータを連動してうごかせるようにした。
# - (追加) エイリアス一括変換機能を追加(changeAlias)
# - (修正) 連続音パラメータ生成直後にspaceで再生すると、表示中の波形でない波形が再生されるバグを修正。

# 2.0-b091120
# - (変更) 全メッセージを外部ファイル化。
# - (追加) wav両端の無音をカットする機能を追加 (cutWav)
# - (修正) パラメータ一覧表の数値を削除すると"0"と表示されるバグ?を修正。

# 2.0-b091104
# - (追加) 読み込み時にパラメータ生成(単独/連続音)を選択実行できるようにした。
# - (追加) 先行発声チェック用の試聴機能および設定窓を追加
# - (追加) 自動収録した連続音のパラメータ自動生成(genParam)
# - (変更) 初期化ファイル保存の保存対象を変更(saveSettings)
# - (修正) 行を複製する際にパラメータに空欄がある場合のコピーのバグを修正。

# 2.0-b091007
# - (修正) 以前作った左右ブランク自動推定を最新バージョンで動くように修正。

# 2.0-b090903
# - (追加) 左ブランク値を変更した際に、同wavファイルの他の音の左ブランク値も
#          連動して変更できるようにした。
# - (変更) 各種窓を開いたときにフォーカスするように変更。
# - (追加) パラメータ検索を実装。
# - (変更) パラメータ一覧表のタイトルが長すぎる場合は切り詰めるように変更。
# - (変更) マウス+F1～F5で各パラメータをドラッグ可能。
# - (修正) setParamでF0が表示されないバグの修正。
# - (修正) setParamでマウスドラッグによるセル複数選択ができないバグの修正。

# 2.0-b090822
# - (修正) setParamの一覧表タイトルのファイル名表示が更新されないバグを修正。
# - (修正) setParamの一覧表の値に挿入・削除したときカーソルが末尾に行くバグを修正。
# - (変更) 全パラメータをマイクロsec精度にした。
# - (追加) 右ブランクの負の値に対応。
# - (追加) オプションで右ブランクの正負を切り替えられるようにした。
# - (追加) オプションで左ブランクの変更時の他パラメータのふるまいを
#          切り替えられるようにした
# (2.0-b090813)
# - (変更) リストスクロールで２つ前後の音が見えるようにした。
# - (追加) 初期化ファイルを生成できるようにした。

# 2.0-b090803
# - (修正) readParamFile。oto.iniにエントリが足りない場合のバグを修正。
# -（追加) ツールメニューにDC成分一括除去を追加
# -（追加) ツールメニューにwavファイル名変更（冒頭に"_"を付ける)を追加
# - (追加) リストボックスの横幅をctrl+wheelで変更可能にした。

# 2.0-b090727
# - (変更) setParamで波形窓にエイリアスを表示。
# - (変更) 一覧表タイトルにファイル名を表示。
# - (変更) 一覧表の上下矢印移動で表の上端・下端でワープしないようにした。
# - (変更) ガイドBGM設定窓で、BGM試聴、録音イメージ音試聴ボタンを追加。
# - (変更) オーディオI/O設定窓に説明文を表示。
# - (修正) 自動録音(loop)で、音名リスト末尾までいったら終了するようにした。
# - (変更) Redrawの演算回数を少し削減。
# - (修正) makeRecListFromDirでのファイル名登録のバグを修正。

# 2.0-b090724
# - (修正) val2sampで実数値を返すことがあるバグを修正。

# 2.0-b090719
# - (修正) メトロノーム再生を停止できなかったバグを修正。

# 2.0-b090715
# - saveParamFile 高速化(paramUの内容を直接書き出すようにした)

# 2.0-b090706
# - oremo.tcl 本体のサブルーチン集を別ファイルに移行。

#---------------------------------------------------
# サブルーチン

proc detectEncoding {fp} {
  seek $fp 0
  fconfigure $fp -encoding shiftjis
  if {[read $fp 3] == "ïｻｿ"} {
    fconfigure $fp -encoding utf-8
    return "utf-8"
  } else {
    seek $fp 0
    return "shiftjis"
  }
}

proc readLanguage {} {
  global t startup
  for {set i 0} {$i < [llength $startup(textFiles)]} {incr i} {
    lset startup(textFiles) $i [tk_getOpenFile -initialfile [lindex $startup(textFiles) $i] -defaultextension "tcl" -filetypes {{{language file} {.tcl}}} -title $t(setLanguage,opentitle)]
    while {[catch {source -encoding utf-8 [lindex $startup(textFiles) $i]}]} {
      lset startup(textFiles) $i [tk_getOpenFile -initialfile [lindex $startup(textFiles) $i] -defaultextension "tcl" -filetypes {{{language file} {.tcl}}} -title $t(setLanguage,opentitle)]
    }
  }
}

#---------------------------------------------------
# メイン画面表示をリセットする？
#
proc resetDisplay {} {
  global v t rec type paramU paramUsize

  if {[array names paramU "1,R"] != ""} {
    set recSeq  $paramU(1,R)
  } else {
    set recSeq  0
  }
  set v(listSeq) 1
  set v(listC)   1
  set v(recLab)  [lindex $v(recList) $recSeq]
  setCellSelection $v(listSeq) $v(listC)
  if {[array names paramU "size_1"] != ""} {
    set v(msg) "$v(listSeq) / $paramU(size_1)"  ;# 現在何個目のデータを処理しているかを表示
  }
  readWavFile
  Redraw all
  setEPWTitle
}


#---------------------------------------------------
# 保存フォルダにあるwavファイルを読み、リストに記憶する
#
proc makeRecListFromDir {{readParam 0} {overWriteRecList 1}} {
  global v t startup

  ;# 自動バックアップの停止と開始
  stopAutoBackup
  set v(backupParamFile) "$v(saveDir)/setParam-backup.ini"
  startAutoBackup

  set dbInitFile [format "%s/%s" $v(saveDir) [file tail $startup(initFile)]]
  if [file exists $dbInitFile] {
    doReadInitFile $dbInitFile
  }

  set recList {}
  foreach filename [lsort [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]]] {
    set filename [file rootname [file tail $filename]]
    if {$filename == ""} continue
    ;# フォルダおよび拡張子を取り除いたファイル名をリストに格納
    ;# 音名と発声タイプは分けない
    lappend recList $filename
  }
  if $overWriteRecList {
    set v(recList) $recList
    set v(typeList) {""}
  }
  initParamS
  initParamU 0 $recList
  set v(openedParamFile) ""

  if {$readParam != 0} {
    set act [tk_dialog .confm $t(.confm) \
      $t(makeRecListFromDir,q) question 0 \
      $t(.confm.r) \
      $t(.confm.nr) \
      $t(makeRecListFromDir,a) \
    ]
    set v(paramFile) "$v(saveDir)/oto.ini"
    switch $act {
      0 {readParamFile}
      2 {genParamWizard}
    }
  }
  clearUndo
}

#---------------------------------------------------
# 起動時にパラメータ自動推定を行う際のウィザード
#
proc genParamWizard {} {
  global t v plugin gpWindow

  if [isExist $gpWindow] return ;# 二重起動を防止
  toplevel $gpWindow
  wm title $gpWindow $t(genParamWizard,title)
  bind $gpWindow <Escape> "destroy $gpWindow"
  wm attributes $gpWindow -topmost 1  ;# 常に最前面に表示
  grab $gpWindow

  label  $gpWindow.lq  -text $t(genParamWizard,q)
  set f [frame $gpWindow.f]
  grid $gpWindow.lq -pady 5
  grid $f

  ;# プラグインメニューを作る
  menu $f.m -tearoff false
  $f.m delete 0 end
  for {set i 0} {$i < $plugin(N)} {incr i} {
    if {$plugin($i,edit) == "all"} {
      set name $plugin($i,name)
      $f.m add command -label "$i: $name" -command "destroy $gpWindow; runPlugin $i 0"
    }
  }
  label $f.lap -text $t(genParamWizard,ap) -relief raised -pady 3
  bind $f.lap <Button-1> {tk_popup $gpWindow.f.m %X %Y}

  button $f.ba0 -text $t(genParamWizard,a0) -command {
    destroy $gpWindow
    estimateParam 0
  }
  button $f.ba2 -text $t(genParamWizard,a2) -command {
    destroy $gpWindow
    genParam 0
  }
  button $f.bc  -text $t(.confm.c) -command {
    destroy $gpWindow
  }
  grid $f.ba0 -sticky nsew
  grid $f.ba2 -sticky nsew
  grid $f.lap -sticky nsew
  grid $f.bc -sticky nsew
  focus $f.bc

                    #  set act [tk_dialog .confm \
                    #    $t(genParamWizard,title) \
                    #    $t(genParamWizard,q) question 3 \
                    #    $t(genParamWizard,a0) \
#    $t(genParamWizard,a1) \
                    #    $t(genParamWizard,a2) \
#                                               $t(.confm.c) \
#  ]
#  switch $act {
#    0 {estimateParam}
#    1 {autoParamEstimation}
#    2 {genParam}
#  }
}

# #---------------------------------------------------
# # テキスト編集窓を作る
# #
# proc makeTextWindow {w title width height {retVarName ""}} {
#   if [winfo exists $w] {destroy $w}
#   toplevel $w
#   wm title $w $title
#   text $w.t -width $width -height $height -yscrollcommand "$w.y set"
#   scrollbar $w.y -command "$w.t yview" -orient vertical
#   button $w.b -text "Close" -command "destroy $w"
#   grid $w.t $w.y -row 0 -column 0 -sticky news -columnspan 2
#   grid rowconfigure    $w 0 -weight 1
#   grid columnconfigure $w 0 -weight 1
#   grid $w.b -row 1 -column 1
#   if {$retVarName != ""} {
#     regsub -- {\(.*\)} $retVarName "" varName
#     global $varName
#     eval "$w.t insert end \$$retVarName"
#     button $w.bSave -text "Save" -command "returnText $retVarName $w.t; destroy $w"
#     grid $w.bSave -row 1 -column 0
#   }
#   bind $w <Escape> "destroy $w"
# }
# 
# #---------------------------------------------------
# # テキスト編集窓の内容を変数に返す
# #
# proc returnText {retVarName w} {
#   regsub -- {\(.*\)} $retVarName "" varName
#   global $varName
#   set t [$w get 1.0 end]
#   regsub -all {[[:space:]]+} $t " " t  ;# 空白や改行を一つの空白にする
#   set t [string trim $t]
#   eval "set $retVarName \"$t\""
# }

#---------------------------------------------------
# 初期化ファイルを指定して読み込む
#
proc readSettings {} {
  global v t startup
 
  set fn [tk_getOpenFile -initialfile $startup(initFile) \
            -title $t(readSettings,title) -defaultextension "tcl" \
            -filetypes { {{tcl file} {.tcl}} {{All Files} {*}} }]
  if {$fn == ""} return

  doReadInitFile $fn
  clearUndo
}

#---------------------------------------------------
# メッセージテキストファイルや初期化ファイルを読み込む
#
proc doReadInitFile {initFile} {
  global topdir t v f0 power startup dev uttTiming genParam estimate pZeroCross

  if {! [file exists $initFile]} return

  if [catch {open $initFile r} in] { 
    if {[array names t "doReadInitFile,errMsg"] != ""} {
      tk_messageBox -message $t(doReadInitFile,errMsg) \
        -title $t(.confm.fioErr) -icon warning
    } else {
      tk_messageBox -message "can not read the file ($initFile)" \
        -title "File I/O Error" -icon warning
    }
    return
  }
  
  fconfigure $in -encoding utf-8

  ;# 簡易サニタイジング
  while {![eof $in]} {
    set l [gets $in]

    if {[regexp {^[ \t]*$} $l]}                   continue  ;# 空行はOK
    if {[regexp {^[ \t]*(;|)[ \t]*#} $l]}         continue  ;# コメント行はOK

    regsub -all -- {\\\[} $l "" l                           ;# \[を消した上で↓のチェックを行う
    if {[regexp {^[ \t]*set[ \t]+[^;\[]+$} $l]} continue    ;# set に;や[がなければOK

    ;# エラーがあった場合
    if {[array names t "doReadInitFile,errMsg2"] != ""} {
      tk_messageBox -message $t(doReadInitFile,errMsg2) \
        -title $t(.confm.fioErr) -icon warning
    } else {
      tk_messageBox -message "Syntax error\nLine: $l\nFile: $initFile\nYou can use only \"set variableName {value}\" in that file." \
        -title "File I/O Error" -icon warning
    }
    close $in
    return
  }
  close $in

  source -encoding utf-8 $initFile

  ;# _SETPARAM_TOPDIR_を$topdirに置き換える
  foreach aName $startup(arrayForInitFile) {
    set sList [array get $aName]
    foreach {key value} $sList {
      if {[string first "_SETPARAM_TOPDIR_" $value] == 0} {
        set newValue [string replace $value 0 [expr [string length "_SETPARAM_TOPDIR_"] -1] $topdir]
        set [eval format "%s(%s)" $aName $key] $newValue
      }
    }
  }
}

#---------------------------------------------------
# reclist.txtを保存する
#
proc saveRecList {} {
  global v t

  set fn [tk_getSaveFile -initialfile $v(recListFile) \
            -title $t(saveRecList,title) -defaultextension "txt" ]
  if {$fn == ""} return

  set v(recListFile) $fn
  if [catch {open $v(recListFile) w} out] { 
    tk_messageBox -message [eval format $t(saveRecList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else {
    fconfigure $out -encoding binary
    puts -nonewline $out \xef\xbb\xbf
    fconfigure $out -encoding utf-8
    foreach sn $v(recList) {
      if [catch {set data [puts $out $sn]}] {
        tk_messageBox -message [eval format $t(saveRecList,errMsg2)] \
          -title $t(.confm.fioErr) -icon warning
      }
    }
    close $out
  }
  set v(msg) [eval format $t(saveRecList,doneMsg)]
}

#---------------------------------------------------
# 音名リストファイルを読み、リストに記憶する
#
proc readRecList {args} {
  global v t

  if {[llength $args] == 0 || ! [file exists $v(recListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(recListFile) \
            -title $t(readRecList,title1) -defaultextension "txt" \
            -filetypes { {{reclist file} {.txt}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
  }
  if {$fn == ""} return
  set v(recListFile) $fn

  if [catch {open $v(recListFile) r} in] { 
    tk_messageBox -message [eval format $t(readRecList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else {
    detectEncoding $in
    if [catch {set data [read -nonewline $in]}] {
      tk_messageBox -message [eval format $t(readRecList,errMsg2)] \
        -title $t(.confm.fioErr) -icon warning
    }
    regsub -all {[[:space:]]} $data " " data
    set v(recList) {}
    foreach line [split $data " "] {
      if {$line != ""} {
        lappend v(recList) $line
      }
    }
    close $in
  }
  set v(recLab) [lindex $v(recList) 0]
  set v(msg) [eval format $t(readRecList,doneMsg)]
  initParamU
  clearUndo
}

#---------------------------------------------------
# オーバーラップ推定対象のリストファイルを読む
#
proc readOvlPattern {fname} {
  global v t

  if {! [file exists $fname]} {
    tk_messageBox -message "error: $fname does not exist"
    return ""
  }

  if [catch {open $fname r} in] { 
    tk_messageBox -message "error: $fname read error"
  } else {
    detectEncoding $in
    if [catch {set data [read -nonewline $in]}] {
      tk_messageBox -message "error: $fname read error"
    }
    regsub -all {[[:space:]]+} $data " " data
    set result {}
    foreach line [split $data " "] {
      if {$line != ""} {
        lappend result $line
      }
    }
    close $in
  }
  return $result
}

#---------------------------------------------------
# 日本語フォントを設定する
#
proc fontSetting {} {
  global v t

  switch $::tcl_platform(platform) {
    unix {
      font create bigkfont -family mincho -size $v(bigFontSize) \
        -weight normal -slant roman
      font create kfont -family mincho -size $v(fontSize) \
        -weight normal -slant roman
      font create smallkfont -family mincho -size $v(smallFontSize) \
        -weight normal -slant roman
    }
    windows {
      font create bigkfont -family $t(fontName) -size $v(bigFontSize) \
        -weight normal -slant roman
      font create kfont    -family $t(fontName) -size $v(fontSize) \
        -weight normal -slant roman
      font create smallkfont -family $t(fontName) -size $v(smallFontSize) \
        -weight normal -slant roman
    }
  }
}

#---------------------------------------------------
# 外部コマンドやファイル、URLを実行する
#
proc execExternal {url} {
    global v t

    if {$::tcl_platform(platform) == "windows"} {
        if {[string match $::tcl_platform(os) "Windows NT"]} {
            exec $::env(COMSPEC) /c start "" $url &
        } {
            exec start $url &
        }
    } else {
        # atode, ここはせめてfirefoxにしないと。。
        if [catch {exec sh -c "netscape -remote 'openURL($url)' -raise"} res] {
            if [string match *netscape* $res] {
                exec sh -c "netscape $url" &
            }
        }
    }
}

#---------------------------------------------------
# D&Dされたものを処理する
#
proc procDnd {objList} {
  global v t

  if $v(paramChanged) {
    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
      question 1 $t(.confm.yes) $t(.confm.no)]
    if {$act == 1} return
  }
  set v(paramChanged) 0

  set obj [lindex $objList 0]
  set obj [file normalize $obj]
  if [file isdirectory $obj] {       ;# フォルダをドロップされた場合
    set v(saveDir) $obj
    set v(openedParamFile) ""
    makeRecListFromDir ;# 保存フォルダからリストを生成する
    resetDisplay
  } elseif [regexp -nocase -- {\.ini$} $obj] {  ;# oto.iniをドロップされた場合
    set v(saveDir) [file dirname $obj]
    set v(openedParamFile) ""
    makeRecListFromDir 0
    readParamFile $obj
    resetDisplay
  } elseif [file isfile $obj] {  ;# ファイルをドロップされた場合
    if [file isdirectory [file dirname $obj]] {
      set v(saveDir) [file dirname $obj]
      set v(openedParamFile) ""
      makeRecListFromDir ;# 保存フォルダからリストを生成する
      resetDisplay
    }
  }
}

#---------------------------------------------------
# 保存ディレクトリを指定する
# 変更したら1、キャンセルしたら0を返す
#
proc choosesaveDir {{readParam 0} {dir ""}} {
  global v t

  if {$v(paramChanged)} {
    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
      question 1 $t(.confm.yes) $t(.confm.no)]
    if {$act == 1} {return 0}
  }

  if {$dir == ""} {
    ;# 保存ディレクトリを選択する。このとき日本語フォルダがv(saveDir)に指定
    ;# されているとtk_chooseDirectoryの-initialdirが正しく動作しなかったので
    ;# 下記のように一旦cdさせている
    if [file isdirectory $v(saveDir)] {
      set cwd [pwd]
      cd "$v(saveDir)"
      set dir [tk_chooseDirectory -initialdir . -title $t(choosesaveDir,title) -mustexist 1]
      cd "$cwd"
    } else {
      set dir [tk_chooseDirectory -title $t(choosesaveDir,title) -mustexist 1]
    }
  }
  if {$dir != ""} {
    if {[file exists $dir] == 0} {
      tk_messageBox -message "error: can not open $dir" \
        -title $t(.confm.errTitle) -icon error
      return 0    ;# 変更なし
    }
    set v(saveDir) $dir
    set v(openedParamFile) ""
    updateDirHistory
    set v(msg) [eval format $t(choosesaveDir,doneMsg)]

    if {$readParam != 0} {
      set act [tk_dialog .confm $t(.confm) $t(choosesaveDir,q) \
        question 0 $t(.confm.r) $t(.confm.nr)]
      set v(paramFile) "$v(saveDir)/oto.ini"
      if {$act == 0} readParamFile
    }
    clearUndo
    set v(paramChanged) 0
    setEPWTitle
    return 1  ;# 変更あり
  }
  return 0    ;# 変更なし
}

#---------------------------------------------------
# ファイルから波形を読む
#
proc readWavFile {} {
  global v snd t

  if {$v(sndLength) > 0} { set v(sndLength) 0 }
  set fname "$v(saveDir)/$v(recLab).$v(ext)"
  if {[file readable $fname]} {
    if [catch {snd read $fname}] {
      tk_messageBox -message "error: can not open $fname" \
        -title $t(.confm.fioErr) -icon warning
      return
    }
    if {[snd cget -channels] != 1} {
      snd convert -channels Mono
    }
    set v(sndLength) [snd length -unit SECONDS]
    if {$v(sndLength) <= 0} {
#koko      set v(wavepps) 1
    } elseif $v(showWhole) {
      set v(wavepps) [expr $v(cWidth) / $v(sndLength)]  ;# wav全体を表示
    } elseif {[expr int($v(sndLength) * $v(wavepps))] > 48000} {
      set v(wavepps) [expr 48000.0 / $v(sndLength)]
    }
  }
}

#---------------------------------------------------
# 平均律の各音階の周波数を求める
#
proc setSinScale {} {
  global v sv t
  set sv(sinScale) {}
  set sv(sinNote) {}
  for {set oct $sv(sinScaleMin)} {$oct <= $sv(sinScaleMax)} {incr oct} {
    for {set i 0} {$i < 12} {incr i} {
      lappend sv(sinScale) [expr int(27.5 * pow(2, $oct + ($i - 9.0)/12.0) + 0.5)]
      lappend sv(sinNote) "[lindex $sv(toneList) $i]$oct"
    }
  }
}

#---------------------------------------------------
# F0計算中にキーボード、マウス入力を制限させるための窓
# うまく窓を表示できていないが、F0計算中の入力を制限できるので
# とりあえずOK(F0計算中に入力すると落ちることがあるため)
#
proc waitWindow {message fraction} {
  global t
  set w .waitw
  if {$fraction >= 1.0 && [winfo exists $w]} {
    grab release $w
    destroy $w
    return
  }
  if [winfo exists $w] return

  toplevel $w
  grab set $w
  wm title $w $t(waitWindow,title)
  label $w.l -text "calc.."
  pack $w.l
  wm transient $w .
  wm geom $w +100+100
}

#---------------------------------------------------
# 行データの順序を音名でソートする
#
proc sortByVowel {} {
  global v paramS paramU paramUsize paramUsizeC t

  if {$paramUsize <= 0} return
  initProgressWindow

  pushUndo all "" $t(tool,sort,sortByVowel)

  ;# 各データからソートに使うキーを求める
  array unset key
  for {set r 1} {$r < $paramUsize} {incr r} {
    if {[array names paramU $r,6] != "" && $paramU($r,6) != ""} {
      set k $paramU($r,6)  ;# エイリアスがあればそれをキーにする
    } elseif {[array names paramU $r,0] != "" && $paramU($r,0) != ""} {
      set k $paramU($r,0)  ;# fidをキーにする
    } else {
      set k ""
    }
    ;# 先行母音を分離してpre、nowに分ける
    set l [split $k " "]
    if {[llength $l] >= 2} {
      set pre [lindex $l 0]
      set now [lindex $l 1]
    } else {
      set pre ""
      set now $k
    }
    ;# 末尾に通し番号があれば分離してnow, seqに分ける
    set seq ""
    regexp {^([^0-9]+)(.*)$} $now dummy now seq
    ;# ソート用のキー文字列を登録
    set key($r) "$now$pre$seq"
    updateProgressWindow [expr 20.0 * $r / $paramUsize]
  }

  ;# データ順序を並び替える
  for {set r 1} {$r < $paramUsize} {incr r} {
    set new $r
    for {set r2 [expr $r + 1]} {$r2 < $paramUsize} {incr r2} {
      if {[string compare $key($new) $key($r2)] > 0} {set new $r2}
    }
    if {$new != $r} {
      swapRow $new $r

      set tmp $key($new)
      set key($new) $key($r)
      set key($r) $tmp
    }
    updateProgressWindow [expr 20 + 80.0 * $r / $paramUsize]
  }

  ;# 波形再読み込み、再描画
  deleteProgressWindow
  set v(paramChanged) 1
  resetDisplay
  pushUndo agn
}

#---------------------------------------------------
# 行データの順序をファイル名でソートする
#
proc sortByFID {} {
  global v paramS paramU paramUsize paramUsizeC t

  if {$paramUsize <= 0} return
  initProgressWindow

  pushUndo all "" $t(tool,sort,sortByFID)

  ;# 各データからソートに使うキーを求める
  array unset key
  for {set r 1} {$r < $paramUsize} {incr r} {
    if {[array names paramU $r,0] != "" && $paramU($r,0) != ""} {
      set k $paramU($r,0)  ;# fidをキーにする
    } else {
      set k ""
    }
    ;# ソート用のキー文字列を登録
    set key($r) $k
    updateProgressWindow [expr 50 + 10.0 * $r / $paramUsize]
  }

  ;# データ順序を並び替える
  for {set r 1} {$r < $paramUsize} {incr r} {
    set minr $r
    set minval $key($minr)
    for {set r2 [expr $minr + 1]} {$r2 < $paramUsize} {incr r2} {
      set val $key($r2)
      switch [string compare $minval $val] {
        1 {
          ;# fidでソート
          set minr $r2
          set minval $val
        }
        0 {
          ;# 同じfidなら左ブランク値が小さい順に並べる
          if {[array names paramS $minr,S] != "" && [array names paramS $r2,S] != ""} {
            if {$paramS($minr,S) > $paramS($r2,S)} {
              set minr $r2
              set minval $val
            }
          }
        }
        default {}
      }
    }

    if {$minr != $r} {
      swapRow $minr $r

      set tmp $key($minr)
      set key($minr) $key($r)
      set key($r) $tmp
    }
    updateProgressWindow [expr 60 + 40.0 * $r / $paramUsize]
  }

  ;# 波形再読み込み、再描画
  deleteProgressWindow
  set v(paramChanged) 1
  resetDisplay
  pushUndo agn
}

#---------------------------------------------------
# 指定した行のデータを入れ替える
#
proc swapRow {r1 r2} {
  global paramS paramU

  if {$r1 != $r2} {
    ;# paramUの入れ替え
    foreach c [makeListC] {
      if {[array names paramU "$r1,$c"] == ""} {set paramU($r1,$c) ""}
      if {[array names paramU "$r2,$c"]   == ""} {set paramU($r2,$c) ""}
      set tmp $paramU($r1,$c)
      set paramU($r1,$c) $paramU($r2,$c)
      set paramU($r2,$c) $tmp
    }

    ;# paramSの入れ替え
    foreach kind {S C E P O} {
      if {[array names paramS "$r1,$kind"] != ""} {
        set tmp $paramS($r1,$kind)
      } else {
        set tmp "__unset__"
      }
      if {[array names paramS "$r2,$kind"] != ""} {
        set paramS($r1,$kind) $paramS($r2,$kind)
      } else {
        array unset paramS "$r1,$kind"
      }
      if {$tmp != "__unset__"} {
        set paramS($r2,$kind) $tmp
      } else {
        array unset paramS "$r2,$kind"
      }
    }
  }
}

#---------------------------------------------------
# 既存の右ブランク値の正負を書き換えて統一させる
#
proc changeE {} {
  global v paramS paramU paramUsize t

  ;# 既存の値があるかチェック
  set exist 0
  for {set i 1} {$i < $paramUsize} {incr i} {
    if {[array names paramU "$i,5"] != ""} {
      set exist 1
      break
    }
  }
  if {$exist == 0} {
    set v(setE) $v(_setE)
    return   ;# 既存の値がなければ終了
  }

  ;# このままにしておくべきでない符号の値がないかチェック
  set exist 0
  for {set st 1} {$st < $paramUsize} {incr st} {
    if {[array names paramU "$st,5"] == ""} continue
    if {$v(_setE) > 0} {
      if {$paramU($st,5) >= 0} continue ;# 正にすべき時のE=0はOK
    } else {
      if {$paramU($st,5) < 0} continue  ;# 負にすべき時のE=0は通常このままにしておくべきでない
    }
    set exist 1
    break
  }
  if {! $exist} {
    set v(setE) $v(_setE)
    return
  }

  set act [tk_dialog .confm $t(changeE,title) $t(changeE,q,$v(_setE)) \
    question 0 $t(changeE,a,$v(_setE)) $t(changeE,a2,$v(_setE)) $t(changeE,a3,$v(_setE))]
  if {$act == 2} {         ;# 変更をキャンセルする場合
    set v(_setE) $v(setE)
    return
  }

  ;# いったんメニュー上の値v(_setE)を以前の状態にしてアンドゥスタックに保存する
  set tmp $v(_setE)
  set v(_setE) $v(setE)
  pushUndo col 5 $t(changeE,undo)
  set v(_setE) $tmp
  snack::sound sWork

  if {$act == 1} {
    ;# 符号だけを変える場合
    for {set i $st} {$i < $paramUsize} {incr i} {
      if {[array names paramU "$i,5"] == ""} continue
      if {$v(_setE) >= 0} {
        if {$paramU($i,5) >= 0} continue
      } else {
        if {$paramU($i,5) < 0} continue
      }
      set paramU($i,5) [expr - $paramU($i,5)]
      jumpRec $paramU($i,R) $v(listC)
      set paramS($i,E) [u2sec E $i 5]
    }
  } else {
    ;# パラメータ位置が変わらないように符号を変更する場合
    for {set i $st} {$i < $paramUsize} {incr i} {
      if {[array names paramU "$i,5"] == ""} continue
      if {$v(_setE) >= 0} {
        if {$paramU($i,5) >= 0} continue
        set fname "$v(saveDir)/$paramU($i,0).$v(ext)"
        if [catch {sWork read $fname}] {
          set newE 0
        } else {
          set newE [cut3 [expr [sWork length -unit SECONDS] * 1000 - $paramS($i,E) * 1000]] 
          if {$newE < 0} {
            set newE 0
          }
        }
      } else {
        if {$paramU($i,5) < 0} continue
        set S 0
        if {[array names paramS "$i,S"] != ""} {
          set S $paramS($i,S)
        }
        set newE [cut3 [expr - ($paramS($i,E) - $S) * 1000] ]
      }
      set paramU($i,5) $newE
    }
  }
  set v(setE) $v(_setE)
  set v(paramChanged) 1
  Redraw all
  setEPWTitle
  pushUndo agn
}

#---------------------------------------------------
# 連続音wavのoto.iniを読み、
# 足りないエイリアスを単独音のパラメータをコピーして生成する
#
proc aliasComplement {} {
  global v paramU paramUsize t

  ;# set fnames [lsort [glob -nocomplain [format "%s/oto.ini" $v(saveDir)]]]

  set act [tk_dialog .confm $t(.confm) \
    $t(aliasComplement,q) \
    question 0 $t(.confm.yes) $t(.confm.no) $t(.confm.c)]
  if {$act == 2} return

  set aliasList {}

  if {$act == 0} {
    ;# 併用する連続音oto.ini(原音設定済みのもの)を選ぶ
    set fn [tk_getOpenFile -initialfile $v(paramFile) \
            -title $t(aliasComplement,selMsg) -defaultextension "ini" \
            -filetypes { {{UTAU param file} {.ini}} {{All Files} {*}} }]
    if {$fn == ""} return
 
    ;# 併用する連続oto.iniを開く
    if [catch {open $fn r} fp] { 
      tk_messageBox -message "error: can not open $fn" \
        -title $t(.confm.fioErr) -icon warning
      return
    }
    
    fconfigure $fp -encoding shiftjis

    ;# 連続oto.iniからエイリアスを呼んでリストに登録する
    while {![eof $fp]} {
      set l [gets $fp]   ;# "fname=A,S,C,E,P,O"
      set p [split $l "=,"]
      if {[llength $p] == 7 && [lindex $p 1] != ""} {
        lappend aliasList "[lindex $p 1]"
      }
    }
    close $fp
  }

  initProgressWindow
  pushUndo all "" $t(aliasComplement,undo)

  ;# 編集中のパラメータ(単独音のみ又は単独連続混在)から登録済みのエイリアスリストを作る
  for {set r 1} {$r < $paramUsize} {incr r} {
    if {[array names paramU "$r,6"] != "" && [regexp { } $paramU($r,6)]} {
      if {[lsearch $aliasList "$paramU($r,6)"] < 0} {
        lappend aliasList "$paramU($r,6)"
      }
    }
    updateProgressWindow [expr 30 * $r / $paramUsize]
  }

  ;# 現在開いている単独音一覧から生成できるエイリアスで、かつ
  ;# 既存のエイリアスリストに存在しないものを見つけてエイリアスを追加登録する
  set prevList {a i u e o n -}
  set addNum 0
  set r 1
  while {$r < $paramUsize} {
    if {! [regexp {^_} $paramU($r,0)]} {
      foreach prev $prevList {
        set alias "$prev $paramU($r,0)"
        if {[lsearch $aliasList $alias] < 0} {
          duplicateEntp .entpwindow.t 0 $r     ;# パラメータを複製する
          set paramU([expr $r + 1],6) $alias   ;# エイリアスを設定する
          lappend aliasList $alias
          incr addNum
          incr r
        }
      }
    }
    incr r
    updateProgressWindow [expr 30 + 70 * $r / $paramUsize]
  }
  deleteProgressWindow
  tk_messageBox -message "[eval format $t(aliasComplement,doneMsg)] (num=$addNum)" -title $t(aliasComplement,doneTitle) -icon info
  if {$addNum <= 0} {
    cancelUndo
  } else {
    pushUndo agn
  }
}

#---------------------------------------------------
# 「を」や「a を」などが無い場合「お」を複製して補完する
# 「ぢ」「づ」にも対応
#
proc woComplement {} {
  global v paramU paramUsize t
  pushUndo all "" $t(woComplement,undo)
  set addNum 0
  set addNum [expr $addNum + [_woComplement お を]]   ;# 「を」を「お」で補完する
  set addNum [expr $addNum + [_woComplement じ ぢ]]   ;# 「ぢ」を「じ」で補完する
  set addNum [expr $addNum + [_woComplement ず づ]]   ;# 「づ」を「ず」で補完する
  tk_messageBox -message "[eval format $t(woComplement,doneMsg)] (num=$addNum)" -title $t(woComplement,doneTitle) -icon info
  if {$addNum <= 0} {
    cancelUndo
  } else {
    pushUndo agn
  }
}

#---------------------------------------------------
# 文字dst("を"など) が無いときに文字src("お"など)を複製して補完する
#
proc _woComplement {src dst} {
  global v paramU paramUsize t

  ;# どんな「を」(dst)のデータがあるかを探してwoListに保存
  set woList {}
  for {set r [expr $paramUsize - 1]} {$r >= 0} {incr r -1} {
    if {[array names paramU "$r,6"] != "" && [regexp "^. $dst" $paramU($r,6)]} {
      lappend woList $paramU($r,6)
    } elseif [regexp "^$dst" $paramU($r,0)] {
      lappend woList $paramU($r,0)
    }
  }

  ;# 「* お」(src)のデータが存在し「* を」(dst)のデータが無ければ「* お」を複製して「* を」を作る
  set addNum 0
  for {set r [expr $paramUsize - 1]} {$r >= 0} {incr r -1} {
    if {[array names paramU "$r,6"] != "" && [regexp $src $paramU($r,6)]} {
      regsub -- $src $paramU($r,6) $dst alias
      if {[lsearch $woList $alias] < 0} {
        duplicateEntp .entpwindow.t 0 $r     ;# パラメータを複製する
        set paramU([expr $r + 1],6) $alias   ;# エイリアスを設定する
        incr addNum
        lappend woList $alias
      }
    }
    if [regexp "^$src" $paramU($r,0)] {
      regsub -- $src $paramU($r,0) $dst alias
      if {[lsearch $woList $alias] < 0} {
        duplicateEntp .entpwindow.t 0 $r     ;# パラメータを複製する
        set paramU([expr $r + 1],6) $alias   ;# エイリアスを設定する
        incr addNum
        lappend woList $alias
      }
    }
  }
  return $addNum
}

#---------------------------------------------------
# 保存フォルダ内の全wavファイル名冒頭に_を追記する
# mode.. wavOnly=wavファイルのみを変更。
#        whole=wavファイル以外も変更する。
#
proc addUnderScore {{mode wavOnly}} {
  global v paramU paramUsize t

  ;# 実行確認
  if {$mode == "whole"} {
    set act [tk_dialog .confm $t(.confm) $t(addUnderScore,q2) \
      question 1 $t(.confm.yes) $t(.confm.no)]
  } else {
    set act [tk_dialog .confm $t(.confm) $t(addUnderScore,q) \
      question 1 $t(.confm.yes) $t(.confm.no)]
  }
  if {$act == 1} return

  ;# 処理対象のファイルを得る
  set fnames [lsort [glob -nocomplain [format "%s/?*.%s" $v(saveDir) $v(ext)]]]
  if {$mode == "whole"} {
    set fnamesTmp {}
    foreach fullpath $fnames {
      set tmplist  [glob -nocomplain [format "%s.*" [file rootname $fullpath]]]
      set tmplist2 [glob -nocomplain [format "%s_wav.*" [file rootname $fullpath]]]
      set fnamesTmp [concat $fnamesTmp [lsort [concat $tmplist $tmplist2]]]
    }
    set fnames $fnamesTmp
  }
  set procNum [llength $fnames]
  set i 0
  set N 0
  initProgressWindow
  foreach fullpath $fnames {
    set filename [file tail $fullpath]
    if {![regexp {^_} $filename]} {
      set dir [file dirname $fullpath]
      file rename "$dir/$filename" "$dir/_$filename"                    ;# ファイル名変更
      incr N
    }
    updateProgressWindow [expr 100 * $i / $procNum]
    incr i
  }

  for {set i 0} {$i < [llength $v(recList)]} {incr i} {
    set fid [lindex $v(recList) $i]
    if ![regexp {^_} $fid] {
      set v(recList) [lreplace $v(recList) $i $i "_$fid"]  ;# recList変更
    }
  }

  for {set i 1} {$i < $paramUsize} {incr i} {
    if ![regexp {^_} $paramU($i,0)] {
      set paramU($i,0) "_$paramU($i,0)"                       ;# paramU変更
    }
  }

  ;# 終了通知
  deleteProgressWindow
  if {$N > 0} {
    if {$mode == "whole"} {
      tk_messageBox -message "[eval format $t(addUnderScore,doneMsg3)] (num=$N)" -title $t(addUnderScore,doneTitle) -icon info
    } else {
      tk_messageBox -message "[eval format $t(addUnderScore,doneMsg)] (num=$N)" -title $t(addUnderScore,doneTitle) -icon info
    }
    clearUndo
    set v(paramChanged) 1
  } else {
    tk_messageBox -message "[eval format $t(addUnderScore,doneMsg2)] (num=$N)" -title $t(addUnderScore,doneTitle) -icon info
  }

  ;# 波形再読み込み、再描画
  resetDisplay
}

#---------------------------------------------------
# 保存フォルダ内の全wavファイルをモノラルに変換する
#
proc convertMonoAll {} {
  global v t paramUsize

  ;# 実行確認
  set act [tk_dialog .confm $t(.confm) $t(convertMonoAll,q) \
    question 1 $t(.confm.yes) $t(.confm.no)]
  if {$act == 1} return

  snack::sound sWork

  ;# モノラル化
  initProgressWindow
  set fnames [lsort [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]]]
  set N [llength $fnames]
  set i 0
  foreach filename $fnames {
    if [catch {sWork read $filename}] {
    } else {
      if {[sWork cget -channels] > 1} {
        sWork convert -channels Mono
        sWork write $filename
      }
    }
    updateProgressWindow [expr 100 * $i / $N]
    set v(msg) "($i / $N)"
    incr i
  }

  ;# 終了通知
  deleteProgressWindow
  tk_messageBox -message [eval format $t(convertMonoAll,doneMsg)] -title $t(convertMonoAll,doneTitle) -icon info

  ;# 波形再読み込み、再描画
  readWavFile
  Redraw all
  # clearUndo

}

#---------------------------------------------------
# 保存フォルダ内の全wavファイルのDC成分を一括除去する
#
proc removeDCall {} {
  global v t paramUsize

  ;# 実行確認
  set act [tk_dialog .confm $t(.confm) $t(removeDCall,q) \
    question 1 $t(.confm.yes) $t(.confm.no)]
  if {$act == 1} return

  ;# フィルタ作成
  set flt [snack::filter iir -numerator "0.99 -0.99" -denominator "1 -0.99"] 
  snack::sound sWork

  ;# DC成分除去
  initProgressWindow
  set fnames [lsort [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]]]
  set N [llength $fnames]
  set i 0
  foreach filename $fnames {
    if [catch {sWork read $filename}] {
    } else {
      sWork filter $flt -continuedrain 0
      sWork write $filename
    }

    updateProgressWindow [expr 100 * $i / $N]
    set v(msg) "($i / $N)"
    incr i
  }

  ;# 終了通知
  deleteProgressWindow
  tk_messageBox -message [eval format $t(removeDCall,doneMsg)] -title $t(removeDCall,doneTitle) -icon info

  ;# 波形再読み込み、再描画
  readWavFile
  Redraw all
  #  clearUndo
}

#---------------------------------------------------
# 保存フォルダ内の全wavファイルのF0ファイルを作る。
# もし既に同名ファイルがある場合、wavファイルの日付よりF0ファイルの日付が古ければ上書きする。
# もし引数unitが"semitone"ならセミトーン単位、それ以外ならHz単位で出力する。
# 無声部は0を出力する。
#
proc saveF0File {{unit "Hz"}} {
  global v sv t f0

  snack::sound sWork
  initProgressWindow "F0 extraction"

  set fnames [lsort [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]]]
  set N [llength $fnames]
  set i 0
  foreach filename $fnames {
    if [catch {sWork read $filename}] {
      continue
    }
    set f0file [format "%s.%s-f0" [file rootname $filename] $sv(appname)]

    ;# もし既にF0ファイルがあり、日付がwavより新しいなら次へスキップ
    if {[file exists $f0file]} {
      if {[file mtime $f0file] >= [file mtime $filename]} continue
    }

    ;# 保存ファイルを開く
    if [catch {open $f0file w} fp] { 
      tk_messageBox -message "error: can not open $f0file" \
        -title $t(.confm.fioErr) -icon warning
      return
    }
    
    fconfigure $fp -encoding utf-8

    ;# F0を求める
    if {[catch {set seriestmp [sWork pitch -method $f0(method) \
        -framelength $f0(frameLength) -windowlength $f0(windowLength) \
        -maxpitch $f0(max) -minpitch $f0(min) \
        -progress waitWindow] } ret]} {
      if {$ret != ""} {
        # puts "error: $ret"
      }
      set seriestmp {}
    }

    ;# F0を出力する
    foreach s $seriestmp {
      set val [lindex [split $s " "] 0]
      if {$unit == "semitone" && $val > 0} {
        set val [hz2semitone $val]
      }
      puts $fp $val
    }

    close $fp

    updateProgressWindow [expr 100 * $i / $N] "F0 extraction"
    set v(msg) "F0 extraction ($i / $N)"
    incr i
  }

  deleteProgressWindow
  update
}

#---------------------------------------------------
# 保存フォルダ内の全wavファイルのパワーファイルを作る
# もし既に同名ファイルがある場合、wavファイルの日付よりパワーファイルの日付が古ければ上書きする
#
proc savePowerFile {} {
  global v sv t power

  snack::sound sWork
  initProgressWindow "Power extraction"

  set fnames [lsort [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]]]
  set N [llength $fnames]
  set i 0
  foreach filename $fnames {
    if [catch {sWork read $filename}] {
      continue
    }
    set powfile [format "%s.%s-power" [file rootname $filename] $sv(appname)]

    ;# もし既にファイルがあり、日付がwavより新しいなら次へスキップ
    if {[file exists $powfile]} {
      if {[file mtime $powfile] >= [file mtime $filename]} continue
    }

    ;# 保存ファイルを開く
    if [catch {open $powfile w} fp] { 
      tk_messageBox -message "error: can not open $powfile" \
        -title $t(.confm.fioErr) -icon warning
      return
    }
    
    fconfigure $fp -encoding utf-8

    ;# パワーを求める
    if {[catch {set seriestmp [sWork power -framelength $power(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1] } ret]} {
      set seriestmp {}
    }

    ;# パワーを出力する
    foreach val $seriestmp {
      puts $fp $val
    }

    close $fp

    updateProgressWindow [expr 100 * $i / $N] "Power extraction"
    set v(msg) "power extraction ($i / $N)"
    incr i
  }

  deleteProgressWindow
  update
}

#---------------------------------------------------
# 一覧表の指定範囲のリストを得る
#
proc getCurSelection {} {
  set target [.entpwindow.t curselection]
  if {[llength $target] <= 0} {
    ;#もし設定窓のentryをダブルクリックするなどしてセルの選択が消えていた場合は
    ;#アクティブなセルを選択し直す
    .entpwindow.t selection set active
    set target [.entpwindow.t curselection]
  }
  .entpwindow.t see active    ;# 選択セルが見えるようにする
  return $target
}

#---------------------------------------------------
# 指定した範囲のデータに対して一律に値を設定したり加減算したりする
#
proc changeCell {} {
  global chCell v t

  if [isExist $chCell(w)] return ;# 二重起動を防止
  toplevel $chCell(w)
  wm title $chCell(w) $t(changeCell,title)
  bind $chCell(w) <Escape> "destroy $chCell(w)"

  set f [frame $chCell(w).f -padx 5 -pady 5]
  pack $f

  radiobutton $f.r1 -variable chCell(ccMode) -value  1 -text $t(changeCell,r1)
  radiobutton $f.r2 -variable chCell(ccMode) -value -1 -text $t(changeCell,r2)
  radiobutton $f.r3 -variable chCell(ccMode) -value  0 -text $t(changeCell,r3)
  radiobutton $f.r4 -variable chCell(ccMode) -value  2 -text $t(changeCell,r4)
  grid $f.r1 $f.r2 $f.r3 $f.r4

  set f1 [frame $chCell(w).f1 -padx 5 -pady 5]
  pack $f1
  label $f1.l -text $t(changeCell,l)
  entry $f1.e -textvar chCell(ccVal) -validate all -validatecommand {
    if {[isDouble %P] || [regexp {^-$} %P]} {
      expr {1}
    } else {
      expr {0}
    }
  }
  grid  $f1.l $f1.e
  focus $f1.e

  set f2 [frame $chCell(w).f2 -padx 5 -pady 5]
  pack $f2
  label $f2.l -text $t(changeCell,rtitle)
  grid $f2.l

  set f3 [frame $chCell(w).f3 -padx 5 -pady 5]
  pack $f3
  radiobutton $f3.r1 -variable chCell(restrictMode) -value 1 -text $t(changeCell,rr1)
  radiobutton $f3.r2 -variable chCell(restrictMode) -value 2 -text $t(changeCell,rr2)
  radiobutton $f3.r3 -variable chCell(restrictMode) -value 3 -text $t(changeCell,rr3)
  radiobutton $f3.r4 -variable chCell(restrictMode) -value 4 -text $t(changeCell,rr4)
  grid $f3.r1 $f3.r2 $f3.r3 $f3.r4

  set f4 [frame $chCell(w).f4 -padx 5 -pady 5]
  pack $f4
  label $f4.l -text $t(changeCell,rl)
  entry $f4.e -textvar chCell(rVal) -validate all -validatecommand {
    if {[isDouble %P] || [regexp {^-$} %P]} {
      expr {1}
    } else {
      expr {0}
    }
  }

  grid  $f4.l $f4.e

  set f5 [frame $chCell(w).f5 -padx 5 -pady 5]
  pack $f5
  button $f5.r -text $t(.confm.run) -command {
    doChangeCell $chCell(ccMode) $chCell(ccVal) $chCell(restrictMode) $chCell(rVal)
    destroy $chCell(w)
    raise .entpwindow
    focus .entpwindow.t
  }
  button $f5.cancel -text $t(.confm.c) -command {
    destroy $chCell(w)
    raise .entpwindow
    focus .entpwindow.t
  }
  grid $f5.r $f5.cancel
  raise $chCell(w)
  focus $chCell(w)
}

#---------------------------------------------------
# 指定した範囲のデータに対して一律に値を設定したり加減算したりする
#
proc doChangeCell {mode val rMode rVal} {
  global paramU v t

  if {$val  == "-"} { set val  0 }
  if {$rVal == "-"} { set rVal 0 }
  if {$val == "" && $mode != 2 && $mode != 0} return
  set undoOpt [getRctOpt]
  set tmp [split $undoOpt ","]
  if {[lindex $tmp 1] == 1} {   ;# もし左ブランクの値を変えるなら。
    if {[lindex $tmp 3] > 5} {
      set c2 [lindex $tmp 3]
    } else {
      set c2 5
    }
    set undoOpt [format "%d,1,%d,%d" [lindex $tmp 0] [lindex $tmp 2] $c2]
  }
  pushUndo rct $undoOpt $t(changeCell,title)

  foreach pos [getCurSelection] {
    ;# pasteする位置と現在の値を得る
    set u [split $pos ","]
    set r [lindex $u 0]
    set c [lindex $u 1]
    if {$c >= 6 && $mode != 0} continue   ;# エイリアスの欄以降についての対応
    if {[array names paramU $pos] != ""} {
      set curVal $paramU($pos)
    } else {
      set curVal 0
    }
    if {$rVal != ""} {
      switch $rMode {
        2 { if {$curVal != $rVal} continue }  ;# 一致モードで一致でなかったら
        3 { if {$curVal <  $rVal} continue }  ;# 以上モードで以上でなかったら
        4 { if {$curVal >  $rVal} continue }  ;# 以下モードで以下でなかったら
      }
    }
    if {$val == "" && $mode == 0} {
      set paramU($pos) $val
    } else {
      switch $mode {
         0 { set paramU($pos) [cut3 $val] }
         1 { set paramU($pos) [cut3 [expr $curVal + $val]] }
        -1 { set paramU($pos) [cut3 [expr $curVal - $val]] }
         2 { set paramU($pos) [cut3 [expr int($curVal)]] }
      }
    }
    paramU2paramS $r
  }
  set v(paramChanged) 1
  Redraw all
  setEPWTitle
  pushUndo agn
}

#---------------------------------------------------
# エイリアス一括変換
#
proc changeAlias {} {
  global chAlias t

  if [isExist $chAlias(traWindow)] return ;# 二重起動を防止
  toplevel $chAlias(traWindow)
  wm title $chAlias(traWindow) $t(changeAlias,title)
  bind $chAlias(traWindow) <Escape> "destroy $chAlias(traWindow)"

  set f [frame $chAlias(traWindow).f -padx 5 -pady 5]
  pack $f
  set r 0

  label  $f.l$r -text $t(changeAlias,trans)
  entry  $f.e$r -textvar chAlias(transRule)
  grid $f.l$r -row $r -column 0 -sticky e  -pady 2
  grid $f.e$r -row $r -column 1 -sticky we -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,delPreNum)
  entry  $f.e$r -textvar chAlias(delPreNum) -validate all -validatecommand {isDouble %P}
  grid $f.l$r -row $r -column 0 -sticky e  -pady 2
  grid $f.e$r -row $r -column 1 -sticky we -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,delPostNum)
  entry  $f.e$r -textvar chAlias(delPostNum) -validate all -validatecommand {isDouble %P}
  grid $f.l$r -row $r -column 0 -sticky e  -pady 2
  grid $f.e$r -row $r -column 1 -sticky we -pady 2
  incr r

  # エイリアス重複に関する設定欄
  label $f.ll$r   -text $t(changeAlias,aliasMaxNum)
  entry $f.e$r    -textvar chAlias(aliasMax) -wi 10 -validate all -validatecommand {isDouble %P}
  grid $f.ll$r -row $r -column 0 -sticky e
  grid $f.e$r  -row $r -column 1 -sticky we
  incr r

  # 実行、キャンセルボタン
  frame $f.f$r
  button $f.f$r.b$r -text $t(changeAlias,runAll) -command {
    doTransAlias $chAlias(transRule) $chAlias(delPreNum) $chAlias(delPostNum) $chAlias(aliasMax) col
    destroy $chAlias(traWindow)
  }
  button $f.f$r.bs$r -text $t(changeAlias,runSel) -command {
    doTransAlias $chAlias(transRule) $chAlias(delPreNum) $chAlias(delPostNum) $chAlias(aliasMax) sel
    destroy $chAlias(traWindow)
  }
  button $f.f$r.bc$r -text $t(.confm.c) -command {
    destroy $chAlias(traWindow)
  }
  grid $f.f$r  -row $r -column 0 -sticky e -pady 2 -columnspan 3
  grid $f.f$r.b$r  -row 0 -column 0 -sticky e  -pady 2
  grid $f.f$r.bs$r -row 0 -column 1 -sticky e  -pady 2
  grid $f.f$r.bc$r -row 0 -column 2 -sticky w  -pady 2
  incr r

  # ヘルプ説明
  label  $f.l$r -text $t(changeAlias,tips0)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,tips0b)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,tips1)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,tips2)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,tips3)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  label  $f.l$r -text $t(changeAlias,ex1)
  grid $f.l$r -row $r -column 0 -columnspan 2 -sticky w -pady 2
  incr r

  raise $f.e0
  focus $f.e0
}

#---------------------------------------------------
# 文字列（a あ2_A3など）の冒頭から
# 「あ」や「a あ」などの音名とその後の部分とに分解してリストで返す
# str  ... 解析対象文字列
# kind ... "A"=$strはエイリアス、"F"=$strはファイル名
#
proc parseOtomei {str {kind "A"}} {
  set otomei ""           ;# 音名を初期化
  set suffix ""           ;# 接尾辞を初期化
  set str [string trim $str]
  if {$kind == "F"} {
    regsub -- {^.*/} $str "" str                 ;# フォルダパスを削除
  }
  regexp {^([^ ]+ )(.+)$} $str dummy otomei str  ;# 連続音名の場合、先行母音部を取り出してotomeiへ。
  ;# otomeiを完成させる
  set char [string range $str 0 0]
  if {$char != "_" && [isKana $char]} {
    # 音名が平仮名カタカナの場合
    for {set i 0} {$i < [string length $str]} {incr i} {
      set char [string range $str $i $i]
      if {$char != "_" && [isKana $char]} {
        set otomei "$otomei$char"
      } else {
        break
      }
    }
  } else {
    # 音名がアルファベットの場合
    for {set i 0} {$i < [string length $str]} {incr i} {
      set char [string range $str $i $i]
      if {$char != "_" && [regexp {^[\-'*a-zA-Z]+$} $char]} {
        set otomei "$otomei$char"
      } else {
        break
      }
    }
  }
  ;# suffixを作る
  if {$i < [string length $str]} {
    set suffix [string range $str $i end]
  }
  return [list $otomei $suffix]
}

#---------------------------------------------------
# エイリアス一括変換
#
proc doTransAlias {{transRule ""} {delPreNum 0} {delPostNum 0} {aliasMax 0} {mode col}} {
  global paramU paramUsize v t

  if {$transRule == ""} return

  set targetList {}
  if {$mode == "col"} {
    for {set r 1} {$r < $paramUsize} {incr r} {
      lappend targetList $r
    }
  } else {
    foreach pos [getCurSelection] {
      set r [lindex [split $pos ","] 0]
      if {[lindex $targetList end] != $r} {
        lappend targetList $r
      }
    }
  }
  if {[llength $targetList] <= 0} return

  initProgressWindow
  if {[regexp {%r} $transRule] && $aliasMax > 0} {
    # %rがあり重複最大数が設定されている場合は行削除される可能性があるので全部アンドゥスタックに入れる
    pushUndo all "" $t(tool,changeAlias)
  } else {
    if {$mode == "col"} {
      pushUndo col 6 $t(tool,changeAlias)
    } else {
      set tmp [split [getRctOpt] ","]
      set undoOpt [format "%d,6,%d,6" [lindex $tmp 0] [lindex $tmp 2]]
      pushUndo rct $undoOpt $t(tool,changeAlias)
    }
  }

  ;# ファイル名、エイリアスを挿入
  foreach r $targetList {
    set newAlias $transRule

    ;# %m、%sの処理（%mに音名を挿入、%sに現在のエイリアスの接尾辞）
    if {[regexp {%[ms]} $newAlias]} {
      if {[array names paramU "$r,6"] != "" && $paramU($r,6) != ""} {
        set ret [parseOtomei $paramU($r,6) "A"]
        set otomei [lindex $ret 0]
        set suffix [lindex $ret 1]
      } else {
        set ret [parseOtomei $paramU($r,0) "F"]
        set otomei [lindex $ret 0]
        set suffix [lindex $ret 1]
      }
      set rule {}; lappend rule "%m"; lappend rule $otomei
      set newAlias [string map $rule $newAlias]
      set rule {}; lappend rule "%s"; lappend rule $suffix
      set newAlias [string map $rule $newAlias]
    }

    ;# %fの処理（%fにファイル名を挿入）
    if {[array names paramU "$r,0"] != "" && $paramU($r,0) != ""} {
      set fid   $paramU($r,0)
      set rule {}; lappend rule "%f"; lappend rule $fid
      set newAlias [string map $rule $newAlias]
    } else {
      set newAlias [string map {%f ""} $newAlias]
    }
    ;# %aの処理（%aに現在のエイリアスを挿入）
    if {[array names paramU "$r,6"] != "" && $paramU($r,6) != ""} {
      set alias $paramU($r,6)
      ;# 冒頭から指定した文字数を削除
      if {$delPreNum > 0} {
        set alias [string replace $alias 0 [expr $delPreNum -1]]
      }
      ;# 末尾から指定した文字数を削除
      if {$delPostNum > 0} {
        set st [expr [string length $alias] - $delPostNum]
        set alias [string replace $alias $st end]
      }
      if {$alias != ""} {
        set rule {}; lappend rule "%a"; lappend rule $alias
        set newAlias [string map $rule $newAlias]
      } else {
        set newAlias [string map {%a ""} $newAlias]
      }
    } else {
      set newAlias [string map {%a ""} $newAlias]
    }

    set paramU($r,6) $newAlias
    if {[regexp {%r} $paramU($r,6)] } {
      updateProgressWindow [expr  80 * $r / $paramUsize]
    } else {
      updateProgressWindow [expr 100 * $r / $paramUsize]
    }
  }

  ;# 重複番号を挿入
  if {[regexp {%r} $paramU([lindex $targetList 0],6)]} {
    ;# もし%rがあれば、各音の重複番号を求める
    array unset cnum   ;# 音の名前ごとの重複回数を入れる配列を初期化
    array unset rseq   ;# 音ごとの重複回数を入れる配列を初期化
    foreach r $targetList {
      set src ""
      if {[array names paramU "$r,6"] != "" && $paramU($r,6) != ""} {
        set src $paramU($r,6)
      } else {
        set src $paramU($r,0)
      }

      if {[array names cnum "$src"] != ""} {
        incr cnum($src)
      } else {
        set cnum($src) 1
      }
      set rseq($r) $cnum($src)
      updateProgressWindow [expr 80 + 10 * $r / $paramUsize]
    }
    ;# 音ごとの重複回数をエイリアスに書き込む
    set deleteList {}
    foreach r $targetList {
      if {$rseq($r) <= 1} {
        ;# 重複がないとき
        if {[array names paramU "$r,6"] != "" && $paramU($r,6) != ""} {
          set paramU($r,6) [string map {%r ""} $paramU($r,6)]   ;# %rを消す
        }
      } else {
        ;# 重複があるとき
        set seq $rseq($r)
        if {$aliasMax <= 0 || $seq <= $aliasMax} {
          set paramU($r,6) [string map "%r $seq" $paramU($r,6)]   ;# 重複番号を付ける
        } else {
          lappend deleteList $r
        }
      }
      updateProgressWindow [expr 90 + 10 * $r / $paramUsize]
    }
    ;# 上限を超えたエントリを削除する
    foreach r [lreverse $deleteList] {
      deleteEntp dummy 0 $r
    }
    ;# 削除できなかったエントリがあれば%rを消す
    foreach r $targetList {
      if {[array names paramU "$r,6"] != "" && [regexp {%r} $paramU($r,6)]} {
        set paramU($r,6) [string map {%r ""} $paramU($r,6)]   ;# %rを消す
      }
    }
  }

  ;# 波形再読み込み、再描画
  deleteProgressWindow
  set v(paramChanged) 1
  setLabAlias
  setEPWTitle
  pushUndo agn
}

#---------------------------------------------------
# 保存フォルダの各wavの両端を指定秒カット
#
proc cutWav {} {
  global ctWav v t

  if [isExist $ctWav(w)] return ;# 二重起動を防止
  toplevel $ctWav(w)
  wm title $ctWav(w) $t(cutWav,title)
  bind $ctWav(w) <Escape> "destroy $ctWav(w)"

  set r 0
  label $ctWav(w).l0$r -text $t(cutWav,L)
  entry $ctWav(w).l1$r -textvar ctWav(L) -validate all -validatecommand {isDouble %P}
  label $ctWav(w).l2$r -text $t(cutWav,sec)
  grid  $ctWav(w).l0$r -row $r -column 0 -sticky e
  grid  $ctWav(w).l1$r -row $r -column 1 -sticky we
  grid  $ctWav(w).l2$r -row $r -column 2 -sticky w
  incr r

  label $ctWav(w).l0$r -text $t(cutWav,R)
  entry $ctWav(w).l1$r -textvar ctWav(R) -validate all -validatecommand {isDouble %P}
  label $ctWav(w).l2$r -text $t(cutWav,sec)
  grid  $ctWav(w).l0$r -row $r -column 0 -sticky e
  grid  $ctWav(w).l1$r -row $r -column 1 -sticky we
  grid  $ctWav(w).l2$r -row $r -column 2 -sticky w
  incr r

  checkbutton $ctWav(w).l0$r -variable ctWav(adjSE) -text $t(cutWav,adjSE)
  grid  $ctWav(w).l0$r -row $r -column 0 -columnspan 3
  incr r

  frame $ctWav(w).f$r
  button $ctWav(w).f$r.l0 -text $t(.confm.run) -command {
    destroy $ctWav(w)
    doCutWav $ctWav(L) $ctWav(R)
  }
  button $ctWav(w).f$r.l1 -text $t(.confm.c)   -command {
    destroy $ctWav(w)
  }
  pack $ctWav(w).f$r.l0 $ctWav(w).f$r.l1 -side left
  grid  $ctWav(w).f$r    -row $r -column 0 -columnspan 3
  incr r
}

#---------------------------------------------------
# 保存フォルダの各wavの両端を指定秒カット
#
proc doCutWav {L R} {
  global paramS paramU paramUsize ctWav v t

  if {$L == ""} { set L 0 }
  if {$R == ""} { set R 0 }

  if {! [string is double $L] || ! [string is double $R] || $L < 0 || $R < 0} {
    tk_messageBox -message [eval format $t(doCutWav,errMsg)] \
      -title $t(.confm.errTitle) -icon error
    return
  }
  if {$L == 0 && $R == 0} return

  ;# 実行確認
  set act [tk_dialog .confm $t(.confm) $t(doCutWav,q) \
    question 1 $t(.confm.yes) $t(.confm.no)]
  if {$act == 1} return

  ;# 両端カット
  snack::sound sWork
  initProgressWindow
  set cutS [expr int($L * $v(sampleRate))]
  array unset cutlog   ;# カット済みのfidを登録する配列
  ;# v(setS)のバックアップをとり、一時的にv(setS)=0にする
  ;# (↑changeParamでSの値のみ変更させるため)
  set setSbackup $v(setS)
  set v(setS) 0
  for {set r 1} {$r < $paramUsize} {incr r} {
    set fid $paramU($r,0)

    ;# カット済みファイルなら次へ
    if {[array names cutlog $fid] != ""} continue
    set cutlog($fid) 1

    ;# wavファイルを読む
    set filename $v(saveDir)/$fid.$v(ext)
    if [catch {sWork read $filename}] {
      continue
    }
    set len [sWork length -unit SAMPLES]
    set cutE [expr $len - int($R * $v(sampleRate))]
    sWork crop $cutS $cutE
    sWork write $filename

    ;# S,E値を修正
    if $ctWav(adjSE) {
      ;# S値を補正
      set c 1
      if {[array names paramU "$r,$c"] != ""} {
        set oldValue $paramU($r,$c)
        set newValue [cut3 [expr $oldValue - $L * 1000]]
        if {$newValue < 0} { set newValue 0 }
        changeParam $oldValue $newValue $r $c
      }

      ;# E値を補正
      set c 5
      if {$R > 0 && [array names paramU "$r,$c"] != "" && $v(setE) > 0} {
        set oldValue $paramU($r,$c)
        set newValue [cut3 [expr $oldValue  - $R * 1000]]
        if {$newValue < 0} { set newValue 0 }
        changeParam $oldValue $newValue $r $c
      }

      paramU2paramS $r
    }
    updateProgressWindow [expr 100 * $r / $paramUsize]
    set v(msg) "($r / $paramUsize)"
  }

  ;# v(setS)を以前の値に戻す
  set v(setS) $setSbackup

  ;# 波形再読み込み、再描画
  set v(paramChanged) 1
  readWavFile
  Redraw all
  clearUndo

  ;# 終了通知
  deleteProgressWindow
  tk_messageBox -message [eval format $t(doCutWav,doneMsg)] \
    -title $t(doCutWav,doneTitle) -icon info
}

#---------------------------------------------------
# 各パラメータを右上がりゼロクロス位置に移動する際の設定窓
#
proc zeroCross {} {
  global zcwindow pZeroCross v t

  if [isExist $zcwindow] return  ;# 二重起動を防止
  toplevel $zcwindow
  wm title $zcwindow $t(zeroCross,title)
  wm resizable $zcwindow 0 0
  bind $zcwindow <Escape> "destroy $zcwindow"

  set w [frame $zcwindow.al]
  pack $w
  set row 0

  ;# 対象の設定
  # frame $w.fem
  label $w.l$row -text $t(zeroCross,target)
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable pZeroCross(S)
  label $w.fe$row.t -text $t(zeroCross,S)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.l$row  -sticky w -row $row -column 0
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable pZeroCross(C)
  label $w.fe$row.t -text $t(zeroCross,C)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable pZeroCross(E)
  label $w.fe$row.t -text $t(zeroCross,E)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable pZeroCross(P)
  label $w.fe$row.t -text $t(zeroCross,P)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable pZeroCross(O)
  label $w.fe$row.t -text $t(zeroCross,O)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ボタンの設定
  button $w.do -text $t(zeroCross,runAll) -command {
    if {$::tcl_platform(os) != "Darwin"} { grab set $zcwindow }
    doZeroCross all
    if {$::tcl_platform(os) == "Darwin"} { deleteProgressWindow } ;# なぜかmacではdoZeroCrossの中で消せなかった(?)
    if {$::tcl_platform(os) != "Darwin"} { grab release $zcwindow }
    destroy $zcwindow
  }
  grid $w.do     -sticky we -row $row -column 0
  button $w.do2 -text $t(zeroCross,runSel) -command {
    if {$::tcl_platform(os) != "Darwin"} { grab set $zcwindow }
    doZeroCross sel
    if {$::tcl_platform(os) == "Darwin"} { deleteProgressWindow } ;# なぜかmacではdoZeroCrossの中で消せなかった(?)
    if {$::tcl_platform(os) != "Darwin"} { grab release $zcwindow }
    #destroy $zcwindow
  }
  grid $w.do2    -sticky we -row $row -column 1
  button $w.cancel -text $t(.confm.c) -command {destroy $zcwindow}
  grid $w.cancel -sticky we -row $row -column 2
  incr row
}

#---------------------------------------------------
# 表示行を変えたときに特定のパラメータに自動フォーカスさせるための設定窓
#
proc autoFocusSettings {} {
  global afwindow v t

  if [isExist $afwindow] return  ;# 二重起動を防止
  toplevel $afwindow
  wm title $afwindow $t(option,autoFocus)
  wm resizable $afwindow 0 0
  bind $afwindow <Escape> "destroy $afwindow"

  set w [frame $afwindow.al]
  pack $w

  label $w.t -text $t(option,autoFocus)
  radiobutton $w.rs -variable v(autoFocus) -value "S" -text $t(zeroCross,S)
  radiobutton $w.ro -variable v(autoFocus) -value "O" -text $t(zeroCross,O)
  radiobutton $w.rp -variable v(autoFocus) -value "P" -text $t(zeroCross,P)
  radiobutton $w.rc -variable v(autoFocus) -value "C" -text $t(zeroCross,C)
  radiobutton $w.re -variable v(autoFocus) -value "E" -text $t(zeroCross,E)
  radiobutton $w.rn -variable v(autoFocus) -value "none" -text $t(autoFocus,none)

  pack $w.t $w.rs $w.ro $w.rp $w.rc $w.re $w.rn -side top -anchor nw
  set v(autoFocus) $v(autoFocus)
}


#---------------------------------------------------
# パラメータ位置が右上がりゼロクロス位置に来るよう補正する
#
proc doZeroCross {{mode all}} {
  global paramS paramU paramUsize pZeroCross v t

  ;# 補正対象のパラメータがあるか確認する
  set ret 1
  foreach kind {S C E P O} {
    if $pZeroCross($kind) {
      set ret 0
      break
    }
  }
  if $ret return

  ;# 推定する行番号のリストを作る
  set targetList {}
  if {$mode == "all"} {
    for {set i 1} {$i < $paramUsize} {incr i} {
      lappend targetList $i
    }
  } else {
    foreach pos [getCurSelection] {
      set r [lindex [split $pos ","] 0]
      if {[lindex $targetList end] != $r} {
        lappend targetList $r
      }
    }
  }

  initProgressWindow
  if {$mode == "all"} {
    pushUndo all "" $t(zeroCross,title)
  } else {
    set tmp [split [getRctOpt] ","]
    set undoOpt [format "%d,1,%d,5" [lindex $tmp 0] [lindex $tmp 2]]
    pushUndo rct $undoOpt $t(zeroCross,title)
  }

  set seq 0
  foreach r $targetList {
    set fid $paramU($r,0)
    snack::sound sWork
    if [catch {sWork read "$v(saveDir)/$fid.$v(ext)"}] {
      tk_messageBox -message "error: can not open $v(saveDir)/$fid.$v(ext)" \
        -title $t(.confm.fioErr) -icon warning
      return 1
    }
    array unset wt
    set change 0

    foreach kind {S C E P O} {
      if {! $pZeroCross($kind)} continue
      if {[array get paramS "$r,$kind"] == ""} continue

      set orgParamS $paramS($r,$kind)
      set val [expr int($v(sampleRate) * $paramS($r,$kind))]

      set halfRange [expr int(0.06 * $v(sampleRate) / 2)]
      set st [expr $val - $halfRange]
      if {$st < 0} { set st 0 }
      set en [expr $val + $halfRange]
      if {$en > [sWork length]} {set en [sWork length]}

      if {[catch {set seriestmp [sWork pitch -method ESPS -start $st -end $en \
          -framelength 0.01 -windowlength 0.01 -maxpitch 800]} ret]} {
        if {$ret != ""} {
          puts "error: $ret"
        }
        set seriestmp {}
      }
      if {[llength $seriestmp] > 0} {
        set f0now [lindex [split [lindex $seriestmp 0] " "] 0]
        if {$f0now > 0} {
          set halfRange [expr int(1.5 / $f0now * $v(sampleRate) / 2)]
          set st [expr $val - $halfRange]
          if {$st < 0} { set st 0 }
          set en [expr $val + $halfRange]
          if {$en > [sWork length]} { set en [sWork length]}
        }
      }

      set max   [sWork sample $st]     ;# 瞬時値の最大値を入れる
      set zc     $st                   ;# ゼロクロス位置を入れていく
      set max_zc $st                   ;# 瞬時値最大の左にあるゼロクロスを入れる
      for {set i $st} {$i < $en} {incr i} {
        set wnow [lindex [sWork sample $i] 0]
        set wt([expr $i - $st]) $wnow
        if {$i > $st && $wt([expr $i - $st - 1]) <= 0 && 0 < $wnow} {
          set zc [expr $i - 1]
        }
        if {$max < $wnow} {
          set max   $wnow
          set max_zc $zc
        }
      }

      set newParamS [expr double($max_zc) / $v(sampleRate)]
      if {$newParamS != $orgParamS} {
        set paramS($r,$kind) $newParamS
        set change 1
      }
    }
    if {$change} { paramS2paramU $r }
    updateProgressWindow [expr 100 * $seq / [llength $targetList]]
    incr seq
  }

  deleteProgressWindow

  ;# 再描画
  set v(paramChanged) 1
  setEPWTitle
  Redraw all
  pushUndo agn
}

#---------------------------------------------------
# wavの左右カットを有効にするか確認する
#
proc cutBlankConfirm {} {
  global v t

  if $v(cutBlank) {
    ;# 有効にしてよいか確認
    set act [tk_dialog .confm $t(.confm) $t(cutBlankConfirm,q) \
      question 1 $t(.confm.yes) $t(.confm.no)]
    if {$act == 1} {
      set v(cutBlank) 0
    }
  }
}

#---------------------------------------------------
# wavの左右ブランクから外側をカット。それに合わせてパラメータ値を変更する
#
proc cutBlank {} {
  global paramS paramU paramUsize v t

  if {$v(cutBlank) == 0} return
  if {$paramUsize <= 0} return

  ;# 試聴対象の行番号リストを作成
  set rList {}
  foreach pos [getCurSelection] {
    set r [lindex [split $pos ","] 0]
    if {[lindex $rList end] != $r} {
      lappend rList $r
    }
  }
  if {[llength $rList] <= 0} {
    lappend rList $v(listSeq)
  }

  ;# v(setS)のバックアップをとり、一時的にv(setS)=0にする
  ;# (↑changeParamでSの値のみ変更させるため)
  set setSbackup $v(setS)
  set v(setS) 0

  foreach r $rList {
    set fid $paramU($r,0)
    set S  0
    set E -1
    set Eu 0
    if {[array get paramS "$r,S"] != ""} {
      set S [expr int($v(sampleRate) * $paramS($r,S))]
    }
    if {[array get paramS "$r,E"] != ""} {
      set E [expr int($v(sampleRate) * $paramS($r,E))]
    }
    if {[array get paramU "$r,5"] != ""} {
      set Eu $paramU($r,5))]
    }
    ;# 両端カット
    if {$S != 0 || $Eu != 0} {
      snack::sound sWork
      sWork read "$v(saveDir)/$fid.$v(ext)"
      sWork crop $S $E ;# 左右ブランク間のみを残す
      sWork write "$v(saveDir)/$fid.$v(ext)"

      ;# S値を補正
      if {$S != 0} {
        changeParam $paramU($r,1) 0 $r 1
      }

      ;# E値を補正
      if {$Eu != 0} {
        if {$v(setE) < 0} {
          set newE [cut3 [expr [sWork length -unit SECONDS] * -1000.0]]
          changeParam $paramU($r,5) $newE $r 5  ;# EをSからの時間で表す場合
        } else {
          changeParam $paramU($r,5) 0 $r 5      ;# Eを末尾からの時間で表す場合
        }
      }

      paramU2paramS $r
    }
  }
  ;# v(setS)を以前の値に戻す
  set v(setS) $setSbackup

  ;# 波形再読み込み、再描画
  set v(paramChanged) 1
  readWavFile
  Redraw all
  clearUndo
}

#---------------------------------------------------
# 合成音を作って試聴
#
proc playSyn {} {
  global v sv t f0 sndSyn snd paramU

  if {$::tcl_platform(platform) != "windows"} return
  if {! [file exists $v(synEngine)]} {
    tk_messageBox -title $t(.confm.errTitle) -icon warning \
      -message [eval format $t(playSyn,errMsg)]
    return
  }

  ;# もし再生中なら停止する
  if $v(playSynStatus) {
    set v(msg) $t(playUttTiming,stopMsg)
    sndSyn stop
    snack::audio stop
    set v(playSynStatus) 0
    return
  }

  set srcFile "$v(saveDir)/$v(recLab).$v(ext)"
  if {! [file exists $srcFile]} return
  regsub -all -- "/" $srcFile "\\\\\\" srcFileWin
  regsub -all -- "/" $v(synFile) "\\\\\\" synFileWin
  set v(sndLength) [snd length -unit SECONDS]
  set S 0
  if {[array names paramU "$v(listSeq),1"] != ""} { set S $paramU($v(listSeq),1) }
  set P 0
  if {[array names paramU "$v(listSeq),3"] != ""} { set P $paramU($v(listSeq),3) }
  set C 0
  if {[array names paramU "$v(listSeq),4"] != ""} { set C $paramU($v(listSeq),4) }
  set E 0
  if {[array names paramU "$v(listSeq),5"] != ""} { set E $paramU($v(listSeq),5) }

  if {$v(synFlag) == ""} {
    set flag "\\\"\\\""
  } else {
    set flag $v(synFlag)
  }

  initProgressWindow
  updateProgressWindow 25 "now synthesizing..."
  set cmd "{$v(synEngine)} \"$srcFileWin\" \"$synFileWin\" $f0(synTone)$f0(synOctave) $v(synCSpeed) $flag $S $v(synLength) $C $E $v(synVolume) $v(synMod)"
  eval exec $cmd 2> NUL    ;# 標準エラー出力への出力は/dev/nullへ

  deleteProgressWindow
  sndSyn read "$v(synFile)"
  set v(playSynStatus) 1
  sndSyn play -command {
    set v(playSynStatus) 0
    if {[file exists $v(synFile)]} {
      file delete $v(synFile)
    }
  }
}

#---------------------------------------------------
# 合成テストの設定窓
#
proc synTestWindow {} {
  global synWindow v sv t
  if [isExist $synWindow] return

  toplevel $synWindow
  wm title $synWindow $t(synWindow,title)
  wm attributes $synWindow -topmost 1
  bind $synWindow <Escape> "destroy $synWindow"
  set topg [split [wm geometry .] "x+"]
  set x [expr [lindex $topg 2] + [lindex $topg 0] / 2 - 100]
  set y [expr [lindex $topg 3] + [lindex $topg 1] / 2 - 5]
  wm geometry $synWindow "+$x+$y"
  wm resizable $synWindow 0 0

  set r 0

  ;# 合成エンジンの選択
  label  $synWindow.l$r -text $t(synWindow,syn)
  button $synWindow.b$r -textvar v(synEngine) -relief solid -command {
    set fn [tk_getOpenFile -initialfile $v(synEngine) \
            -title $t(synWindow,synSelect) -defaultextension "exe" \
            -filetypes { {{exe file} {.exe}} {{All Files} {*}} }]
    if {$fn != ""} {
      set v(synEngine) $fn
    }
  }
  grid $synWindow.l$r -sticky e -row $r -column 0
  grid $synWindow.b$r -sticky w -row $r -column 1 -columnspan 3
  incr r

  ;# 合成音の高さ
  label $synWindow.l$r -text $t(synWindow,setPitch)
  frame $synWindow.f$r
  eval tk_optionMenu $synWindow.f$r.t f0(synTone) $sv(toneList)   ;# 音名選択
  set ss {}
  for {set i $sv(sinScaleMin)} {$i <= $sv(sinScaleMax)} {incr i} {
    lappend ss $i
  }
  eval tk_optionMenu $synWindow.f$r.o f0(synOctave) $ss           ;# オクターブ選択
  grid $synWindow.l$r   -sticky e -row $r -column 0
  grid $synWindow.f$r   -sticky w -row $r -column 1
  grid $synWindow.f$r.t -sticky e -row 0 -column 0
  grid $synWindow.f$r.o -sticky w -row 0 -column 1

  ;# 子音速度
  label $synWindow.rl$r -text $t(synWindow,setCSpeed)
  entry $synWindow.re$r -textvar v(synCSpeed) -wi 10
  grid $synWindow.rl$r -sticky e -row $r -column 2
  grid $synWindow.re$r -sticky w -row $r -column 3
  incr r

  ;# 音の長さ
  label $synWindow.l$r -text $t(synWindow,setLength)
  entry $synWindow.e$r -textvar v(synLength) -wi 10 -validate all -validatecommand {isDouble %P}
  grid $synWindow.l$r -sticky e -row $r -column 0
  grid $synWindow.e$r -sticky w -row $r -column 1

  ;# 音量
  label $synWindow.rl$r -text $t(synWindow,setVolume)
  entry $synWindow.re$r -textvar v(synVolume) -wi 10
  grid $synWindow.rl$r -sticky e -row $r -column 2
  grid $synWindow.re$r -sticky w -row $r -column 3
  incr r

  ;# 合成フラグ
  label $synWindow.l$r -text $t(synWindow,setFlag)
  entry $synWindow.e$r -textvar v(synFlag) -wi 10
  grid $synWindow.l$r -sticky e -row $r -column 0
  grid $synWindow.e$r -sticky w -row $r -column 1

  ;# モジュレーション
  label $synWindow.rl$r -text $t(synWindow,setMod)
  entry $synWindow.re$r -textvar v(synMod) -wi 10
  grid $synWindow.rl$r -sticky e -row $r -column 2
  grid $synWindow.re$r -sticky w -row $r -column 3
  incr r
}

#---------------------------------------------------
# 拍単位の時間軸用の設定窓
#
proc setBPMWindow {} {
  global bpmWindow v t
  if [isExist $bpmWindow] return

  toplevel $bpmWindow
  wm title $bpmWindow $t(setBPMWindow,title)
  wm attributes $bpmWindow -topmost 1
  bind $bpmWindow <Escape> "destroy $bpmWindow"
  set topg [split [wm geometry .] "x+"]
  set x [expr [lindex $topg 2] + [lindex $topg 0] / 2 - 100]
  set y [expr [lindex $topg 3] + [lindex $topg 1] / 2 - 5]
  wm geometry $bpmWindow "+$x+$y"
  wm resizable $bpmWindow 0 0

  set fr [frame $bpmWindow.fr]
  radiobutton $fr.rsec -text $t(show,timeAxisSec) -variable v(timeUnit) -value "Sec."
  radiobutton $fr.rbpm -text $t(show,timeAxisBar) -variable v(timeUnit) -value "Bar"
  pack $fr.rsec $fr.rbpm -side left

  set f [frame $bpmWindow.f]
  label $f.lbpm  -text $t(setBPMWindow,tempo)
  label $f.lbpm2 -text "(BPM)"
  entry $f.ebpm -textvar v(bpmTmp) -wi 10 -validate all -validatecommand {isDouble %P}
  label $f.loff -text $t(setBPMWindow,offset)
  label $f.loff2 -text $t(setBPMWindow,sec)
  entry $f.eoff -textvar v(bpmOffsetTmp) -wi 10 -validate all -validatecommand {isDouble %P}
  grid $f.lbpm  -sticky w -row 0 -column 0
  grid $f.ebpm  -sticky w -row 0 -column 1
  grid $f.lbpm2 -sticky w -row 0 -column 2
  grid $f.loff  -sticky w -row 1 -column 0
  grid $f.eoff  -sticky w -row 1 -column 1
  grid $f.loff2 -sticky w -row 1 -column 2
  button $bpmWindow.bok -text $t(.confm.ok) -command {
    if {[string is double $v(bpmTmp)]  &&
        [string length $v(bpmTmp)] > 0 && $v(bpmTmp) > 0} {
      set v(bpm) $v(bpmTmp)
    } else {
      set v(bpmTmp) $v(bpm)
    }
    if {[string length $v(bpmOffsetTmp)] <= 0} {
      set v(bpmOffsetTmp) 0
    }
    if {[string is double $v(bpmOffsetTmp)]} {
      set v(bpmOffset) $v(bpmOffsetTmp)
    } else {
      set v(bpmOffsetTmp) $v(bpmOffset)
    }
    Redraw scale
    destroy $bpmWindow
  }
  button $bpmWindow.bapply -text $t(.confm.apply) -command {
    if {[string is double $v(bpmTmp)]  &&
        [string length $v(bpmTmp)] > 0 && $v(bpmTmp) > 0} {
      set v(bpm) $v(bpmTmp)
    } else {
      set v(bpmTmp) $v(bpm)
    }
    if {[string length $v(bpmOffsetTmp)] <= 0} {
      set v(bpmOffsetTmp) 0
    }
    if {[string is double $v(bpmOffsetTmp)]} {
      set v(bpmOffset) $v(bpmOffsetTmp)
    } else {
      set v(bpmOffsetTmp) $v(bpmOffset)
    }
    Redraw scale
  }
  button $bpmWindow.bcancel -text $t(.confm.c) -command {
    set v(bpmTmp) $v(bpm)
    set v(bpmOffsetTmp) $v(bpmOffset)
    destroy $bpmWindow
  }

  pack $fr -side top
  pack $f -side top
  pack $bpmWindow.bcancel $bpmWindow.bapply $bpmWindow.bok -side right
}

#---------------------------------------------------
# 先行発声チェック用の設定窓
#
proc uttTimingSettings {} {
  global v uttTiming uttTiming_bk t
  if [isExist .uts] return ;# 二重起動を防止
  toplevel .uts
  wm title .uts $t(uttTimingSettings,title)
  bind .uts <Escape> "destroy .uts"

  array set uttTiming_bk [array get uttTiming]     ;# パラメータバックアップ

  label .uts.lwav -text $t(uttTimingSettings,click)
  button .uts.bwav -textvar uttTiming(clickWav) -relief solid -command {
    set fn [tk_getOpenFile -initialfile $uttTiming(clickWav) \
            -title $t(uttTimingSettings,clickTitle) -defaultextension "wav" \
            -filetypes { {{wav file} {.wav}} {{All Files} {*}} }]
    if {$fn != ""} {
      set uttTiming(clickWav) $fn
    }
  }

  label .uts.l -text $t(uttTimingSettings,tempo)
  entry .uts.ebpm -textvar uttTiming(tempo) -validate key -validatecommand {
          if {![isDouble %P] || ![string is integer %P]} {return 0}
          if {%P <= 0} {return 0}
          set uttTiming(tempoMSec) [expr 60000.0 / double(%P)]
          return 1
        }
  label .uts.lbpm -text $t(uttTimingSettings,bpm)
  label .uts.lbpmSec1 -textvar uttTiming(tempoMSec) -fg red
  label .uts.lbpmSec2 -text $t(uttTimingSettings,bpmUnit)

  label .uts.lpc -text $t(uttTimingSettings,clickNum)
  entry .uts.epc -textvar uttTiming(preCount) -validate key -vcmd {
          if {![isDouble %P] || ![string is integer %P]} {return 0}
          return 1
        }
  label .uts.lpcunit -text $t(uttTimingSettings,clickUnit)

  label .uts.lmix -text $t(uttTimingSettings,mix)
  scale .uts.smix -variable uttTiming(mix) -orient horiz \
    -from 0 -to 1 -resolution .1 -showvalue 1

  frame  .uts.ctrl
  button .uts.ctrl.ok     -text $t(.confm.ok) -command {
    set ret [doUttTimingSettings]
    if {$ret == 0} {destroy .uts}
  }
  button .uts.ctrl.cancel -text $t(.confm.c) -command {
    array set uttTiming [array get uttTiming_bk]     ;# パラメータを以前の状態に戻す
    destroy .uts
  }
  button .uts.ctrl.apply -text $t(.confm.apply) -command {doUttTimingSettings}
  pack .uts.ctrl.ok .uts.ctrl.cancel .uts.ctrl.apply -side left

  grid .uts.lwav -row 0 -column 0 -sticky e
  grid .uts.bwav -row 0 -column 1 -columnspan 4 -sticky nesw

  grid .uts.l        -row 1 -column 0 -sticky e
  grid .uts.ebpm     -row 1 -column 1 -sticky nesw
  grid .uts.lbpm     -row 1 -column 2 -sticky w
  grid .uts.lbpmSec1 -row 1 -column 3 -sticky e
  grid .uts.lbpmSec2 -row 1 -column 4 -sticky w

  grid .uts.lpc      -row 2 -column 0 -sticky e
  grid .uts.epc      -row 2 -column 1 -sticky nesw
  grid .uts.lpcunit  -row 2 -column 2 -sticky w

  grid .uts.lmix     -row 3 -column 0 -sticky e
  grid .uts.smix     -row 3 -column 1 -sticky nesw

  grid .uts.ctrl     -row 4 -column 0 -columnspan 5 -sticky es
}

#---------------------------------------------------
# 先行発声チェック用の設定
#
proc doUttTimingSettings {} {
  global v uttTiming t

  if {$uttTiming(preCount) > 20} {
    tk_messageBox -title $t(.confm.errTitle) -icon warning \
      -message [eval format $t(doUttTimingSettings,errMsg)]
    return 1
  }
  if {$uttTiming(preCount) < 0} {
    tk_messageBox -title $t(.confm.errTitle) -icon warning \
      -message [eval format $t(doUttTimingSettings,errMsg2)]
    return 1
  }

  snack::sound oneClick
  oneClick read $uttTiming(clickWav)
  if {[oneClick cget -channels] != 1} {
    oneClick convert -channels Mono
  }

  set beatLength [expr int($v(sampleRate) * 60.0 / $uttTiming(tempo))] ;# 単位=sample
  oneClick crop 0 [expr $beatLength -1]   ;# クリック音を一拍分の長さに切り落とす

  uttTiming(clickSnd) read $uttTiming(clickWav)
  if {[uttTiming(clickSnd) cget -channels] != 1} {
    uttTiming(clickSnd) convert -channels Mono
  }
  uttTiming(clickSnd) crop 0 [expr $beatLength -1]   ;# クリック音を一拍分の長さに切り落とす
  for {set i 0} {$i < $uttTiming(preCount)} {incr i} {
    uttTiming(clickSnd) concatenate oneClick
  }
  return 0
}

#---------------------------------------------------
# 先行発声を試聴
#
proc playUttTiming {} {
  global paramS paramU paramUsize v uttTiming sndUtt t

  if {$paramUsize <= 0} return

  ;# もし再生中なら停止する
  if $v(playUttStatus) {
    set v(msg) $t(playUttTiming,stopMsg)
    sndUtt stop
    snack::audio stop
    set v(playUttStatus) 0
    return
  }

  ;# 試聴対象の行番号リストを作成
  set checkList {}
  foreach pos [getCurSelection] {
    set r [lindex [split $pos ","] 0]
    if {[lindex $checkList end] != $r} {
      lappend checkList $r
    }
  }
  if {[llength $checkList] <= 0} {
    lappend checkList $v(listSeq)
  } elseif {[llength $checkList] > 20} {
    tk_messageBox -title $t(.confm,warnTitle) -icon warning \
      -message $t(playUttTiming,msg)

    set checkList [lrange $checkList 0 19]
  }

  set beatLength [expr int($v(sampleRate) * 60.0 / $uttTiming(tempo))] ;# 単位=sample
  sndUtt copy uttTiming(clickSnd)
  sndUtt flush
  foreach r $checkList {
    set fid $paramU($r,0)
    set S  0
    set E -1
    if {[uttTiming(clickSnd) length] <= 0} {
      set ret [doUttTimingSettings]
      if $ret return
    }
    if {[array get paramS "$r,S"] != ""} {
      set S [expr int($v(sampleRate) * $paramS($r,S))]
    }
    if {[array get paramS "$r,E"] != ""} {
      set E [expr int($v(sampleRate) * $paramS($r,E))]
    }
    if {[array get paramS "$r,P"] != ""} {
      set P [expr int($v(sampleRate) * $paramS($r,P))]
    } else {
      set P $S
    }

    set SandP [expr $P - $S]
    set mixStart [expr $uttTiming(preCount) * $beatLength - $SandP + [sndUtt length]]
    ;# もしS～Pの長さが一拍より長い場合は一拍分だけを切り出すよう補正する
    if {$SandP > $beatLength} {
      set mixStart [expr ($uttTiming(preCount) - 1) * $beatLength + [sndUtt length]]
      set S [expr int($P - $beatLength)]
    } elseif {$SandP > [expr $beatLength / 2]} {
      ;# もしS～Pの長さが半拍より長い場合は半拍分だけを切り出すよう補正する
      set mixStart [expr ($uttTiming(preCount) - 1) * $beatLength + $beatLength/2 + [sndUtt length]]
      set S [expr int($P - $beatLength/2)]
    } 

    snack::sound sWork
    sWork read "$v(saveDir)/$fid.$v(ext)"
    if {[sWork cget -channels] != 1} {
      sWork convert -channels Mono
    }
    if {$S < $E} {
      sWork crop $S $E ;# 左右ブランク間のみを残す
    } else {
      sWork flush
    }

    sndUtt concatenate uttTiming(clickSnd)
    sndUtt mix sWork -start $mixStart -mixscaling $uttTiming(mix) -prescaling [expr 1.0 - $uttTiming(mix)]
  }

  set v(msg) $t(playUttTiming,playMsg)
  set v(playUttStatus) 1
  sndUtt play -command {
    set v(msg) $t(playUttTiming,playMsg)
    set v(playUttStatus) 0
  }
  set v(pmPlayStart)  [expr double($S) / $v(sampleRate)]
  set v(pmStartDelay) [expr double($mixStart) / $v(sampleRate)]
  if {[llength $checkList] == 1} {
    showPlayMark 1
  }
  ;# sndUtt write $v(saveDir)/a.$v(ext)
}

#---------------------------------------------------
# 指定した周波数[Hz]のsin波を再生する
#
proc playSin {freq vol length} {
  global v onsa t
  if [snack::audio active] return
  if $::debug {puts $freq}
  if {$freq > 10 && $vol > 0} { 
#    set f [snack::filter generator $freq $vol 0.0 sine $v(sampleRate)]
    set g  [snack::filter generator $freq $vol 0.01 triangle $length]
    set f1 [snack::filter formant 500 50]
    set f2 [snack::filter formant 1500 75]
    set f3 [snack::filter formant 2500 100]
    set f4 [snack::filter formant 3500 150]
    set f  [snack::filter compose $g $f1 $f2 $f3 $f4]
    onsa play -filter $f -command "$f destroy" 
  }
}

#---------------------------------------------------
# 指定した番号の音の収録に移動
#
proc jumpRec {row col {mode 0}} {
  global v rec t paramU paramS c

  set oldR $paramU($v(listSeq),R)
  set newR $paramU($row,R)
  setCellSelection $row $col $mode
  set v(msg) "$row / $paramU(size_1)"  ;# 現在何個目のデータを処理しているかを表示
  if {$oldR == $newR} {
    RedrawParam    ;# 連続音の場合wavは変わらないがパラメータは変わるため
  } else {
    set v(recLab) [lindex $v(recList) $newR] 
    readWavFile
    Redraw all
  }
  ;# パラメータにフォーカスする
  if {$v(sndLength) > 0 && $v(autoFocus) != "none"} {
    if {[array get paramS "$row,$v(autoFocus)"] != "" && $paramS($row,$v(autoFocus)) != "_UNSET_" \
        && $v(wavepps) > 0 && $v(sndLength) > 0} {
      $c xview moveto [expr ($paramS($row,$v(autoFocus)) - $v(cWidth)/2.0/$v(wavepps) ) / $v(sndLength)]
    }
  }
}

;#koko,エイリアスで、先行拗音にya,yu,yoを付けるとか？
;#koko,"きゃん"を合成する際の"ん"で"ya ん"を選べるようにする狙いで。
#---------------------------------------------------
# 自動収録した連続発声からoto.iniを生成
#
proc genParam {{undo 1}} {
  global v sv genWindow genParam t

  if [isExist $genWindow] return ;# 二重起動を防止
  toplevel $genWindow
  wm title $genWindow $t(genParam,title)
  bind $genWindow <Escape> "destroy $genWindow"

  set c 0
  set r 0

  # 初期設定
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]

  label $f($r).lB  -text $t(genParam,tempo)
  entry $f($r).eB  -textvar genParam(bpm) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lBU -text $t(genParam,bpm)

  label $f($r).lS  -text $t(genParam,S)
  entry $f($r).eS  -textvar genParam(S) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lSU -text $t(genParam,unit)
  tk_optionMenu $f($r).mSU genParam(SU) msec $t(genParam,haku)

  grid  $f($r).lB  -row 0 -column 0 -sticky nse
  grid  $f($r).eB  -row 0 -column 1 -sticky nse
  grid  $f($r).lBU -row 0 -column 2 -sticky nsw -columnspan 2
  grid  $f($r).lS  -row 1 -column 0 -sticky nse
  grid  $f($r).eS  -row 1 -column 1 -sticky nse
  grid  $f($r).lSU -row 1 -column 2 -sticky nsw
  grid  $f($r).mSU -row 1 -column 3 -sticky nsw
  incr r

  # ボタン
  set f($r) [frame $genWindow.f($r) -padx 5 -pady 0]
  label  $f($r).arrow1 -text $t(genParam,darrow)
  button $f($r).bInit  -text $t(genParam,bInit)  -command initGenParam
  button $f($r).bInit2 -text $t(genParam,bInit2) -command initGenParam2
  label  $f($r).arrow2 -text $t(genParam,darrow)
  label  $f($r).arrow3 -text $t(genParam,darrow)

  grid  $f($r).arrow1 -row 0 -column 0 -sticky nsew
  grid  $f($r).bInit  -row 1 -column 0 -sticky nsew
  grid  $f($r).bInit2 -row 1 -column 1 -sticky nsew
  grid  $f($r).arrow2 -row 2 -column 0 -sticky nsew
  grid  $f($r).arrow3 -row 2 -column 1 -sticky nsew
  incr r

  # msec単位での各設定
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]
  label $f($r).lO  -text $t(genParam,O)
  entry $f($r).eO  -textvar genParam(O) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lOU -text $t(genParam,msec)

  label $f($r).lP  -text $t(genParam,P)
  entry $f($r).eP  -textvar genParam(P) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lPU -text $t(genParam,msec)

  label $f($r).lC  -text $t(genParam,C)
  entry $f($r).eC  -textvar genParam(C) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lCU -text $t(genParam,msec)

  label $f($r).lE  -text $t(genParam,E)
  entry $f($r).eE  -textvar genParam(E) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lEU -text $t(genParam,msec)

  grid  $f($r).lO    -row 0 -column 0 -sticky nse
  grid  $f($r).eO    -row 0 -column 1 -sticky nse
  grid  $f($r).lOU   -row 0 -column 2 -sticky nse
  grid  $f($r).lP    -row 1 -column 0 -sticky nse
  grid  $f($r).eP    -row 1 -column 1 -sticky nse
  grid  $f($r).lPU   -row 1 -column 2 -sticky nse
  grid  $f($r).lC    -row 2 -column 0 -sticky nse
  grid  $f($r).eC    -row 2 -column 1 -sticky nse
  grid  $f($r).lCU   -row 2 -column 2 -sticky nse
  grid  $f($r).lE    -row 3 -column 0 -sticky nse
  grid  $f($r).eE    -row 3 -column 1 -sticky nse
  grid  $f($r).lEU   -row 3 -column 2 -sticky nse
  incr r

  # パワーに基づく先行発声位置の自動推定用の設定窓
  checkbutton $genWindow.lfcb$r -variable genParam(autoAdjustRen) -text $t(genParam,autoAdjustRen)
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5 -labelwidget $genWindow.lfcb$r]
  $genWindow.lfcb$r configure -command "changeStateAutoAdjustRen $f($r)"
  label $f($r).lv  -text $t(genParam,vLow)
  entry $f($r).ev  -textvar genParam(vLow) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lvu -text $t(genParam,db)
  label $f($r).ls  -text $t(genParam,sRange)
  entry $f($r).es  -textvar genParam(sRange) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lsu -text $t(genParam,msec)
  label $f($r).lb -text $t(genParam,f0pow)

  grid  $f($r).lv  -row 0 -column 0 -sticky nse
  grid  $f($r).ev  -row 0 -column 1 -sticky nse
  grid  $f($r).lvu -row 0 -column 2 -sticky nsw
  grid  $f($r).ls  -row 1 -column 0 -sticky nse
  grid  $f($r).es  -row 1 -column 1 -sticky nse
  grid  $f($r).lsu -row 1 -column 2 -sticky nsw
  grid  $f($r).lb  -row 2 -column 0 -sticky nsw -columnspan 3
  incr r

  # MFCCに基づく先行発声位置の自動推定の設定窓
  checkbutton $genWindow.lfcb$r -variable genParam(autoAdjustRen2) -text $t(genParam,autoAdjustRen2)
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5 -labelwidget $genWindow.lfcb$r]
  $genWindow.lfcb$r configure -command "changeStateAutoAdjustRen2 $f($r)"
  label $f($r).lv  -text $t(genParam,autoAdjustRen2Opt)
  entry $f($r).ev  -textvar genParam(autoAdjustRen2Opt) -wi 35
  label $f($r).lm  -text $t(genParam,autoAdjustRen2Pattern)
  entry $f($r).em  -textvar genParam(autoAdjustRen2Pattern) -wi 35
  changeStateAutoAdjustRen2 $f($r)

  grid  $f($r).lv  -row 0 -column 0 -sticky nse
  grid  $f($r).ev  -row 0 -column 1 -sticky nsew -columnspan 2
  grid  $f($r).lm  -row 1 -column 0 -sticky nse
  grid  $f($r).em  -row 1 -column 1 -sticky nsew -columnspan 2
  incr r

  # エイリアス重複に関する設定欄
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5 -text $t(genParam,alias)]

  label $f($r).ls -text $t(genParam,suffix)
  entry $f($r).es -textvar genParam(suffix) -wi 10
  label $f($r).lt -text $t(genParam,aliasMax)
  frame $f($r).frm
  radiobutton $f($r).frm.rm1 -variable genParam(useAliasMax) -value  0 -text $t(genParam,aliasMaxNo)
  radiobutton $f($r).frm.rm2 -variable genParam(useAliasMax) -value  1 -text $t(genParam,aliasMaxYes)
  grid $f($r).frm.rm1 -row 0 -column 0 -sticky nse
  grid $f($r).frm.rm2 -row 0 -column 1 -sticky nsw
  label $f($r).ll   -text $t(genParam,aliasMaxNum)
  entry $f($r).e    -textvar genParam(aliasMax) -wi 10 -validate key -vcmd {isDouble %P}
  label $f($r).lr   -text $t(genParam,aliasRecList)

  frame $f($r).f
  entry $f($r).f.el -textvar genParam(aliasRecList) -wi 28
  button $f($r).f.bs -text $t(genParam,aliasSelect) -command selectAliasRecList
  button $f($r).f.br -text $t(genParam,aliasReset)  -command { set genParam(aliasRecList) "" }
  grid $f($r).f.el -row 0 -column 0 -sticky nsew
  grid $f($r).f.bs -row 0 -column 1 -sticky nse
  grid $f($r).f.br -row 0 -column 2 -sticky nse

  grid $f($r).ls  -row 0 -column 0 -sticky nse
  grid $f($r).es  -row 0 -column 1 -sticky nse
  grid $f($r).lt  -row 1 -column 0 -sticky nsw -columnspan 2
  grid $f($r).frm -row 2 -column 0 -sticky nse -columnspan 2
  grid $f($r).ll  -row 3 -column 0 -sticky nse
  grid $f($r).e   -row 3 -column 1 -sticky nse
  grid $f($r).lr  -row 4 -column 0 -sticky nsw  -columnspan 2
  grid $f($r).f   -row 5 -column 0 -sticky nse  -columnspan 2
  incr r

  # "_"に関する設定欄
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5 -text $t(genParam,uscore)]
  radiobutton $f($r).r0 -variable genParam(underScoreMode) -value 0 -text $t(genParam,uscoreIgnore)
  radiobutton $f($r).r1 -variable genParam(underScoreMode) -value 1 -text $t(genParam,uscoreRest)
  radiobutton $f($r).r2 -variable genParam(underScoreMode) -value 2 -text $t(genParam,uscoreDelimiter)
  grid $f($r).r0 -row 0 -column 0 -sticky nsw
  grid $f($r).r1 -row 1 -column 0 -sticky nsw
  grid $f($r).r2 -row 2 -column 0 -sticky nsw
  incr r

  # 実行ボタン
  set f($r) [frame $genWindow.f($r) -padx 5 -pady 0]

  if {$sv(appname) == "OREMO"} {
    button $f($r).bs -text $t(genParam,do) -command {
      destroy $genWindow
      doGenParamForOREMO
      set v(paramFile) "$v(saveDir)/oto.ini"
      saveParamFile
    }
  } else {
    button $f($r).bs -text $t(genParam,do) -command "destroy $genWindow; doGenParam $undo"
  }
  button $f($r).bc -text $t(.confm.c) -command {destroy $genWindow}

  grid  $f($r).bs     -row 0 -column 0 -sticky nsew
  grid  $f($r).bc     -row 0 -column 1 -sticky nsew
  set focusWidget $f($r).bc
  incr r

  ;# フレームを配置する
  set rowNum 5
  for {set i 0} {$i < $rowNum} {incr i} {
    # pack $f($i) -anchor nw -padx 2 -pady 2 -expand 1 -fill x
    grid $f($i) -row $i -column 0 -sticky nsew
  }
  grid $f(5) -row 0 -column 1 -rowspan 5    -sticky nsew -rowspan 3
  grid $f(6) -row 3 -column 1 -rowspan 5    -sticky nsew -rowspan 2
  grid $f(7) -row 5 -column 0 -columnspan 2 -sticky nse

  raise $focusWidget
  focus $focusWidget
}

#---------------------------------------------------
# 自動補正にチェックを入れたとき、各ウィジェットの状態を変更する
#
proc changeStateAutoAdjustRen {w} {
  global genParam
  if {$genParam(autoAdjustRen)} {
    $w.ev configure -state normal
    $w.es configure -state normal
  } else {
    $w.ev configure -state disabled
    $w.es configure -state disabled
  }
}

#---------------------------------------------------
# 自動補正にチェックを入れたとき、各ウィジェットの状態を変更する
#
proc changeStateAutoAdjustRen2 {w} {
  global genParam
  if {$genParam(autoAdjustRen2)} {
    $w.ev configure -state normal
    $w.em configure -state normal
  } else {
    $w.ev configure -state disabled
    $w.em configure -state disabled
  }
}

#---------------------------------------------------
# 重複エイリアスの優先順リストファイルを選ぶ
#
proc selectAliasRecList {} {
  global v genParam genWindow t

  if {$genParam(aliasRecList) != ""} {
    set dir [file dirname $genParam(aliasRecList)]
  } else {
    set dir $v(saveDir)
  }
  set fn [tk_getOpenFile -initialfile $genParam(aliasRecList) \
          -initialdir $dir \
          -title $t(genParam,aliasReclistTitle) -defaultextension {ini txt} \
          -filetypes { {{Related file} {.ini .txt}} {{Txt file} {.txt}} {{Ini file} {.ini}} {{All Files} {*}} }]
  if {$fn != ""} {
    set genParam(aliasRecList) $fn
  }
  raise $genWindow
}

#---------------------------------------------------
# BPM、冒頭Sからパラメータの初期値を求める
#
proc initGenParam {} {
  global genParam t

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める

  set genParam(O) [cut3 [expr $mspb / 6.0]]
  set genParam(P) [cut3 [expr $mspb / 2.0]]
  set genParam(C) [cut3 [expr $mspb * 3.0 / 4.0]]
  set genParam(E) [cut3 [expr - ($mspb + $genParam(O)) ]]
  set genParam(sRange) $genParam(P)
  ;#set genParam(E) [cut3 [expr - $mspb ]]
}

#---------------------------------------------------
# 現在表示中の設定を自動推定の値にする
#
proc initGenParam2 {} {
  global genParam t v paramU

  set O 0
  if {[array names paramU "$v(listSeq),2"] != ""} { set O $paramU($v(listSeq),2) }
  set P 0
  if {[array names paramU "$v(listSeq),3"] != ""} { set P $paramU($v(listSeq),3) }
  set C 0
  if {[array names paramU "$v(listSeq),4"] != ""} { set C $paramU($v(listSeq),4) }
  set E 0
  if {[array names paramU "$v(listSeq),5"] != ""} { set E $paramU($v(listSeq),5) }

  set genParam(O) $O
  set genParam(P) $P
  set genParam(C) $C
  set genParam(E) $E
  set genParam(sRange) $genParam(P)
  ;#set genParam(E) [cut3 [expr - $mspb ]]
}

#---------------------------------------------------
# 連続発声の先頭モーラの先行発声位置を推定し、
# 先行発声がその場所になるための補正量(sec)を返す
# Porg, rangeの単位：sec。Porg-range～Porg+rangeの範囲を探索する
#
proc autoAdjustRen {fid Porg range} {
  global sv v t f0 power genParam

  snack::sound sWork
  if {[file readable "$v(saveDir)/$fid.$v(ext)"]} {
    sWork read "$v(saveDir)/$fid.$v(ext)"
    if {[sWork cget -channels] > 1} {
      sWork convert -channels Mono
    }
    if {$sv(appname) == "OREMO"} {
      set v(sndLength) [sWork length -unit SECONDS]
    }
  } else {
    return 0
  }

  if {$Porg > $range} {
    set Lsec [expr $Porg - $range]
  } else {
    set Lsec 0
  }

  ;# 有声開始位置を求める
  set seriestmp {}
  set start [expr int($Lsec * $v(sampleRate))]
  set end   [expr int(($Porg + $range) * $v(sampleRate))]
  if {[catch {set seriestmp [sWork pitch -method $f0(method) \
    -framelength $f0(frameLength) -windowlength $f0(windowLength) \
    -maxpitch $f0(max) -minpitch $f0(min) \
    -start $start -end $end \
    ] } ret]} {
    if {$ret != ""} {
      puts "error: $ret"
      return 0
    }
    set seriestmp {}
  }
  set f0old 1
  for {set i 0} {$i < [llength $seriestmp]} {incr i} {
    set f0now [lindex [split [lindex $seriestmp $i] " "] 0]
    if {$f0old <= 0 && $f0now > 0} break  ;# 直前が無声、当該が有声ならbreak
    set f0old $f0now
  }
  if {$i < [llength $seriestmp]} {
    ;# 有声開始点であればそこを先行発声候補とし、更に次のパワーに基づく
    ;# 探索開始点にする
    set Pnew [expr $i * $f0(frameLength) + $Lsec]
    set Lsec $Pnew
    set start [expr int($Lsec * $v(sampleRate))]   ;# end はF0と同じ
  } else {
    set Pnew $Porg
  }

  ;# 固定範囲～右ブランク間の平均パワーavePを求める。ただし値が30個以上なら
  ;# 30個で平均を求める
  set Nmax 30
  set N 0
  set aveP 0
  set avePstart [expr int(($Pnew + ($genParam(C) - $genParam(P)) / 1000.0) * $v(sampleRate))]
  set avePend   [expr int(($Pnew + (abs($genParam(E)) - $genParam(P)) / 1000.0) * $v(sampleRate))]
  if {[catch {set pw [sWork power -framelength $power(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start $start -end $end] } ret]} {
      set pw {}
  }

  for {set i 0} {$i < [llength $pw] && $i < $Nmax} {incr i} {
    set aveP [expr $aveP + [lindex $pw $i]]
    incr N
  }
  if {$N > 0} {
    set aveP [expr $aveP / $N]
  }

  ;# 探索区間のパワーを求める
  if {[catch {set pw [sWork power -framelength $power(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start $start -end $end] } ret]} {
      set pw {}
  }

  ;# 閾値に対してパワー曲線が右上がりにクロスする点を探す
  ;# votから右に行き、パワーが右上がりに閾値を超える所まで移動する
  ;# そのような場所が複数ある場合は凹みがより深いものにする
  set vLow [expr $aveP - $genParam(vLow)]
  set powOld $vLow
  set pn -1                         ;# 先行発声位置を入れる変数
  set pnMin     10001               ;# 先行発声前の凹みの深さ
  set powNowMin 10000
  for {set i 0} {$i < [llength $pw]} {incr i} {
    set powNow [lindex $pw $i]
    if {$powNow < $powNowMin} {
      set powNowMin $powNow         ;# 凹みの値を求めていく
    }
    if {$powOld < $vLow && $powNow >= $vLow && $powNowMin < $pnMin} {
      set pn $i
      set pnMin $powNowMin       ;# 凹みの値を保存
      set powNowMin 10000        ;# 再初期化
    }
    set powOld $powNow
  }

  #if {$pn < 0 && [expr $genParam(avePPrev) - $genParam(vLow) - $aveP] > 0} {
  #  ;# パワー凹みを見つけられず、かつ先行モーラより当該モーラの平均パワーがある程度小さい場合、
  #  ;# votから右に行き、パワー曲線が当該モーラの平均パワーにクロスする点を探す
  #  for {set i 0} {$i < [llength $pw]} {incr i} {
  #    set powNow [lindex $pw $i]
  #    if {$powNow <= $aveP} {
  #      set pn $i
  #      break
  #    }
  #  }
  #}

  if {$pn >= 0} {
    set Pnew [expr $pn * $power(frameLength) + $Lsec]
  }

#koko,もう一つ規則を作るなら、上記パワーの凹みが検出できない場合に
#現在のPnewの直近の凹み(x(i-1) >= x(i) < x(i+1) なi)を探すとか。

#koko,平均パワーが先行モーラより大きい場合の規則。

  set genParam(avePPrev) $aveP    ;# 次回の推定のために平均パワーを保存
 
  ;# 現在位置が先行発声になるための補正量(sec)を返す
  return [expr $Pnew - $Porg]
}

#---------------------------------------------------
# もしSが負なら他のパラメータ位置が変わらないようにS=0にする
# ※本ルーチンは連続音用(genParam用)
# ※本ルーチンではparamUのみ訂正し、paramSには反映させないことに注意
#
proc setSto0 {r} {
  global paramU

  if {$paramU($r,1) < 0} {     ;# S < 0 なら
    ;# E(負) の値を修正
    set paramU($r,5) [cut3 [expr $paramU($r,5) - $paramU($r,1)]]
    ;# C の値を修正
    set paramU($r,4) [cut3 [expr $paramU($r,4) + $paramU($r,1)]]
    ;# P の値を修正
    set paramU($r,3) [cut3 [expr $paramU($r,3) + $paramU($r,1)]]
    ;# O の値を修正
    set paramU($r,2) [cut3 [expr $paramU($r,2) + $paramU($r,1)]]
    if {$paramU($r,2) < 0} {
      set paramU($r,2) 0
    }
    ;# S を0にする
    set paramU($r,1) 0
  }
}

#---------------------------------------------------
# 重複エイリアスの優先順リストファイルを読み込んで順番を変える
#
proc sortRecList {seqFile} {
  global v t

  if {! [file exists $seqFile]} return
  if [catch {open $seqFile r} fp] { 
    tk_messageBox -message "error: can not open $seqFile" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  detectEncoding $fp
  set ext [string tolower [file extension $seqFile]]

  ;# 収録リストを読む
  set wavOld ""
  set recListNew {}
  while {![eof $fp]} {
    set l [gets $fp]
    if {$ext == "ini"} {
      set wav [lindex [split $l "."] 0]
      if {$wav != "" && $wav != $wavOld && [isExistInRecList $wav]} {
        lappend recListNew $wav
        set wavOld $wav
      }
    } else {
      set wavList [split $l " "]
      if {[llength $wavList] > 0} {
        for {set i 0} {$i < [llength $wavList]} {incr i} {
          set wav [lindex $wavList $i]
          if {$wav != $wavOld && [isExistInRecList $wav]} {
            lappend recListNew $wav
            set wavOld $wav
          }
        }
      }
    }
  }
  close $fp

  ;# 読み込んだ収録リストに無い音がv(recList)にあれば収録リスト末尾に追加する
  foreach wav $v(recList) {
    set N [llength $recListNew]
    for {set i 0} {$i < $N} {incr i} {
      if {$wav == [lindex $recListNew $i]} break
    }
    if {$i >= $N} {
      lappend recListNew $wav
    }
  }
  set v(recList) $recListNew
}

#---------------------------------------------------
# 指定した文字列がrecListに入っているか調べて返す
#
proc isExistInRecList {key} {
  global v
  foreach wav $v(recList) {
    if {$wav == $key} {return 1}
  }
  return 0
}

#---------------------------------------------------
# 連続発声のパラメータを自動生成する
#
proc doGenParam {{undo 1}} {
  global genParam v snd paramS paramU paramUsize t

#  if $v(paramChanged) {
#    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
#      question 1 $t(.confm.yes) $t(.confm.no)]
#    if {$act == 1} return
#  }

  initProgressWindow
  if $undo {
    pushUndo all "" $t(tool,auto,genParam)
  }
  set procStart [clock seconds]
  initParamS
  initParamU 1
  snack::sound sWork

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める

  # 1モーラ目の開始位置[ms]を求める
  if {$genParam(SU) == "msec"} {
    set Sstart $genParam(S)
  } else {
    set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める
    set Sstart [expr $genParam(S) * $mspb]
  }

  ;# 重複エイリアスの優先順指定ファイルを呼んで収録リストの順序を変える
  if {[file exists $genParam(aliasRecList)]} {
    sortRecList $genParam(aliasRecList)
  }

  array unset aliasChoufuku   ;# エイリアス重複数を入れる
  set recListMax [llength $v(recList)]
  for {set recListSeq 0} {$recListSeq < $recListMax} {incr recListSeq} {
    set fid [lindex $v(recList) $recListSeq]
    set S $Sstart
    set morae [getMorae [string trimleft $fid "_"]]
    set genParam(avePPrev) 0    ;# 平均パワーを初期化
    set fname ""
    set fnameOld ""
    set paramUsizeSt $paramUsize
    for {set i 0} {$i < [llength $morae]} {incr i} {
      ;# 当該モーラが休符(_)であればSを次の位置に移動して次のモーラへ
      set mora [lindex $morae $i]
      if {$mora == "_"} {
        set S [expr $S + $mspb]   ;# Sを次の位置に移動
        continue                  ;# 登録せず次のモーラへ
      }
      ;# エイリアスの決定
      set alias [getRenAlias $morae $i]
      ;# エイリアスに接尾辞を付ける
      if {$genParam(suffix) != ""} {
        set alias "$alias$genParam(suffix)"
      }
      ;# エイリアス重複数をチェック
      if {$genParam(useAliasMax) && [array names aliasChoufuku $alias] != ""} {
        incr aliasChoufuku($alias)
        if {$genParam(aliasMax) <= 0 || $aliasChoufuku($alias) <= $genParam(aliasMax)} {
          set alias "$alias$aliasChoufuku($alias)"
        } else {
          set S [expr $S + $mspb]   ;# Sを次の位置に移動
          continue                  ;# 重複が上限を超えたので登録せず次へ。
        }
      } else {
        set aliasChoufuku($alias) 1
      }
      # Sの位置補正
      if $genParam(autoAdjustRen) {
        ;# 先行発声位置を自動推定し、その差分をSに加える
        set Psec [expr ($S + $genParam(P)) / 1000.0]
        set range [expr $genParam(sRange) / 1000.0]
        set S [cut3 [expr $S + 1000.0 * [autoAdjustRen $fid $Psec $range]]]
      }
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) $alias         ;# A
      set paramU($paramUsize,1) $S             ;# S
      set paramU($paramUsize,4) $genParam(C)   ;# C
      set paramU($paramUsize,5) $genParam(E)   ;# E
      set paramU($paramUsize,3) $genParam(P)   ;# P
      set paramU($paramUsize,2) $genParam(O)   ;# O
      set paramU($paramUsize,7) ""             ;# コメント
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号

      setSto0 $paramUsize    ;# Sが負の場合は他のパラメータ位置を動かさず0に修正

      set S [expr $S + $mspb]   ;# Sを次の位置に移動

      ;# paramSを求める
      set fname "$v(saveDir)/$fid.$v(ext)"
      if [file exists "$fname"] {
        if {$fname != $fnameOld} {
          sWork read "$fname"
          set v(sndLength) [sWork length -unit SECONDS]
          set fname $fnameOld
        }
        paramU2paramS $paramUsize
      }

      incr paramUsize
    }
    # もしwavファイル名が「息.wav」など平仮名の一切ない名前だった場合、上のfor文が実行されず
    # oto.iniにwavのエントリ自体が無くなってしまう。そこで以下でエントリを一つ追加する。
    if {[llength $morae] <= 0} {
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) ""             ;# A
      set paramU($paramUsize,7) ""             ;# コメント
      set paramU($paramUsize,1) 0              ;# S
      set paramU($paramUsize,4) 0              ;# C
      set paramU($paramUsize,5) 0              ;# E
      set paramU($paramUsize,3) 0              ;# P
      set paramU($paramUsize,2) 0              ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号
      incr paramUsize
    }

    # MFCCに基づくSの位置補正
    if {$genParam(autoAdjustRen2) && [llength $morae] > 0} {
      autoAdjustRen2 $paramUsizeSt  [expr $paramUsize - 1]
    }

    set remain [expr ([clock seconds] - $procStart) * ($recListMax - $recListSeq) / ($recListSeq + 1)]
    updateProgressWindow [expr 100 * $recListSeq / [llength $v(recList)]] "($recListSeq / $recListMax) (remain: $remain sec)"
  }

  deleteProgressWindow
  resetDisplay
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
    setCellSelection
  }
  set v(paramChanged) 1
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) [eval format $t(doGenParam,doneMsg)]
  if $undo {
    pushUndo agn
  }
}

#---------------------------------------------------
# 指定範囲内のパラメータをMFCCで補正する
#
proc autoAdjustRen2sel {} {
  global paramU v

  set targetList {}
  foreach pos [getCurSelection] {
    set r [lindex [split $pos ","] 0]
    if {[lindex $targetList end] != $r} {
      lappend targetList $r
    }
  }
  if {[llength $targetList] <= 0} return

  set tmp [split [getRctOpt] ","]
  set undoOpt [format "%d,1,%d,5" [lindex $tmp 0] [lindex $tmp 2]]
  pushUndo rct $undoOpt "Correction based on MFCC"

  set start [lindex $targetList 0]
  set r $start
  set i 0
  while {$i < [llength $targetList]} {
    set r [lindex $targetList $i]
    if {$paramU($start,0) != $paramU($r,0)} {
      autoAdjustRen2 $start [expr $r - 1]
      set start $r
    }
    incr i
  }
  autoAdjustRen2 $start $r

  RedrawParam
  set v(paramChanged) 1
  pushUndo agn
}

#---------------------------------------------------
# MFCCに基づくSの位置補正
#
proc autoAdjustRen2 {start end} {   ;# start番目からend番目(end-1までではない)のデータを処理する
  global genParam v paramS paramU paramUsize t topdir

  set pattern [split $genParam(autoAdjustRen2Pattern) " "]

  ;# 適用すべきモーラが一つもなければreturn
  if {$genParam(autoAdjustRen2Pattern) != ""} {
    for {set f $start} {$f <= $end} {incr f} {
      if {[array names paramU $f,6] != ""} {
        set mora [lindex [getMorae [lindex [split $paramU($f,6) " "] 1]] 0]
        if {[lsearch $pattern $mora] >= 0} break
      }
    }
    if {$f > $end} return
  }

  set f $start
  while {$f <= $end} {
    set fname "$v(saveDir)/$paramU($f,0).$v(ext)"
    set opt ""

    set d 0
    for {set i $f} {$i <= $end && $i < $paramUsize && $paramU($f,0) == $paramU($i,0)} {incr i} {
      set tmp [expr $paramS($i,E) * 0.25 + $paramS($i,P) * 0.75]
      set opt "$opt $tmp"
      incr d
    }
    set ret [eval exec "./tools/modifyPre.exe" $genParam(autoAdjustRen2Opt) "$fname" $opt]
    if {$ret != -1} {
      set newP [split $ret "\n"]
      set r $f
      set ftmp $f
      for {set i 0} {$i < [llength $newP]} {incr i} {
        ;# 適用すべきモーラでなければskip
        if {[array names paramU $ftmp,6] == ""} { ;# エイリアスが無いなら次へ
          incr r
          continue
        }
        set ftmp [expr $f + $i]
        set pre  [lindex [split $paramU($ftmp,6) " "] 0]
        set mora [lindex [getMorae [lindex [split $paramU($ftmp,6) " "] 1]] 0]
        if {$genParam(autoAdjustRen2Pattern) != ""} {
          if {$pre == "-" || [lsearch $pattern $mora] < 0 || $pre == [getVowel $mora]} {
            incr r
            continue
          }
        }

        set S [cut3 [expr ($paramS($r,S) + [lindex $newP $i] - $paramS($r,P)) * 1000.0]]
        if {$S >= 0} {
          set paramU($r,1) $S             ;# S
          paramU2paramS $r
        } else {
          set paramU($r,1) 0             ;# S
          set paramU($r,3) [cut3 [expr $paramU($r,3) + $S]] ;# P
          paramU2paramS $r
        }
        incr r
      }
    }
    set f [expr $f + $d]
  }
}

#---------------------------------------------------
# モーラ列moraeの指定した位置iから連続音用のエイリアス(「a い」など)を求めて返す
#
proc getRenAlias {morae i} {
  global genParam v paramS paramU paramUsize t

  set mora [lindex $morae $i]
  if {$i == 0} {
    set prev "-"
  } else {
    set prev [getVowel [lindex $morae [expr $i - 1]]]
  }
  return "$prev $mora"
}

#---------------------------------------------------
# 文字列を1モーラに分解して返す
#
proc getMorae {inMorae} {
  global genParam

  if {$genParam(underScoreMode) == 0} {
    regsub -all -- {_} $inMorae "" inMorae     ;# "_"を無視するモードなら
  } elseif {$genParam(underScoreMode) == 2} {
    return [split $inMorae "_"]                ;# 1モーラの区切り記号とみなすなら
  }

  ;# ローマ字で始まる場合
  if [regexp {^[a-zA-Z]+$} $inMorae] {
    return [getMoraeRoman $inMorae]
  }

  set morae {}
  for {set i 0} {$i < [string length $inMorae]} {incr i} {
    set char [string range $inMorae $i $i]
    if [isKana $char] {
      if [isMora $char] {
        ;# 現在の$charは一モーラなのでリストに追加
        lappend morae $char
      } else {
        set last [expr [llength $morae] -1]
        set mora "[lindex $morae $last]$char"
        set morae [lreplace $morae $last $last $mora]
      }
    }
  }
  return $morae
}

#---------------------------------------------------
# 文字列を1モーラに分解して返す（ローマ字が入力された場合）
#
proc getMoraeRoman {inMorae} {
  set morae {}
  set mi 0
  for {set i 0} {$i < [string length $inMorae]} {incr i} {
    set char [string range $inMorae $i $i]
    if [regexp {^[a-zA-Z]+$} $char] {
      if {[llength $morae] <= $mi} {
        lappend morae $char
      } else {
        set mora "[lindex $morae $mi]$char"
        set morae [lreplace $morae $mi $mi $mora]
      }
      if [regexp {^[aiueoN]+$} $char] {
        incr mi
      }
    }
  }
  return $morae
}

#---------------------------------------------------
# 一モーラの母音部の音素を返す
#
proc getVowel {mora} {
  set last [expr [string length $mora] -1]
  set char [string range $mora $last $last]

  set vA {a あ か さ た な は ま や ら わ が ざ だ ば ぱ ゃ ぁ ゎ \
          ア カ サ タ ナ ハ マ ヤ ラ ワ ガ ザ ダ バ パ ャ ァ ヮ }
  set vI {i い き し ち に ひ み    り    ぎ じ ぢ び ぴ    ぃ ゐ \
          イ キ シ チ ニ ヒ ミ    リ    ギ ジ ヂ ビ ピ    ィ ヰ }
  set vU {u う く す つ ぬ ふ む ゆ る    ヴ ぐ ず づ ぶ ぷ ぅ ゅ っ \
          ウ ク ス ツ ヌ フ ム ユ ル       グ ズ ヅ ブ プ ゥ ュ ッ }
  set vE {e え け せ て ね へ め    れ    げ ぜ で べ ぺ    ぇ ゑ \
          エ ケ セ テ ネ ヘ メ    レ    ゲ ゼ デ ベ ペ    ェ ヱ }
  set vO {o お こ そ と の ほ も よ ろ を ご ぞ ど ぼ ぽ ょ ぉ    \
          オ コ ソ ト ノ ホ モ ヨ ロ ヲ ゴ ゾ ド ボ ポ ョ ォ    }
  set vN {N ん ン}
  set vR {_}

  if {[lsearch $vA $char] >= 0} { return "a" }
  if {[lsearch $vI $char] >= 0} { return "i" }
  if {[lsearch $vU $char] >= 0} { return "u" }
  if {[lsearch $vE $char] >= 0} { return "e" }
  if {[lsearch $vO $char] >= 0} { return "o" }
  if {[lsearch $vN $char] >= 0} { return "n" }
  if {[lsearch $vR $char] >= 0} { return "-" }   ;# 休符だった場合
}

#---------------------------------------------------
# charが平仮名または片仮名なら1を、それ以外なら0を返す
#
proc isKana {char} {
  set kanaList {あ か さ た な は ま や ら わ    が ざ だ ば ぱ ゃ ぁ ゎ \
                ア カ サ タ ナ ハ マ ヤ ラ ワ    ガ ザ ダ バ パ ャ ァ ヮ \
                い き し ち に ひ み    り       ぎ じ ぢ び ぴ    ぃ ゐ \
                イ キ シ チ ニ ヒ ミ    リ       ギ ジ ヂ ビ ピ    ィ ヰ \
                う く す つ ぬ ふ む ゆ る       ぐ ず づ ぶ ぷ ゅ ぅ っ \
                ウ ク ス ツ ヌ フ ム ユ ル    ヴ グ ズ ヅ ブ プ ュ ゥ ッ \
                え け せ て ね へ め    れ       げ ぜ で べ ぺ    ぇ ゑ \
                エ ケ セ テ ネ ヘ メ    レ       ゲ ゼ デ ベ ペ    ェ ヱ \
                お こ そ と の ほ も よ ろ を    ご ぞ ど ぼ ぽ ょ ぉ    \
                オ コ ソ ト ノ ホ モ ヨ ロ ヲ    ゴ ゾ ド ボ ポ ョ ォ    \
                ん ン ゛ ゜ °\
                ー ・ _ }
  if {[lsearch $kanaList $char] >= 0} {
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
# charが一モーラなら1を、拗音などなら0を返す
#
proc isMora {char} {
  set notMora {ぁ ぃ ぅ ぇ ぉ ゃ ゅ ょ ゎ っ \
               ァ ィ ゥ ェ ォ ャ ュ ョ ヮ ッ ゛ ゜ °}
  if {[lsearch $notMora $char] >= 0} {
    return 0
  } else {
    return 1
  }
}

##---------------------------------------------------
## 現在のパラメータ配列を登録する
##
#proc setUndoPoint {} {
#  global v paramU paramUsizeC paramS paramU_bk paramS_bk paramUsize
#
#  ;# アンドゥポイントの内容と同じかどうかチェック
#  set diff 0
#  for {set r 1} {$r < $paramUsize} {incr r} {
#    for {set c 0} {$c < $paramUsizeC} {incr c} {
#      if {[array names paramU    $r,$c] == "" && \
#          [array names paramU_bk $paramU_bk(i),$r,$c] == ""} continue
#
#      if {[array names paramU    $r,$c] != "" && \
#          [array names paramU_bk $paramU_bk(i),$r,$c] != ""} {
#        if {$paramU($r,$c) != $paramU_bk($paramU_bk(i),$r,$c)} {
#          set diff 1
#          break
#        }
#      } else {
#        set diff 1
#        break
#      }
#    }
#  }
#  if {$diff == 0} {return 0}   ;# 内容が同じならここで終了
#
#  incr paramS_bk(i)
#  incr paramU_bk(i)
#  foreach k [array names paramS_bk $paramS_bk(i),*] {
#    unset paramS_bk($k)
#  }
#  foreach k [array names paramU_bk $paramU_bk(i),*] {
#    unset paramU_bk($k)
#  }
#  foreach k [array names paramS] {
#    if {$k == "active"} continue
#    set paramS_bk($paramS_bk(i),$k) $paramS($k)
#  }
#  foreach k [array names paramU] {
#    if {$k == "active"} continue
#    set paramU_bk($paramU_bk(i),$k) $paramU($k)
#  }
#  set paramS_bk(N) $paramS_bk(i)
#  set paramU_bk(N) $paramU_bk(i)
#  return 1
#}

##---------------------------------------------------
## パラメータ配列のアンドゥ
##
#proc undoParam {} {
#  global v paramU paramS paramU_bk paramS_bk
#
#  if {$paramS_bk(i) < 0} return
#  setUndoPoint
#  incr paramS_bk(i) -1
#  incr paramU_bk(i) -1
#  if {$paramS_bk(i) < 0} {
#    set paramS_bk(i) 0
#    set paramU_bk(i) 0
#  }
#
#  pushUndo whl "" "old undo"
# 
#  array unset paramS
#  array unset paramU
#  foreach k [array names paramU_bk $paramU_bk(i),*] {
#    set kList [split $k ","]
#    if {[llength $kList] >= 3} {
#      set sk "[lindex $kList 1],[lindex $kList 2]"
#    } else {
#      set sk [lindex $kList 1]
#    }
#    set paramU($sk) $paramU_bk($k)
#  }
#  foreach k [array names paramS_bk $paramS_bk(i),*] {
#    set kList [split $k ","]
#    if {[llength $kList] >= 3} {
#      set sk "[lindex $kList 1],[lindex $kList 2]"
#    } else {
#      set sk [lindex $kList 1]
#    }
#    set paramS($sk) $paramS_bk($k)
#  }
#  set v(paramChanged) 1
#  RedrawParam
#  pushUndo agn
#}

##---------------------------------------------------
## パラメータ配列のリドゥ
##
#proc redoParam {} {
#  global v paramU paramS paramU_bk paramS_bk paramUsize paramUsizeC
#
#  if {$paramS_bk(i) >= $paramS_bk(N)} return
#  ;# アンドゥポイントの内容と同じかどうかチェック
#  set diff 0
#  for {set r 1} {$r < $paramUsize} {incr r} {
#    for {set c 0} {$c < $paramUsizeC} {incr c} {
#      if {[array names paramU    $r,$c] == "" && \
#          [array names paramU_bk $paramU_bk(i),$r,$c] == ""} continue
#
#      if {[array names paramU    $r,$c] != "" && \
#          [array names paramU_bk $paramU_bk(i),$r,$c] != ""} {
#        if {$paramU($r,$c) != $paramU_bk($paramU_bk(i),$r,$c)} {
#          set diff 1
#          break
#        }
#      } else {
#        set diff 1
#        break
#      }
#    }
#  }
#  if {$diff == 1} return   ;# 内容が違うならここで終了
#
#  pushUndo whl "" "old redo"
# 
#  incr paramS_bk(i)
#  incr paramU_bk(i)
#  array unset paramS
#  array unset paramU
#  foreach k [array names paramU_bk $paramU_bk(i),*] {
#    set kList [split $k ","]
#    if {[llength $kList] >= 3} {
#      set sk "[lindex $kList 1],[lindex $kList 2]"
#    } else {
#      set sk [lindex $kList 1]
#    }
#    set paramU($sk) $paramU_bk($k)
#  }
#  foreach k [array names paramS_bk $paramS_bk(i),*] {
#    set kList [split $k ","]
#    if {[llength $kList] >= 3} {
#      set sk "[lindex $kList 1],[lindex $kList 2]"
#    } else {
#      set sk [lindex $kList 1]
#    }
#    set paramS($sk) $paramS_bk($k)
#  }
#  set v(paramChanged) 1
#  RedrawParam
#  pushUndo agn
#}

#---------------------------------------------------
# 一覧表の検索窓
#
proc searchParam {} {
  global v searchWindow t

  ;# 二重起動を防止
  if [winfo exists $searchWindow] {
    raise $searchWindow.f.e
    focus $searchWindow.f.e
    return
  }
  toplevel $searchWindow
  wm title $searchWindow $t(searchParam,title)
  bind $searchWindow <Escape> "destroy $searchWindow"

  set f [frame $searchWindow.f]
  entry  $f.e  -textvar v(keyword) -wi 30
  button $f.bs -text $t(searchParam,search) -command {doSearchParam $v(sdirection)}
  button $f.bc -text $t(.confm.c) -command {destroy $searchWindow}
  set f2 [labelframe $searchWindow.f2 -relief groove]
  radiobutton $f2.rup   -variable v(sdirection) -value 0 \
    -text $t(searchParam,rup)
  radiobutton $f2.rdown -variable v(sdirection) -value 1 \
    -text $t(searchParam,rdown)
  set f3 [labelframe $searchWindow.f3 -relief groove]
  radiobutton $f3.rMatch1 -variable v(sMatch) -value full \
    -text $t(searchParam,rMatch1)
  radiobutton $f3.rMatch2 -variable v(sMatch) -value sub \
    -text $t(searchParam,rMatch2)
  pack $f.e $f.bs $f.bc        -side left -anchor nw
  pack $f2.rup $f2.rdown       -side top  -anchor nw
  pack $f3.rMatch1 $f3.rMatch2 -side top  -anchor ne
  pack $f -anchor nw
  pack $f2 $f3 -anchor nw -side left

  bind $searchWindow <Return> {doSearchParam $v(sdirection)}
  raise $f.e
  focus $f.e
}

#---------------------------------------------------
# 一覧表の検索
#
proc doSearchParam {{direction 1}} {
  if $direction {
    doSearchParamNext
  } else {
    doSearchParamPrev
  }
}

#---------------------------------------------------
# 一覧表の検索(先頭方向)
#
proc doSearchParamPrev {} {
  global v paramU paramUsizeC paramUsize searchWindow t

  if {$paramUsize <= 1} return

  ;# 現在のアクティブセルの前のセルを求める
  set sel [.entpwindow.t index active]
  if {$sel == ""} return
  set rs [lindex [split $sel ","] 0]
  set cs [lindex [split $sel ","] 1]
  if {$cs > 1} {  ;# ここを $cs > 0にすると前に戻れなくなるので×。
    incr cs -1
  } else {
    set cs $paramUsizeC
    incr rs -1
  }

  ;# 現在のアクティブセルの前から先頭までを検索
  for {set r $rs} {$r > 0} {incr r -1} {
    for {set c $cs} {$c >= 0} {incr c -1} {
      if {[array get paramU "$r,$c"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $paramU($r,$c) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $paramU($r,$c)] >= 0} {
          if {$c == 0} {incr c}
          focus .entpwindow.t
          jumpList .entpwindow.t 0 0 0 $r $c
          return
        }
      }
    }
    set cs $paramUsizeC
  }
  ;# 末尾から現在のアクティブセルあたりまでを検索
  for {set r [expr $paramUsize - 1]} {$r >= $rs} {incr r -1} {
    for {set c $cs} {$c >= 0} {incr c -1} {
      if {[array get paramU "$r,$c"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $paramU($r,$c) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $paramU($r,$c)] >= 0} {
          if {$c == 0} {incr c}
          focus .entpwindow.t
          jumpList .entpwindow.t 0 0 0 $r $c
          return
        }
      }
    }
    set cs $paramUsizeC
  }
  ;# 見つからなかった場合
  tk_messageBox -title $t(searchParam,doneTitle) -icon warning \
      -message [eval format $t(searchParam,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# 一覧表の検索(末尾方向)
#
proc doSearchParamNext {} {
  global v paramU paramUsizeC paramUsize searchWindow t

  if {$paramUsize <= 1} return

  ;# 現在のアクティブセルの次のセルを求める
  set sel [.entpwindow.t index active]
  if {$sel == ""} return
  set rs [lindex [split $sel ","] 0]
  set cs [lindex [split $sel ","] 1]
  if {$cs < $paramUsizeC} {
    incr cs
  } else {
    set cs 0
    incr rs
  }

  ;# 現在のアクティブセルの次から末尾までを検索
  for {set r $rs} {$r < $paramUsize} {incr r} {
    for {set c $cs} {$c < $paramUsizeC} {incr c} {
      if {[array get paramU "$r,$c"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $paramU($r,$c) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $paramU($r,$c)] >= 0} {
          if {$c == 0} {incr c}
          focus .entpwindow.t
          jumpList .entpwindow.t 0 0 0 $r $c
          return
        }
      }
    }
    set cs 0
  }
  ;# 先頭から現在のアクティブセルまでを検索
  for {set r 1} {$r <= $rs} {incr r} {
    for {set c $cs} {$c < $paramUsizeC} {incr c} {
      if {[array get paramU "$r,$c"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $paramU($r,$c) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $paramU($r,$c)] >= 0} {
          if {$c == 0} {incr c}
          focus .entpwindow.t
          jumpList .entpwindow.t 0 0 0 $r $c
          return
        }
      }
    }
    set cs 0
  }
  ;# 見つからなかった場合
  tk_messageBox -title $t(searchParam,doneTitle) -icon warning \
      -message [eval format $t(searchParam,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# DC成分除去
#
#proc removeDC {} {
#  global snd t v
#  set flt [snack::filter iir -numerator "0.99 -0.99" -denominator "1 -0.99"] 
#  snd filter $flt -continuedrain 0
#  set v(sndLength) [snd length -unit SECONDS]
#}

#---------------------------------------------------
# 波形を横方向に拡大縮小(ctrl+マウスホイール)
# mode=1...拡大, mode=0...縮小
#
proc changeWidth {mode {x -1}} {
  global v t c wscrl

  if {$v(sndLength) <= 0} return

  if {$x < 0} {
    set x [expr $v(cWidth) / 2]
  }
  set sec [point2sec $x]
  set v(showWhole) 0

  if $mode {
    set v(wavepps) [expr $v(wavepps) * 1.5]
  } else {
    set v(wavepps) [expr $v(wavepps) / 1.5]
  }
  # 描画幅がキャンバスより小さくならないようにする
  if {[expr $v(wavepps) * $v(sndLength)] < $v(cWidth)} {
    set v(wavepps) [expr $v(cWidth) / $v(sndLength)]
  }
  # 描画幅がある程度よりおおきくならないようにする
  if {[expr int($v(sndLength) * $v(wavepps))] > 48000} {
    set v(wavepps) [expr 48000 / $v(sndLength)]
  }
  Redraw scale

  $c xview moveto [expr double($sec - double($x) / $v(wavepps)) / $v(sndLength)]

#  if $mode {
#    incr v(cWidth) +40
#  } elseif {$v(cWidth) <= $v(cWidthMin)} {
#    set v(cWidth) $v(cWidthMin)
#  } else {
#    incr v(cWidth) -40
#  }
#  Redraw scale
}

#---------------------------------------------------
# 時間スケールの拡大率をユーザが指定する窓
#
proc changeZoomX {} {
  global v changeZoomWindow t

  if [isExist $changeZoomWindow] return ;# 二重起動を防止
  toplevel $changeZoomWindow
  wm title $changeZoomWindow $t(changeZoomX,title)
  bind $changeZoomWindow <Escape> "destroy $changeZoomWindow"

  entry  $changeZoomWindow.erate   -textvar v(zoomRate) -wi 6 -validate key -vcmd {isDouble %P}
  label  $changeZoomWindow.lunit   -text "$t(changeZoomX,unit)"
  button $changeZoomWindow.bchange -text "$t(changeZoomX,change)" -command {
    if {$v(zoomRate) < 100}   {set v(zoomRate) 100}
    if {$v(zoomRate) > 10000} {set v(zoomRate) 10000}
    zoomX $v(zoomRate) 0
    destroy $changeZoomWindow
  }
  bind $changeZoomWindow <Return> {
    if {$v(zoomRate) < 100}   {set v(zoomRate) 100}
    if {$v(zoomRate) > 10000} {set v(zoomRate) 10000}
    zoomX $v(zoomRate) 0
    destroy $changeZoomWindow
  }

  grid $changeZoomWindow.erate   -row 0 -column 0
  grid $changeZoomWindow.lunit   -row 0 -column 1
  grid $changeZoomWindow.bchange -row 1 -column 0 -sticky nsew
}

#---------------------------------------------------
# 時間スケールを拡大縮小する
# zoom...拡大率。100=wav全体表示、0=常にwav全体表示、負=最大拡大率
#
proc zoomX {zoom x} {
  global v t c wscrl

  if {$v(sndLength) <= 0} return
  set sec [point2sec $x]

  if {$zoom < 0} {
    set v(wavepps) [expr 48000 / $v(sndLength)]       ;# 最大拡大率にする
    set v(showWhole) 0
  } elseif {$zoom == 0} {
    set v(wavepps) [expr $v(cWidth) / $v(sndLength)]  ;# wav全体を表示
    set v(showWhole) 1                       ;# 常にwav全体を表示
  } elseif {$zoom <= 100} {
    set v(wavepps) [expr $v(cWidth) / $v(sndLength)]  ;# wav全体を表示
    set v(showWhole) 0
  } else {
    set v(wavepps) [expr $v(cWidth) / $v(sndLength) * $zoom / 100]
    set v(showWhole) 0
  }
  
  if {$zoom < 0} {
    set v(zoomRate) [expr 100 * 48000 / $v(cWidth)]
  } elseif {$zoom < 100} {
    set v(zoomRate) 100
  } else {
    set v(zoomRate) $zoom
  }

  if {[expr int($v(sndLength) * $v(wavepps))] > 48000} {
    set v(wavepps) [expr 48000 / $v(sndLength)]       ;# 最大拡大率にする
  }

  Redraw scale
  $c xview moveto [expr double($sec - double($x) / $v(wavepps)) / $v(sndLength)]
}

#---------------------------------------------------
# 音名リストボックスを横方向に拡大縮小(ctrl+マウスホイール)
# mode=1...拡大, mode=0...縮小
#
proc changeRecListWidth {mode} {
  global rec t
  set width [$rec cget -width]
  if $mode {
    $rec configure -width [expr $width +1]   ;# 拡大
  } elseif {$width > 5} {
    $rec configure -width [expr $width -1]   ;# 縮小
  }
}

#---------------------------------------------------
# 引数で指定した単位の値をサンプル単位に変換する
#
proc val2samp {val from sr} {
  switch $from {
    MSEC -
    msec { ;# msec → サンプル単位に変換
      return [expr int($val / 1000.0 * $sr)]
    }
    SEC  -
    sec  { ;# sec → サンプル単位に変換
      return [expr int($val * $sr)]
    }
    default { ;# そのまま返す(念のため整数化する)
      return int($val);
    }
  }
}

#---------------------------------------------------
# 再生位置の表示
#
proc showPlayMark {{init 0}} {
  global c v
  if {$v(playStatus) || $v(playUttStatus)} {
    set ylow [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
    set eTime [snack::audio elapsedTime]
    if $init {
      ;# 再生開始の場合
      after cancel showPlayMark
      $c delete playMark
      set v(pmPlayStart) [expr $v(pmPlayStart) - $eTime] ;#本来は不要のはずだが再生時にelapsedTimeが0でない場合への対策
      if {$v(pmStartDelay) > 0} {
        set x -100  ;# 表示されない位置にする
      } else {
        set x [expr $v(wavepps) * $v(pmPlayStart) + $eTime]
      }
      $c create line $x 0 $x $ylow -fill #ffa030 -tags playMark
      $c raise playMark
    } else {
      ;# 再生中の場合
      if {$eTime >= $v(pmStartDelay)} {
        set x [expr $v(wavepps) * ($v(pmPlayStart) + $eTime - $v(pmStartDelay))]
        $c coords playMark $x 0 $x $ylow
      }
    }
    update
    after 30 showPlayMark
    return
  }

  ;# 再生停止の場合
  $c delete playMark
}

#---------------------------------------------------
# 再生/停止の切替
#
proc togglePlay {{start 0} {end -1}} {
  global v snd t paramUsize

  if $v(playStatus) {
    snd stop
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
  } else {
    if {$paramUsize <= 0} return
    set v(msg) $t(togglePlay,playMsg)
    set v(playStatus) 1
    snd play -start $start -end $end -command {
      set v(playStatus) 0       ;# 再生終了したときの処理
      set v(msg) $t(togglePlay,stopMsg)
    }
    set v(pmPlayStart) [expr double($start) / $v(sampleRate)]
    set v(pmStartDelay) 0
    showPlayMark 1
  }
}

#---------------------------------------------------
# 左右ブランク間を再生
#
proc playFromStoE {} {
  global paramS v t
  set start  0
  set end   -1
  set ls $v(listSeq)
  if {[array get paramS "$ls,S"] != ""} {
    set start [expr int($v(sampleRate) * $paramS($ls,S))]
  }
  if {[array get paramS "$ls,E"] != ""} {
    set end   [expr int($v(sampleRate) * $paramS($ls,E))]
  }
  togglePlay $start $end
}

#---------------------------------------------------
# 画面クリックで、両側のパラメータ間再生
# x...マウスx座標
#
proc clickPlayRange {x} {
  global v t paramS

  set sec [point2sec $x]
  set Ldis $sec
  set L ""
  set Rdis [expr $v(sndLength) - $sec]
  set R ""

  foreach kind {S C E P O} {
    if {[array names paramS $v(listSeq),$kind] != ""} {
      if {$paramS($v(listSeq),$kind) < $sec && [expr $sec - $paramS($v(listSeq),$kind)] < $Ldis} {
        set Ldis [expr $sec - $paramS($v(listSeq),$kind)]
        set L $kind
      }
      if {$sec < $paramS($v(listSeq),$kind) && [expr $paramS($v(listSeq),$kind) - $sec] < $Rdis} {
        set Rdis [expr $paramS($v(listSeq),$kind) - $sec]
        set R $kind
      }
    }
  }
  playRange $L $R
}

#---------------------------------------------------
# 範囲指定再生
#   playRange 番号 ... 番号=Ctrl+F1～F5の設定番号
#   playRange sKind eEkind ... ?Kind=S,C,E,P,O,""で範囲指定して再生
#
proc playRange {a1 {a2 "none"}} {
  global paramS v t paramUsize

  if {$paramUsize <= 0} return
  if {$a2 == "none"} {
    set fnum $a1
    set sKind ""
    set eKind ""
  } else {
    set sKind $a1
    set eKind $a2
  }
  set ls $v(listSeq)
  set start 0
  if {$a2 == "none"} {
    set sSeq [string range  "$v(setPlayRange,$fnum,start)" 0 0] ;# 0..6=ファイル先頭,S,O,P,C,E,末尾
    if {$sSeq != 0 && $sSeq != 6} {
      set sKind [c2kind $sSeq]
    }
  }
  if {[array get paramS "$ls,$sKind"] != ""} {
    set start [expr int($v(sampleRate) * $paramS($ls,$sKind))]
  }

  set end -1
  if {$a2 == "none"} {
    set eSeq [string range  "$v(setPlayRange,$fnum,end)"   0 0] ;# 0..6=ファイル先頭,S,O,P,C,E,末尾
    if {$eSeq != 0 && $eSeq != 6} {
      set eKind [c2kind $eSeq]
    }
  }
  if {[array get paramS "$ls,$eKind"] != ""} {
    set end [expr int($v(sampleRate) * $paramS($ls,$eKind))]
  }
  togglePlay $start $end
}

#---------------------------------------------------
# 範囲指定再生の設定
#
proc setPlayRange {} {
  global v playRangeWindow t

  if [isExist $playRangeWindow] return ;# 二重起動を防止
  toplevel $playRangeWindow
  wm title $playRangeWindow $t(setPlayRange,title)
  bind $playRangeWindow <Escape> "destroy $playRangeWindow"

  array unset lf
  for {set i 1} {$i <= 5} {incr i} {
    set lf($i) [labelframe $playRangeWindow.lf$i -text "Ctrl+F$i" \
      -relief groove -padx 5 -pady 5]

    label $lf($i).ls -text "$t(setPlayRange,start)"
    label $lf($i).le -text "$t(setPlayRange,end)"
    ;# 開始位置の設定
    tk_optionMenu $lf($i).ss v(setPlayRange,$i,start) \
      "0 $t(setPlayRange,head)" "1 $t(initParamU,1)" "2 $t(initParamU,2)" \
      "3 $t(initParamU,3)"      "4 $t(initParamU,4)" "5 $t(initParamU,5)"
    ;# 終了位置の設定
    tk_optionMenu $lf($i).se v(setPlayRange,$i,end) \
      "1 $t(initParamU,1)" "2 $t(initParamU,2)" "3 $t(initParamU,3)"    \
      "4 $t(initParamU,4)" "5 $t(initParamU,5)" "6 $t(setPlayRange,tail)"

    grid $lf($i).ls -row 0 -column 0
    grid $lf($i).le -row 1 -column 0
    grid $lf($i).ss -row 0 -column 1
    grid $lf($i).se -row 1 -column 1
  }

  grid $lf(1) -row 0 -column 0
  grid $lf(2) -row 0 -column 1
  grid $lf(3) -row 0 -column 2
  grid $lf(4) -row 1 -column 0
  grid $lf(5) -row 1 -column 1

  raise $playRangeWindow
  focus $playRangeWindow
}

#---------------------------------------------------
# 発声タイミング補正モードON/OFFの切替
#
proc timingAdjMode {} {
  global v t

  if $v(timingAdjMode) {
    tk_messageBox -message [eval format $t(timingAdjMode,startMsg)] \
      -icon info
    set v(msg)  $t(timingAdjMode,on)
    set v(clickPlayRangeMode) 0
  } else {
    tk_messageBox -message [eval format $t(timingAdjMode,doneMsg)] \
      -icon info
    set v(msg)  $t(timingAdjMode,off)
  }
}

#---------------------------------------------------
# 画面クリックで範囲指定再生するモードのON/OFF切替。
# もし発声タイミング補正モードが有効であれば本モードは有効にしない。
#
proc clickPlayRangeMode {} {
  global v t

  if {$v(timingAdjMode)} {
    set v(clickPlayRangeMode) 0
    tk_messageBox -message [eval format $t(clickPlayRangeMode,errMsg)] \
      -icon info
  }
}

#---------------------------------------------------
# 波形表示/非表示の切替
#
proc toggleWave {} {
  global v t c

  ;#if [snack::audio active] return
  if $v(showWave) {
    set v(waveh) $v(wavehbackup)
    set h [expr $v(winHeight) + $v(waveh)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(wavehmin)]
  } else {
    set h [expr $v(winHeight) - $v(waveh)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(wavehmin)]
    set v(wavehbackup) $v(waveh)
    set v(waveh) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw wave
}

#---------------------------------------------------
# スペクトル表示/非表示の切替
#
proc toggleSpec {} {
  global v t c

  ;#if [snack::audio active] return
  if $v(showSpec) {
    set v(spech) $v(spechbackup)
    set h [expr $v(winHeight) + $v(spech)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(spechmin)]
  } else {
    set h [expr $v(winHeight) - $v(spech)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(spechmin)]
    set v(spechbackup) $v(spech)
    set v(spech) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw spec
}

#---------------------------------------------------
# パワー表示/非表示の切替
#
proc togglePow {} {
  global v t c

  ;#if [snack::audio active] return
  if $v(showpow) {
    set v(powh) $v(powhbackup)
    set h [expr $v(winHeight) + $v(powh)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(powhmin)]
  } else {
    set h [expr $v(winHeight) - $v(powh)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(powhmin)]
    set v(powhbackup) $v(powh)
    set v(powh) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw pow
}

#---------------------------------------------------
# F0表示/非表示の切替
#
proc toggleF0 {} {
  global v t c wscrl

  ;#if [snack::audio active] return
  if $v(showf0) {
    set v(f0h) $v(f0hbackup)
    set h [expr $v(winHeight) + $v(f0h)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(f0hmin)]
  } else {
    set h [expr $v(winHeight) - $v(f0h)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(f0hmin)]
    set v(f0hbackup) $v(f0h)
    set v(f0h) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw f0
}

#---------------------------------------------------
# F0パネルの縦軸表示
# snack の unix/snack.tcl の frequencyAxis を改造
proc myAxis {canvas x y width height args} {
  global sv
  # 引数処理
  array set a [list \
    -tags snack_y_axis -font {Helvetica 8} -max 100 \
    -fill black -draw0 0 -min 0 -unit Hz]
  array set a $args

  if {$height <= 0} return
  if {$a(-max) <= $a(-min)} return

  # ピアノロールを表示
  set max_min [expr $a(-max) - $a(-min)]
  if {$a(-unit) == "semitone"} {
    set ylow [expr $height + $y]
    set ppd [expr double($height) / $max_min]
    set kokken  [expr int($ppd / 2)]
    if {$kokken < 10} {
      set kokkenHH  $kokken
    } else {
      set kokkenHH  10
    }
    set kokkenW [expr $width / 2]
    set first 0
    for {set i 0} {$i < [llength $sv(sinScale)]} {incr i} {
      set tgt [hz2semitone [lindex $sv(sinScale) $i]]
      set y1 [expr $ylow - ($tgt - $a(-min)) * $ppd]
      if {$y1 <= [expr $ylow - $height]} break
      if {$y1 <= $ylow} {
        set tt  [expr $i % 12]
        if {$tt == 1 || $tt == 3 || $tt == 6 || $tt == 8 || $tt == 10} {
          set yt [expr $y1 - $kokkenHH]
          set yb [expr $y1 + $kokkenHH + 1]
          $canvas create line $kokkenW $y1 $width $y1 -tags $a(-tags) -fill black
          $canvas create rectangle 0 $yt $kokkenW $yb -tags $a(-tags) -fill #d0d0d0
        } elseif {$tt == 4 || $tt == 11} {
          set yw [expr $y1 - $kokken]
          $canvas create line 0 $yw $width $yw -tags $a(-tags) -fill black
        } elseif {$tt == 0} {
          set keyName [format "C%d" [expr int($i / 12 + $sv(sinScaleMin))]]
          $canvas create text $kokkenW $y1 -text $keyName \
            -fill $a(-fill) -font $a(-font) -anchor w -tags $a(-tags)
        }
        if {$first == 0} {
          if {$tt != 0} {
            set key [lindex $sv(toneList) $tt]
            set keyName [format "%s%d" $key [expr int($i / 12 + $sv(sinScaleMin))]]
            $canvas create line $kokkenW $y1 $width $y1 -tags $a(-tags) -fill white
            $canvas create text $kokkenW $y1 -text $keyName \
              -fill $a(-fill) -font $a(-font) -anchor w -tags $a(-tags)
          }
          set first 1
        }
      }
    }

    return
  }

  ;# ticklist...目盛りの間隔の候補
  set ticklist [list 0.2 0.5 1 2 5 10 20 50 100 200 500]

  foreach elem $ticklist {
    set npt $elem  ;# npt...目盛の値の間隔
    ;# dy...目盛りを描画する間隔(y座標)
    set dy [expr {double($height * $npt) / ($a(-max) - $a(-min))}]
    if {$dy >= [font metrics $a(-font) -linespace]} break
  }
  set hztext $a(-unit)
  if {$hztext == "semitone"} {set hztext st} ;# 表示を短縮

  if $a(-draw0) {
    set i0 0
    set j0 0
  } else {
    set i0 $dy
    set j0 1
  }

  if {$a(-min) != 0} {
    set j0 [expr int($a(-min) / $npt) + 1]
  }

  ;# j=描画する目盛りの番号
  set yzure [expr {double($a(-min) - ($j0 - 1) * $npt) * $height / ($a(-max) - $a(-min))}]

  set yc [expr {$height + $y + $yzure - $i0}]  ;# 目盛を描画するy座標
  set j $j0
  for {} {$yc > $y} {set yc [expr {$yc-$dy}]; incr j} {

    if {$npt < 1000} {
      set tm [expr {$j * $npt}]
    } else {
      set tm [expr {$j * $npt / 1000}]
    }
    if {$yc > [expr {8 + $y}]} {
      if {[expr {$yc - [font metrics $a(-font) -ascent]}] > \
          [expr {$y + [font metrics $a(-font) -linespace]}] ||
          [font measure $a(-font) $hztext]  < \
          [expr {$width - 8 - [font measure $a(-font) $tm]}]} {
        $canvas create text [expr {$x +$width - 8}] [expr {$yc-2}]\
          -text $tm -fill $a(-fill)\
          -font $a(-font) -anchor e -tags $a(-tags)
      }
      $canvas create line [expr {$x + $width - 5}] $yc \
        [expr {$x + $width}]\
        $yc -tags $a(-tags) -fill $a(-fill)
    }
  }
  $canvas create text [expr {$x + 2}] [expr {$y + 1}] -text $hztext \
    -font $a(-font) -anchor nw -tags $a(-tags) -fill $a(-fill)

  return $npt
}

#---------------------------------------------------
# 色選択
#
proc chooseColor {w key initcolor} {
  global v t
  set ctmp [tk_chooseColor -initialcolor $initcolor -title $t(chooseColor,title)]
  if {$ctmp != ""} {
    set v($key) $ctmp
    $w configure -bg $v($key)
  }
}

#---------------------------------------------------
# 音名に対応する周波数を返す
#
proc tone2freq {tone} {
  global v sv t
  for {set i 0} {$i < [llength $sv(sinNote)]} {incr i} {
    if {$tone == [lindex $sv(sinNote) $i]} break
  }
  return [lindex $sv(sinScale) $i]
}

#---------------------------------------------------
# 波形色設定
#
proc setColor {w key msg} {
  global v t

  set ic $v($key)
  pack [frame $w.$key] -anchor nw
  label  $w.$key.l  -text $msg -width 20 -anchor nw
  label  $w.$key.l2 -textvar v($key) -width 7 -anchor nw -bg $v($key)
  button $w.$key.b  -text $t(setColor,selColor) -command "chooseColor $w.$key.l2 $key $ic"
  pack $w.$key.l $w.$key.l2 $w.$key.b -side left
}

#---------------------------------------------------
# 1Hzに対する周波数比をセミトーンにする
#
proc hz2semitone {hz} {
  return [expr log($hz) / log(2) * 12.0]
}

#---------------------------------------------------
# 項目名：[エントリー]のフレームを作って配置する(power用)
#
proc packEntryPower {wname text key} {
  global power t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar power($key) -wi 6 -validate key -vcmd {isDouble %P}
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# 項目名：[エントリー]のフレームを作って配置する(f0用)
#
proc packEntryF0 {wname text key} {
  global f0 t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar f0($key) -wi 6 -validate key -vcmd {isDouble %P}
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# 音名の選択メニューをpackしたフレームを生成
#
proc packToneList {w text toneKey octaveKey freqKey width vol} {
  global f0 v sv t
  pack [frame $w] -fill x
  # 項目名ラベル
  label $w.l -text $text -width $width -anchor w
  # 音名選択
  eval tk_optionMenu $w.t f0($toneKey) $sv(toneList)
  # オクターブ選択
  set ss {}
  for {set i $sv(sinScaleMin)} {$i <= $sv(sinScaleMax)} {incr i} {
    lappend ss $i
  }
  eval tk_optionMenu $w.o f0($octaveKey) $ss
  # 試聴ボタン
  button $w.play -text $t(packToneList,play) -bitmap snackPlay -command \
    "playSin \[tone2freq \$f0($toneKey)\$f0($octaveKey)\] \$f0($vol) \$v(sampleRate)"
  # 音に対応する周波数を表示するラベル
  label $w.$freqKey -textvar f0($freqKey) -width 3 -anchor e
  label $w.unit -text "Hz"
  #pack $w.l $w.t $w.o $w.play $w.togglePlay $w.$freqKey $w.unit -side left
  pack $w.l $w.t $w.o $w.play $w.$freqKey $w.unit -side left
}

#---------------------------------------------------
#   入出力デバイスやバッファサイズを初期化する
#
proc audioSettings {} {
  global dev snd bgm t

  set dev(in)   [encoding convertfrom [lindex [snack::audio inputDevices]  0]]
  set dev(out)  [encoding convertfrom [lindex [snack::audio outputDevices] 0]]
  set dev(ingain)    [snack::audio record_gain]
  set dev(outgain)   [snack::audio play_gain]
  set dev(latency)   [snack::audio playLatency]
  set dev(sndBuffer) [snd cget -buffersize]
  set dev(bgmBuffer) [bgm cget -buffersize]
  # snack::audio selectInput $dev(in) ;# 漢字コード未対応
}

#---------------------------------------------------
#   入出力デバイスの設定窓の値をデバイスに反映させる
#
proc setIODevice {} {
  global dev snd bgm t
  ;# dev(in),dev(out)にはメニュー表示のため漢字コードをsjis→utf-8に
  ;# 変換した文字列を入れている。デバイス設定時には元の漢字コード文字列で
  ;# 指定しないとエラーになる様子なので以下のようなコードで対応している
  foreach dname [snack::audio inputDevices] {
    if {$dev(in) == [encoding convertfrom $dname]} {
      snack::audio selectInput  $dname
      break
    }
  }
  foreach dname [snack::audio outputDevices] {
    if {$dev(out) == [encoding convertfrom $dname]} {
      snack::audio selectOutput $dname
      break
    }
  }
  snack::audio record_gain  $dev(ingain)
  snack::audio play_gain    $dev(outgain)
  snack::audio playLatency  $dev(latency)
  snd configure -buffersize $dev(sndBuffer)
  bgm configure -buffersize $dev(bgmBuffer)
}

#---------------------------------------------------
#   現在の設定を保存する
#
proc saveSettings {{fn ""}} {
  global topdir t v f0 power startup dev uttTiming genParam estimate pZeroCross
  # ↑保存する配列を増やしたら、ここに追加すると共にdoReadInitFileのglobalにも追加

  if {$fn == ""} {
    set fn [tk_getSaveFile -initialfile $startup(initFile) \
            -title $t(saveSettings,title) -defaultextension "tcl" ]
  }
  if {$fn == ""} return

  ;# 保存ファイルを開く
  if [catch {open $fn w} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  
  fconfigure $fp -encoding utf-8

  foreach aName $startup(arrayForInitFile) {
    set sList [array get $aName]
    foreach {key value} $sList {
      ;# もし文字列に[が含まれていればエスケープシーケンスを挿入する
      regsub -all -- {\[} $value "\\\[" value

      ;# $topdir下のファイルを指したデータなら_SETPARAM_TOPDIR_という文字に置き換える
      ;# 他PCに移動した時などtopdirの違う環境にも対応させるため
      if {[string first $topdir $value] == 0} {
        set value [string replace $value 0 [expr [string length $topdir] - 1] "_SETPARAM_TOPDIR_"]
      }

      ;# バージョンアップの仕様変更に伴い保存しなくなったものへの対応
      if {$aName == "v" && [regexp {^plugin,} $key]} continue
      if {$aName == "v"} {
        set skip 0
        foreach k {rec tempo tempoMSec playMetroStatus clickWav} {
          if {$key == $k} {
            set skip 1
            break
          }
        }
        if {$skip} continue
      }

      if {[lsearch $startup(exclusionKeysForInitFile,aName) $aName] < 0 ||
          [lsearch $startup(exclusionKeysForInitFile,$aName) $key]  < 0} {
        ;# 保存対象のデータを書き込む
        puts $fp [format "set %s(%s)\t\t{%s}" $aName $key $value]
      }
    }
  }
  close $fp
}

#---------------------------------------------------
#   指定した窓が起動済みかチェック。起動済みならフォーカスする。
#
proc isExist {w} {
  if [winfo exists $w] {
    raise $w
    focus $w
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
#   入出力デバイスやバッファサイズを設定する窓
#
proc ioSettings {} {
  global ioswindow dev dev_bk snd bgm t

  if [isExist $ioswindow] return ;# 二重起動を防止
  toplevel $ioswindow
  wm title $ioswindow $t(ioSettings,title)
  bind $ioswindow <Escape> "destroy $ioswindow"

  ;# ゲイン、レイテンシの最新状況を取得
  set dev(ingain)  [snack::audio record_gain]
  set dev(outgain) [snack::audio play_gain]
  set dev(latency) [snack::audio playLatency]
  set dev(sndBuffer) [snd cget -buffersize]
  set dev(bgmBuffer) [bgm cget -buffersize]

  array set dev_bk [array get dev]     ;# パラメータバックアップ

  ;# 入力デバイスの選択
  set devList {}
  foreach d [snack::audio inputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    # if {[string length $d] == [string bytelength $d]} {  ;# 英語デバイスのみ登録
    #  lappend devList "$d"
    # }
  }
  set f1 [frame $ioswindow.f1]
  label $f1.l -text $t(ioSettings,inDev) -width 12 -anchor w
  eval tk_optionMenu $f1.in dev(in) $devList
  pack $f1.l $f1.in -side left
  pack $f1 -anchor w

  ;# 出力デバイスの選択
  set devList {}
  foreach d [snack::audio outputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    #if {[string length $d] == [string bytelength $d]} {  ;# 英語デバイスのみ登録
    #  lappend devList "$d"
    #}
  }
  set f2 [frame $ioswindow.f2]
  label $f2.l -text $t(ioSettings,outDev) -width 12 -anchor w
  eval tk_optionMenu $f2.out dev(out) $devList
  pack $f2.l $f2.out -side left
  pack $f2 -anchor w

  ;# 入力ゲインの指定
  set f3 [frame $ioswindow.f3]
  label $f3.l -text $t(ioSettings,inGain) -width 28 -anchor w
  entry $f3.e -textvar dev(ingain) -wi 6 -validate key -vcmd {isDouble %P}
  scale $f3.s -variable dev(ingain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f3.l $f3.e $f3.s -side left
  pack $f3 -anchor w

  ;# 出力ゲインの指定
  set f4 [frame $ioswindow.f4]
  label $f4.l -text $t(ioSettings,outGain) -width 28 -anchor w
  entry $f4.e -textvar dev(outgain) -wi 6 -validate key -vcmd {isDouble %P}
  scale $f4.s -variable dev(outgain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f4.l $f4.e $f4.s -side left
  pack $f4 -anchor w

  ;# レイテンシの指定
  set f5 [frame $ioswindow.f5]
  label $f5.l -text $t(ioSettings,latency) -width 28 -anchor w
  entry $f5.e -textvar dev(latency) -wi 6 -validate key -vcmd {isDouble %P}
  label $f5.u -text "(msec)"
  pack $f5.l $f5.e $f5.u -side left
  pack $f5 -anchor w

  ;# 収録音のバッファサイズの指定
  set f6 [frame $ioswindow.f6]
  label $f6.l -text $t(ioSettings,sndBuffer) -width 28 -anchor w
  entry $f6.e -textvar dev(sndBuffer) -wi 6 -validate key -vcmd {isDouble %P}
  label $f6.u -text "(sample)"
  pack $f6.l $f6.e $f6.u -side left
  pack $f6 -anchor w

  ;# ガイドBGMのバッファサイズの指定
  set f7 [frame $ioswindow.f7]
  label $f7.l -text $t(ioSettings,bgmBuffer) -width 28 -anchor w
  entry $f7.e -textvar dev(bgmBuffer) -wi 6 -validate key -vcmd {isDouble %P}
  label $f7.u -text "(sample)"
  pack $f7.l $f7.e $f7.u -side left
  pack $f7 -anchor w

  ;# 決定ボタン
  set fb [frame $ioswindow.fb]
  button $fb.ok -text $t(.confm.ok) -command {
    setIODevice
    destroy $ioswindow
  }
  button $fb.ap -text $t(.confm.apply) -command {
    setIODevice
    array set dev_bk [array get dev]     ;# パラメータバックアップ
  }
  button $fb.cn -text $t(.confm.c) -command {
    array set dev [array get dev_bk]     ;# パラメータを以前の状態に戻す
    setIODevice
    destroy $ioswindow
  }
  pack $fb.ok $fb.ap $fb.cn -side left -padx 2
  pack $fb -anchor w

  ;# 説明文
  set fm [frame $ioswindow.fm]
  label $fm.lm0  -fg red -text $t(ioSettings,comment0)
  label $fm.lm0b -fg red -text $t(ioSettings,comment0b)
  label $fm.lm1  -fg red -text $t(ioSettings,comment1)
  label $fm.lm2  -fg red -text $t(ioSettings,comment2)
  pack $fm.lm0 $fm.lm0b $fm.lm1 $fm.lm2 -anchor w -side top
  pack $fm -anchor w

  raise $ioswindow
  focus $ioswindow
}

##---------------------------------------------------
## UTAU原音パラメータを自動推定する外部ツールを起動
##
#proc autoParamEstimation {} {
#  global aepwindow v t
#
#  if [isExist $aepwindow] return ;# 二重起動を防止
#
#  toplevel $aepwindow
#  wm title $aepwindow $t(autoParamEstimation,title)
#  wm resizable $aepwindow 0 0
#  bind $aepwindow <Escape> "destroy $aepwindow"
#
#  set w [frame $aepwindow.al]
#  pack $w
#
#  set v(aepResult) "$v(saveDir)/oto-autoEstimation.ini";
#  set v(aepParamFile) [file dirname $v(aepTool)]/inParam.txt
#  set v(aepArg)    "-f $v(aepParamFile)"  ;# "\"$v(saveDir)\" \"$v(aepResult)\"";
#
#  ;# 外部ツールの指定
#  label $w.lpath -text $t(autoParamEstimation,aepTool)
#  button $w.bpath -textvar v(aepTool) \
#    -fg $v(fg) -bg $v(bg) -relief solid \
#    -command {
#      set fn [tk_getOpenFile -initialfile $v(aepTool) \
#              -title $t(autoParamEstimation,selTitle) -defaultextension "exe" \
#              -filetypes { {{exe file} {.exe}} {{All Files} {*}} }]
#      if {$fn != ""} { set v(aepTool) $fn }
#    }
#  button $w.bsel -image snackOpen -highlightthickness 0 -fg $v(fg) -bg $v(bg) \
#    -command {
#      set fn [tk_getOpenFile -initialfile $v(aepTool) \
#              -title $t(autoParamEstimation,selTitle) -defaultextension "exe" \
#              -filetypes { {{exe file} {.exe}} {{All Files} {*}} }]
#      if {$fn != ""} { set v(aepTool) $fn }
#    }
#
#  ;# 外部ツールの起動引数
#  label $w.larg -text $t(autoParamEstimation,option)
#  entry $w.earg -textvar v(aepArg)
#
#  ;# 外部ツールの出力するファイル名
#  label $w.lresult -text $t(autoParamEstimation,aepResult)
#  entry $w.eresult -textvar v(aepResult)
#
#  ;# ボタン
#  set f [frame $w.b]
#  button $f.run -text $t(.confm.run) -command {
#    if $v(paramChanged) {
#      set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
#        question 1 $t(.confm.yes) $t(.confm.no)]
#      if {$act == 1} return
#    }
#    destroy $aepwindow
#    tk_dialog .confm "info" $t(autoParamEstimation,runMsg) "" 0 OK
#    makeAepParam $v(aepParamFile) "$v(saveDir)" "$v(aepResult)"
#    eval exec "$v(aepTool) -- $v(aepArg)"
#    tk_dialog .confm "info" $t(autoParamEstimation,resultMsg) "" 0 OK
#    set paramFileTmp $v(paramFile)
#    readParamFile $v(aepResult)
#    set v(paramFile) $paramFileTmp
#    resetDisplay
#    setCellSelection
#  }
#  button $f.cancel -text $t(.confm.c) -command {
#    destroy $aepwindow
#  }
#  grid $f.run $f.cancel
#
#  ;# 配置
#  grid $w.lpath              -row 0 -column 0
#  grid $w.bpath   -sticky we -row 0 -column 1
#  grid $w.bsel    -sticky w  -row 0 -column 2
#  grid $w.larg               -row 1 -column 0
#  grid $w.earg    -sticky we -row 1 -column 1 -columnspan 2
#  grid $w.lresult            -row 2 -column 0
#  grid $w.eresult -sticky we -row 2 -column 1 -columnspan 2
#  grid $f                    -row 3 -column 0 -columnspan 3
#
#  raise $aepwindow
#  focus $aepwindow
#}

#---------------------------------------------------
# パラメータ自動推定コマンドへ渡すパラメータファイルを作る
#
#proc makeAepParam {paramFile saveDir aepResult} {
#  if [catch {open $paramFile w} fp] { 
#    tk_messageBox -message "error: can not open $paramFile" \
#      -title $t(.confm.fioErr) -icon warning
#    return
#  }
#  puts $fp "$saveDir"
#  puts $fp "$aepResult"
#  close $fp
#}

#---------------------------------------------------
# pluginsフォルダ内にあるプラグインを得る
#
proc readPlugin {} {
  global v plugin t topdir

  ;# plugin(N)         ... プラグイン数
  ;# plugin(i,name)    ... i-th プラグイン名
  ;# plugin(i,execute) ... i-th 実行コマンド名
  ;# plugin(i,argv)    ... i-th 実行コマンドに与える引数
  ;# plugin(i,needF0)  ... i-th F0ファイルが必要か否かのフラグ(0 or 1)
  ;# plugin(i,F0unit)  ... i-th F0値の単位(Hz or semitone)
  ;# plugin(i,needPower) ... i-th パワーファイルが必要か否かのフラグ(0 or 1)
  ;# plugin(i,edit)      ... プラグインの編集対象(all / single / region)。デフォルトはall。

  ;# 各プラグインの情報をbufに入れる
  array unset buf
  set N 0
  set Nall 0
  set Nregion 0
  set Nsingle 0
  foreach dir [lsort [glob -nocomplain [format "%s/plugins/*" $topdir]]] {
    if {[file isdirectory $dir] && [file exists "$dir/plugin.txt"]} {
      if [catch {open "$dir/plugin.txt" r} fp] {
        fconfigure $fp -encoding shiftjis
        continue
      }

      ;# 初期化
      foreach item {name execute argv needF0 F0unit needPower edit} {
        set buf($N,$item) ""
      }
      set buf($N,edit) "all"

      ;# plugin.txtの内容を読む
      while {![eof $fp]} {
        set data [split [gets $fp] "="]
        if {[llength $data] > 1} {
          set item [string trim [lindex $data 0]]       ;# 項目名
          set val  [string trim [join [lreplace $data 0 0] "="]]       ;# データ内容
          if {$item == "execute"} {
            set buf($N,$item) "$dir/$val"
          } elseif {$item == "name"   || $item == "argv"   || \
                    $item == "needF0" || $item == "F0unit" || $item == "needPower" || $item == "edit"} {
            set buf($N,$item) $val
          }
        }
      }
      close $fp

      if {$buf($N,execute) == ""} continue
      if {[regexp {;} $buf($N,execute)]} {
        tk_messageBox -message "error: can not use ';' in 'execute=' of plugin.txt" \
          -title $t(.confm.fioErr) -icon warning
        continue
      }

      ;# 未記入の項目があればデフォルト値をセットする
      if {$buf($N,name) == ""} {
        set buf($N,name) $buf($N,execute)
      }

      if {$buf($N,edit) == "single"} {
        incr Nsingle
      } elseif {$buf($N,edit) == "region"} {
        incr Nregion
      } else {
        incr Nall
      }
      incr N
    }
  }

  ;# プラグインの情報を種類順に並べて登録する
  set seq 0
  foreach edit {all region single} {
    for {set i 0} {$i < $N} {incr i} {
      if {$buf($i,edit) == $edit} {
        foreach item {name execute argv needF0 F0unit needPower edit} {
          set plugin($seq,$item) $buf($i,$item)
        }
        incr seq
      }
    }
  }
  set plugin(N) $seq
}

#---------------------------------------------------
# 指定した番号(seq)のプラグインを実行する
#
proc runPlugin {seq undo} {
  global v plugin t topdir f0 power paramUsize

  if {$seq >= $plugin(N) || $paramUsize <= 0} return
  set targetList {}
  foreach pos [getCurSelection] {
    set r [lindex [split $pos ","] 0]
    if {[lindex $targetList end] != $r} {
      lappend targetList $r
    }
  }
  set execute $plugin($seq,execute)
  set argv    $plugin($seq,argv)
  regsub -all -- {%s} $argv $v(saveDir)   argv              ;# %sがあれば音源フォルダの絶対パスにする
  regsub -all -- {%S} $argv "\"$v(saveDir)\""   argv        ;# %sの改良版。絶対パスを二重引用符でくくる
  regsub -all -- {%r} $argv $v(aepResult) argv              ;# %rがあればデータ受け渡し用oto.iniの絶対パスにする
  regsub -all -- {%R} $argv "\"$v(aepResult)\"" argv              ;# %rの改良版。絶対パスを二重引用符でくくる
  regsub -all -- {%f} $argv $f0(frameLength)    argv        ;# %fがあればF0抽出間隔にする
  regsub -all -- {%p} $argv $power(frameLength) argv        ;# %pがあればパワー抽出間隔にする
  regsub -all -- {%n} $argv $v(listSeq) argv                ;# %nがあれば現在設定中の行番号にする
  regsub -all -- {%l} $argv [join $targetList ","] argv     ;# %lがあれば現在選択中の行番号リストにする
#  set act [tk_dialog .confm $t(.confm) $t(autoParamEstimation,runMsg) \
#    question 1 $t(.confm.yes) $t(.confm.no)]
  update
#  if {$act == 1} return

  set v(aepResult) "$v(saveDir)/oto-autoEstimation.ini";
  if {[file exists $v(aepResult)]} {
    file delete $v(aepResult)
  }
  set paramFileBak $v(paramFile)
  saveParamFile $v(aepResult) 1
  set v(paramFile) $paramFileBak

  ;# inParam.txtを作る
  if [catch {open $v(aepParamFile) w} fp] { 
    tk_messageBox -message "error: can not open $v(aepParamFile)" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  fconfigure $fp -encoding utf-8
  puts $fp "$v(saveDir)"         ;# 音源フォルダ
  puts $fp "$v(aepResult)"       ;# 結果出力用oto.ini
  puts $fp "$f0(frameLength)"    ;# F0抽出間隔[sec]
  puts $fp "$power(frameLength)" ;# パワー抽出刻み[sec]
  puts $fp "$v(listSeq)"         ;# 編集中の行番号
  puts $fp [join $targetList ","] ;# 選択中の行番号リスト
  close $fp

  ;# 必要なら各wavのF0ファイルを作る
  if {$plugin($seq,needF0) == 1} {
    if {$plugin($seq,F0unit) == "semitone"} {
      saveF0File semitone
    } else {
      saveF0File
    }
  }

  ;# 必要なら各wavのパワーファイルを作る
  if {$plugin($seq,needPower) == 1} savePowerFile

  ;# プラグイン実行
  eval exec "\"$execute\" $argv"

#  tk_dialog .confm "info" $t(autoParamEstimation,resultMsg) "" 0 OK
  if $undo {
    if {$plugin($seq,edit) == "single"} {
      pushUndo row $v(listSeq) $t(runPlugin,undo)
    } else {
      pushUndo all "" $t(runPlugin,undo)
    }
  }
  set v(paramChanged) 0           ;# 次のreadParamFileでパラメータ消去の警告を出させないため。
  if {$plugin($seq,edit) == "single"} {
    readPluginResult $v(aepResult) $v(listSeq) $v(listSeq)
  } elseif {$plugin($seq,edit) == "region"} {
    readPluginResult $v(aepResult) [lindex $targetList 0] [lindex $targetList end]
  } else {
    readParamFile $v(aepResult) 0   ;# アンドゥスタックをクリアせずにパラメータを読み込む
  }
  set v(paramFile) $paramFileBak
  if $undo {
    set v(paramChanged) 1
    pushUndo agn
    setEPWTitle
  }
}

#---------------------------------------------------
# 単独音自動設定の各パラメータをデフォルトに戻す
#
proc defaultEstimateParam {} {
  global f0 power estimate v t

  set estimate(frameLength) 0.002 ;# パワー抽出刻みの設定
  set power(preemphasis)    0.97  ;# プリエンファシスの設定
  set power(windowLength)  0.01   ;# パワー抽出窓長[sec]
  set power(window) Hanning       ;# 窓の選択

  ;# ハイパスフィルタ
  set estimate(hpfPattern) "が ぎ ぐ げ ご な に ぬ ね の ば び ぶ べ ぼ ヴ ま み む め も や ゆ よ ら り る れ ろ ga gi gu ge go na ni nu ne no ba bi bu be bo vu ma mi mu me mo ya yu yo ra ri ru re ro"
  ;# ローパスフィルタ
  set estimate(lpfPattern) "ざ じ ず ぜ ぞ だ ぢ づ で ど za ji zi zu ze do da di dzu de do"

  ;# 発話中とみなされる時間長
  set power(uttLengthSec) 0.05
  set power(uttLength) [sec2samp $power(uttLengthSec) $estimate(frameLength)]

  set power(uttHigh) 28    ;# 発話とみなされる振幅の閾値[dB]
  set power(uttLow)  28    ;# 無音とみなされる振幅の閾値[dB]
  set power(uttKeep) 5     ;# 発話中の音量のゆらぎとみなされる幅の閾値[dB]
  set power(vLow)    40    ;# 母音とみなされる振幅の閾値[dB]
  ;# ポーズとみなされる時間長
  set power(silLengthSec) 0.01
  set power(silLength) [sec2samp $power(silLengthSec) $estimate(frameLength)]
  set estimate(minC) 0.001 ;# 子音長最小値の設定
  set estimate(ovl) 0.4    ;# 先行発声値に対するオーバーラップの割合の設定
  set estimate(S)    1
  set estimate(E)    1
  set estimate(C)    1
  set estimate(P)    1
  set estimate(O)    1
}

#---------------------------------------------------
# 単独音のwavに自動推定パラメータを自動設定する
#
proc preEstimateParam {{fname ""} {fnameFiltered ""}} {
  global f0 power estimate v sv t

#  set estimate(hpfPattern) "が ぎ ぐ げ ご な に ぬ ね の ば び ぶ べ ぼ ヴ ま み む め も や ゆ よ ら り る れ ろ"
#  set estimate(lpfPattern) "ざ じ ず ぜ ぞ だ ぢ づ で ど"

  snack::sound sWork

  ;# wavファイルを読む
  if {$fname == ""} {
    set fname "$v(saveDir)/$v(recLab).$v(ext)"
  }
  if {[catch {sWork read $fname}]} return
  if {[sWork cget -channels] > 1} {
    sWork convert -channels Mono
  }
  if {$sv(appname) == "OREMO"} {
    set v(sndLength) [sWork length -unit SECONDS]
  }

  ;# F0を求める
  set seriestmp {}
  if {[catch {set seriestmp [sWork pitch -method $f0(method) \
    -framelength $estimate(frameLength) -windowlength $f0(windowLength) \
    -maxpitch $f0(max) -minpitch $f0(min) \
    ] } ret]} {
    set seriestmp {}
  }
  ;# 中央付近のF0値($f0cnt)を求める
  set f0cnt 0
  set seriesNum [llength $seriestmp]
  if {$seriesNum > 0} {
    ;# 左側有声開始位置leftを求める
    for {set left 0} {$left < $seriesNum} {incr left} {
      if {[lindex [split [lindex $seriestmp $left] " "] 0] > 0} break
    }
    ;# 右側有声開始位置rightを求める
    for {set right [expr $seriesNum - 1]} {$right >= 0} {incr right -1} {
      if {[lindex [split [lindex $seriestmp $right] " "] 0] > 0} break
    }
    ;# leftとrightの真ん中から有声部分のF0を求める
    set st [expr int(($right + $left) / 2)]
    for {set d 0} {$d < $st} {incr d} {
      set pos [expr $st - $d]
      if {$pos < $left} break
      set f0cnt [lindex [split [lindex $seriestmp $pos] " "] 0]
      if {$f0cnt > 0} break

      set pos [expr $st + $d]
      if {$pos > $right} break
      set f0cnt [lindex [split [lindex $seriestmp $pos] " "] 0]
      if {$f0cnt > 0} break
    }
  }

  ;# パワー抽出刻みの設定
#  set estimate(frameLength) 0.002

  ;# 発話中とみなされる時間長
#  set power(uttLengthSec) 0.1
  set power(uttLength) [sec2samp $power(uttLengthSec) $estimate(frameLength)]

  ;# ポーズとみなされる時間長
#  set power(silLengthSec) 0.01
  set power(silLength) [sec2samp $power(silLengthSec) $estimate(frameLength)]

  ;# プリエンファシスの設定
#  set power(preemphasis)    0.97

  ;# パワーとF0抽出窓長の設定
  if {$f0cnt <= 0} {
    set power(windowLength) 0.02
    set f0(windowLength) 0.02
  } else {
    set power(windowLength) [cut3 [expr 2.5 / $f0cnt]]
    set f0(windowLength)    $power(windowLength)
  }

  ;# 窓の選択
#  set power(window) Hanning

  ;# パワーを抽出する
  if {[catch {set pw [sWork power -framelength $estimate(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start 0 -end -1] } ret]} {
    set pw {}
  }
  set pwNum [llength $pw]

  ;# 中央周辺の平均パワー、最大、最小を求める
  set pwCnt 0
  set pwCntMax -1
  set pwCntMin -1
  set cnt [expr int($pwNum / 2 - 0.1/2 / $estimate(frameLength))]
  for {set i 0} {$cnt >= 0 && $i < $pwNum && [expr $i * $estimate(frameLength)] < 0.1} {incr i} {
    set pos [expr int($cnt + $i)]
    if {$pos >= $pwNum} break
    set pwNow [lindex $pw $pos]
#    if {$pwNow < 20} break                  ;# もし現在のパワーが20dBを下回るなら終了
    set pwCnt  [expr $pwCnt  + $pwNow]
    if {$pwCntMax < $pwNow || $pwCntMax < 0} {
      set pwCntMax $pwNow
    }
    if {$pwCntMin > $pwNow || $pwCntMin < 0} {
      set pwCntMin $pwNow
    }
  }
  if {$i > 0} {
    set pwCnt  [expr $pwCnt  / double($i)]
  }

  ;# 左端周辺の平均パワーを求める
  set pwLeft 0
  set pwEndT [expr $pwCnt / 2.0]
  for {set i 0} {$i < $pwNum && [expr $i * $estimate(frameLength)] < 0.05} {incr i} {
    set pwNow 0
    if {$i < $pwNum} {
      set pwNow [lindex $pw $i]
    }
    if {$pwNow >= $pwEndT} break
    set pwLeft [expr $pwLeft + $pwNow]
  }
  if {$i > 0} {
    set pwLeft [expr $pwLeft / $i]
  }

  ;# 発話中とみなされる最小パワーの設定
  if {$pwCnt > $pwLeft} {
    set power(uttHigh) [cut3 [expr ($pwCnt + $pwLeft) / 2.0]]
  }

  ;# 発声中に生じるパワーの揺らぎの大きさ設定
  if {$pwCntMax > 0 && $pwCntMin > 0 && $pwCntMax > $pwCntMin} {
    set power(uttKeep) [cut3 [expr ($pwCntMax - $pwCntMin) * 4.0]]
  }

  ;# ポーズ中とみなされるパワーの設定
  set power(uttLow) [cut3 [expr 0.9 * $pwLeft + 0.1 * $power(uttHigh)]]

  ;# 母音パワー最小値の設定（この値未満は子音部とみなす）
  if {$fnameFiltered == "" || ! [file readable $fnameFiltered]} {
    ;# HPF/LPFを使わない場合
    if {$pwCnt > 0} {
      set power(vLow) [cut3 [expr $pwCnt * 4.0 / 5.0]]
    }
  } else {
    ;# HPF/LPFを使う場合はフィルタを書けた波形からパワーを抽出して求める
    snack::sound sWorkFiltered
    sWorkFiltered read $fnameFiltered
    if {[sWorkFiltered cget -channels] > 1} {
      sWorkFiltered convert -channels Mono
    }
    ;# パワーを抽出する
    if {[catch {set pw [sWorkFiltered power -framelength $estimate(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1] } ret]} {
        set pw {}
    }
    set pwNum [llength $pw]

    ;# 中央周辺の平均パワー、最大、最小を求める
    set pwCnt 0
    set cnt [expr int($pwNum / 2 - 0.1/2 / $estimate(frameLength))]
    for {set i 0} {$cnt >= 0 && $i < $pwNum && [expr $i * $estimate(frameLength)] < 0.1} {incr i} {
      set pos [expr int($cnt + $i)]
      if {$pos >= $pwNum} break
      set pwNow [lindex $pw $pos]
      if {$pwNow < 20} break                  ;# もし現在のパワーが20dBを下回るなら終了
      set pwCnt [expr $pwCnt + $pwNow]
    }
    if {$i > 0} {
      set pwCnt [expr $pwCnt / $i]
    }

    if {$pwCnt > 0} {
      set power(vLow) [cut3 [expr $pwCnt * 4.0 / 5.0]]
    }
  }

  ;# 子音長最小値の設定（子音部=0でUTAUがエラーになるのを回避するため）
#  set estimate(minC) 0.001

  ;# 先行発声値に対するオーバーラップの割合の設定
#  set estimate(ovl) 0.4

}

#---------------------------------------------------
# 単独音推定の設定窓の各パラメータの有効無効を切り替える
# mode: 1..無効にする、0..有効にする
#
proc toggleEstimateParam {mode} {
  global epwindow v t

  set w $epwindow.al
  if {$mode} {
    set newState disabled
  } else {
    set newState normal
  }

#  foreach w2 {efl eem ewlSec mwn ehp elp ehi eulSec ekp elw emvSec eslSec emcSec eol eop} {    }
  foreach w2 {ewlSec ehi ekp elw emvSec} {
    $w.$w2 configure -state $newState
  }
}

# 入力が実数なら1を返す
proc isDouble {str} {
  if {[string is double $str] && [regexp { } $str] == 0} {
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
# 単独音のUTAU原音パラメータを推定する際の設定窓
#
proc estimateParam {{undo 1}} {
  global topdir epwindow power estimate v sv t

  if [isExist $epwindow] return  ;# 二重起動を防止
  toplevel $epwindow
  wm title $epwindow $t(estimateParam,title)
  wm resizable $epwindow 0 0
  bind $epwindow <Escape> "destroy $epwindow"

  set w [frame $epwindow.al]
  pack $w
  set row 0

  ;# 以下の各パラメータを自動推定するかどうかの設定
  frame $w.f$row
  checkbutton $w.f$row.b -variable estimate(preEstimateParam) -command {
    toggleEstimateParam $estimate(preEstimateParam)
  }
  button $w.f$row.t -text $t(estimateParam,preEstimate) -relief flat -command {
    if {$estimate(preEstimateParam)} {
      set estimate(preEstimateParam) 0
    } else {
      set estimate(preEstimateParam) 1
    }
    toggleEstimateParam $estimate(preEstimateParam)
  }
  pack $w.f$row.b $w.f$row.t -side left
  grid $w.f$row -sticky w -row $row -column 0 -columnspan 3
  incr row

  ;# パワー抽出刻みの設定
  label $w.lfl -text $t(estimateParam,frameLength)
  entry $w.efl -textvar estimate(frameLength) \
    -validate all -validatecommand {
         if {[string is double %P] && [regexp { } %P] == 0} {
           if {[string length %P] > 0 && %P > 0} {
             set tmp [sec2samp $power(uttLengthSec) %P]
             if {$tmp >= 0} {
               set power(uttLength) $tmp
             }
           }
           expr {1}
         } else {
           expr {0}
         }
    }
  label $w.lflu -text "(sec)"
  grid $w.lfl  -sticky w -row $row -column 0
  grid $w.efl  -sticky w -row $row -column 1
  grid $w.lflu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# プリエンファシスの設定
  # frame $w.fem
  label $w.lem -text $t(estimateParam,preemph)
  entry $w.eem -textvar power(preemphasis) -validate all -validatecommand {isDouble %P}
  grid $w.lem  -sticky w -row $row -column 0
  grid $w.eem  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# パワー抽出窓長の設定
  label $w.lwl -text $t(estimateParam,pWinLen)
  entry $w.ewlSec -textvar power(windowLength) -validate all -validatecommand {isDouble %P}
  label $w.lwlSec -text "(sec)"
  grid $w.lwl      -sticky w -row $row -column 0
  grid $w.ewlSec   -sticky w -row $row -column 1
  grid $w.lwlSec   -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 窓の選択
  label $w.lwn -text $t(estimateParam,pWinkind)
  tk_optionMenu $w.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  grid $w.lwn  -sticky w -row $row -column 0
  grid $w.mwn  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ハイパスフィルタをかける対象の設定
  label $w.lhp -text $t(estimateParam,hpfPattern)
  entry $w.ehp -textvar estimate(hpfPattern)
  label $w.chp -text $t(estimateParam,hpfComment)
  grid $w.lhp -sticky w -row $row -column 0
  grid $w.ehp -sticky w -row $row -column 1
  grid $w.chp -sticky w -row $row -column 2 -columnspan 3
  incr row

  ;# ローパスフィルタをかける対象の設定
  label $w.llp -text $t(estimateParam,lpfPattern)
  entry $w.elp -textvar estimate(lpfPattern)
  label $w.clp -text $t(estimateParam,lpfComment)
  grid $w.llp -sticky w -row $row -column 0
  grid $w.elp -sticky w -row $row -column 1
  grid $w.clp -sticky w -row $row -column 2 -columnspan 3
  incr row

  ;# 発話中とみなされる最小パワーの設定
  # frame $w.fhi
  label $w.lhi -text $t(estimateParam,pUttMin)
  entry $w.ehi -textvar power(uttHigh) -validate all -validatecommand {isDouble %P}
  label $w.lhiu -text "(db)"
  grid $w.lhi  -sticky w -row $row -column 0
  grid $w.ehi  -sticky w -row $row -column 1
  grid $w.lhiu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 発話中とみなされる時間長の設定
  # frame $w.ful
  label $w.lul -text $t(estimateParam,pUttMinTime)
  entry $w.eulSec -textvar power(uttLengthSec) \
    -validate all -validatecommand {
      if {[isDouble %P] == 0} {
        expr {0}
      } else {
        set tmp [sec2samp %P $estimate(frameLength)]
        if {$tmp >= 0} {
          set power(uttLength) $tmp
          expr {1}
        } else {
          expr {0}
        }
      }
    }
  label $w.lulSec -text "(sec) = "
  label $w.lulSamp -textvar power(uttLength)
  label $w.lulSampu -text "(sample)"
  grid $w.lul      -sticky w -row $row -column 0
  grid $w.eulSec   -sticky w -row $row -column 1
  grid $w.lulSec   -sticky w -row $row -column 2
  grid $w.lulSamp  -sticky w -row $row -column 3
  grid $w.lulSampu -sticky w -row $row -column 4
  incr row

  ;# 発声中に生じるパワーの揺らぎの大きさ設定
  # frame $w.fhi
  label $w.lkp -text $t(estimateParam,uttLen)
  entry $w.ekp -textvar power(uttKeep) -validate all -validatecommand {isDouble %P}
  label $w.lkpu -text "(db)"
  grid $w.lkp  -sticky w -row $row -column 0
  grid $w.ekp  -sticky w -row $row -column 1
  grid $w.lkpu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# ポーズ中とみなされるパワーの設定
  # frame $w.flw
  label $w.llw -text $t(estimateParam,silMax)
  entry $w.elw -textvar power(uttLow) -validate all -validatecommand {isDouble %P}
  label $w.llwu -text "(db)"
  grid $w.llw  -sticky w -row $row -column 0
  grid $w.elw  -sticky w -row $row -column 1
  grid $w.llwu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 母音パワー最小値の設定（この値未満は子音部とみなす）
  label $w.lmv -text $t(estimateParam,vLow)
  entry $w.emvSec -textvar power(vLow) -validate all -validatecommand {isDouble %P}
  label $w.lmvSec -text "(db)"
  grid $w.lmv      -sticky w -row $row -column 0
  grid $w.emvSec   -sticky w -row $row -column 1
  grid $w.lmvSec   -sticky w -row $row -column 2
  incr row

  ;# ポーズとみなされる時間長の設定
  # frame $w.fsl
  label $w.lsl -text $t(estimateParam,silMinTime)
  entry $w.eslSec -textvar power(silLengthSec) \
    -validate all -validatecommand {
      if {[isDouble %P] == 0} {
        expr {0}
      } else {
        set tmp [sec2samp %P $estimate(frameLength)]
        if {$tmp >= 0} {
          set power(silLength) $tmp
          expr {1}
        } else {
          expr {0}
        }
      }
    }
  label $w.lslSec -text "(sec) = "
  label $w.lslSamp -textvar power(silLength)
  label $w.lslSampu -text "(sample)"
  grid $w.lsl      -sticky w -row $row -column 0
  grid $w.eslSec   -sticky w -row $row -column 1
  grid $w.lslSec   -sticky w -row $row -column 2
  grid $w.lslSamp  -sticky w -row $row -column 3
  grid $w.lslSampu -sticky w -row $row -column 4
  incr row

  ;# 子音長最小値の設定（子音部=0でUTAUがエラーになるのを回避するため）
  label $w.lmc -text $t(estimateParam,minC)
  entry $w.emcSec -textvar estimate(minC) -validate all -validatecommand {isDouble %P}
  label $w.lmcSec -text "(sec)"
  grid $w.lmc      -sticky w -row $row -column 0
  grid $w.emcSec   -sticky w -row $row -column 1
  grid $w.lmcSec   -sticky w -row $row -column 2
  incr row

  ;# 先行発声値に対するオーバーラップの割合の設定
  label $w.lol -text $t(estimateParam,ovl)
  entry $w.eol -textvar estimate(ovl) -validate all -validatecommand {isDouble %P}
  grid $w.lol -sticky w -row $row -column 0
  grid $w.eol -sticky w -row $row -column 1
  incr row

  ;# オーバーラップを求める対象の設定
  label  $w.lop -text $t(estimateParam,ovlPattern)
  button $w.bop -text $t(estimateParam,edit) -command { execExternal "$topdir/estimate-ovlPattern.txt" }
  grid $w.lop -sticky w -row $row -column 0
  grid $w.bop -sticky w -row $row -column 1
  incr row

  ;# F0に関する説明文
  label $w.lf0 -text $t(estimateParam,f0)
  grid $w.lf0      -sticky w -row $row -column 0 -columnspan 3
  incr row

  ;# 推定対象の設定(S,O)
  label $w.l$row -text $t(estimateParam,target)
  frame $w.fs$row
  checkbutton $w.fs$row.b -variable estimate(S)
  button $w.fs$row.t -text $t(estimateParam,S) -relief flat -command {
    if {$estimate(S)} {
      set estimate(S) 0
    } else {
      set estimate(S) 1
    }
  }
  pack $w.fs$row.b $w.fs$row.t -side left
  grid $w.l$row  -sticky w -row $row -column 0
  grid $w.fs$row -sticky w -row $row -column 1

  frame $w.fo$row
  checkbutton $w.fo$row.b -variable estimate(O)
  button $w.fo$row.t -text $t(estimateParam,O) -relief flat -command {
    if {$estimate(O)} {
      set estimate(O) 0
    } else {
      set estimate(O) 1
    }
  }
  pack $w.fo$row.b $w.fo$row.t -side left
  grid $w.fo$row -sticky w -row $row -column 2 -columnspan 3

  incr row

  ;# 推定対象の設定(P,C)
  frame $w.fp$row
  checkbutton $w.fp$row.b -variable estimate(P)
  button $w.fp$row.t -text $t(estimateParam,P) -relief flat -command {
    if {$estimate(P)} {
      set estimate(P) 0
    } else {
      set estimate(P) 1
    }
  }
  pack $w.fp$row.b $w.fp$row.t -side left
  grid $w.fp$row -sticky w -row $row -column 1

  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(C)
  button $w.fe$row.t -text $t(estimateParam,C) -relief flat -command {
    if {$estimate(C)} {
      set estimate(C) 0
    } else {
      set estimate(C) 1
    }
  }
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 2 -columnspan 3

  incr row

  ;# 推定対象の設定(E)
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(E)
  button $w.fe$row.t -text $t(estimateParam,E) -relief flat -command {
    if {$estimate(E)} {
      set estimate(E) 0
    } else {
      set estimate(E) 1
    }
  }
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ボタンの設定
  frame $w.f$row
  grid $w.f$row -sticky we -row $row -column 0 -columnspan 5
  button $w.f$row.do -text $t(estimateParam,runAll) -command "_estimateParamAll $undo"
  grid $w.f$row.do     -sticky we -row 0 -column 0
  if {$sv(appname) != "OREMO"} {
    button $w.f$row.do2 -text $t(estimateParam,runSel) -command "_estimateParamSel $undo"
    grid $w.f$row.do2    -sticky we -row 0 -column 1
  }
  if {! $undo} {
    $w.f$row.do2 configure -state disabled  ;# 起動時の実行の場合
  }
  button $w.f$row.default -text $t(estimateParam,default) -command defaultEstimateParam
  grid $w.f$row.default -sticky we -row 0 -column 2
  button $w.f$row.cancel -text $t(.confm.c) -command {destroy $epwindow}
  grid $w.f$row.cancel -sticky we -row 0 -column 3
  incr row

  ;# 各部品の有効/無効を設定する
  toggleEstimateParam $estimate(preEstimateParam)
}

#---------------------------------------------------
# UTAU原音パラメータの推定
#
proc _estimateParamAll {undo} {
  global epwindow power v sv t

  if $v(paramChanged) {
    set act [tk_dialog .confm $t(.confm) $t(estimateParam,overWrite) \
      question 1 $t(.confm.ok) $t(.confm.c)]
    if {$act == 1} return
  }
  ;# もしエントリ欄が空欄だったなら0を代入
  if {[string length $power(silLengthSec)] == 0} {
    set power(silLengthSec) 0
  }
  if {[string length $power(uttLengthSec)] == 0} {
    set power(uttLengthSec) 0
  }

  if {$sv(appname) == "OREMO"}          { makeRecListFromDir 0 }
  destroy $epwindow
  doEstimateParam all $undo
  if {$::tcl_platform(os) == "Darwin"} { deleteProgressWindow } ;# なぜかmacではdoEstimateParamの中で消せなかった
  if {$sv(appname) == "OREMO"}          {
                                          set v(paramFile) "$v(saveDir)/oto.ini"
                                          saveParamFile
                                        }
  if {$sv(appname) != "OREMO"} {
    resetDisplay
  }
}

#---------------------------------------------------
# UTAU原音パラメータの推定
#
proc _estimateParamSel {undo} {
  global epwindow power v t

  ;# もしエントリ欄が空欄だったなら0を代入
  if {[string length $power(silLengthSec)] == 0} {
    set power(silLengthSec) 0
  }
  if {[string length $power(uttLengthSec)] == 0} {
    set power(uttLengthSec) 0
  }

  destroy $epwindow
  doEstimateParam sel $undo
  raise .
  Redraw all
  focus .
}

#---------------------------------------------------
# UTAU原音パラメータの推定
#
proc doEstimateParam {{mode all} {undo 1}} {
  global topdir power sv v paramS paramU paramUsize estimate t f0 ;# f0は他でも使っている

  set v(msg) $t(doEstimateParam,startMsg)

  snack::sound sWork
  snack::sound sWorkFiltered
  set ovlPattern [readOvlPattern "$topdir/estimate-ovlPattern.txt"]
  set lpfPattern [split $estimate(lpfPattern) " "]
  set hpfPattern [split $estimate(hpfPattern) " "]

  ;# 推定する行番号のリストを作る
  set targetList {}
  if {$mode == "all"} {
    for {set i 1} {$i < $paramUsize} {incr i} {
      lappend targetList $i
    }
  } else {
    foreach pos [getCurSelection] {
      set r [lindex [split $pos ","] 0]
      if {[lindex $targetList end] != $r} {
        lappend targetList $r
      }
    }
  }

  initProgressWindow
  if $undo {
    if {[llength $targetList] == 1} {
      pushUndo row $v(listSeq) $t(tool,auto,estimateParam)
    } else {
      pushUndo all "" $t(tool,auto,estimateParam)
    }
  }

  foreach i $targetList {
    ;# wavファイルを読む
    set fid $paramU($i,0)
    set filename "$v(saveDir)/$fid.$v(ext)"
    sWork read $filename
    if {[sWork cget -channels] > 1} {
      sWork convert -channels Mono
    }
    if {$sv(appname) == "OREMO"} {
      set v(sndLength) [sWork length -unit SECONDS]
    }

    ;# HPF/LPFをかける音であればフィルタをかけたwavを作って読み込む
    set mora0 [string range $paramU($i,0) 0 0]
    if {$estimate(lpfPattern) != "" && [lsearch $lpfPattern $mora0] >= 0} {
      set pwFilter  "lowpass"
      set pwFilterFreq 4000
      set pwFilterCoef "./tools/lpf-4000-31.txt"
    } elseif {$estimate(hpfPattern) != "" && [lsearch $hpfPattern $mora0] >= 0} {
      set pwFilter  "highpass"
      set pwFilterFreq 2500  ;#koko手動変更可能に。
      set pwFilterCoef "./tools/hpf-2500-31.txt"
    } else {
      set pwFilter  ""
      set pwFilterFreq 0
      set pwFilterCoef ""
    }

    ;# HPF/LPFをかけた音も利用する場合
    if {$pwFilter != ""} {
      if {[file exists $estimate(tmpWav)]} {
        file delete $estimate(tmpWav)
      }
      exec "./tools/sox/sox.exe" -V1 $filename $estimate(tmpWav) fir $pwFilterCoef
    }

    ;# wav毎に自動推定パラメータを自動設定する場合
    if {$estimate(preEstimateParam)} {
      if {$pwFilter == "" || ! [file readable $estimate(tmpWav)]} {
        preEstimateParam $filename
      } else {
        preEstimateParam $filename $estimate(tmpWav)  ;# パワー抽出用のファイルを別に指定している
      }
    }

    ;# パワーを抽出する
    if {[catch {set pw [sWork power -framelength $estimate(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1] } ret]} {
        set pw {}
    }

    ;# 初期値設定
    if {$estimate(S) || [array names paramS "$i,S"] == ""} {
      set paramS($i,S) 0
      set paramU($i,[kind2c S]) [sec2u $i S $paramS($i,S)]
    }
    if $estimate(C) { set paramS($i,C) $estimate(minC) }
    if $estimate(E) { set paramS($i,E) [sWork length -unit SECONDS] }
    set uttS 0           ;# 発声音量が十分な大きさになっているとみなされた位置
    set uttE [expr [llength $pw] - 1]     ;# 発声音量が減衰し始める位置

    if {[llength $pw] > 0} {
      ;# 左側の発話中確定点を探す
      set length 0   ;# 発話が連続しているサンプル数
      for {set j 0} {$j < [llength $pw]} {incr j} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttS $j     ;# 現在位置を保存
          break
        }
      }
      ;# 左にたどって左ブランク位置（発話開始点）を探す
      if $estimate(S) {
        set length 0
        for {set k $uttS} {$k > 0} {incr k -1} {
          if {[lindex $pw $k] <= $power(uttLow)} {
            if {$length >= $power(silLength)} {
              ;# 現在位置を左ブランクにする
              set tm [expr $k * $estimate(frameLength)] ;# 時刻[sec]を計算
              set paramS($i,S) $tm
              break
            }
            incr length
          } else {
            set length 0
          }
        }
      }

      ;# 発声音量が減衰し始める点を求める
      set length 0   ;# 発話が連続しているサンプル数
      for {set j [expr [llength $pw] - 1]} {$j > $uttS} {incr j -1} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttE $j     ;# 現在位置を保存
          break
        }
      }

      ;# uttS～uttE間の中央付近の平均パワーavePを求める
      set Nmax 30
      set N 0
      set aveP 0
      set center [expr int(($uttE + $uttS) / 2)]
      for {set j [expr $center + 1]} {$j <= $uttE && $N < [expr $Nmax / 2]} {incr j} {
        set aveP [expr $aveP + [lindex $pw $j]]
        incr N
      }
      for {set j $center} {$j >= $uttS && $N < $Nmax} {incr j -1} {
        set aveP [expr $aveP + [lindex $pw $j]]
        incr N
      }
      set aveP [expr $aveP / $N]

      ;# 右ブランク位置を探す
      if $estimate(E) {
        ;# 右ブランク位置探索法その1。中央から右方向へ、大きさの揺らぎの閾値を下回る位置を探す。
        set Et [expr $power(uttKeep) / 2]
        for {set j $center} {$j <= $uttE} {incr j} {
          if {[expr $aveP - [lindex $pw $j]] > $Et} {
            break
          }
        }
        ;# 右ブランク位置探索法その2。右から中央へ、平均パワーを超える位置を探す。
        for {set j2 $uttE} {$j2 > $center} {incr j2 -1} {
          if {[lindex $pw $j2] > $aveP} break
        }
        ;# 探索法1と2で、より右側にある値を採用する。
        if {$j2 > $j} { set j $j2 }
        ;# 現在位置を右ブランクにする
        set tm [expr $j * $estimate(frameLength)] ;# 時刻[sec]を計算
        if {$paramS($i,S) < $tm} {
          set paramS($i,E) $tm
        } else {
          set paramS($i,E) $paramS($i,S)
        }
      }

      ;# 有声開始位置を求める
      if {$estimate(C) || $estimate(P)} {
        set seriestmp {}
        if {[catch {set seriestmp [sWork pitch -method $f0(method) \
          -framelength $estimate(frameLength) -windowlength $f0(windowLength) \
          -maxpitch $f0(max) -minpitch $f0(min) \
          ] } ret]} {
          if {$ret != ""} {
            puts "error: $ret"
          }
          set seriestmp {}
        }
        if {[array names paramS "$i,S"] != ""} {
          set votInit [expr int($paramS($i,S) / $estimate(frameLength))]
        } else {
          set votInit 0
        }
        for {set vot $votInit} {$vot < [llength $seriestmp]} {incr vot} {
          if {[lindex [split [lindex $seriestmp $vot] " "] 0] > 0} break
        }
        set votSec [expr $vot * $estimate(frameLength)]
      }

      ;# 子音部位置を探す
      if $estimate(C) {
        set votPw [expr int($votSec / $estimate(frameLength))]  ;# vot位置(単位:パワーのサンプル数)を求める
        for {set j $center} {$j >= $uttS && $j > $votPw} {incr j -1} {
;#koko, パワーが平均値より大きい方に揺らいでいる分はOKとした。
;#koko, パワーが平均値より小さく揺らいだときに反応させるようにした
          if {[expr $aveP - [lindex $pw $j]] > [expr $power(uttKeep) / 2]} break
        }
        ;# 現在位置を子音部にする
        set tm [expr $j * $estimate(frameLength)] ;# 時刻[sec]を計算
        if {$tm >= [expr $paramS($i,S) + $estimate(minC)]} {
          set paramS($i,C) $tm
        } else {
          set paramS($i,C) [expr $paramS($i,S) + $estimate(minC)]
        }
      }

      ;# 先行発声位置を探す
      if $estimate(P) {
        set paramS($i,P) $paramS($i,S)

        ;# HPF/LPFを使う音の場合はここでパワーを抽出し直す
        if {$pwFilter != "" && [file readable $estimate(tmpWav)]} {
          sWorkFiltered read $estimate(tmpWav)
          if {[sWorkFiltered cget -channels] > 1} {
            sWorkFiltered convert -channels Mono
          }
          ;# パワーを抽出し直す
          if {[catch {set pw [sWorkFiltered power -framelength $estimate(frameLength) \
            -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
            -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
            -start 0 -end -1] } ret]} {
            set pw {}
          }
        }

        ;# votから右に行き、母音パワー最小値を超える所まで移動する
        if {[array names paramS "$i,C"] != ""} {
          set C $paramS($i,C)
        } elseif {[array names paramS "$i,E"] != ""} {
          set C $paramS($i,E)
        } else {
          set C [sWork length -unit SECONDS]
        }
        for {set j [expr int($votSec / $estimate(frameLength))]} \
            {[expr $j * $estimate(frameLength)] < $C} \
            {incr j} {
          if {[lindex $pw $j] >= $power(vLow)} break
        }

        ;# 現在位置を先行発声にする
        set tm [expr $j * $estimate(frameLength)] ;# 時刻[sec]を計算
        if {$tm <= $C} {
          set paramS($i,P) $tm
        } elseif {[array names paramS "$i,C"] != ""} {
          set paramS($i,P) $paramS($i,C)
        } else {
          set paramS($i,P) $paramS($i,S)
        }
      }

      ;# 子音部位置を補正
      if $estimate(C) {
        if {[expr $paramS($i,E) - $paramS($i,P)] > 0.6 && [expr $paramS($i,C) - $paramS($i,P)] < 0.1} {
          set paramS($i,C) [expr $paramS($i,P) + 0.1]
        }
      }
    }

    ;# オーバーラップ位置を求める
    if $estimate(O) {
      set paramS($i,O) $paramS($i,S)
      if {[llength $ovlPattern] > 0 && [array names paramS "$i,P"] != ""} {
        foreach ovl $ovlPattern {
          if {[string first $ovl $paramU($i,0)] == 0} {
            set newO [expr ($paramS($i,P) - $paramS($i,S)) * $estimate(ovl) + $paramS($i,S)]
            set paramS($i,O) $newO
            break
          }
        }
      }
    }

    ;# paramUを設定する
    foreach kind {S E C P O} {
      if $estimate($kind) {
        set paramU($i,[kind2c $kind]) [sec2u $i $kind $paramS($i,$kind)]
      }
    }
    updateProgressWindow [expr 100 * $i / $paramUsize]
    set v(msg) "$t(doEstimateParam,startMsg) ($i / $paramUsize)"

    if {[file exists $estimate(tmpWav)]} {
      file delete $estimate(tmpWav)
    }
  }
  deleteProgressWindow

  set v(paramChanged) 1
  setEPWTitle
  set v(msg) [eval format $t(doEstimateParam,doneMsg)]
  if $undo {
    pushUndo agn
  }
}

#---------------------------------------------------
# プログレスバーを初期化して表示する
#
proc initProgressWindow {{title "now processing..."}} {
  global prgWindow v

  if {$::tcl_platform(os) == "Darwin"} {
    if [isExist $prgWindow] {  ;# macではprogressbarを二回実行すると落ちたので
      set v(progress) 0 
      wm deiconify $prgWindow
      return
    }
  } else {
    if [isExist $prgWindow] return
  }

  toplevel $prgWindow
  wm title $prgWindow $title
  if {$::tcl_platform(os) != "Darwin"} {
    wm attributes $prgWindow -toolwindow 1
    wm attributes $prgWindow -topmost 1
  }
  bind $prgWindow <Escape> "destroy $prgWindow"
  set topg [split [wm geometry .] "x+"]
  set x [expr [lindex $topg 2] + [lindex $topg 0] / 2 - 100]
  set y [expr [lindex $topg 3] + [lindex $topg 1] / 2 - 5]
  wm geometry $prgWindow "+$x+$y"

  set v(progress) 0
  ttk::progressbar $prgWindow.p -length 200 -variable v(progress) -mode determinate
  pack $prgWindow.p

  raise $prgWindow
  focus $prgWindow
  if {$::tcl_platform(os) != "Darwin"} { grab set $prgWindow }
  update
}

#---------------------------------------------------
# プログレスバーを更新する。進捗状況は$progress(0～100)で指定する)
#
proc updateProgressWindow {progress {title ""}} {
  global v prgWindow

  if {! [isExist $prgWindow]} return
  if {$title != ""} { wm title $prgWindow $title }
  set v(progress) $progress
  raise $prgWindow
  focus $prgWindow
  if {$::tcl_platform(os) != "Darwin"} { grab set $prgWindow }
  update
}

#---------------------------------------------------
# プログレスバーを消去する
#
proc deleteProgressWindow {} {
  global prgWindow
  if [isExist $prgWindow] {
    if {$::tcl_platform(os) != "Darwin"} { grab release $prgWindow }
    destroy $prgWindow
  }
}

#---------------------------------------------------
# ustファイルを読み、該当する音名のみの編集環境を作る
#
proc readUstFile {} {
  global paramU paramUsizeC paramUsize paramS v ruWindow t

  if [isExist $ruWindow] return ;# 二重起動を防止
  toplevel $ruWindow
  wm title $ruWindow $t(.confm)
  bind $ruWindow <Escape> "destroy $ruWindow"
  wm attributes $ruWindow -topmost 1  ;# 常に最前面に表示
  grab $ruWindow

  label  $ruWindow.lq  -text $t(readUstFile,startMsg)
  button $ruWindow.b0  -text $t(readUstFile,modeComment) -command {destroy $ruWindow; doReadUstFile 0}
  button $ruWindow.b1  -text $t(readUstFile,modeDelete)  -command {destroy $ruWindow; doReadUstFile 1}
  button $ruWindow.bc  -text $t(.confm.c)                -command {destroy $ruWindow}
  label  $ruWindow.ll  -text $t(readUstFile,limit)
  entry  $ruWindow.el  -textvar v(readUstFileLimit)
  label  $ruWindow.le  -text $t(readUstFile,comment)
  entry  $ruWindow.ec  -textvar v(readUstFileComment)
  grid $ruWindow.lq -sticky news -row 0 -column 0 -columnspan 3 -pady 5
  grid $ruWindow.ll -sticky nes  -row 1 -column 1
  grid $ruWindow.el -sticky news -row 1 -column 2
  grid $ruWindow.b0 -sticky news -row 2 -column 0
  grid $ruWindow.le -sticky nes  -row 2 -column 1
  grid $ruWindow.ec -sticky news -row 2 -column 2
  grid $ruWindow.b1 -sticky news -row 3 -column 0
  grid $ruWindow.bc -sticky news -row 4 -column 0
}

#---------------------------------------------------
# ustファイルを読み、該当する音名のみの編集環境を作る
#
proc doReadUstFile {mode} { ;# mode=0...対象データにコメント追記、mode=1...対象外データを削除
  global paramU paramUsizeC paramUsize paramS v t

#  ;# パラメータを変更していたなら確認する
#  if $v(paramChanged) {
#    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
#      question 1 $t(.confm.yes) $t(.confm.no)]
#    if {$act == 1} return
#  }

  ;# ustファイル名取得
  set fn [tk_getOpenFile \
          -title $t(readParamFile,selMsg) -defaultextension "ust" \
          -filetypes { {{UTAU ust file} {.ust}} {{All Files} {*}} }]
  if {$fn == ""} return

  ;# 編集対象となる音名のリストを lyric に入れる
  set lyric {}
  if [catch {open $fn r} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  
  fconfigure $fp -encoding shiftjis

  pushUndo all "" $t(readUstFile,undo)

  while {![eof $fp]} {
    set data [split [gets $fp] "="]
    if {[llength $data] > 1} {
      set item [lindex $data 0]       ;# 項目名
      set val  [lindex $data 1]       ;# データ内容
      if {$item == "Lyric"} {
        ;# 重複がなければリストに追加
        if {[lsearch -exact $lyric $val] < 0} {
          lappend lyric $val
        }
      }
    }
  }
  close $fp

  ;# 編集対象のパラメータ行を求める(editTarget(r)==1ならrは編集対象)
  array unset editTarget
  for {set r 1} {$r < $paramUsize} {incr r} {
    set editTarget($r) 0
  }
  set targetNum 0     ;# 対象データ数の初期化
  foreach l $lyric {
    set chofuku 0
    for {set r 1} {$r < $paramUsize} {incr r} {
      set flag 0
      ;# 一致するかチェック
      if {[array names paramU "$r,0"] != "" && $l == $paramU($r,0)} {
        set flag 1   ;# fidが歌詞と完全一致する
      } elseif {[array names paramU "$r,6"] != "" && [regexp "^$l" $paramU($r,6)]} {
        set len [string length $l]
        if {$len < [string length $paramU($r,6)]} {
          if {[isKana [string index $paramU($r,6) $len]] == 0} {
            set flag 1  ;# 歌詞がエイリアスと前方一致した(エイリアスのマッチ部分の後ろに仮名文字がなかった)
          }
        } else {
          set flag 1  ;# 歌詞がエイリアスと完全一致した
        }
      }
      ;# 重複数のチェック
      if {$flag != 0} {
        incr chofuku
        if {$v(readUstFileLimit) > 0 && $v(readUstFileLimit) < $chofuku} {
          break  ;# 重複上限を超えたらskip
        }
        set editTarget($r) 1
        incr targetNum
      }
    }
  }

  if {$mode == 0} {   ;# 対象データにコメント追記。
    for {set r 1} {$r < $paramUsize} {incr r} {
      if {$editTarget($r)} {
        if {[array names paramU "$r,7"] != ""} {
          set paramU($r,7) "$paramU($r,7) $v(readUstFileComment)"
        } else {
          set paramU($r,7) $v(readUstFileComment)
        }
      }
    }
    set v(paramChanged) 1
  } else {            ;# 対象外データを削除
    ;# 編集対象のみの一覧表を作る
    set paramUsizeNew 1
    set recListNew {}
    for {set r 1} {$r < $paramUsize} {incr r} {
      if {$editTarget($r)} {
        ;# paramUを詰める
        for {set c 0} {$c < $paramUsizeC} {incr c} {
          if {[array names paramU "$r,$c"] != ""} {
            set paramU($paramUsizeNew,$c) $paramU($r,$c) 
          } else {
            array unset paramU $paramUsizeNew,$c
          }
        }
        set paramU($paramUsizeNew,R) [llength $recListNew]
        lappend recListNew $paramU($r,0)

        ;# paramSを更新
        for {set c 1} {$c < 6} {incr c} {
          set kind [c2kind $c]
          if {[array names paramS "$r,$kind"] != ""} {
            set paramS($paramUsizeNew,$kind) $paramS($r,$kind) 
          } else {
            array unset paramS $paramUsizeNew,$kind
          }
        }

        incr paramUsizeNew
      }
    }

    ;# リストを構築できないときはエラーを返す
    if {$paramUsizeNew <= 1} {
      tk_messageBox -message [eval format $t(readUstFile,errMsg)] \
        -title $t(.confm.errTitle) -icon error
      cancelUndo
      return
    }

    ;# paramUsizeを更新
    set paramUsize $paramUsizeNew
    set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存

    ;# v(recList)を更新
    set v(recList) $recListNew

    resetDisplay
    ;# 一覧表のサイズを更新する
    if [winfo exists .entpwindow] {
      .entpwindow.t configure -rows $paramUsize
      setCellSelection
    }
    set v(paramChanged) 0
  }
  setEPWTitle
  set tmp [expr $paramUsize -1]
  set v(msg) "$t(readUstFile,doneMsg) (num=$targetNum)"
  pushUndo agn
}

#---------------------------------------------------
# 新たに原音パラメータを読み込んで読み込み済みのものにマージする
#
proc mergeParamFile {args} {
  global paramU paramUsizeC paramS v paramUsize t

#  if $v(paramChanged) {
#    set act [tk_dialog .confm $t(.confm) $t(mergeParamFile,delParam) \
#      question 1 $t(.confm.yes) $t(.confm.no)]
#    if {$act == 1} return
#  }

  if {[llength $args] == 0} {
    set fn [tk_getOpenFile -initialfile $v(paramFile) \
            -title $t(mergeParamFile,selMsg) -defaultextension "ini" \
            -filetypes { {{UTAU param file} {.ini}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
  }
  if {$fn == ""} return

  ;# プログレス表示用に、一度データ数をカウントする
  set dataMax 0
  if [catch {open $fn r} fptmp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  fconfigure $fptmp -encoding utf-8
  while {![eof $fptmp]} {
    gets $fptmp
    incr dataMax
  }
  close $fptmp

  ;# マージする原音パラメータファイルを開く
  if [catch {open $fn r} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  
  fconfigure $fp -encoding utf-8

  ;# 結果報告する窓を表示する
  initProgressWindow "now merging..."
  pushUndo whl "" $t(file,mergeParamFile)

  set appendParam {}       ;# 上書き対象のなかったデータを入れる
  set fnameOld ""
  set cnt 0
  snack::sound sWork

  while {![eof $fp]} {
    set l [gets $fp]   ;# "fname=A,S,C,E,P,O"
    set p [split $l "=,"]
    if {[llength $p] == 7} {
      ;# ファイルIDを求める
      set fname [lindex $p 0]
      set fid [string range $fname 0 [expr [string first ".$v(ext)" $fname] - 1]]

      set alias [lindex $p 1]

      for {set r 1} {$r < $paramUsize} {incr r} {
        ;# fidおよびエイリアスが一致するデータがあれば上書きして次へ
        if {$paramU($r,0) == $fid && $paramU($r,6) == $alias} {

          ;# 空欄のパラメータを0にする
          for {set i 2} {$i < [llength $p]} {incr i} {
            if {[lindex $p $i] == ""} {
              set p [lreplace $p $i $i 0]
            }
          }
 
          ;# paramUを上書き
          set paramU($r,1) [lindex $p 2]   ;# S
          set paramU($r,4) [lindex $p 3]   ;# C
          set paramU($r,5) [lindex $p 4]   ;# E
          set paramU($r,3) [lindex $p 5]   ;# P
          set paramU($r,2) [lindex $p 6]   ;# O

          ;# paramSを更新
          if {$fname != $fnameOld} {
            if [catch {sWork read "$v(saveDir)/$fname"}] {
              set v(sndLength) 0
            } else {
              set v(sndLength) [sWork length -unit SECONDS]
            }
            set fnameOld $fname
          }
          paramU2paramS $r

          break
        }
      }
      ;# 上書きしなかったデータを記録
      if {$r >= $paramUsize} {
        lappend appendParam $l
      }
    }
    ;# 進捗を表示
    updateProgressWindow [expr 100 * $cnt / $dataMax]
    set v(msg) "$t(mergeParamFile,startMsg) ($paramUsize / $dataMax)"

    incr cnt
  }

  ;# ファイルを閉じる
  close $fp

  deleteProgressWindow

  ;# 上書きしていないデータが残った場合
  if {[llength $appendParam] > 0} {

    initProgressWindow
    set i 0
    set notExistWav {}
    foreach l $appendParam {
      set p [split $l "=,"]
      if {[llength $p] == 7} {
        ;# ファイルIDを求める
        set fname [lindex $p 0]
        set fid [string range $fname 0 [expr [string first ".$v(ext)" $fname] - 1]]

        ;# もしwavが存在しないエントリであれば登録しない
        if {[file exists "$v(saveDir)/$fname"] == 0} {
          lappend notExistWav $fid
          continue
        }

        ;# 挿入位置を求める
        for {set ins 2} {$ins < $paramUsize} {incr ins} {
          if {$paramU([expr $ins -1],0) == $fid && $paramU($ins,0) != $fid } {
            break
          }
        }
        
        ;# 挿入位置が一覧表の途中だった場合はセル内容を一行下にずらす
        if {$ins < $paramUsize} {
          for {set r $paramUsize} {$r > $ins} {incr r -1} {
            ;# paramUの内容を一つ下にコピーする
            for {set c 0} {$c < $paramUsizeC} {incr c} {
              if {[array names paramU [expr $r - 1],$c] != ""} {
                set paramU($r,$c) $paramU([expr $r - 1],$c)
              } else {
                array unset paramU $r,$c
              }
            }
            set paramU($r,R) $paramU([expr $r - 1],R)

            ;# paramSの内容を一つ下にコピーする
            foreach kind {S C E P O} {
              if {[array names paramS [expr $r - 1],$kind] != ""} {
                set paramS($r,$kind) $paramS([expr $r - 1],$kind)
              } else {
                array unset paramS $r,$kind
              }
            }
          }
        }

        ;# paramUを求める
        set paramU($ins,0) $fid            ;# fid
        set paramU($ins,6) [lindex $p 1]   ;# A
        set paramU($ins,1) [lindex $p 2]   ;# S
        set paramU($ins,4) [lindex $p 3]   ;# C
        set paramU($ins,5) [lindex $p 4]   ;# E
        set paramU($ins,3) [lindex $p 5]   ;# P
        set paramU($ins,2) [lindex $p 6]   ;# O
        set paramU($ins,R) [llength $v(recList)]

        ;# recListに追加
        lappend v(recList) $fid

        ;# paramSを求める
        if [catch {sWork read "$v(saveDir)/$fname"}] {
          set v(sndLength) 0
        } else {
          set v(sndLength) [sWork length -unit SECONDS]
        }
        paramU2paramS $ins

        updateProgressWindow [expr 100 * $i / [llength $appendParam]]
        incr i
        incr paramUsize
      }
    }
  }
  resetDisplay
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
    setCellSelection
  }
  set v(paramChanged) 1
  setEPWTitle
  deleteProgressWindow
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) [eval format $t(mergeParamFile,doneMsg)]
  pushUndo agn
}

#---------------------------------------------------
proc readPluginResult {fn startLine endLine} {
  global paramU paramS v paramUsize t

  ;# 原音パラメータファイルを開く
  if [catch {open $fn r} fp] { 
    tk_messageBox -message "error: can not open $fn" 
      -title $t(.confm.fioErr) -icon warning
    return 0
  }
  
  fconfigure $fp -encoding shiftjis

  ;# 結果報告する窓を表示する
  initProgressWindow "now loading..."

  snack::sound sWork

  set fnameOld ""
  for {set line 1} {$line < $startLine} {incr line} {
    if {[eof $fp]} {return 0}
    set l [gets $fp]   ;# "fname=A,S,C,E,P,O"
  }
  for {set line $startLine} {$line <= $endLine} {incr line} {
    if {[eof $fp]} {return 0}
    set l [gets $fp]   ;# "fname=A,S,C,E,P,O"
    set p [split $l "=,"]
    if {[llength $p] == 7} {
      ;# ファイルIDを求める
      set fname [lindex $p 0]
      set fid [string range $fname 0 [expr [string first ".$v(ext)" $fname] - 1]]

      ;# もしwavが存在しないエントリであれば登録しない
      if {[file exists "$v(saveDir)/$fname"] == 0} continue

      ;# 空欄のパラメータは0にする
      for {set i 2} {$i < [llength $p]} {incr i} {
        if {[lindex $p $i] == ""} {
          set p [lreplace $p $i $i 0]
        }
      }
 
      ;# paramUを求める
      # set paramU($line,0) $fid            ;# fid
      set paramU($line,6) [lindex $p 1]   ;# A
      set paramU($line,1) [lindex $p 2]   ;# S
      set paramU($line,4) [lindex $p 3]   ;# C
      set paramU($line,5) [lindex $p 4]   ;# E
      set paramU($line,3) [lindex $p 5]   ;# P
      set paramU($line,2) [lindex $p 6]   ;# O

      ;# paramSを求める
      if {$fname != $fnameOld} {
        if [catch {sWork read "$v(saveDir)/$fname"}] {
          set v(sndLength) 0
        } else {
          set v(sndLength) [sWork length -unit SECONDS]
        }
        set fnameOld $fname
      }
      paramU2paramS $line
    }
  }
  close $fp
  deleteProgressWindow
  Redraw all
  setLabAlias
  setEPWTitle
  set v(paramChanged) 1
  return 1
}

#---------------------------------------------------
# 原音パラメータを読み込む
# 返り値:1=読み込んだ。 0=読み込まなかった。
#
proc readParamFile {{fn ""} {clearUndo 1} {addEntry 1}} {
  global paramU paramS v paramUsize t

  if {$clearUndo && $v(paramChanged)} {
    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
      question 1 $t(.confm.yes) $t(.confm.no)]
    if {$act == 1} {return 0}
  }

  if {$fn == ""} {
    set fn [tk_getOpenFile -initialfile $v(paramFile) \
            -title $t(readParamFile,selMsg) -defaultextension "ini" \
            -filetypes { {{UTAU param file} {.ini}} {{All Files} {*}} }]
  }
  if {$fn == ""} {return 0}

  #if {![file exists "$v(saveDir)/oto.ini"]} {
  #  tk_messageBox -message "$v(saveDir)/oto.iniを読み込めませんでした" \
  #    -icon warning -title ファイルI/Oエラー
  #  return 0
  #}

  ;# プログレス表示用に、一度データ数をカウントする
  set dataMax 0

  if [catch {open $fn r} fptmp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return 0
  }
  fconfigure $fptmp -encoding shiftjis
  while {![eof $fptmp]} {
    gets $fptmp
    incr dataMax
  }
  close $fptmp

  ;# 原音パラメータファイルを開く
  if [catch {open $fn r} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return 0
  }
  fconfigure $fp -encoding shiftjis
  set v(paramFile) $fn

  ;# キャッシュを読むかチェック
  ;# oto.iniよりキャッシュファイルの日付が新しいなら利用する(useCache=1にする)
  set useCache 0
  set cacheFn [format "%s.oremo-Scache" [file rootname $v(paramFile)]]
  if [file readable $cacheFn] {
    if {[file mtime $cacheFn] >= [file mtime $v(paramFile)]} {
      set useCache 1
    }
  }

  ;# 結果報告する窓を表示する
  initProgressWindow "now loading..."

  set reclistO {}  ;# oto.iniから生成したreclistを入れる
  initParamS
  initParamU 1
  set fnameOld ""
  set notExistWav {} ;# wavファイルの存在しないfidを入れる
  snack::sound sWork

  while {![eof $fp]} {
    set l [gets $fp]   ;# "fname=A,S,C,E,P,O"
    set p [split $l "=,"]
    if {[llength $p] == 7} {
      ;# ファイルIDを求める
      set fname [lindex $p 0]
      set fid [string range $fname 0 [expr [string first ".$v(ext)" $fname] - 1]]

      ;# もしwavが存在しないエントリであれば登録しない
      if {[file exists "$v(saveDir)/$fname"] == 0} {
        lappend notExistWav $fid
        continue
      }

      ;# 空欄のパラメータは0にする
      for {set i 2} {$i < [llength $p]} {incr i} {
        if {[lindex $p $i] == ""} {
          set p [lreplace $p $i $i 0]
        }
      }
 
      ;# paramUを求める
      set paramU($paramUsize,0) $fid            ;# fid
      set paramU($paramUsize,6) [lindex $p 1]   ;# A
      set paramU($paramUsize,1) [lindex $p 2]   ;# S
      set paramU($paramUsize,4) [lindex $p 3]   ;# C
      set paramU($paramUsize,5) [lindex $p 4]   ;# E
      set paramU($paramUsize,3) [lindex $p 5]   ;# P
      set paramU($paramUsize,2) [lindex $p 6]   ;# O
      ;# 内部で参照するデータを設定
      set chofuku [lsearch -exact $reclistO $fid]
      if {$chofuku >= 0} {
        set paramU($paramUsize,R) $chofuku
      } else {
        set paramU($paramUsize,R) [llength $reclistO]
      }

      ;# reclistOに追加(重複する場合は追加しない)
      if {$chofuku < 0} {
        lappend reclistO $fid
      }

      ;# paramSを求める
      if {$useCache == 0 && [file exists "$v(saveDir)/$fname"]} {
        if {$fname != $fnameOld} {
          if [catch {sWork read "$v(saveDir)/$fname"}] {
            set v(sndLength) 0
          } else {
            set v(sndLength) [sWork length -unit SECONDS]
          }
        }
        paramU2paramS $paramUsize
      }

      incr paramUsize
      set fnameOld $fname
    }
    ;# 進捗を表示
    updateProgressWindow [expr 100 * $paramUsize / $dataMax]
    set v(msg) "$t(readParamFile,startMsg) ($paramUsize / $dataMax)"
  }

  if $useCache readCacheFile

  ;# ファイルを閉じる
  close $fp

  deleteProgressWindow

  ;# reclistOがv(recList)に一致するかチェック
  set rlV $v(recList)
  set i 0
  while {$i < [llength $rlV]} {
    if {[lsearch -exact $reclistO [lindex $rlV $i]] >= 0} {
      ;# 同じエントリがあった場合エントリを削除する
      set rlV [lreplace $rlV $i $i]
    } else {
      ;# reclistOにあるエントリがv(recList)にない場合
      incr i
    }
  }
  ;# 存在しないwav用のパラメータがある場合
  if {[llength $notExistWav] > 0} {
    set example [lindex $notExistWav 0]
    set mes [eval format $t(readParamFile,errMsg)]
    set mes "$mes\n$t(readParamFile,example)$example.$v(ext)"
    tk_messageBox -message $mes -icon warning -title $t(.confm.warnTitle)
  }
  ;# v(recList)にエントリが残った場合
  if {$addEntry && [llength $rlV] > 0} {
    set example [lindex $rlV 0]
    set mes [eval format $t(readParamFile,errMsg2)]
    set mes "$mes\n$t(readParamFile,example)$example.$v(ext)"
    if {[llength $rlV] >= 2} {
      set example [lindex $rlV 1]
      set mes "$mes\n$t(readParamFile,example)$example.$v(ext) ..."
    }
    tk_messageBox -message $mes -icon warning -title $t(.confm.warnTitle)

    initProgressWindow
    set i 0
    foreach fid $rlV {
      ;# paramUを求める
      set paramU($paramUsize,0) $fid            ;# fid
      set paramU($paramUsize,6) ""  ;# A
      set paramU($paramUsize,1) 0   ;# S
      set paramU($paramUsize,4) 0   ;# C
      set paramU($paramUsize,5) 0   ;# E
      set paramU($paramUsize,3) 0   ;# P
      set paramU($paramUsize,2) 0   ;# O
      ;# 内部で参照するデータを設定
      set paramU($paramUsize,R) [llength $reclistO]

      ;# reclistOに追加
      lappend reclistO $fid

      ;# paramSを求める
      if {[file exists "$v(saveDir)/$fid.$v(ext)"]} {
        if [catch {sWork read "$v(saveDir)/$fid.$v(ext)"}] {
          set v(sndLength) 0
        } else {
          set v(sndLength) [sWork length -unit SECONDS]
        }
        paramU2paramS $paramUsize
      }

      updateProgressWindow [expr 100 * $i / [llength $rlV]]
      incr i
      incr paramUsize
    }
  }
  ;# ファイルから生成したリストをv(recList)に登録する
  set v(recList) $reclistO

  readCommentFile [format "%s-comment.txt" [file rootname $fn]]

  ;# 先頭行の右ブランク値に沿ってsetParam側の設定を変える
  if {[array names paramU "1,5"] != ""} {
    if {$paramU(1,5) >= 0} {
      set v(_setE) 1
      set v(setE)  1
    } else {
      set v(_setE) -1
      set v(setE)  -1
    }
  }

  resetDisplay
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
    setCellSelection
  }

  set v(paramChanged) 0
  setEPWTitle
  deleteProgressWindow
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) [eval format $t(readParamFile,doneMsg)]
  if $clearUndo clearUndo
  set v(openedParamFile) $v(paramFile)    ;# 今回読み込んだファイル名を保存する
  return 1
}

#---------------------------------------------------
# コメントファイルを読み込む
#
proc readCommentFile {{fn ""}} {
  global v t paramU paramUsize

  ;# 原音パラメータファイルを開く
  if {$fn == ""} {
    set fn [format "%s-comment.txt" [file rootname $v(paramFile)]]
  }
  if {! [file exists $fn]} return
  if [catch {open $fn r} fp] return

  detectEncoding $fp
  set commNum 0
  while {![eof $fp]} {
    set l [gets $fp]
    if {$commNum < $paramUsize && $l != ""} {
      set paramU([expr $commNum + 1],7) $l
    }
    incr commNum
  }
  if {$commNum != $paramUsize} {
    set t(readCommentFile,err) "wavファイル数とコメント行数が一致しません。"
    tk_messageBox -message $t(readCommentFile,err) \
      -title $t(.confm.warnTitle) -icon warning
  }

  close $fp
}

#---------------------------------------------------
# エクスプローラで保存フォルダを開く
#
proc runExplorer {} {
  global v t

  if {$::tcl_platform(platform) == "windows"} {
    if {[string match $::tcl_platform(os) "Windows NT"]} {
      exec $::env(COMSPEC) /c start "" "$v(saveDir)" &
    } {
      exec start $v(saveDir) &
    }
  }
}

#---------------------------------------------------
# 自動バックアップを開始する
#
proc startAutoBackup {} {
  global v t

  if {$v(backupParamFile) == ""} return

  ;# もしバックアップファイルが存在していたら警告を出す
  if {[file exists $v(backupParamFile)] != 0} {
    set act [tk_dialog .confm $t(.confm) $t(autoBackup,q) \
      question 0 $t(autoBackup,a1) $t(autoBackup,a2)]
    if {$act == 0} {
      set dir [file dirname $v(backupParamFile)]
      exec $::env(COMSPEC) /c start "" "$dir"    ;# setParam-backup.iniのあるフォルダを開く
      destroy .
      exit
    }
    file delete $v(backupParamFile)
  }
  ;# 定期バックアップ開始
  if {$v(autoBackup) > 0} {
    after [expr $v(autoBackup) * 60000] doAutoBackup
  }
}

#---------------------------------------------------
# 自動バックアップを停止する
#
proc stopAutoBackup {} {
  global v t

  after cancel doAutoBackup
  if {$v(backupParamFile) != "" && [file exists $v(backupParamFile)]} {
    file delete $v(backupParamFile)
  }
  set v(backupParamFile) ""
}

#---------------------------------------------------
# 自動バックアップをとる
#
proc doAutoBackup {} {
  global v t

  if {$v(backupParamFile) == "" || $v(autoBackup) <= 0} return
  set paramFileTmp $v(paramFile)
  saveParamFile $v(backupParamFile)  1
  set v(paramFile) $paramFileTmp ;# ファイル名を元に戻す
  after [expr $v(autoBackup) * 60000] doAutoBackup
}

#---------------------------------------------------
# 原音パラメータを保存する
# return: 1=保存した。0=保存しなかった。
# 引数1 fn: 保存ファイル名。指定なしの場合ダイアログ窓を開く
# 引数2 autoBackup: 0=通常のoto.ini保存。
#         1=自動バックアッププラグイン実行のための保存。キャッシュファイルを保存しない。
#           保存した際にメッセージを表示しない。
#
proc saveParamFile {{fn ""} {autoBackup 0}} {
  global paramU paramUsize v sv t
 
  ;#if {$v(paramChanged) == 0} {
  ;#  set v(msg) "パラメータが変更されていないので保存しませんでした"
  ;#  tk_dialog .confm "Warning" \
  ;#    "パラメータが変更されていないので保存しませんでした" \
  ;#    warning 0 OK
  ;#  return 0
  ;#}
  if {$fn == ""} {
    set fn [tk_getSaveFile -initialfile $v(paramFile) \
              -title $t(saveParamFile,selFile) -defaultextension "ini" ]
    if {$fn == ""} {return 0}
  } elseif {$fn != $v(openedParamFile) && $autoBackup == 0 && [file exists $fn]} {
    set act [tk_dialog .confm $t(.confm) \
      "$fn $t(saveParamFile,confm)" question 1 $t(.confm.yes) $t(.confm.no) ]
    if {$act == 1} {return 0}
  }

  if {$autoBackup == 0} {
    set v(msg) $t(saveParamFile,startMsg)
  }

  if {[file exists $v(saveDir)] == 0} {
    file mkdir $v(saveDir)
  }
  ;# 保存ファイルを開く
  if [catch {open $fn w} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return 0
  }
  if {$::tcl_platform(os) != "Darwin"} {
    set v(paramFile) $fn  ;# macだとパス解析に失敗して次回のmy_getSaveFileで不正確なフォルダが初期指定されたので
  }
  
  fconfigure $fp -encoding shiftjis

  for {set i 1} {$i < $paramUsize} {incr i} {
    if {[array names paramU "$i,0"] != ""} {
      set name $paramU($i,0).$v(ext)
      set S 0; set O 0; set P 0; set C 0; set E 0; set A "";
      if {[array names paramU "$i,1"] != ""} { set S $paramU($i,1) }
      if {[array names paramU "$i,2"] != ""} { set O $paramU($i,2) }
      if {[array names paramU "$i,3"] != ""} { set P $paramU($i,3) }
      if {[array names paramU "$i,4"] != ""} { set C $paramU($i,4) }
      if {[array names paramU "$i,5"] != ""} { set E $paramU($i,5) }
      if {[array names paramU "$i,6"] != ""} { set A $paramU($i,6) }
      puts $fp $name=$A,$S,$C,$E,$P,$O    ;# ファイルへ書き出し
    }
  }
  close $fp        ;# ファイルを閉じる

  if {$::tcl_platform(os) == "Darwin"} {
    global nkf 
    exec -- $nkf -s --in-place $fn      ;# 漢字コードをsjisに変換
  }
  if {$autoBackup == 0} {
    if {$sv(appname) != "OREMO"} {
      saveCacheFile $fn   ;# キャッシュ作成。これはoto.ini保存より先にやってはいけない。
      set v(paramChanged) 0
      changeParamChangedInUndo
      setEPWTitle
    }
    set v(msg) [eval format $t(saveParamFile,doneMsg)]
  }

  ;# コメントを保存する
  saveCommentFile [format "%s-comment.txt" [file rootname $fn]]
  set v(openedParamFile) $v(paramFile)    ;# 今回書き込んだファイル名を保存する
  return 1
}

#
#---------------------------------------------------
# コメントを保存する
#
proc saveCommentFile {{fn ""}} {
  global paramU paramUsize v t

  ;# コメントがあるか調べる
  set existComment 0
  for {set i 1} {$i < $paramUsize} {incr i} {
    if {[array names paramU "$i,7"] != "" && $paramU($i,7) != ""} {
      set existComment 1
      break
    }
  }

  if {$fn == ""} {
    set fn [format "%s-comment.txt" [file rootname $v(paramFile)]]
  }

  ;# コメントを保存する
  if {$existComment || [file exists $fn]} {
    if [catch {open $fn w} fp] { 
      tk_messageBox -message "error: can not open $fn" \
        -title $t(.confm.fioErr) -icon warning
      return
    }
    
    fconfigure $out -encoding binary
    puts -nonewline $out \xef\xbb\xbf
    fconfigure $out -encoding utf-8

    for {set i 1} {$i < $paramUsize} {incr i} {
      if {[array names paramU "$i,7"] != "" && $paramU($i,7) != ""} {
        puts $fp $paramU($i,7)
      } else {
        puts $fp ""
      }
    }

    close $fp        ;# ファイルを閉じる
  }
}

#---------------------------------------------------
# 原音パラメータの内部形式 paramS を保存する
# fn: 原音パラメータファイル名。キャッシュファイル名ではない。
# return: 1=保存した。0=保存しなかった。
#
proc saveCacheFile {{fn ""}} {
  global paramS paramUsize v sv t

  if {$fn != ""} {
    if {$sv(appname) != "setParam" || $fn == ""} {return 0}
    set fn [format "%s.%s-Scache" [file rootname $fn] $sv(appname)]
  } else {
    if {$sv(appname) != "setParam" || $v(paramFile) == ""} {return 0}
    set fn [format "%s.%s-Scache" [file rootname $v(paramFile)] $sv(appname)]
  }
 
  ;# 保存ファイルを開く
  if [catch {open $fn w} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  fconfigure $fp -translation binary  ;# バイナリモードにする

  for {set r 1} {$r < $paramUsize} {incr r} {
    for {set c 1} {$c < 6} {incr c} {
      set val 0
      set kind [c2kind $c]
      if {[array names paramS "$r,$kind"] != ""} { set val $paramS($r,$kind) }
      puts -nonewline $fp [binary format d1 $val]   ;# ファイルへ書き出し
    }
  }
  close $fp        ;# ファイルを閉じる
  return 1
}

#---------------------------------------------------
# キャッシュファイルを読み込む
#
proc readCacheFile {} {
  global paramS v sv t

  set fn [format "%s.%s-Scache" [file rootname $v(paramFile)] $sv(appname)]

  if {$fn == "" || ! [file readable $fn]} {return 0}

  ;# 保存ファイルを開く
  if [catch {open $fn r} fp] { 
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  fconfigure $fp -translation binary  ;# バイナリモードにする

  set r 1
  while {![eof $fp]} {
    for {set c 1} {$c < 6} {incr c} {
      set val 0
      set kind [c2kind $c]
      set buf [binary scan [read $fp 8] d1 paramS($r,$kind)]
    }
    incr r
  }
  close $fp        ;# ファイルを閉じる
  return 1
}


#---------------------------------------------------
# 詳細設定
#
proc settings {} {
  global swindow v sv power f0 v_bk power_bk f0_bk snd t
    # ↑*_bkは大域変数にしないとキャンセル時にバックアップ復帰できなかった

  ;# 二重起動を防止
  if [isExist $swindow] return
  toplevel $swindow
  wm title $swindow $t(settings,title)
  wm resizable $swindow 0 0
  bind $swindow <Escape> "destroy $swindow"

  array set v_bk     [array get v]     ;# パラメータバックアップ
  array set power_bk [array get power] ;# パラメータバックアップ
  array set f0_bk    [array get f0]    ;# パラメータバックアップ

  ;# 1カラム目のフレーム
  set frame1 [frame $swindow.l]
  pack $frame1 -side left -anchor n -fill y -padx 2 -pady 2

  ;#---------------------------
  ;# 波形
  set lf1 [labelframe $frame1.lf1 -text $t(settings,wave) \
    -relief groove -padx 5 -pady 5]
  pack $lf1 -anchor w -fill x

  ;# 波形色の設定
  set cw [frame $lf1.f4w]
  setColor $cw "wavColor" $t(settings,waveColor)
  pack $cw -anchor nw

  ;# 波形縦軸の最大値
  pack [frame $lf1.fs] -anchor w
  label $lf1.fs.l -text $t(settings,waveScale) -wi 35 -anchor w
  entry $lf1.fs.e -textvar v(waveScale) -wi 6 -validate key -validatecommand {
    if {![isDouble %P] || ![string is integer %P]} {return 0}
    if {%P < 0 || %P > 32768} {return 0}
    return 1
  }
  pack $lf1.fs.l $lf1.fs.e  -side left

  ;# サンプリング周波数の設定
  pack [frame $lf1.f20] -anchor w
  label $lf1.f20.l -text $t(settings,sampleRate) -wi 35 -anchor w
  entry $lf1.f20.e -textvar v(sampleRate) -wi 6 -validate key -validatecommand {
    if {![isDouble %P] || ![string is integer %P]} {return 0}
    if {%P < 0} {return 0}
    return 1
  }
  pack $lf1.f20.l $lf1.f20.e  -side left

  ;#---------------------------
  ;# スペクトルパラメータ
  set lf2 [labelframe $frame1.lf2 -text $t(settings,spec) \
    -relief groove -padx 5 -pady 5]
  pack $lf2 -anchor w -fill x

  ;# スペクトルの配色
  pack [frame $lf2.f45] -anchor w
  label $lf2.f45.l -text $t(settings,specColor) -width 20 -anchor w
  tk_optionMenu $lf2.f45.cm v(cmap) grey color1 color2
  pack $lf2.f45.l $lf2.f45.cm -side left

  ;# スペクトル周波数の最高値
  pack [frame $lf2.f20] -anchor w
  label $lf2.f20.l -text $t(settings,maxFreq) -width 20 -anchor w
  entry $lf2.f20.e -textvar v(topfr) -wi 6 -validate all -validatecommand {isDouble %P}
  scale $lf2.f20.s -variable v(topfr) -orient horiz \
    -from 0 -to [expr $v(sampleRate)/2] -showvalue 0
  pack $lf2.f20.l $lf2.f20.e $lf2.f20.s -side left

  ;# 明るさ
  pack [frame $lf2.f30] -anchor w
  label $lf2.f30.l -text $t(settings,brightness) -width 20 -anchor w
  entry $lf2.f30.e -textvar v(brightness) -wi 6 -validate all -validatecommand {isDouble %P}
  scale $lf2.f30.s -variable v(brightness) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f30.l $lf2.f30.e $lf2.f30.s -side left

  ;# コントラスト
  pack [frame $lf2.f31] -anchor w
  label $lf2.f31.l -text $t(settings,contrast) -width 20 -anchor w
  entry $lf2.f31.e -textvar v(contrast) -wi 6 -validate all -validatecommand {isDouble %P}
  scale $lf2.f31.s -variable v(contrast) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f31.l $lf2.f31.e $lf2.f31.s -side left

  ;# FFT長(必ず2のべき乗にすること)
  pack [frame $lf2.f32] -anchor w
  label $lf2.f32.l -text $t(settings,fftLength) -width 20 -anchor w
  tk_optionMenu $lf2.f32.om v(fftlen) 8 16 32 64 128 256 512 1024 2048 4096
  pack $lf2.f32.l $lf2.f32.om -side left

  ;# 窓長(必ずFFT長以下にすること)
  pack [frame $lf2.f33] -anchor w
  label $lf2.f33.l -text $t(settings,fftWinLength) -width 20 -anchor w
  entry $lf2.f33.e -textvar v(winlen) -wi 6 -validate all -validatecommand {isDouble %P}
  scale $lf2.f33.s -variable v(winlen) -orient horiz \
    -from 8 -to 4096 -showvalue 0
  pack $lf2.f33.l $lf2.f33.e $lf2.f33.s -side left

  ;# プリエンファシス
  pack [frame $lf2.f34] -anchor w
  label $lf2.f34.l -text $t(settings,fftPreemph) -width 20 -anchor w
  entry $lf2.f34.e -textvar v(preemph) -wi 6 -validate all -validatecommand {isDouble %P}
  pack $lf2.f34.l $lf2.f34.e -side left

  ;# 窓の選択
  pack [frame $lf2.f35] -anchor w
  label $lf2.f35.lwn -text $t(settings,fftWinKind) -width 20 -anchor w
  tk_optionMenu $lf2.f35.mwn v(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf2.f35.lwn $lf2.f35.mwn -side left

  ;#---------------------------
  ;# パワーの設定
  set lf3 [labelframe $frame1.lf3 -text $t(settings,pow) \
    -relief groove -padx 5 -pady 5]
  pack $lf3 -anchor w -fill x

  ;# パワー色の設定
  set cp [frame $lf3.f4p]
  setColor $cp "powcolor" $t(settings,powColor)
  pack $cp -anchor nw

  ;# パワー抽出刻みの設定
  packEntryPower $lf3.ffl $t(settings,powLength) frameLength

  ;# プリエンファシスの設定
  packEntryPower $lf3.fem $t(settings,powPreemph) preemphasis

  ;# 窓長の設定
  packEntryPower $lf3.fwl $t(settings,winLength) windowLength

  ;# 窓の選択
  pack [frame $lf3.fwn] -anchor w
  label $lf3.fwn.lwn -text $t(settings,powWinKind) -width 20 -anchor w
  tk_optionMenu $lf3.fwn.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf3.fwn.lwn $lf3.fwn.mwn -side left

  ;#---------------------------
  ;#---------------------------
  ;# 2カラム目のフレーム
  set frame2 [frame $swindow.r]
  pack $frame2 -side left -anchor n -fill both -expand true -padx 2 -pady 2

  ;#---------------------------
  ;# F0の設定
  set lf4 [labelframe $frame2.lf4 -text $t(settings,f0) \
    -relief groove -padx 5 -pady 5]
  pack $lf4 -anchor w -fill x

  ;# F0色の設定
  set cf [frame $lf4.f4f]
  setColor $cf "f0color" $t(settings,f0Color)
  pack $cf -anchor nw

  ;# 抽出アルゴリズムの選択
  pack [frame $lf4.p1] -anchor w
  label $lf4.p1.l -text $t(settings,f0Argo) -width 20 -anchor w
  tk_optionMenu $lf4.p1.mt f0(method) ESPS AMDF
  pack $lf4.p1.l $lf4.p1.mt -side left

  ;# entry型の設定いろいろ
  packEntryF0 $lf4.p2 $t(settings,f0Length)    frameLength
  packEntryF0 $lf4.p3 $t(settings,f0WinLength) windowLength
  packEntryF0 $lf4.p4 $t(settings,f0Max)       max
  packEntryF0 $lf4.p5 $t(settings,f0Min)       min

  ;# 表示単位の選択
  pack [frame $lf4.p6] -anchor w
  label $lf4.p6.l -text $t(settings,f0Unit) -width 20 -anchor w
  tk_optionMenu $lf4.p6.mt f0(unit) Hz semitone
  pack $lf4.p6.l $lf4.p6.mt -side left

  ;# グラフ範囲の設定
  checkbutton $lf4.p7cb -text $t(settings,f0FixRange) \
    -variable f0(fixShowRange) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p7 -labelwidget $lf4.p7cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  packToneList $lf4.p7.tl1 $t(settings,f0FixRange,h) \
    showMaxTone showMaxOctave showMaxTmp 10 checkVol
  packToneList $lf4.p7.tl2 $t(settings,f0FixRange,l) \
    showMinTone showMinOctave showMinTmp 10 checkVol

  ;# 各音の線を表示
  checkbutton  $lf4.p8cb -text $t(settings,grid) \
    -variable f0(showToneLine) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p8 -labelwidget $lf4.p8cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  setColor $lf4.p8 "toneLineColor" $t(settings,gridColor)

  ;# ターゲット音の線を表示
  checkbutton $lf4.p9cb -text $t(settings,target) \
    -variable f0(showTgtLine) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p9 -labelwidget $lf4.p9cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  packToneList $lf4.p9.tl $t(settings,targetTone) \
    tgtTone tgtOctave tgtFreqTmp 10 checkVol
  setColor $lf4.p9 "tgtf0color" $t(settings,targetColor)
  label  $lf4.p9.al -text $t(settings,autoSetting) -anchor nw
  button $lf4.p9.ab -text $t(.confm.run) -command autoF0Settings
  pack $lf4.p9.al $lf4.p9.ab -side left

  ;# 各音名に対応する周波数を自動計算して表示する(非常に汚いやり方)
  ;# 音名orオクターブに変化があれば周波数計算を行う
  ;# 周波数をf0(tgtFreq)などでなくf0(tgtFreqTmp)などに入れるのは、
  ;#「OK」or「適用」ボタンを押すまで値変更を反映させないため。
  set f0(showMaxTmp) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
  set f0(showMinTmp) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
  set f0(tgtFreqTmp) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
  trace variable f0 w calcFreq
  proc calcFreq {var elm mode} {
    global f0 t
    switch $elm {
      "showMaxTone" -
      "showMaxOctave" {
        set f0(showMaxTmp) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
      }
      "showMinTone" -
      "showMinOctave" {
        set f0(showMinTmp) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      }
      "tgtTone" -
      "tgtOctave" {
        set f0(tgtFreqTmp) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
      }
    }
  }
  bind $swindow <Destroy> { trace vdelete f0 w calcFreq }

  ;#---------------------------
  ;# OK, Apply, キャンセルボタン
  pack [frame $frame2.f] -anchor e -side bottom -padx 2 -pady 2
  button $frame2.f.exit -text $t(.confm.c) -command {
    array set v     [array get v_bk]     ;# パラメータを以前の状態に戻す
    array set power [array get power_bk] ;# パラメータを以前の状態に戻す
    array set f0    [array get f0_bk]    ;# パラメータを以前の状態に戻す
    set power(fid) ""  ;# パワーを強制的に再描画させる
    set f0(fid)    ""  ;# F0を強制的に再描画させる
    Redraw all
    destroy $swindow
  }
  button $frame2.f.app -text $t(.confm.apply) -command {
    ;# サンプリング周波数の変更
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd configure -rate $v(sampleRate)
    }
    ;# ターゲット音の周波数を求める
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0表示範囲周波数を求める
    if $f0(fixShowRange) {
      set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
    }
    set power(fid) ""  ;# パワーを強制的に再描画させる
    set f0(fid)    ""  ;# F0を強制的に再描画させる
    Redraw all
    ;# パラメータバックアップの更新
    array set v_bk     [array get v]     ;# パラメータバックアップ
    array set power_bk [array get power] ;# パラメータバックアップ
    array set f0_bk    [array get f0]    ;# パラメータバックアップ
  }
  button $frame2.f.ok -text $t(.confm.ok) -wi 6 -command {
    ;# サンプリング周波数の変更
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd configure -rate $v(sampleRate)
    }
    ;# ターゲット音の周波数を求める
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0表示範囲周波数を求める
    if $f0(fixShowRange) {
      set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
    }
    set power(fid) ""  ;# パワーを強制的に再描画させる
    set f0(fid)    ""  ;# F0を強制的に再描画させる
    Redraw all
    destroy $swindow
  }
  pack $frame2.f.exit $frame2.f.app $frame2.f.ok -side right
}

#---------------------------------------------------
# F0ターゲットに合わせて他の設定値を自動設定する
#
proc autoF0Settings {} {
  global v sv f0

  set tgtFreq [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]

  set f0(max) [expr int($tgtFreq * 2.1)]
  if {$tgtFreq >= 260} {
    set f0(min) [expr int($tgtFreq / 2.2)]
  } else {
    set f0(min) 60
  }

  set f0(fixShowRange) 1
  set ret [calcTone $f0(tgtTone) $f0(tgtOctave) 2]
  set f0(showMaxTone)   [lindex $ret 0]
  set f0(showMaxOctave) [lindex $ret 1]
  if {$f0(showMaxOctave) > $sv(sinScaleMax)} {
    set f0(showMaxOctave) $sv(sinScaleMax)
    set f0(showMaxTone)   [lindex $sv(toneList) [expr [llength $sv(toneList)] -1]]
  }
  set ret [calcTone $f0(tgtTone) $f0(tgtOctave) -2]
  set f0(showMinTone)   [lindex $ret 0]
  set f0(showMinOctave) [lindex $ret 1]
  if {$f0(showMinOctave) < $sv(sinScaleMin)} {
    set f0(showMinOctave) $sv(sinScaleMin)
    set f0(showMinTone)   [lindex $sv(toneList) 0]
  }
  set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
  set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
}

#---------------------------------------------------
# tone-octaveをadd度？上げたときのトーンとオクターブのリストを返す
#
proc calcTone {tone octave add} {
  global v sv
  for {set i 0} {$i < [llength $sv(toneList)]} {incr i} {
    if {$tone == [lindex $sv(toneList) $i]} break
  }
  set seq [expr $i + $add]
  while {$seq >= [llength $sv(toneList)]} {
    incr octave
    incr seq -12
  }
  while {$seq < 0} {
    incr octave -1
    incr seq +12
  }
  set ret {}
  lappend ret [lindex $sv(toneList) $seq]
  lappend ret $octave
  return $ret
}

#---------------------------------------------------
# 拍を画素単位に変換
#
proc beat2pixel {beat} {
  global v

  return [expr $beat * $v(wavepps) / ($v(bpm) / 60.0) + $v(bpmOffset) * $v(wavepps)]
}

#---------------------------------------------------
# キャンバス再描画
#
proc Redraw {opt} {
  global v sv c cYaxis snd power f0 paramS rec t

  # 描画中は他の操作ができないようにする
  # grab set $c
  # ↑これがあると窓の隅をドラッグしてサイズ変更できなくなるのでボツ

  ;# キャンバス上のものを削除して高さを再調整する
  set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
  if {$v(cHeight) < [winfo height $rec]} {set v(cHeight) [winfo height $rec]}
  set cWholeWidth [expr int($v(sndLength) * $v(wavepps))]
  $c delete obj
  $c delete axis
  $c configure -height $v(cHeight) -width $v(cWidth)
  $c configure -scrollregion [list 0 0 $cWholeWidth $v(cHeight)]
  $c create line 0 0 $cWholeWidth 0 -tags axis -fill $v(fg)
  $cYaxis delete axis
  $cYaxis configure -height $v(cHeight)
  $cYaxis create line 0 2 $v(yaxisw) 2 -tags axis -fill $v(fg)
  $cYaxis create line $v(yaxisw) 0 $v(yaxisw) $v(cHeight) -tags axis -fill $v(fg)

  ;# 波形表示
  if {$v(showWave)} {
    $c create waveform 0 0 -sound snd -height $v(waveh) -width $cWholeWidth \
      -tags [list obj wave] -debug $::debug -fill $v(wavColor) \
      -pixelspersecond $v(wavepps) -limit $v(waveScale)
    $c lower wave
    if {$v(waveScale) > 0} {
      $cYaxis create text $v(yaxisw) 4 -text $v(waveScale) \
        -font $v(sfont) -anchor ne -tags axis -fill #0000b0
      $cYaxis create text $v(yaxisw) [expr $v(waveh) * 0.5] -text [snd max] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
      $cYaxis create text $v(yaxisw) [expr $v(waveh) * 0.5 + 14] -text [snd min] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
    } else {
      $cYaxis create text $v(yaxisw) 4 -text [snd max] \
        -font $v(sfont) -anchor ne -tags axis -fill $v(fg)
      $cYaxis create text $v(yaxisw) $v(waveh) -text [snd min] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
    }

    set ylow $v(waveh)
    $c create line 0 $ylow $cWholeWidth $ylow -tags axis -fill $v(fg)
    set yAxisLow [expr $v(waveh) + 2]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)
#    $c create line $v(yaxisw) 0 $v(yaxisw) $v(waveh) -tags axis -fill $v(fg)
  }

  ;# スペクトル表示
  if {$v(showSpec)} {
    if {$v(winlen) > $v(fftlen)} {
      set v(winlen) $v(fftlen)
    }
    if {$cWholeWidth < 30000} {
      $c create spectrogram 0 $v(waveh) -sound snd -height $v(spech) \
        -width $cWholeWidth -tags [list obj spec] -debug $::debug \
        -fftlength $v(fftlen) -winlength $v(winlen) -windowtype $v(window) \
        -topfr $v(topfr) -contrast $v(contrast) -brightness $v(brightness) \
        -preemph $v(preemph) -colormap $sv($v(cmap)) -topfrequency $v(topfr) \
        -pixelspersecond $v(wavepps)
    } else {
      ;# 数十秒以上のwavのスペクトルを拡大表示させる場合、フーリエ変換の回数を複数回に分けて表示する
      for {set sLen [expr $v(sndLength) / 2.0]} {[expr $sLen * $v(wavepps)] >= 30000} {set sLen [expr $sLen / 2.0]} {}
      set sWidth [expr int($sLen * $v(wavepps) + 0.5)]
      for {set wt 0} {$wt < $v(sndLength)} {set wt [expr $wt + $sLen]} {
        set wavX [expr int($v(wavepps) * $wt + 0.5)]
        set wavS [expr int($v(sampleRate) * $wt)]
        set wavE [expr int($v(sampleRate) * ($wt + $sLen))]
        $c create spectrogram $wavX $v(waveh) -sound snd -height $v(spech) \
          -start $wavS -end $wavE -width $sWidth \
          -tags [list obj spec] -debug $::debug \
          -fftlength $v(fftlen) -winlength $v(winlen) -windowtype $v(window) \
          -topfr $v(topfr) -contrast $v(contrast) -brightness $v(brightness) \
          -preemph $v(preemph) -colormap $sv($v(cmap)) -topfrequency $v(topfr) \
          -pixelspersecond $v(wavepps)
      }
    }
    $c lower spec
    snack::frequencyAxis $cYaxis 0 $v(waveh) $v(yaxisw) $v(spech) \
          -topfr $v(topfr) -tags axis -font $v(sfont)
    set ylow [expr $v(spech) + $v(waveh)]
    $c create line 0 $ylow $cWholeWidth $ylow -tags axis
    set yAxisLow [expr $ylow + 2]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)
#    $c create line $v(yaxisw) $v(waveh) $v(yaxisw) $ylow -tags axis -fill $v(fg)
  }

  ;# パワー表示
  if {$v(showpow)} {
    ;# パワーを抽出
    set ytop [expr $v(waveh) + $v(spech)]
    set ylow [expr $ytop     + $v(powh)]
    if {$power(fid) != $v(recLab) || $power(fid) == ""} {
      if {[catch {set power(power) [snd power -framelength $power(frameLength) \
        -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
        -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
        -start 0 -end -1] } ret]} {
          set power(power) {}
      }

      if {[llength $power(power)] > 0} {
        # パワーの最大値・最小値を求める
        set power(powerMax) [lindex $power(power) 0]
        set power(powerMin) [lindex $power(power) 0]
        for {set i 1} {$i < [llength $power(power)]} {incr i} {
          if {$power(powerMax) < [lindex $power(power) $i]} {
            set power(powerMax) [lindex $power(power) $i]
          }
          if {$power(powerMin) > [lindex $power(power) $i]} {
            set power(powerMin) [lindex $power(power) $i]
          }
        }
        if {$power(powerMin) < 0} { set power(powerMin) 0 }
      }
    }

    set pwN [llength $power(power)]
    if {$pwN > 0} {
      # ppd= 1dBあたりのピクセル数。
      if {[expr $power(powerMax) - $power(powerMin)] > 0} {
        set ppd [expr double($v(powh)) / ($power(powerMax) - $power(powerMin))]
      } else {
        set ppd 0
      }

      set pwXold 0
      set pwYold [expr $ylow - ([lindex $power(power) 0] - $power(powerMin)) * $ppd]
      set a [expr $power(frameLength) * $v(wavepps)]
      for {set i 0} {$i < $pwN} {incr i} {
        set pwX [expr $i * $a]
        set pw  [lindex $power(power) $i]
        if {$pw > 0} {
          set pwY [expr $ylow - ($pw - $power(powerMin)) * $ppd]
        } else {
          set pwY $ylow
        }
        $c create line $pwXold $pwYold $pwX $pwY -tags {obj pow} -fill $v(powcolor)
        set pwXold $pwX
        set pwYold $pwY
      }

      # 軸表示
      myAxis $cYaxis 0 $ytop $v(yaxisw) $v(powh) \
        -max $power(powerMax) -tags axis -fill $v(fg) \
        -font $v(sfont) -min $power(powerMin) -unit dB
    }

    $c create line 0 $ylow $cWholeWidth $ylow -tags axis
#    $c create line $v(yaxisw) $ytop $v(yaxisw) $ylow -tags axis -fill $v(fg)
    set yAxisLow [expr $ylow + 2]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)

    ;# パワーを抽出したならそのFIDを記録する
    if {$power(fid) != $v(recLab)} {
      set power(fid) $v(recLab)
    }
  }

  ;# F0表示
  if $v(showf0) {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh)]
    set ylow [expr $ytop + $v(f0h)]
    ;# F0抽出用に波形を正規化する(小声やInt16以外の形式に対応させるため)
    snack::sound sndF0
    sndF0 copy snd
    if {[sndF0 cget -channels] > 1} {
      sndF0 convert -channels Mono
    }
    set amp [expr [sndF0 max] - [sndF0 min]]
    if {$amp > 0} {
      sndF0 filter [snack::filter map [expr 65535.0 / $amp]]
    }
    ;# F0を抽出
    if {$f0(fid) != $v(recLab) || $f0(fid) == ""} {
      set seriestmp {}
      if {[catch {set seriestmp [sndF0 pitch -method $f0(method) \
        -framelength $f0(frameLength) -windowlength $f0(windowLength) \
        -maxpitch $f0(max) -minpitch $f0(min) \
        -progress waitWindow] } ret]} {
        if {$ret != ""} {
          puts "error: $ret"
        }
        set seriestmp {}
      }
      set f0(f0) {}
      foreach s $seriestmp {
        set val [lindex [split $s " "] 0]
        if {$f0(unit) == "semitone" && $val > 0} {
          set val [hz2semitone $val]
        }
        lappend f0(f0) $val
      }

      if {[llength $f0(f0)] > 0} {
        # F0の最大値・最小値を求める
        if {$opt == "all" || $opt == "f0"} {
          set f0(extractedMax) [lindex $f0(f0) 0]
          set f0(extractedMin) [lindex $f0(f0) 0]
          for {set i 1} {$i < [llength $f0(f0)]} {incr i} {
            set f0cand [lindex $f0(f0) $i]
            if {$f0(extractedMax) < $f0cand} {
              set f0(extractedMax) $f0cand
            }
            if {$f0(extractedMin) > $f0cand && $f0cand > 0 || $f0(extractedMin) <= 0} {
              set f0(extractedMin) $f0cand
            }
          }
        }
        # 描画するスケールを決める
        if $f0(fixShowRange) {
          set f0(extractedMax) $f0(showMax)
          set f0(extractedMin) $f0(showMin)
          if {$f0(unit) == "semitone"} {
            if {$f0(extractedMax) > 0} { set f0(extractedMax) [hz2semitone $f0(extractedMax)] }
            if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $f0(extractedMin)] }
          }
#          } else {
#            set f0(extractedMin) $f0(min)  ;# あえてf0(min)にしている
#            if {$f0(unit) == "semitone"} {
#              if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $min] }
#            }
        }
      }
    }

    if {$f0(extractedMax) > $f0(extractedMin) && $f0(extractedMin) >= 0} {
      # ppd= 1Hzあたりのピクセル数。4は上下各2ピクセルのマージン
      set ppd [expr double($v(f0h)) / ($f0(extractedMax) - $f0(extractedMin))]

      # 各音に対応する周波数で横線を引く
      if $f0(showToneLine) {
        for {set i 0} {$i < [llength $sv(sinScale)]} {incr i} {
          if {$f0(unit) == "semitone"} {
            set tgt [hz2semitone [lindex $sv(sinScale) $i]]
          } else {
            set tgt [lindex $sv(sinScale) $i]
          }
          set y1 [expr $ylow - ($tgt - $f0(extractedMin)) * $ppd]
          if {$y1 <= [expr $ylow - $v(f0h)]} break
          if {$y1 < $ylow} {
#            $c create line 0 $y1 $cWholeWidth $y1 -tags axis -fill $v(toneLineColor)
            set tt  [expr $i % 12]
            if {$tt == 1 || $tt == 3 || $tt == 6 || $tt == 8 || $tt == 10} {
              $c create line 0 $y1 $cWholeWidth $y1 -tags axis -fill #50c0f0 -stipple gray50
            } else {
              $c create line 0 $y1 $cWholeWidth $y1 -tags axis -fill #f0c0a0
            }
          }
        }
      }

      # ターゲット線をひく
      if $f0(showTgtLine) {
        if {$f0(unit) == "semitone"} {
          set tgt [hz2semitone $f0(tgtFreq)]
        } else {
          set tgt $f0(tgtFreq)
        }
        set y1 [expr $ylow - ($tgt - $f0(extractedMin)) * $ppd ]
        if {$y1 <= $ylow && $y1 >= [expr $ylow - $v(f0h)]} {
          $c create text [expr 0 + 2] $y1 \
            -text "$f0(tgtTone)$f0(tgtOctave)" -fill $v(tgtf0color) \
            -font smallkfont -anchor w -tags {axis tgtName}
          $c create line [lindex [$c bbox tgtName] 2] $y1 $cWholeWidth $y1 -tags axis \
            -fill $v(tgtf0color)
        }
      }

      # F0データをプロットする
      # set coord {} ;# F0曲線を引く座標(x,y)列
      set f0tags {obj f0}
      for {set i 0} {$i < [llength $f0(f0)]} {incr i} {
        # lappend coord \
        #   [expr $i * $f0(frameLength) * $v(wavepps)] \
        #   [expr $ylow - ([lindex $f0(f0) $i] - $f0(f0Min)) * $ppd]
        if {[lindex $f0(f0) $i] > 0} {
          set x1 [expr $i * $f0(frameLength) * $v(wavepps) - 2]
          set y1 [expr $ylow - ([lindex $f0(f0) $i] - $f0(extractedMin)) * $ppd - 2]
          set x2 [expr $x1 + 3]
          set y2 [expr $y1 + 3]
          $c create oval $x1 $y1 $x2 $y2 -tags $f0tags -fill $v(f0color)
        }
      }
    }
#      eval {$c create line} $coord -tags {$f0tags} -fill $v(f0color)
    # 軸表示
    myAxis $cYaxis 0 $ytop $v(yaxisw) $v(f0h) \
      -tags axis -fill $v(fg) -font $v(sfont) \
      -max $f0(extractedMax) -min $f0(extractedMin) -unit $f0(unit)

    # 下線
    $c create line 0 $ylow $cWholeWidth $ylow -tags axis
#    $c create line $v(yaxisw) $ytop $v(yaxisw) $ylow -tags axis -fill $v(fg)
    set yAxisLow [expr $ylow + 2]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)

    ;# F0を抽出したならFIDを記録する
    if {$f0(fid) != $v(recLab)} {
      set f0(fid) $v(recLab)
    }
  }

  ;# 時間軸表示
  if {$v(showWave) || $v(showSpec) || $v(showpow) || $v(showf0)} {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]
    set ylow [expr $ytop + $v(timeh)]
    if {$v(timeUnit) == "Sec."} {
      ;# 時間軸(単位=秒)
      snack::timeAxis $c 0 $ytop $cWholeWidth $v(timeh) $v(wavepps) \
        -tags axis -starttime 0 -fill $v(fg)
      $c create line 0 $ylow $cWholeWidth $ylow -tags axis
    } else {
      # 小節単位の時間軸表示
      set b  0               ;# 現在の拍を入れる[単位=拍]
      set bp [beat2pixel $b] ;# 現在の拍を入れる[単位=pixel]
      set hbp  [expr [beat2pixel 0.5]  - [beat2pixel 0]] ;# 8分音符の長さ[単位=pixel]
      set hhbp [expr [beat2pixel 0.25] - [beat2pixel 0]] ;# 16分音符半拍の長さ[単位=pixel]
      set vlbtmShrt [expr $ytop + $v(timeh) / 4]
      set vlbtm     [expr $ytop + $v(timeh) / 2]
      while {$bp < $cWholeWidth} {
        if {$b % 4 == 0} {
          $c create line $bp 0 $bp $vlbtm     -tags axis -fill #909090
          $c create text $bp $vlbtm -text [expr $b / 4]  -tags axis -fill $v(fg) \
            -font $v(sfont) -anchor center
        } else {
          $c create line $bp 0 $bp $vlbtm     -tags axis -fill #b0b0b0
        }
        if {$hbp >= 25} {
          set bph [expr $bp + $hbp]
          $c create line $bph $ytop $bph $vlbtmShrt -tags axis -fill blue
        }
        if {$hhbp >= 25} {
          set bphh [expr $bp + $hhbp]
          $c create line $bphh $ytop $bphh $vlbtmShrt -tags axis -fill #a000a0
          set bphh [expr $bp + $hhbp + $hbp]
          $c create line $bphh $ytop $bphh $vlbtmShrt -tags axis -fill #a000a0
        }

        incr b
        set bp [beat2pixel $b]
      }
      incr y $v(timeh)
      $c create line 0 $ytop $cWholeWidth $ytop -tags axis -fill $v(fg)
      $c raise param
    }

    ;# 時間軸ラベル
    $cYaxis create text 2 $ytop -text $v(timeUnit) \
      -font $v(sfont) -anchor nw -tags axis -fill $v(fg)
  }

  ;# UTAU原音パラメータ表示
  RedrawParam

  ;# grabを解放
  ;#  grab release $c
}

#---------------------------------------------------
# パラメータ名の表示位置を求める
#
proc setParamNameY {} {
  global v c cYaxis power f0 paramS rec t

  set mid [expr $v(waveh) / 2]
  set kankaku [expr ($mid - $v(fontSize)) / 3]
  set v(pSy) $v(fontSize)
  set v(pOy) [expr $v(fontSize) + $kankaku]
  set v(pPy) [expr $v(fontSize) + $kankaku * 2]
  set v(pCy) $mid
  set v(pEy) $v(fontSize)
}

#---------------------------------------------------
# UTAU原音パラメータを描画する
#
proc initDrawParam {} {
  global v c cParamID t

  array unset cParamID

  ;# 左ブランク
  set cParamID(Srect) [$c create rectangle -100 -100 -100 -100 -tags param -fill #A0FFA0 -stipple gray50]
  set cParamID(Sline) [$c create line      -100 -100 -100 -100 -tags {param Sl} -fill #600060]
  set cParamID(Stri)  [$c create polygon   -100 -100 -100 -100 -tags param -fill #00A000]
  set cParamID(Stext) [$c create text -100 -100 -text $t(Redraw,S) -fill #600060 \
    -tags {param Sl} -anchor s -font smallkfont]

  ;# 右ブランク
  set cParamID(Erect) [$c create rectangle -100 -100 -100 -100 -tags param -fill #FFFFA0 -stipple gray25]
  set cParamID(Eline) [$c create line      -100 -100 -100 -100 -tags {param El} -fill #000060]
  set cParamID(Etext) [$c create text -100 -100 -text $t(Redraw,E) -fill #000060 \
    -tags {param El} -anchor s -font smallkfont]

  ;# オーバーラップ
  set cParamID(Oline) [$c create line -100 -100 -100 -100 -tags {param Ol} -fill #00CF00]
  set cParamID(Otext) [$c create text -100 -100 -text $t(Redraw,O) -fill #00CF00 \
    -tags {param Ol} -anchor s -font smallkfont]

  ;# 先行発声
  set cParamID(Pline) [$c create line    -100 -100 -100 -100 -tags {param Pl} -fill red]
  set cParamID(Ptri)  [$c create polygon -100 -100 -100 -100 -tags {param Pl} -fill red]
  set cParamID(Ptext) [$c create text -100 -100 -text $t(Redraw,P) -fill red \
    -tags {param Pl} -anchor s -font smallkfont]

  ;# 子音部
  set cParamID(Crect) [$c create rectangle -100 -100 -100 -100 -tags param -fill #8080FF -stipple gray25]
  set cParamID(Cline) [$c create line      -100 -100 -100 -100 -tags {param Cl} -fill #8080FF]
  set cParamID(Ctext) [$c create text -100 -100 -text $t(Redraw,C) -fill #8080FF \
    -tags {param Cl} -anchor s -font smallkfont]
}

#---------------------------------------------------
# UTAU原音パラメータを描画する
#
proc RedrawParam {} {
  global v c cYaxis cParamID power f0 paramS rec t

  # $c delete param

  set cWholeWidth [expr int($v(sndLength) * $v(wavepps))]
  setParamNameY

  if {$v(sndLength) <= 0} return

  ;# UTAU原音パラメータ表示
  set ytop [expr $v(waveh) / 2]
  set ylow [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]
  set ls $v(listSeq)
  ;# 左ブランク
  set pSx 0
  if {[array get paramS "$ls,S"] != "" && $paramS($ls,S) != "_UNSET_"} {
    set pSx [expr $v(wavepps) * $paramS($ls,S)]
    $c coords $cParamID(Srect) 0 0 $pSx $ylow
    if {$v(setS) == 0} {
      $c coords $cParamID(Stri) [expr $pSx - 5] 0 [expr $pSx + 5] 0 $pSx 10
    } else {
      $c coords $cParamID(Stri) $pSx 0 $pSx 0 $pSx 0
    }
    $c coords $cParamID(Sline) $pSx 0 $pSx $ylow
    $c coords $cParamID(Stext) $pSx $v(pSy)
  } elseif {[array names cParamID Sline] != ""} {
    $c coords $cParamID(Srect) -100 -100 -100 -100
    $c coords $cParamID(Stri)  -100 -100 -100 -100
    $c coords $cParamID(Sline) -100 -100 -100 -100
    $c coords $cParamID(Stext) -100 -100
  }
  ;# 右ブランク
  set pEx $cWholeWidth
  if {[array get paramS "$ls,E"] != "" && $paramS($ls,E) != "_UNSET_"} {
    set pEx [expr $v(wavepps) * $paramS($ls,E)]
    $c coords $cParamID(Erect) $cWholeWidth 0 $pEx $ylow
    $c coords $cParamID(Eline) $pEx 0 $pEx $ylow
    $c coords $cParamID(Etext) $pEx $v(pEy)
  } elseif {[array names cParamID Eline] != ""} {
      $c coords $cParamID(Erect) -100 -100 -100 -100
      $c coords $cParamID(Eline) -100 -100 -100 -100
      $c coords $cParamID(Etext) -100 -100
  }
  ;# オーバーラップ
  set pOx 0
  if {[array get paramS "$ls,O"] != "" && $paramS($ls,O) != "_UNSET_"} {
    set pOx [expr $v(wavepps) * $paramS($ls,O)]
    $c coords $cParamID(Oline) $pOx $v(pOy) $pOx $ylow
    $c coords $cParamID(Otext) $pOx $v(pOy)
  } elseif {[array names cParamID Oline] != ""} {
    $c coords $cParamID(Oline) -100 -100 -100 -100
    $c coords $cParamID(Otext) -100 -100
  }
  ;# 先行発声
  set pPx 0
  if {[array get paramS "$ls,P"] != "" && $paramS($ls,P) != "_UNSET_"} {
    set pPx [expr $v(wavepps) * $paramS($ls,P)]
    $c coords $cParamID(Pline) $pPx $v(pPy) $pPx $ylow
    $c coords $cParamID(Ptext) $pPx $v(pPy)
    if {$v(setP) == 0} {
      $c coords $cParamID(Ptri) [expr $pPx - 5] 0 [expr $pPx + 5] 0 $pPx 10
    } else {
      $c coords $cParamID(Ptri) $pPx 0 $pPx 0 $pPx 0
    }
  } elseif {[array names cParamID Pline] != ""} {
    $c coords $cParamID(Pline) -100 -100 -100 -100
    $c coords $cParamID(Ptext) -100 -100
    $c coords $cParamID(Ptri)  -100 -100 -100 -100
  }
  ;# 子音部
  set pCx 0
  if {[array get paramS "$ls,C"] != "" && $paramS($ls,C) != "_UNSET_"} {
    set pCx [expr $v(wavepps) * $paramS($ls,C)]
    $c coords $cParamID(Crect) $pSx $v(pCy) $pCx $v(waveh)
    $c coords $cParamID(Cline) $pCx $v(pCy) $pCx $ylow
    $c coords $cParamID(Ctext) $pCx $v(pCy)
  } elseif {[array names cParamID Cline] != ""} {
    $c coords $cParamID(Crect) -100 -100 -100 -100 
    $c coords $cParamID(Cline) -100 -100 -100 -100 
    $c coords $cParamID(Ctext) -100 -100
  }
}

#---------------------------------------------------
# マウスx座標が波形の何μsecの所に相当するかを返す
#
proc point2micro {x} {
  global v t
  ;# ↓精度を小数点以下3桁までにする(44.1kHzのとき1sampleは0.000023秒)
  return [ \
    expr int(1000000 * $v(sndLength) * ($x - [winfo width .s]) / double($v(cWidth))) \
  ]
}

#---------------------------------------------------
# マウスx座標が波形の何secの所に相当するかを返す
#
proc point2sec {x} {
  global v t wscrl

  set cLeft  [lindex [$wscrl get] 0]
  set cLeftPoint [expr $v(sndLength) * $cLeft * $v(wavepps)]

  return [ expr double($cLeftPoint + $x) / double($v(wavepps)) ]
}

#---------------------------------------------------
# 実数を小数点以下6桁で打ち切る
#
proc cut6 {val} {
  return [expr int($val * 1000000) / 1000000.0 ]
}

#---------------------------------------------------
# 実数を小数点以下3桁で打ち切る
#
proc cut3 {val} {
  return [expr int($val * 1000) / 1000.0 ]
}

#---------------------------------------------------
# paramSのパラメータ種類名をparamU列番号に変換
#
proc kind2c {k} {
  switch $k {
    ;# A       6
    ;# fid     0
    ;#         R
    ;#         7
    S { return 1 }
    O { return 2 }
    P { return 3 }
    C { return 4 }
    E { return 5 }
    default { return ""}
  }
}

#---------------------------------------------------
# paramUの列番号をparamSのパラメータ種類名に変換
#
proc c2kind {c} {
  switch $c {
    1 { return S }
    2 { return O }
    3 { return P }
    4 { return C }
    5 { return E }
    default { return ""}
  }
    ;# 0       fid
    ;# 6       A
    ;# 7
    ;# R
}

#---------------------------------------------------
# 指定した行のparamUをparamSに変換する
# 波形長が$v(sndLength)に入っていることが前提
#
proc paramU2paramS {r} {
  global paramU paramS t

  for {set c 1} {$c < 6} {incr c} {
    set kindTmp [c2kind $c]
    if {[array names paramU "$r,$c"] != ""} {
      set paramS($r,$kindTmp) [u2sec $kindTmp $r $c]
    }
  }
}

#---------------------------------------------------
# 指定した行のparamSをparamUに変換する
#
proc paramS2paramU {{r -1}} {
  global paramU paramS v t

  if {$r < 0} {set r $v(listSeq)}
  for {set c 1} {$c < 6} {incr c} {
    set kind [c2kind $c]
    if {[array names paramS "$r,$kind"] != ""} {
      set paramU($r,$c) [sec2u $r $kind $paramS($r,$kind)]
    }
  }
}

#---------------------------------------------------
# マウスで原音パラメータを指定する
# 引数：kind         : パラメータの種類
#       x            : マウスのx座標、
#       changeOtherS : 1= S位置を変更した際に同じwavファイルの
#                         他の音のパラメータ位置も移動させる
#       changeOtherP : 1= P位置を変更した際に同じwavファイルの
#                         他の音のパラメータ位置も移動させる
#
proc setParam {kind x {changeOtherS 0} {changeOtherP 0}} {
  global v paramU paramUsize paramS t

  if {$paramUsize <= 0} return
  set ls $v(listSeq)
  set sec [point2sec $x]
  if {$sec > $v(sndLength)} {
    set sec $v(sndLength)
  }
  if {$kind != "O" && $sec < 0} {
    set sec 0
  }
  if {$kind == "S" && $v(setS) == 0} {
    ;# 設定対象がSであり、かつ他のパラメータの数値を変えない(場所は変わる)ようにする場合

    ;# 旧Sとの差を求める
    set c [kind2c $kind]
    if {[array names paramU "$ls,$c"] != ""} {
      set old $paramU($ls,$c)
    } else {
      set old 0.0
    }
    ;# パラメータ値を更新する
    if {[array names paramS "$ls,S"] != "" } {
      if {[array names paramS "$ls,E"] != "" } {
        set ES [expr $paramS($ls,E) - $paramS($ls,S)]
        ;# Eがファイル末尾より右に行かないようにする
        if {[expr $sec + $ES] > $v(sndLength)} {
          set sec [expr $v(sndLength) - $ES]
        }
      }

      set paramU($ls,$c) [sec2u $ls $kind $sec]

      # Eが正の値の場合
      set cE [kind2c E]
      if {[array names paramU "$ls,$cE"] != "" && $paramU($ls,$cE) >= 0} {
       # set paramU($ls,$cE) [sec2u $ls "E" [expr $sec + $ES]]
        set diff [expr $paramU($ls,$c) - $old]
        set paramU($ls,$cE) [cut3 [expr $paramU($ls,$cE) - $diff + double(0.0005)]]
        #set paramU($i,$c) [cut3 [expr double($paramU($i,$c) + $diff) - double(0.0005)]]
      }

      ;# 次に他のパラメータをUTAU形式から時刻に変換
      paramU2paramS $ls
    } else {
      ;# Sを初めて指定する場合は既に指定済みのパラメータ位置を移動しないようにする
      set paramS($ls,S) $sec
      paramS2paramU $ls
    }

    ;# 同wavファイルの他の音についても場所を移動させる場合
    if $changeOtherS {
      set diff [expr $paramU($ls,$c) - $old]
      _changeOtherS $ls $c $diff
    }

  } elseif {$kind == "P" && $v(setP) == 0} {
    ;# 設定対象がPであり、かつ他のパラメータの数値を変えてPとの相対的な位置関係が
    ;# 変わらないようにする場合

    ;# 旧Pとの差を求める
    set cP [kind2c $kind]
    if {[array names paramU "$ls,$cP"] != ""} {
      set old $paramU($ls,$cP)
      set newPtmp [sec2u $ls $kind $sec]
      if {$newPtmp >= $old} {
        set diff [cut3 [expr double($newPtmp - $old) + double(0.0005)]]
      } else {
        set diff [cut3 [expr double($newPtmp - $old) - double(0.0005)]]
      }
    } else {
      set paramU($ls,$cP) [sec2u $ls $kind $sec]
      set diff 0
    }

    ;# Sをずらす
    set c [kind2c S]
    set oldS 0.0
    if {[array names paramU "$ls,$c"] != ""} { set oldS $paramU($ls,$c) }
    set cE [kind2c E]
    set oldE 0.0
    if {[array names paramU "$ls,$cE"] != ""} { set oldE $paramU($ls,$cE) }
    ;# Eがファイル末尾より右に行かないようにする
    if {[array names paramS "$ls,E"] != "" &&
          [expr $paramS($ls,E) + $diff / 1000.0] > $v(sndLength)} {
      set sec [expr $v(sndLength) + $paramS($ls,S) - $paramS($ls,E)]
      set paramU($ls,$c) [sec2u $ls S $sec]
      if {$oldE >= 0} {
        set paramU($ls,$cE) 0   ;# Eが正の値の場合
      }
    } else {
      ;# Sがファイル先頭より左に行かないようにする
      if {[expr $oldS + $diff] >= 0} {
        set paramU($ls,$c) [cut3 [expr $oldS + $diff]]
        if {[array names paramS "$ls,E"] != "" && $oldE >= 0} {
          set paramU($ls,$cE) [cut3 [expr $oldE - $diff]]   ;# Eが正の値の場合
        }
      } else {
        set paramU($ls,$c) 0
        if {[array names paramS "$ls,E"] != "" && $oldE >= 0} {
          set paramU($ls,$cE) [cut3 [expr $oldE + $oldS]]   ;# Eが正の値の場合
        }
      }
    }

    ;# 他のパラメータをUTAU形式から時刻に変換
    paramU2paramS $ls

    ;# 同wavファイルの他の音についても場所を移動させる場合
    if $changeOtherP { _changeOtherS $ls $c $diff }
  } else {
    set paramS($ls,$kind) $sec

    ;# 設定する対象がS以外の場合、または
    ;# Sを変更しても他の位置をずらさない設定の場合の処理

    ;# Sを変えたとき
    if {$kind == "S" && [array get paramS "$ls,S"] != ""} {
      if {$paramS($ls,S) < 0} {
        ;# Sがファイル先頭より左に行かないようにする
        set paramS($ls,S) 0
      } else {
        if {$v(blankBroom)} {
          ;# Sが他のパラメータ(OはminusOの設定次第で対象外とする)より右に行ったときは他パラメータもずらす
          foreach ktmp {C E P} {
            if {[array get paramS "$ls,$ktmp"] != "" && $paramS($ls,S) > $paramS($ls,$ktmp)} {
              set paramS($ls,$ktmp)  $paramS($ls,S)
            }
          }
          if {$v(minusO) == 0 && [array get paramS "$ls,O"] != "" && $paramS($ls,S) > $paramS($ls,O)} {
            set paramS($ls,O)  $paramS($ls,S)  ;# Oは負の値にならないモードならずらす
          }
        } else {
          ;# Sが他のパラメータ(Oを除く)より右に行かないようにする
          foreach ktmp {C E P} {
            if {[array get paramS "$ls,$ktmp"] != "" && $paramS($ls,S) > $paramS($ls,$ktmp)} {
              set paramS($ls,S)  $paramS($ls,$ktmp)
            }
          }
          if {$v(minusO) == 0 && [array get paramS "$ls,O"] != "" && $paramS($ls,S) > $paramS($ls,O)} {
            set paramS($ls,S)  $paramS($ls,O)
          }
        }
      }
    ;# Eを変えたとき
    } elseif {$kind == "E" && [array get paramS "$ls,E"] != ""} {
      if {$paramS($ls,E) > $v(sndLength)} {
        ;# Eがファイル末尾より右に行かないようにする
        set paramS($ls,E)  $v(sndLength)
      } else {
        foreach ktmp {S C P O} {
          if {[array get paramS "$ls,$ktmp"] != "" && $paramS($ls,E) < $paramS($ls,$ktmp)} {
            if {$v(blankBroom)} {
              ;# Eが他のパラメータより左に行ったときは他パラメータもずらす
              set paramS($ls,$ktmp)  $paramS($ls,E)
            } else {
              ;# Eが他のパラメータより左に行かないようにする
              set paramS($ls,E)  $paramS($ls,$ktmp)
            }
          }
        }
      }
    ;# Oを変えたとき
    } elseif {$kind == "O" && [array get paramS "$ls,O"] != ""} {
      if {$v(minusO) == 0 && [array get paramS "$ls,S"] != "" && $paramS($ls,O) < $paramS($ls,S)} {
        set paramS($ls,O) $paramS($ls,S)
      } elseif {[array get paramS "$ls,C"] != "" && $paramS($ls,O) > $paramS($ls,C)} {
        ;# パラメータがCより右に行かないようにする
        set paramS($ls,O) $paramS($ls,C)
      } elseif {[array get paramS "$ls,E"] != "" && $paramS($ls,O) > $paramS($ls,E)} {
        ;# パラメータがEより右に行かないようにする
        set paramS($ls,O) $paramS($ls,E)
      } else {
        if {$paramS($ls,$kind) > $v(sndLength)} {
          ;# パラメータがファイル末尾より右に行かないようにする
          set paramS($ls,$kind)  $v(sndLength)
        }
      }
    ;# Pを変えたとき
    } elseif {$kind == "P" && [array get paramS "$ls,$kind"] != ""} {
      if {$paramS($ls,$kind) < 0} {
        ;# パラメータがファイル先頭より左に行かないようにする
        set paramS($ls,$kind) 0
      } elseif {[array get paramS "$ls,S"] != "" && $paramS($ls,$kind) < $paramS($ls,S)} {
        ;# パラメータがSより左に行かないようにする
        set paramS($ls,$kind) $paramS($ls,S)
      } elseif {[array get paramS "$ls,C"] != "" && $paramS($ls,$kind) > $paramS($ls,C)} {
        ;# パラメータがCより右に行かないようにする
        set paramS($ls,$kind) $paramS($ls,C)
      } elseif {[array get paramS "$ls,E"] != "" && $paramS($ls,$kind) > $paramS($ls,E)} {
        ;# パラメータがEより右に行かないようにする
        set paramS($ls,$kind) $paramS($ls,E)
      } else {
        if {$paramS($ls,$kind) > $v(sndLength)} {
          ;# パラメータがファイル末尾より右に行かないようにする
          set paramS($ls,$kind)  $v(sndLength)
        }
      }
    ;# Cを変えたとき
    } elseif {$kind == "C" && [array get paramS "$ls,$kind"] != ""} {
      if {$paramS($ls,$kind) < 0} {
        ;# パラメータがファイル先頭より左に行かないようにする
        set paramS($ls,$kind) 0
      } else {
        ;# Cが他のパラメータより左に行かないようにする
        foreach ktmp {S P O} {
          if {[array get paramS "$ls,$ktmp"] != "" &&
              $paramS($ls,C) < $paramS($ls,$ktmp)} {
            set paramS($ls,C)  $paramS($ls,$ktmp)
          }
        }

        if {[array get paramS "$ls,E"] != "" && $paramS($ls,$kind) > $paramS($ls,E)} {
          ;# パラメータがEより右に行かないようにする
          set paramS($ls,$kind) $paramS($ls,E)
        } else {
          if {$paramS($ls,$kind) > $v(sndLength)} {
            ;# パラメータがファイル末尾より右に行かないようにする
            set paramS($ls,$kind)  $v(sndLength)
          }
        }
      }
    }

    # Uに転写
    paramS2paramU $ls
  }

  set v(paramChanged) 1
  setEPWTitle
  RedrawParam
}

#---------------------------------------------------
# alt-F1,alt-F3の際に変更する行の範囲を返す
#
proc changeRangeForAltF {ls} {
  global paramU paramUsize

  set fname $paramU($ls,0)
  set ls1 $ls
  for {set r $ls} {$r >= 1 && $fname == $paramU($r,0)} {incr r -1} {
    set ls1 $r
  }
  set ls2 $ls
  for {set r $ls} {$r < $paramUsize && $fname == $paramU($r,0)} {incr r} {
    set ls2 $r
  }
  return [list $ls1 $ls2]
}

#---------------------------------------------------
# alt-F1,alt-F3を押し、SやPの変更に連動して同wavの他のSやPをずらすときの処理
# ls,c = 直接変更した行,列。diff = 変更量
# 変更した行の範囲を返す
#
proc _changeOtherS {ls c diff} {
  global paramU paramUsize

  set lsList [changeRangeForAltF $ls]
  set ls1 [lindex $lsList 0]
  set ls2 [lindex $lsList 1]

  set cE [kind2c E]
  for {set i $ls1} {$i <= $ls2} {incr i} {
    if {$i == $ls} continue
    if {[array names paramU "$i,$c"] != ""} {
      if {[expr $paramU($i,$c) + $diff] >= 0} {
        set paramU($i,$c) [cut3 [expr double($paramU($i,$c) + $diff) + double(0.0005)]]
        if {[array names paramU "$i,$cE"] != ""} {
          if {$paramU($i,$cE) >= 0} {
            set newVal [cut3 [expr $paramU($i,$cE) - $diff + double(0.0005)]]
            if {$newVal < 0} { set newVal 0 }
            set paramU($i,$cE) $newVal
          }
        }

      } else {
        set paramU($i,$c) [cut3 [expr double($paramU($i,$c) + $diff) - double(0.0005)]]
        if {[array names paramU "$i,$cE"] != ""} {
          if {$paramU($i,$cE) >= 0} {
            set newVal [cut3 [expr $paramU($i,$cE) - $diff - double(0.0005)]]
            if {$newVal < 0} { set newVal 0 }
            set paramU($i,$cE) $newVal
          }
        }
      }
      paramU2paramS $i
    }
  }
}

#---------------------------------------------------
# ファイルを保存して終了
#
proc Exit {} {
  global v t startup ustData
  if $v(paramChanged) {
    if {[array names ustData "pluginMode"] != ""} {
      # プラグインモードのとき
      set act [tk_dialog .confm $t(.confm) $t(Exit,q1) \
        question 2 $t(Exit,a1) $t(Exit,a2) $t(Exit,a3)]
      switch $act {
        0 {                      ;# 上書き保存して終了する場合
            if ![saveParamFile $v(paramFile)] {
              return  ;# もしここで保存しなかったら終了中止。
            }
            utaup_updateTargetParamFile  ;# 設定内容を元oto.iniに反映する
          }
        1 { }                    ;# 保存せず終了する場合
        2 { return }             ;# 終了しない場合
      }
    } else {
      # 通常(非プラグインモード)のとき
      set act [tk_dialog .confm $t(.confm) $t(Exit,q1) \
        question 3 $t(Exit,a1) $t(Exit,a1b) $t(Exit,a2) $t(Exit,a3)]
      switch $act {
        0 {                      ;# 上書き保存して終了する場合
            if ![saveParamFile $v(paramFile)] {
              return  ;# もしここで保存しなかったら終了中止。
            }
          }
        1 {                      ;# 名前を付けて保存して終了する場合
            if ![saveParamFile] {
              return  ;# もしここで保存しなかったら終了中止。
            }
          }
        2 { }                    ;# 保存せず終了する場合
        3 { return }             ;# 終了しない場合
      }
    }
  }

  saveSysIniFile               ;# iniファイルを保存する
  stopAutoBackup               ;# バックアップファイルを削除する
  if {$v(autoSaveInitFile)} {
    saveSettings $startup(initFile)
  }
  destroy .
  exit
}

#↓ver.2.0-b130130で有効にしたがエラーの原因になっていそうだったので無効にした。
# proc exit {} {Exit}

#---------------------------------------------------
# メニューの初期化
#
proc setRclickMenuA {} {
  global v plugin t rclickMenuA
  $rclickMenuA delete 0 end
  set editOld ""
  set seq 0
  for {set i 0} {$i < $plugin(N)} {incr i} {
    if {$plugin($i,edit) != "all"} {
      if {$editOld != "" && $editOld != $plugin($i,edit)} {
        $rclickMenuA add separator
      }
      set name    $plugin($i,name)
      $rclickMenuA add command -label "$seq: $name" -command "runPlugin $i 1"
      set editOld $plugin($i,edit)
      incr seq
    }
  }
}

#---------------------------------------------------
# メニューの初期化
#
proc setRclickMenuS {} {
  global v t rclickMenuS
  $rclickMenuS delete 0 end
  $rclickMenuS add radiobutton -label $t(option,S,1) -variable v(setS) -value 0 -command {RedrawParam}
  $rclickMenuS add radiobutton -label $t(option,S,2) -variable v(setS) -value 1 -command {RedrawParam}
}

#---------------------------------------------------
# メニューの初期化
#
proc setRclickMenuP {} {
  global v t rclickMenuP
  $rclickMenuP delete 0 end
  $rclickMenuP add radiobutton -label $t(option,P,1) -variable v(setP) -value 0 -command {RedrawParam}
  $rclickMenuP add radiobutton -label $t(option,P,2) -variable v(setP) -value 1 -command {RedrawParam}
}

#---------------------------------------------------
# 右クリックメニュー
#
proc PopUpMenu {X Y x y} {
  global v rclickMenu rclickMenuZ rclickMenuS rclickMenuP rclickMenuA ustData t

  $rclickMenu delete 0 end
  $rclickMenu add cascade -label $t(PopUpMenu,zoomTitle) -menu $rclickMenuZ
  $rclickMenu add cascade -label $t(option,S) -menu $rclickMenuS
  $rclickMenu add cascade -label $t(option,P) -menu $rclickMenuP
  $rclickMenu add separator
  $rclickMenu add checkbutton -variable v(showWave) \
    -label $t(PopUpMenu,showWave) -command toggleWave
  $rclickMenu add checkbutton -variable v(showSpec) \
    -label $t(PopUpMenu,showSpec) -command toggleSpec
  $rclickMenu add checkbutton -variable v(showpow) \
    -label $t(PopUpMenu,showPow) -command togglePow
  $rclickMenu add checkbutton -variable v(showf0) \
    -label $t(PopUpMenu,showF0) -command toggleF0
  $rclickMenu add separator
  $rclickMenu add checkbutton -label $t(PopUpMenu,alwaysOnTop) -variable v(alwaysOnTop) -command {
    if {$v(alwaysOnTop)} {
      wm attributes .           -topmost 1
      wm attributes .entpwindow -topmost 1
    } else {
      wm attributes .           -topmost 0
      wm attributes .entpwindow -topmost 0
    }
  }
  $rclickMenu add command -label $t(PopUpMenu,setAlpha) -command setAlphaWindow

#  $rclickMenu add separator
#  $rclickMenu add command -label $t(PopUpMenu,pitchGuide) -command pitchGuide
#  $rclickMenu add command -label $t(PopUpMenu,tempoGuide) -command tempoGuide
  $rclickMenu add separator
  if {[array names ustData "pluginMode"] == ""} {
    $rclickMenu add command -label $t(edit,estimateParam)   -command estimateParam
  }
  $rclickMenu add command -label $t(edit,zeroCross)       -command zeroCross
  $rclickMenu add command -label $t(PopUpMenu,settings)   -command settings
  if {[array names ustData "pluginMode"] == ""} {
    $rclickMenu add separator
    $rclickMenu add cascade -label $t(tool,auto,plugin) -menu $rclickMenuA
  }

  $rclickMenuZ delete 0 end
  $rclickMenuZ add command -label $t(PopUpMenu,zoom0)     -command {zoomX 0     $x}
  $rclickMenuZ add command -label $t(PopUpMenu,zoom100)   -command {zoomX 100   $x}
  $rclickMenuZ add command -label $t(PopUpMenu,zoom1000)  -command {zoomX 1000  $x}
  $rclickMenuZ add command -label $t(PopUpMenu,zoom5000)  -command {zoomX 5000  $x}
  $rclickMenuZ add command -label $t(PopUpMenu,zoom10000) -command {zoomX 10000 $x}
  $rclickMenuZ add command -label $t(PopUpMenu,zoomMax)   -command {zoomX -1    $x}
  $rclickMenuZ add command -label $t(PopUpMenu,changeZoomX) -command {changeZoomX}

  catch {tk_popup $rclickMenu $X $Y}
}

#---------------------------------------------------
# 右クリックメニュー（一覧表用）
#
proc setPopUpMenuTable {} {
  global v rclickMenuTable rclickMenuExcel rclickMenuA ustData t

  $rclickMenuTable delete 0 end

  $rclickMenuTable add command -label $t(edit,tk_tableCopy) \
                               -command {copyCell  .entpwindow.t ","}
  $rclickMenuTable add command -label $t(edit,pasteCell) \
                               -command {pasteCell .entpwindow.t ","}

  $rclickMenuTable add cascade -label $t(edit,copyWithSpace) -menu $rclickMenuExcel
  $rclickMenuExcel delete 0 end
  $rclickMenuExcel add command -label $t(edit,copyCellWithSpace) \
                               -command {copyCell .entpwindow.t " "}
  $rclickMenuExcel add command -label $t(edit,pasteCellWithSpace) \
                               -command {pasteCell .entpwindow.t " "}
  $rclickMenuTable add separator
  $rclickMenuTable add command -label $t(edit,duplicateEntp) \
                               -command {duplicateEntp .entpwindow.t 1}
  $rclickMenuTable add command -label $t(edit,deleteEntp) \
                               -command {deleteEntp .entpwindow.t 1}

  $rclickMenuTable add separator
  $rclickMenuTable add command -label $t(edit,searchParam) \
                               -command searchParam
  $rclickMenuTable add command -label $t(edit,doSearchParam1) \
                               -command {doSearchParam 1}
  $rclickMenuTable add command -label $t(edit,doSearchParam0) \
                               -command {doSearchParam 0}
  $rclickMenuTable add separator
  $rclickMenuTable add command -label $t(edit,changeCell) \
                               -command changeCell
  $rclickMenuTable add command -label $t(tool,changeAlias) \
                               -command changeAlias
  if {[array names ustData "pluginMode"] == ""} {
    $rclickMenuTable add command -label $t(edit,estimateParam) \
                                 -command estimateParam
  }
  $rclickMenuTable add command -label $t(edit,zeroCross) \
                               -command zeroCross
  if {[array names ustData "pluginMode"] == ""} {
    $rclickMenuTable add separator
    $rclickMenuTable add cascade -label $t(tool,auto,plugin) -menu $rclickMenuA
  }
}

#---------------------------------------------------
# バージョン情報表示
#
proc Version {} {
  global v sv t
  tk_messageBox -title $t(Version,msg) \
    -message "$sv(appname) version $sv(version)"
}

#---------------------------------------------------
# リストボックスウィジット w を d だけスクロールさせる(Windows版)
# +/-120 は Windows でホイールを1つ動かした際に%Dにセットされる値
#
proc listboxScroll {w d} {
  if {$w ne ""} {
    $w yview scroll [expr -$d / 120] units
  }
}

#---------------------------------------------------
# 単位変換
#
proc sec2samp {sec length} {
  if {[string length $sec] == 0 || [string length $length] == 0} {
    return 0
  }
  if {[string is double $sec] && [string is double $length]} {
    return [expr int(double($sec) / $length)]
  } else {
    return -1
  }
}

#---------------------------------------------------
# 単位変換(秒→UTAU原音パラメータ)
#
proc sec2u {r kind newVal} {  ;# r=-1:アクティブセルを変換。
  global paramS paramU snd v t

  if {$r < 0} {set r $v(listSeq)}  ;# 現在のアクティブセルの行番号

  if {[llength $newVal] == 0} {
    set newVal $paramS($r,$kind)   ;# 変換したい値(秒単位)を決定。
  }

  set fid $paramU($r,0)
  set fname $v(saveDir)/$fid.$v(ext)
  if {[snd cget -load] != $fname && [file readable $fname]} {
    if [catch {snd read $fname}] {
      set v(sndLength) 0
    } else {
      if {[snd cget -channels] != 1} {
        snd convert -channels Mono
      }
      set v(sndLength) [snd length -unit SECONDS]
    }
  }
  if {[array names paramS "$r,S"] != ""} {
    set S $paramS($r,S)
  } else {
    set S 0
  }
  switch $kind {
    S { return   [cut3 [expr double($newVal) * 1000.0] ] }
    E { if {$v(setE) < 0 } {
          return [cut3 [expr - ($newVal - $S) * 1000.0] ]
        } else {
          return [cut3 [expr $v(sndLength) * 1000.0 - $newVal * 1000.0]] 
        }
      }
    C -
    P -
    O { return [cut3 [expr ($newVal - $S) * 1000] ]}
  }
}

#---------------------------------------------------
# 単位変換(UTAU原音パラメータ→秒)
# snd に波形を読んでいることが前提
#
proc u2sec {kind r c} {
  global paramS paramU t v
  if {[array names paramS "$r,S"] != ""} {
    set S $paramS($r,S)
  } else {
    set S 0
  }
  if {$paramU($r,$c) != ""} {
    set u $paramU($r,$c)
  } else {
    set u 0
  }
  switch $kind {
    S { return [cut6 [expr $u / 1000.0]] }
    C -
    P -
    O { return [cut6 [expr $u / 1000.0 + $S]] }
    E { if {$u >= 0} {
          return [cut6 [expr $v(sndLength) - $u / 1000.0]] 
        } else {
          return [cut6 [expr $u / -1000.0 + $S]]
        }
      }
  }
}

#---------------------------------------------------
# 原音パラメータ値の初期化
#
proc initParamS {} {
  global paramS v t

  array unset paramS
}

#---------------------------------------------------
# ParamUを初期化
#
proc initParamU {{clean 0} {recList {}}} {
  global paramU v sv paramUsize t

  if {[llength $recList] <= 0} {
    set recList $v(recList)
  }

  array unset paramU
  set paramU(0,0) $t(initParamU,0)
  set paramU(0,1) $t(initParamU,1)
  set paramU(0,2) $t(initParamU,2)
  set paramU(0,3) $t(initParamU,3)
  set paramU(0,4) $t(initParamU,4)
  set paramU(0,5) $t(initParamU,5)
  set paramU(0,6) $t(initParamU,6)
  set paramU(0,7) $t(initParamU,7)
  set paramUsize 1
  set paramU(size_1) 0   ;# 表示用に行数-1した値を保存
  if $clean return  ;# もし配列サイズを0にする初期化ならここで終了
  for {set i 0} {$i < [llength $recList]} {incr i} {
    set fid [lindex $recList $i]

    ;# 表に表示するデータを設定
    set paramU($paramUsize,0) $fid

    ;# 内部で参照するデータを設定
    set paramU($paramUsize,R) $i    ;# 行番号→recListの配列番号

    incr paramUsize
  }
  ;# 一覧表のサイズを更新する
  if {$sv(appname) != "OREMO" && [winfo exists .entpwindow]} {
    .entpwindow.t configure -rows $paramUsize
  }
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
}

#---------------------------------------------------
# 一覧表、本体窓のタイトルを更新する
#
proc setEPWTitle {} {
  global v sv t

  if $v(paramChanged) {
    set edit "(*)"
  } else {
    set edit ""
  }
  set maxlen 50
  if {[string length $v(paramFile)] <= $maxlen} {
    set fname $v(paramFile)
  } else {
    set fname [string range $v(paramFile) \
               [expr [string length $v(paramFile)] - $maxlen] end]
    set fname "...$fname"
  }
  wm title .entpwindow "$t(setEPWTitle) - $edit $fname $edit"
  wm title . "$sv(appname) $sv(version) - $edit $fname $edit"
}

#---------------------------------------------------
# 原音パラメータ値の一覧表を作る
#
proc makeEntParamWindow {} {
  global paramU v paramUsize paramUsizeC t

  if [isExist .entpwindow] return  ;# 二重起動を防止

  toplevel .entpwindow
  setEPWTitle
  wm resizable .entpwindow 1 1
  wm protocol .entpwindow WM_DELETE_WINDOW Exit
  ;# bind .entpwindow <Escape> "destroy .entpwindow"

  table .entpwindow.t -variable paramU -rows $paramUsize -cols $paramUsizeC \
      -colwidth 10 -height 11 -bordercursor fleur \
      -multiline 0 -selectmode extended \
      -titlerows 1 -titlecols 1 -selecttitle 0 \
      -colstretchmode none -rowstretchmode none \
      -padx 1 -pady 1 \
      -validate 1 -validatecommand {changeParam %s %S %r %c} \
      -xscrollcommand {.entpwindow.x set} -yscrollcommand {.entpwindow.y set}
  scrollbar .entpwindow.x -command {.entpwindow.t xview} -orient horizontal
  scrollbar .entpwindow.y -command {.entpwindow.t yview} -orient vertical

  grid .entpwindow.t .entpwindow.y -sticky news
  grid .entpwindow.x -sticky news
  grid rowconfigure .entpwindow 0 -weight 1
  grid columnconfigure .entpwindow 0 -weight 1

  .entpwindow.t width 0 14                        ;# 0列目の横幅を変更
  .entpwindow.t tag configure active -bg #A0A0A0  ;# アクティブなセルの背景色
  setCellSelection
}

#---------------------------------------------------
# 原音パラメータを数値入力で変更する
# 引数undo: push , skip
#
proc changeParam {oldValue newValue {r -1} {c -1} {undo "push"}} {
  global paramS paramU v t
  if {$c < 0 || $r < 0} {return 1}

  set cur [.entpwindow.t icursor]   ;# 当初のカーソル位置を保存
  if {[string length $oldValue] < [string length $newValue]} {
    ;# 文字挿入の場合の新しいカーソル位置を求める
    set curNew [expr $cur + 1]
  } else {
    ;# 文字削除の場合の新しいカーソル位置を求める
    if {$cur > 0} {
      set curNew [expr $cur - 1]
      if {[string index $oldValue $curNew] == [string index $newValue $curNew]} {
        incr curNew
      }
    } else {
      set curNew 0
    }
  }

  ;# エイリアスまたはコメントの場合
  if {$c >= 6} {
    if {$undo != "skip"} { pushUndo cel "$r,$c" $t(changeParam,undo) }
    set paramU($r,$c) $newValue
    if {$undo != "skip"} { pushUndo agn }
    setLabAlias
    .entpwindow.t icursor $curNew
    set v(paramChanged) 1
    setEPWTitle
    return 0   ;# ここは本来1を返すべきと思うが、1にするとセルに文字が反映されなくなった
  }

  ;# エイリアス、コメント以外のパラメータの場合
  if {[string is double $newValue] == 0 && $newValue != "-"} {  ;# 数値でなければ入力内容はボツ
    set paramU($r,$c) $oldValue
    return 0
  }
  if {[regexp " " $newValue]} {         ;# 空白を入力した場合はボツ
    set paramU($r,$c) $oldValue
    return 0
  }

  ;# 入力値が負符号の場合
  if {$newValue == "-"} {
    if {$undo != "skip"} { pushUndo cel "$r,$c" $t(changeParam,undo) }
    set paramU($r,$c) $newValue
    .entpwindow.t icursor $curNew
    set v(paramChanged) 1
    setEPWTitle
    RedrawParam
    if {$undo != "skip"} { pushUndo agn }
    return 0   ;# ここは本来1を返すべきかもしれないが、1にするとセルに文字が反映されない
  }
  ;# 入力値が空欄の場合
  if {$newValue == ""} {
    if {$undo != "skip"} { pushUndo cel "$r,$c" $t(changeParam,undo) }
    array unset paramU "$r,$c"
    array unset paramS "$r,[c2kind $c]"
    .entpwindow.t icursor $curNew
    set v(paramChanged) 1
    setEPWTitle
    RedrawParam
    if {$undo != "skip"} { pushUndo agn }
    return 0   ;# ここは本来1を返すべきかもしれないが、1にするとセルに文字が反映されない
  }

  ;# 入力がオーバーフローする数値の場合
  if {$newValue > 1000000 || $newValue < -1000000} {
    set paramU($r,$c) $oldValue
    return 0
  }
  ;# 入力が数値の場合
  set kind [c2kind $c]
  ;# 最初に0詰めされている場合は削除する(8進数と見なされるのを防ぐため)
  while {$newValue != 0 && [string index $newValue 0] == 0} {
    set newValue [string trimleft $newValue 0]
  }
  ;# 実数を入力可。小数点以下３桁以下は切り捨てる。
  if {$newValue != "" && [expr $newValue * 1000] != [expr int($newValue * 1000)]} {
    set newValue [cut3 $newValue]
  }
  if {$kind != "S"} {
    ;# 左ブランク以外を変更
    if {$undo != "skip"} { pushUndo cel "$r,$c" $t(changeParam,undo) }
    set paramU($r,$c) $newValue
    set paramS($r,$kind) [u2sec $kind $r $c]
  } else {
    if {$undo != "skip"} { pushUndo row $r $t(changeParam,undo) }
    set paramU($r,$c) $newValue
    set paramS($r,$kind) [u2sec $kind $r $c]
    ;# 左ブランクを変更したら、他の数値や位置を再計算させる
    for {set column 2} {$column < 6} {incr column} {
      set kindTmp [c2kind $column]
      if $v(setS) {
        ;# 他のパラメータの位置が変わらないよう数値を再計算する
        if {[array names paramS "$r,$kindTmp"] != ""} {
          set paramU($r,$column) [sec2u $r $kindTmp $paramS($r,$kindTmp)]
        }
      } else {
        ;# 他のパラメータの数値が変わらないよう位置を再計算する
        if {[array names paramU "$r,$column"] != ""} {
          set paramS($r,$kindTmp) [u2sec $kindTmp $r $column]
        }
      }
    }
  }
  if {$undo != "skip"} { pushUndo agn }
  .entpwindow.t icursor $curNew
  set v(paramChanged) 1
  setEPWTitle
  RedrawParam
  return 0   ;# ここは本来1を返すべきかもしれないが、1にするとセルに文字が反映されない
}

#---------------------------------------------------
# 次のwavファイルに移動
#
proc nextWav {} {
  global v paramU paramUsize t

  if {$paramUsize <= 0} return
  set wavName $paramU($v(listSeq),0)

  set end [expr $paramUsize - 1]
  for {set r $v(listSeq)} {$r < $end} {incr r} {
    if {$paramU($r,0) != $wavName} break
  }
  if {$paramU($r,0) != $wavName} {
    set v(msg) ""
    jumpRec $r $v(listC)
  }
}

#---------------------------------------------------
# 前のwavファイルに移動
#
proc prevWav {} {
  global v paramU paramUsize t

  if {$paramUsize <= 0} return
  set wavName $paramU($v(listSeq),0)

  set v(msg) ""
  for {set r $v(listSeq)} {$r > 1} {incr r -1} {
    if {$paramU($r,0) != $wavName} break
  }
  if {$paramU($r,0) != $wavName} {
    jumpRec $r $v(listC)
  }
}

#---------------------------------------------------
# 次の音に移動
#
proc nextList {} {
  global v paramU paramUsize t

  if {$paramUsize <= 0} return
  if {$v(listSeq) < [expr $paramUsize - 1]} {
    set v(msg) ""
    jumpRec [expr $v(listSeq) + 1] $v(listC)
  }
}

#---------------------------------------------------
# 前の音に移動
#
proc prevList {} {
  global v paramU paramUsize t

  if {$paramUsize <= 0} return
  if {$v(listSeq) > 1} {
    set v(msg) ""
    jumpRec [expr $v(listSeq) - 1] $v(listC)
  }
}

#---------------------------------------------------
#
# パラメータ一覧表のセルを選択する
#
proc jumpList {w x y {mode 1} {r 0} {c 0}} {  ;# mode=1:マウスで指定。0:直接指定
  global paramU paramUsize v t

  if {$paramUsize <= 0} return
  if $mode {
    ;# set sel [lindex [getCurSelection] end]
    set sel [$w index "@$x,$y"]
    if {$sel == ""} return
    set r [lindex [split $sel ","] 0]
    set c [lindex [split $sel ","] 1]
  }
  if {$r == $v(listSeq) && $c == $v(listC)} return
  if {$r < 1} return
  jumpRec $r $c $mode
}

#---------------------------------------------------
#
# 波形画面にエイリアスを表示する
#
proc setLabAlias {} {
  global v paramU t
  if {[array names paramU $v(listSeq),6] != "" && $paramU($v(listSeq),6) != ""} {
    set v(labAlias) "($paramU($v(listSeq),6))"
  } else {
    set v(labAlias) ""
  }
}

#---------------------------------------------------
#
# パラメータ一覧表の行を複製する
# addUndo ... 1=アンドゥスタックに登録する
# rnow ... 複製する行
#
proc duplicateEntp {w {addUndo 1} {rnow -1}} {
  global v paramU paramUsizeC paramS paramUsize t

  if {$rnow < 0} {
    set target [getCurSelection]
    set sel [lindex $target end]
    if {$sel == ""} return
    set rnow [lindex [split $sel ","] 0]

    ;# エラーチェック(選択領域が複数行でないか)
    if {[llength $target] > 1} {
      foreach seltmp $target {
        set rtmp [lindex [split $seltmp ","] 0]
        if {$rtmp != $rnow} {
          tk_messageBox -message $t(duplicateEntp,msg) \
            -title $t(duplicateEntp,title) -icon error -parent .entpwindow
          return
        }
      }
    }
  }

  if $addUndo {
    pushUndo all "" $t(duplicateEntp,undo)
  }

  ;# セル内容を一行下にコピーする
  for {set r $paramUsize} {$r > $rnow} {incr r -1} {
    set onr [expr $r - 1]
    for {set c 0} {$c < $paramUsizeC} {incr c} {
      if {[array names paramU $onr,$c] != ""} {
        set paramU($r,$c) $paramU($onr,$c)
      } else {
        array unset paramU $r,$c
      }
    }
    set paramU($r,R) $paramU($onr,R)

    ;# paramSの内容を一つ下にコピーする
    foreach kind {S C E P O} {
      if {[array names paramS $onr,$kind] != ""} {
        set paramS($r,$kind) $paramS($onr,$kind)
      } else {
        array unset paramS $r,$kind
      }
    }
  }
  incr paramUsize
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
  }
  set v(paramChanged) 1
  setEPWTitle
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) "$v(listSeq) / $paramU(size_1)"  ;# 現在何個目のデータを処理しているかを表示
  if $addUndo {
    pushUndo agn
  }
}

#---------------------------------------------------
#
# パラメータ一覧表の行を削除する
# addUndo ... 1=アンドゥスタックに登録する
#
proc deleteEntp {w {addUndo 1} {rnow ""}} {
  global v paramU paramUsizeC paramS paramUsize t

  ;# 削除行を指定していないならフォーカスされた行を削除対象にする
  if {$rnow == ""} {
    ;# エラーチェック(選択領域が複数行でないか)
    set target [getCurSelection]
    if {[llength $target] > 1} {
      foreach seltmp $target {
        set rtmp [lindex [split $seltmp ","] 0]
        if {$rtmp != $rnow} {
          tk_messageBox -message $t(deleteEntp,msg) \
            -title $t(deleteEntp,title) -icon error -parent .entpwindow
          return
        }
      }
    }

    set sel [lindex $target 0]
    if {$sel == ""} return
    set rnow [lindex [split $sel ","] 0]   ;# 削除対象の行番号
  }

  ;# 削除する行は、duplicateEntpで複製されて複数存在するもののみとする
  ;# すなわち、あるwavに対応する行が複数ある場合のみ削除可能とし、
  ;# 対応行が一つしかない場合は削除しない。
  set del 0 ;# 1=削除可能, 0=削除不可
  for {set r [expr $rnow + 1]} {$r < $paramUsize} {incr r} {
    if {$paramU($r,R) == $paramU($rnow,R)} {
      set del 1
      break
    } elseif {$paramU($r,R) > $paramU($rnow,R)} {
      break
    }
  }
  for {set r [expr $rnow - 1]} {$r > 0} {incr r -1} {
    if {$paramU($r,R) == $paramU($rnow,R)} {
      set del 1
      break
    } elseif {$paramU($r,R) < $paramU($rnow,R)} {
      break
    }
  }
  if {$del == 0} return  ;# 削除不可なら何もしない

  if $addUndo {
    pushUndo all "" $t(deleteEntp,undo)
  }

  ;# セル内容を一行上に移動する
  for {set r $rnow} {$r < [expr $paramUsize - 1]} {incr r} {
    for {set c 0} {$c < $paramUsizeC} {incr c} {
      if {[array names paramU [expr $r + 1],$c] != ""} {
        set paramU($r,$c) $paramU([expr $r + 1],$c)
      }
    }
    set paramU($r,R) $paramU([expr $r + 1],R)

    ;# paramSの内容を一つ上にコピーする
    foreach kind {S C E P O} {
      if {[array names paramS [expr $r + 1],$kind] != ""} {
        set paramS($r,$kind) $paramS([expr $r + 1],$kind)
      }
    }
  }
  ;# 最後の行を初期化する
  set r [expr $paramUsize - 1]
  for {set c 0} {$c < $paramUsizeC} {incr c} {
    set paramU($r,$c) ""
  }
  set paramU($r,R) ""
  foreach kind {S C E P O} {
    set paramS($r,$kind) ""
  }

  incr paramUsize -1
  if {$rnow < $v(listSeq)} {
    incr v(listSeq) -1
  }

  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
  }
  if {$rnow >= $paramUsize} prevList

  set v(paramChanged) 1
  setLabAlias
  setEPWTitle
  RedrawParam
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) "$v(listSeq) / $paramU(size_1)"  ;# 現在何個目のデータを処理しているかを表示
  if $addUndo {
    pushUndo agn
  }
}

#---------------------------------------------------
# セルをコピー
# "1,2\n3,4\n"といった文字列でコピーする
#
proc copyCell {w {separator ","}} {
  global paramU v t

  set region [getCurSelection]
  if {[llength $region] <= 0} return

  ;# 選択範囲の左端、右端の番号を得る
  set cL [lindex [split [lindex $region 0  ] ","] 1]
  set cR [lindex [split [lindex $region end] ","] 1]

  clipboard clear
  set buf ""
  foreach pos $region {
    ;# pasteする位置と現在の値を得る
    set u [split $pos ","]
    set r [lindex $u 0]
    set c [lindex $u 1]
    set str ""
    if {$c > $cL} {
      set str $separator
    }
    if {[array names paramU $pos] != ""} {
      set str "$str$paramU($pos)"
    }
    if {$c >= $cR} {
      set str "$str\n"
    }
    set buf "$buf$str"
  }
  clipboard append $buf
}

#---------------------------------------------------
# クリップボードの内容をアクティブセルに貼り付ける
# 貼り付け先領域の縦・横幅よりも、コピー元領域の縦・横幅を優先した形で貼り付ける
# もしコピー元が1つのセルの場合はそのセルを貼り付け先領域に合わせて複製する
#
proc pasteCell {w {separator ","}} {
  global paramU v t

  ;# クリップボードからデータを取得(二次元のリストで格納される)
  if {[catch {::tk::table::GetSelection $w CLIPBOARD} clip]} return

  ;# 区切り文字の指定がある場合は全体が一つの文字列なのでリストにする
  if {$separator != ""} {
    regsub "\n$" $clip "" clip
    set _clip ""
    foreach l [split $clip "\n"] {
      lappend _clip [split $l $separator]
    }
    set clip $_clip
  }

  ;# コピー元領域の横幅cW、縦幅cHを求める
  if {$clip == ""} {
    set cH 1
    set cW 1
  } else {
    set cH [llength $clip]
    set tmp [lindex $clip 0]
    if {$tmp == ""} {
      set cW 1
    } else {
      set cW [llength $tmp]
    }
  }

  ;# 選択領域の横幅pW、縦幅pHを求める
  set pasteRegion [getCurSelection]
  if {[llength $pasteRegion] <= 0} return
  set p1 [lindex $pasteRegion 0  ]
  set p2 [lindex $pasteRegion end]
  set pr [lindex [split $p1 ","] 0]  ;# 選択領域の上端の行番号
  set pc [lindex [split $p1 ","] 1]  ;# 選択領域の左端の列番号
  set pH [expr [lindex [split $p2 ","] 0] - $pr + 1]
  set pW [expr [lindex [split $p2 ","] 1] - $pc + 1]

  ;# コピー元領域と選択領域との幅が違うなら貼り付けるか確認する
  if {$cH != 1 || $cW != 1} {
    if {$cH != $pH || $cW != $pW} {
      set act [tk_dialog .confm $t(.confm) $t(pasteCell,q1) \
        question 1 $t(.confm.yes) $t(.confm.no)]
      regexp {^\.[^.]*} $w window
      raise $window
      focus $w
      if {$act == 1} return  ;# 「いいえ」なら貼り付けない
    }
  }

  set undoOpt [getRctOpt]
  set tmp [split $undoOpt ","]
  if {[lindex $tmp 1] == 1} {   ;# もし左ブランクの値を変えるなら。
    set undoOpt [format "%d,1,%d,5" [lindex $tmp 0] [lindex $tmp 2]]
  }
  pushUndo rct $undoOpt $t(pasteCell,undo)

  set pasteNum [llength $pasteRegion]
  if {$pasteNum >= 50} {
    initProgressWindow
    set seq 0
  }
  foreach pos $pasteRegion {
    ;# pasteする位置と現在の値を得る
    set u [split $pos ","]
    set r [lindex $u 0]
    set c [lindex $u 1]
    if {[array names paramU $pos] != ""} {
      set oldValue $paramU($pos)
    } else {
      set oldValue ""
    }

    ;# pasteするデータを得る
    set cr [expr ($r - $pr) % $cH]
    set cc [expr ($c - $pc) % $cW]
    if {$cr < 0 || $cr >= $cH || $cc < 0 || $cc >= $cW} continue
    set newValue [lindex [lindex $clip $cr] $cc]

    ;# pasteする
    set setSbak $v(setS)
    set v(setS) 0
    changeParam $oldValue $newValue $r $c skip
    set v(setS) $setSbak
    if {$pasteNum >= 50} {
      updateProgressWindow [expr 100.0 * $seq / $pasteNum]
      incr seq
    }
  }
  ;# 最後にpasteしたセルをアクティブにする
  .entpwindow.t activate [lindex $pasteRegion end]
  set v(paramChanged) 1
  setEPWTitle
  pushUndo agn
  if {$pasteNum >= 50} deleteProgressWindow
}

#---------------------------------------------------
# セルでカーソルを左に移動
#
proc leftInCell {w} {
  global v
  if {[$w icursor] > 0} {
    $w icursor [expr {[$w icursor] - 1}]
  } else {
    setCellSelection $v(listSeq) [expr $v(listC) - 1]
    $w icursor end
  }
}

#---------------------------------------------------
# セルでカーソルを右に移動
#
proc rightInCell {w} {
  global v
  set cur [$w icursor]
  $w icursor [expr {[$w icursor] + 1}]
  if {[$w icursor] == $cur} {
    setCellSelection $v(listSeq) [expr $v(listC) + 1]
    $w icursor 0
  }
}

#---------------------------------------------------
# セル選択時の設定
#
proc setCellSelection {{r 1} {c 1} {mode 0}} {
  global v paramUsize paramUsizeC t paramU
  if {$mode == 0} { .entpwindow.t selection clear all }
  if {$r < $paramUsize && $c < $paramUsizeC} {
    .entpwindow.t see $r,$c
    .entpwindow.t selection set $r,$c
    .entpwindow.t activate $r,$c
    set v(listSeq) $r
    set v(listC)   $c
  }
  setLabAlias
}

#---------------------------------------------------
# フォルダ使用履歴のリストを更新する
#
proc _updateDirHistory {_dirHistory saveDir} {
  upvar $_dirHistory dirHistory
  global v startup

  # メニューの履歴表示を更新
  set seq [lsearch -exact $dirHistory $saveDir] 
  if {$seq == 0} {
    ;# 履歴に変更ないなら終了
    return
  } elseif {$seq < 0} {
    ;# 履歴にないフォルダなら追加
    set dirHistory [linsert $dirHistory 0 $saveDir]
    if {[llength $dirHistory] > $v(dirHistoryMax)} {
      set dirHistory [lrange $dirHistory 0 end-1]
    }
  } else {
    ;# 履歴にあるフォルダなら順番を変える
    set dirHistory [lreplace $dirHistory $seq $seq]
    set dirHistory [linsert  $dirHistory 0 $saveDir]
  }
}

#---------------------------------------------------
# フォルダ使用履歴を更新する
#
proc updateDirHistory {} {
  global v startup

  _updateDirHistory v(dirHistory) $v(saveDir)
  if {[regexp {^(.+)/} $v(saveDir) dummy pDir]} {
    _updateDirHistory v(pDirHistory) $pDir
  }
  renewMenu
}

#---------------------------------------------------
# setParam-settings.iniファイルを保存する
#
proc saveSysIniFile {} {
  global v startup

  if [catch {open $startup(sysIniFile) w} fp] { 
    return
  }
  fconfigure $fp -encoding utf-8
  # $topdir/setParam-init.tclを自動保存するかどうか
  puts $fp "autoSaveInitFile=$v(autoSaveInitFile)"
  # 拡張子をファイルに保存
  puts $fp "waveFileExt=$v(ext)"
  # 起動時にダイアログを開くかどうか
  puts $fp "openStartDialog=$startup(choosesaveDir)"
  # アンドゥ設定をファイルに保存
  puts $fp "undoLimit=$v(undoLimit)"
  # 履歴をファイルに保存
  for {set i 0} {$i < [llength $v(dirHistory)]} {incr i} {
    puts $fp "recentDir$i=[lindex $v(dirHistory) $i]"
  }
  for {set i 0} {$i < [llength $v(pDirHistory)]} {incr i} {
    puts $fp "recentPDir$i=[lindex $v(pDirHistory) $i]"
  }
  close $fp
}

#---------------------------------------------------
# setParam-settings.iniファイルを読む
#
proc readSysIniFile {} {
  global v startup

  set v(dirHistory) {}
  set v(pDirHistory) {}
  if [catch {open $startup(sysIniFile) r} fp] { 
    return
  }
  fconfigure $fp -encoding utf-8
  while {![eof $fp]} {
    set l [gets $fp]
    if {[regexp {^recentDir([0-9]+)=(.+)$} $l dummy seq dir]} {        ;# フォルダ履歴を読み込む
      set v(dirHistory) [linsert $v(dirHistory) $seq $dir]
    } elseif {[regexp {^recentPDir([0-9]+)=(.+)$} $l dummy seq dir]} { ;# 親フォルダ履歴を読み込む
      set v(pDirHistory) [linsert $v(pDirHistory) $seq $dir]
    } elseif {[regexp {^openStartDialog=(.+)$} $l dummy bool]} {       ;# 起動時のダイアログを出すかどうか
      set startup(makeRecListFromDir) $bool
      set startup(choosesaveDir) $bool
    } elseif {[regexp {^waveFileExt=(.+)$} $l dummy ext]} {            ;# 拡張子を読み込む
      set v(ext) $ext
    } elseif {[regexp {^undoLimit=(.+)$} $l dummy undoLimit]} {        ;# アンドゥ設定を読み込む
      set v(undoLimit) $undoLimit                                ;# 0=未使用、負=メモリ上限なし
      set v(undoLimitStrLen) [expr $v(undoLimit) * 1000000 / $v(undoLimitWeight)]
    } elseif {[regexp {^autoSaveInitFile=(.+)$} $l dummy bool]} {      ;# $topdir/setParam-init.tclを自動保存するかどうか
      set v(autoSaveInitFile) $bool
    }
  }
  close $fp
}

#---------------------------------------------------
# 最近開いたフォルダを開く
# mode: 1=$dirを開く。 0=$dirを初期フォルダにしてユーザがフォルダ選択
#
proc openRecentDir {dir mode} {
  global v

  if $mode {
    if {[choosesaveDir 0 $dir] == 0} return
  } else {
    set v(saveDir) $dir
    set v(openedParamFile) ""
    if {[choosesaveDir] == 0} return
  }
  makeRecListFromDir 1 ;# 保存フォルダからリストを生成する
  resetDisplay
  updateDirHistory
}

#---------------------------------------------------
# メニュー表示内容を更新する
#
proc renewMenu {} {
  global t v
  [snack::menuGet $t(file,dirHistory)] delete 0 $v(dirHistoryMax)  ;# 履歴を消去する
  for {set i 0} {$i < [llength $v(dirHistory)]} {incr i} {
    set d [lindex $v(dirHistory) $i]
    snack::menuCommand $t(file,dirHistory) "$i: $d" "openRecentDir \"$d\" 1"
  }
  [snack::menuGet $t(file,pDirHistory)] delete 0 $v(dirHistoryMax)  ;# 履歴を消去する
  for {set i 0} {$i < [llength $v(pDirHistory)]} {incr i} {
    set d [lindex $v(pDirHistory) $i]
    snack::menuCommand $t(file,pDirHistory) "$i: $d" "openRecentDir \"$d\" 0"
  }
}

#---------------------------------------------------
# メニュー表示
#
proc setMenu {} {
  global t plugin v ustData
  
  if {[array exists snack::menu]} {
    destroy .menubar
    unset snack::menu
  }

  snack::menuInit

  snack::menuPane    $t(file)
  if {[array names ustData "pluginMode"] == ""} {
    ;# 通常(非プラグインモード)時のファイルメニュー
    snack::menuCommand $t(file) $t(file,choosesaveDir) {
      if [choosesaveDir] {
        makeRecListFromDir 1 ;# 保存フォルダからリストを生成する
        resetDisplay
      }
    }
    snack::menuCascade $t(file) $t(file,dirHistory)
    for {set i 0} {$i < [llength $v(dirHistory)]} {incr i} {
      set d [lindex $v(dirHistory) $i]
      snack::menuCommand $t(file,dirHistory) "$i: $d" "openRecentDir \"$d\" 1"
    }
    snack::menuCascade $t(file) $t(file,pDirHistory)
    for {set i 0} {$i < [llength $v(pDirHistory)]} {incr i} {
      set d [lindex $v(pDirHistory) $i]
      snack::menuCommand $t(file,pDirHistory) "$i: $d" "openRecentDir \"$d\" 0"
    }
    snack::menuSeparator $t(file)
    snack::menuCommand $t(file) $t(file,readParamFile) {
      if {[readParamFile]} {resetDisplay}
    }

    snack::menuCommand $t(file) $t(file,saveParamFile)   {saveParamFile $v(paramFile)}
    snack::menuCommand $t(file) $t(file,saveParamFileAs) saveParamFile
    snack::menuCommand $t(file) $t(file,readUstFile)   {readUstFile;   resetDisplay}
    snack::menuCommand $t(file) $t(file,mergeParamFile) mergeParamFile
    snack::menuSeparator $t(file)
    snack::menuCommand $t(file) $t(file,readSettings)  readSettings
    snack::menuCommand $t(file) $t(file,saveSettings)  saveSettings
    snack::menuCascade $t(file) $t(file,test)
    snack::menuCommand $t(file,test) $t(file,test,makeRecList) {
      makeRecListFromDir
      resetDisplay
      set v(msg) $t(file,test,makeRecList,msg)
    }
    snack::menuCommand $t(file,test)  $t(file,test,readRecList)  {readRecList; resetDisplay}
    snack::menuCommand $t(file,test)  $t(file,test,saveRecList)  saveRecList
    snack::menuSeparator $t(file)
    snack::menuCommand $t(file)       $t(file,Exit)              Exit
  } else {
    ;# プラグインモード時のファイルメニュー
    snack::menuCommand $t(file)       $t(file,Exit)              Exit
  }

  #snack::menuPane      $t(edit)
  #snack::menuCommand   $t(edit)     $t(edit,tk_tableCopy)   {tk_tableCopy .entpwindow.t}
  #snack::menuCommand   $t(edit)     $t(edit,pasteCell)      {pasteCell    .entpwindow.t}
  #snack::menuSeparator $t(edit)
  #snack::menuCommand   $t(edit)     $t(edit,searchParam)    searchParam
  #snack::menuCommand   $t(edit)     $t(edit,doSearchParam1) {doSearchParam 1}
  #snack::menuCommand   $t(edit)     $t(edit,doSearchParam0) {doSearchParam 0}
  #snack::menuSeparator $t(edit)
  #snack::menuCommand   $t(edit)     $t(edit,changeCell) changeCell

  snack::menuPane    $t(undo)
  snack::menuCommand $t(undo)        $t(undo,undo)                     undo
  snack::menuCommand $t(undo)        $t(undo,redo)                     redo

  snack::menuPane    $t(show)
  snack::menuCascade $t(show)   $t(show,zoomTitle)
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoom0)     {zoomX     0 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoom100)   {zoomX   100 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoom1000)  {zoomX  1000 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoom5000)  {zoomX  5000 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoom10000) {zoomX 10000 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,zoomMax)   {zoomX    -1 0}
  snack::menuCommand $t(show,zoomTitle)   $t(PopUpMenu,changeZoomX) {changeZoomX}
  snack::menuCascade $t(show)          $t(show,timeAxis)
  snack::menuRadio   $t(show,timeAxis) $t(show,timeAxisSec) v(timeUnit) "Sec." { Redraw scale}
  snack::menuRadio   $t(show,timeAxis) $t(show,timeAxisBar) v(timeUnit) "Bar"  { Redraw scale; setBPMWindow}
  snack::menuSeparator $t(show)
  snack::menuCheck   $t(show)   $t(PopUpMenu,showWave)     v(showWave) toggleWave
  snack::menuCheck   $t(show)   $t(PopUpMenu,showSpec)     v(showSpec) toggleSpec
  snack::menuCheck   $t(show)   $t(PopUpMenu,showPow)      v(showpow)  togglePow
  snack::menuCheck   $t(show)   $t(PopUpMenu,showF0)       v(showf0)   toggleF0
  #snack::menuSeparator $t(show)
  #snack::menuCommand $t(show)   $t(PopUpMenu,pitchGuide)   pitchGuide
  #snack::menuCommand $t(show)   $t(PopUpMenu,tempoGuide)   tempoGuide
  snack::menuSeparator $t(show)
  snack::menuCheck   $t(show)   $t(PopUpMenu,alwaysOnTop)  v(alwaysOnTop) {
    if {$v(alwaysOnTop)} {
      wm attributes .           -topmost 1
      wm attributes .entpwindow -topmost 1
    } else {
      wm attributes .           -topmost 0
      wm attributes .entpwindow -topmost 0
    }
  }
  snack::menuCommand $t(show)   $t(PopUpMenu,setAlpha)     setAlphaWindow
  ;#snack::menuCommand 表示 {原音パラメータ一覧を表示}   makeEntParamWindow

  snack::menuPane      $t(option)
  snack::menuCascade   $t(option)     $t(option,gui)
    snack::menuCascade $t(option,gui) $t(option,S)
      snack::menuRadio $t(option,S)   $t(option,S,1) v(setS) 0 {RedrawParam}
      snack::menuRadio $t(option,S)   $t(option,S,2) v(setS) 1 {RedrawParam}
    snack::menuCascade $t(option,gui) $t(option,P)
      snack::menuRadio $t(option,P)   $t(option,P,1) v(setP) 0 {RedrawParam}
      snack::menuRadio $t(option,P)   $t(option,P,2) v(setP) 1 {RedrawParam}
    snack::menuCheck   $t(option,gui) $t(option,minusO)        v(minusO)        {}
    snack::menuCheck   $t(option,gui) $t(option,blankBroom)    v(blankBroom)    {}
    snack::menuCheck   $t(option,gui) $t(option,cutBlank)      v(cutBlank)      {cutBlankConfirm}
    snack::menuCheck   $t(option,gui) $t(option,timingAdjMode) v(timingAdjMode) timingAdjMode
    snack::menuCheck   $t(option,gui) $t(option,clickPlayRangeMode) v(clickPlayRangeMode) clickPlayRangeMode

  snack::menuCascade   $t(option)    $t(option,E)
    snack::menuRadio   $t(option,E)  $t(option,E,1) v(_setE)  1 changeE
    snack::menuRadio   $t(option,E)  $t(option,E,2) v(_setE) -1 changeE

  snack::menuSeparator $t(option)

  snack::menuCommand $t(option)    $t(option,uttTimingSettings) uttTimingSettings
  snack::menuCommand $t(option)    $t(option,synTestWindow)     synTestWindow
  snack::menuCommand $t(option)    $t(option,setPlayRange)      setPlayRange
  snack::menuCommand $t(option)    $t(option,autoFocus)         autoFocusSettings
  snack::menuCommand $t(option)    $t(option,ioSettings)        ioSettings
  snack::menuCommand $t(option)    $t(option,settings)          settings
  snack::menuCommand $t(option)    $t(option,setLanguage)       {
  readLanguage
  setMenu
  }

  #snack::menuSeparator $t(option)
  #snack::menuCascade $t(option)    $t(option,unusual)
  #snack::menuCheck   $t(option,unusual) $t(option,removeDC)     v(removeDC) {}
  #snack::menuCheck   $t(option,unusual) $t(option,rec) v(rec)   {}

  snack::menuPane    $t(tool)
  if {[array names ustData "pluginMode"] == ""} {
    ;# 通常(非プラグインモード)時のファイルメニュー
    snack::menuCascade $t(tool)        $t(tool,auto)
    snack::menuCommand $t(tool,auto)   $t(tool,auto,estimateParam)       estimateParam
#  snack::menuCommand $t(tool,auto)   $t(tool,auto,autoParamEstimation) autoParamEstimation
    snack::menuCommand $t(tool,auto)   $t(tool,auto,genParam)            genParam
    snack::menuCascade $t(tool)        $t(tool,wav)
    snack::menuCommand $t(tool,wav)    $t(tool,removeDCall)              removeDCall
    snack::menuCommand $t(tool,wav)    $t(tool,addUnderScore)            {addUnderScore wavOnly}
    snack::menuCommand $t(tool,wav)    $t(tool,addUnderScore2)           {addUnderScore whole}
    snack::menuCommand $t(tool,wav)    $t(tool,cutWav)                   cutWav
    snack::menuCommand $t(tool,wav)    $t(tool,convertMonoAll)           convertMonoAll
    snack::menuCascade $t(tool)        $t(tool,finish)
    snack::menuCommand $t(tool,finish) $t(tool,finish,aliasComplement)   aliasComplement
    snack::menuCommand $t(tool,finish) $t(tool,finish,woComplement)      woComplement
    snack::menuCascade $t(tool)        $t(tool,sort)
    snack::menuCommand $t(tool,sort)   $t(tool,sort,sortByVowel)         sortByVowel
    snack::menuCommand $t(tool,sort)   $t(tool,sort,sortByFID)           sortByFID
    snack::menuSeparator $t(tool)
  }
  snack::menuCommand $t(tool)        $t(tool,changeAlias)              changeAlias
  snack::menuCommand $t(tool)        $t(tool,zeroCross)                zeroCross
  snack::menuCommand $t(tool)        $t(tool,runExplorer)              runExplorer

  ;# プラグインを登録
  if {[array names ustData "pluginMode"] == ""} {
    snack::menuCascade $t(tool,auto) $t(tool,auto,plugin)
    for {set i 0} {$i < $plugin(N)} {incr i} {
      if {$plugin($i,edit) == "all"} {
        set name    $plugin($i,name)
        snack::menuCommand $t(tool,auto,plugin) "$i: $name" "runPlugin $i 1"
      }
    }
  }

  snack::menuPane    $t(help)
  snack::menuCommand $t(help) $t(help,Version)    Version
  snack::menuCommand $t(help) $t(help,official1) {execExternal http://nwp8861.web.fc2.com/soft/setParam/ }
  snack::menuCommand $t(help) $t(help,official2) {execExternal https://osdn.net/users/nwp8861/pf/setParam/files/ }
}

#---------------------------------------------------
# usage
#
proc usage {} {
  global argv0 t
  puts "usage: $argv0 \[-d saveDir|-f initScript\]"
}

#---------------------------------------------------
# paramUの列要素の各キーをリストにして返す
#
proc makeListC {} {
  global paramUsizeC

  set ret {}
  for {set c 0} {$c < $paramUsizeC} {incr c} {
    lappend ret $c
  }
  lappend ret R
  return $ret
}

#---------------------------------------------------
# undo
#
# u(iMin)           ... スタック内の履歴番号最小値
# u(iMax)           ... スタック内の履歴番号最大値
# u(i)              ... スタックの番号i。undoしたら1減らす
# u($i,cmd)         ... アンドゥコマンド。
# u($i,opt)         ... アンドゥコマンドのオプション。
#                       whl: ""     ... 全データ(パラメータ全体のみでなく他の設定変数も)を保存
#                       all: ""     ... パラメータ全体を保存
#                       row: 行     ... 指定した行の全列データを保存
#                       col: 列     ... 指定した列の全行データを保存
#                       rct: "行1,列1,行2,列2" ... (r1,c1)-(r2,c2)の範囲のデータを保存
#                       cel: "行,列" ... 指定したセルのデータを保存
#                       agn: ""      ... 前回pushUndoしたときと同じコマンドで再度pushする
# u($i,comment)     ... スタックに保存した内容の一言コメント
# u($i,v)           ... vのデータを保存
# u($i,paramS)      ... paramSのデータを保存
# u($i,paramU)      ... paramUのデータを保存
# u($i,paramUsize)  ... paramUsizeのデータを保存
# u($i,paramUsizeC) ... paramUsizeCのデータを保存
# u($i,listSeq)     ... v(listSeq)のデータを保存
# u($i,listC)       ... v(listC)のデータを保存
# u($i,paramChanged)... v(paramChanged)のデータを保存
#

#---------------------------------------------------
# アンドゥスタックを初期化する
# 返り値...0=初期化したとき, 1=初期化しなかったとき
#
proc clearUndo {{confirm 0}} {
  global u t

  if $confirm {
    set act [tk_dialog .confm $t(.confm) \
      $t(clearUndo,q) question 1 \
      $t(.confm.yes) \
      $t(.confm.no)
    ]
    if {$act == 1} return 1
  }

  array unset u
  set u(i) 0
  set u(iMin) 0
  set u(iMax) 0
  set u(undoSize) 0
  ;# メニュー更新
  [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo) --"
  [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo) --"
  return 0
}

#---------------------------------------------------
# アンドゥスタックに入れた内容をキャンセルする
#
proc cancelUndo {} {
  global u v t
  if {$v(undoLimit) == 0} return   ;# アンドゥ未使用なら
  incr u(i) -1
  incr u(iMax) -1
  set j [expr $u(i) - 1]
  if {$j > $u(iMin)} {
    [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo)  $u($j,comment)"
  } else {
    [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo) --"
  }
  [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo) --"
}

#---------------------------------------------------
proc __myArrayGet {_a key} {
  global $_a
  upvar $_a a
  if {[array names $_a $key] != ""} {
    set val $a($key)
    if [regexp " " $val] {
      set val "{$val}"
    } elseif {$val == ""} {
      set val "{}"
    }
  } else {
    set val "_UNSET_"
  }
  return $val
}

#---------------------------------------------------
proc _myArraySet {_a r1 r2 clist i} {
  global $_a u
  upvar $_a a
  array set $_a $u($i,$_a)
  for {set r $r1} {$r <= $r2} {incr r} {
    foreach kind $clist {
      set key "$r,$kind"
      if {[array names $_a $key] != "" && $a($key) == "_UNSET_"} {
        array unset $_a $key
      }
    }
  }
}

#---------------------------------------------------
proc _myArrayGet {_a r1 r2 clist} {
  global $_a
  upvar $_a a
  set buf ""
  for {set r $r1} {$r <= $r2} {incr r} {
    foreach c $clist {
      set key "$r,$c"
      set val [__myArrayGet $_a $key]
      set buf "$buf $key $val"
    }
  }
  return [string trim $buf]
}

#---------------------------------------------------
proc _myArrayGet2 {_a rstart rend c} {
  global $_a
  upvar $_a a
  set buf ""
  for {set r $rstart} {$r <= $rend} {incr r} {
    set key "$r,$c"
    set val [__myArrayGet $_a $key]
    set buf "$buf $key $val"
  }
  return [string trim $buf]
}

#---------------------------------------------------
# アンドゥスタックに現在のデータを保存する
# cmd...保存の仕方の指定
# comment...今行った作業内容の一言コメント
#
proc pushUndo {cmd {opt ""} {comment ""}} {
  global u v t paramS paramU paramUsize paramUsizeC

  if {$v(undoLimit) == 0} return   ;# アンドゥ未使用なら

  if {[expr $u(i) % 2] && $u(i) < $u(iMax)} {
    incr u(i)
  }
  set i $u(i)

  # puts "debug,$cmd: $opt"
  ;# もしコマンドがagnなら前回pushしたときの内容と差し替える
  if {$cmd == "agn"} {
    set j [expr $i - 1]
    set cmd     $u($j,cmd)
    set opt     $u($j,opt)
    set comment $u($j,comment)
  }

  ;# 現在の状態を保存
  array unset uTmp
  set uTmp($i,cmd)          $cmd
  set uTmp($i,opt)          $opt
  set uTmp($i,comment)      $comment
  set uTmp($i,listSeq)      $v(listSeq)
  set uTmp($i,listC)        $v(listC)
  set uTmp($i,paramChanged) $v(paramChanged)
  switch $cmd {
    whl {
      set msgTmp $v(msg)
      set v(msg) ""
      set uTmp($i,v)      [array get v]
      set v(msg) $msgTmp
      set uTmp($i,paramS) [array get paramS]
      set uTmp($i,paramU) [array get paramU]
      set uTmp($i,paramUsize)  $paramUsize
      set uTmp($i,paramUsizeC) $paramUsizeC
    }
    all {
      set uTmp($i,paramS) [array get paramS]
      set uTmp($i,paramU) [array get paramU]
      set uTmp($i,paramUsize)  $paramUsize
      set uTmp($i,paramUsizeC) $paramUsizeC
    }
    row {
      ;# paramSを保存
      set uTmp($i,paramS) [_myArrayGet paramS $uTmp($i,opt) $uTmp($i,opt) {S C E P O}]
      ;# paramUを保存
      set uTmp($i,paramU) [_myArrayGet paramU $uTmp($i,opt) $uTmp($i,opt) [makeListC]]
    }
    rct {
      set tmp [split $opt ","]
      set r1 [lindex $tmp 0]    ; if {$r1 == ""} {set r1 1}
      set c1 [lindex $tmp 1]    ; if {$c1 == ""} {set c1 1}
      set r2 [lindex $tmp 2]    ; if {$r2 == ""} {set r2 $paramUsize}
      set c2 [lindex $tmp 3]    ; if {$c2 == ""} {set c2 $paramUsizeC}
      set clistS {}
      set clistU {}
      for {set c $c1} {$c <= $c2} {incr c} {
        lappend clistS [c2kind $c]
        lappend clistU $c
      }
      ;# paramSを保存
      set uTmp($i,paramS) [_myArrayGet paramS $r1 $r2 $clistS]
      ;# paramUを保存
      set uTmp($i,paramU) [_myArrayGet paramU $r1 $r2 $clistU]
    }
    col {
      set rend [expr $paramUsize - 1]
      set uTmp($i,paramS) [_myArrayGet2 paramS 1 $rend $uTmp($i,opt)]
      set uTmp($i,paramU) [_myArrayGet2 paramU 1 $rend $uTmp($i,opt)]
    }
    cel {
      set tmp [split $opt ","]
      set r1 [lindex $tmp 0]
      set c1 [lindex $tmp 1]
      ;# paramSを保存
      set uTmp($i,paramS) [_myArrayGet paramS $r1 $r1 [c2kind $c1]]
      ;# paramUを保存
      set uTmp($i,paramU) [_myArrayGet paramU $r1 $r1 $c1]
    }
  }
  array set u [array get uTmp]
  set u($i,undoSize) [string length [array get uTmp]]
  incr u(undoSize) $u($i,undoSize)
  incr u(i)
  set u(iMax) $u(i)
  if {[expr $u(i) % 2] == 0} checkUndoLimit

  ;# メニュー更新
  [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo)  $comment"
  [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo) --"
}

#---------------------------------------------------
# アンドゥスタックの要領が設定値の上限を超えていないか確認し、
# 超えていた場合は古い履歴を削除する
#
proc checkUndoLimit {} {
  global u v

  ;# アンドゥデータがメモリ上限に達していないか制限なしならreturn。
  if {$v(undoLimit) < 0 || $u(undoSize) < $v(undoLimitStrLen)} return

  ;# 古いデータから削除していく
  for {set i $u(iMin)} {$i < $u(i)} {incr i 2} {
    set u(undoSize) [expr $u(undoSize) - $u($i,undoSize)]
    array unset u "$i,*"
    set j [expr $i + 1]
    set u(undoSize) [expr $u(undoSize) - $u($j,undoSize)]
    array unset u "$j,*"
    set u(iMin) [expr $i + 2]
    if {$u(undoSize) < $v(undoLimitStrLen)} break
  }
  # puts "debug, checkUndoLimit $u(iMin)..$u(iMax)"
}

#---------------------------------------------------
# アンドゥ
#
proc undo {} {
  global u v paramS paramU paramUsize paramUsizeC

  if {[expr $u(i) % 2] == 0} {
    set i [expr $u(i) - 2]
  } else {
    set i [expr $u(i) - 1]
  }
  if {$u(i) <= $u(iMin)} return

  changeState $i
  set u(undoSize) [expr $u(undoSize) - $u($i,undoSize)]
  # puts "debug, undo $u($i,cmd) $u($i,opt), comment=$u($i,comment), i=$u(i), $u(iMin)..$u(iMax)"
}

#---------------------------------------------------
# リドゥ
#
proc redo {} {
  global u v paramS paramU paramUsize paramUsizeC

  if {[expr $u(i) % 2] == 0} {
    set i [expr $u(i) + 1]
  } else {
    set i [expr $u(i) + 2]
  }
  if {$i >= $u(iMax)} return

  changeState $i
  set u(undoSize) [expr $u(undoSize) + $u($i,undoSize)]
  # puts "debug, redo $u($i,cmd) $u($i,opt), comment=$u($i,comment), i=$u(i), $u(iMin)..$u(iMax)"
}

#---------------------------------------------------
# アンドゥ/リドゥ実行時にparamSなどの状態を変更する
#
proc changeState {i} {
  global u v t paramS paramU paramUsize paramUsizeC

  switch $u($i,cmd) {
    whl {
      array unset v
      array unset paramS
      array unset paramU
      array set v      $u($i,v)
      array set paramS $u($i,paramS)
      array set paramU $u($i,paramU)
      set paramUsizeC  $u($i,paramUsizeC)
      set paramUsize   $u($i,paramUsize)
      set paramU(size_1) [expr $paramUsize - 1]
    }
    all {
      set paramUsizeC  $u($i,paramUsizeC)
      set paramUsize   $u($i,paramUsize)
      set paramU(size_1) [expr $paramUsize - 1]
      jumpRec $u($i,listSeq) $u($i,listC)    ;# これは不要に思えるが、これがないと以下の操作で値が書き換わる例があった。
                                             ;# セルAを選択→Ctrl+i→別の行のセルBを選択→undo→Bの値がAの値になってしまう。変わらない場合もある
      array unset paramS
      array unset paramU
      array set paramS $u($i,paramS)
      array set paramU $u($i,paramU)
    }
    row {
      jumpRec $u($i,listSeq) $u($i,listC)
      _myArraySet paramS $u($i,listSeq) $u($i,listSeq) {S C E P O} $i
      _myArraySet paramU $u($i,listSeq) $u($i,listSeq) [makeListC] $i
    }
    rct {
      jumpRec $u($i,listSeq) $u($i,listC)
      set tmp [split $u($i,opt) ","]
      set r1 [lindex $tmp 0]
      set c1 [lindex $tmp 1]
      set r2 [lindex $tmp 2]
      set c2 [lindex $tmp 3]
      set clistS {}
      set clistU {}
      for {set c $c1} {$c <= $c2} {incr c} {
        lappend clistS [c2kind $c]
        lappend clistU $c
      }
      _myArraySet paramS $r1 $r2 $clistS $i
      _myArraySet paramU $r1 $r2 $clistU $i
    }
    col {
      jumpRec $u($i,listSeq) $u($i,listC)
      _myArraySet paramS 1 [expr $paramUsize -1] [c2kind $u($i,listC)] $i
      _myArraySet paramU 1 [expr $paramUsize -1] $u($i,listC) $i
    }
    cel {
      jumpRec $u($i,listSeq) $u($i,listC)
      _myArraySet paramS $u($i,listSeq) $u($i,listSeq) [c2kind $u($i,listC)] $i
      _myArraySet paramU $u($i,listSeq) $u($i,listSeq) $u($i,listC) $i
    }
  }
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
  }
  set u(i) $i
  set v(listSeq)      $u($i,listSeq)
  set v(listC)        $u($i,listC)
  set v(paramChanged) $u($i,paramChanged) 
  jumpRec $v(listSeq) $v(listC)
  setEPWTitle

  ;# メニュー更新
  if [expr $i % 2] {
    ;# リドゥしたときのメニュー変更
    [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo)  $u($i,comment)"
    set j [expr $i + 1]
    if {$j < $u(iMax)} {
      [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo)  $u($j,comment)"
    } else {
      [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo) --"
    }
  } else {
    ;# アンドゥしたときのメニュー変更
    set j [expr $i - 1]
    if {$j > $u(iMin)} {
      [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo)  $u($j,comment)"
    } else {
      [snack::menuGet $t(undo)] entryconfigure 1 -label "$t(undo,undo) --"
    }
    [snack::menuGet $t(undo)] entryconfigure 2 -label "$t(undo,redo)  $u($i,comment)"
  }
}

#---------------------------------------------------
# 一覧表の選択範囲に外接する長方形の座標を求める
# アンドゥのrctモード用。
#
proc getRctOpt {} {
  set posList [getCurSelection]
  set key1 [lindex $posList 0  ]
  set key2 [lindex $posList end]
  return "$key1,$key2"
}

#---------------------------------------------------
# oto.iniを保存したときにアンドゥスタック内のv(paramChanged)や
# u(i,paramChanged)の内容を更新する
#
proc changeParamChangedInUndo {} {
  global u v

  for {set i $u(iMin)} {$i < $u(iMax)} {incr i} {
    ;# v(paramChanged)を更新
    if {[array names u "$i,v"] != ""} {
      array set uTmp $u($i,v)
      if {$i == $u(i)} {
        set uTmp(paramChanged) $v(paramChanged)
      } else {
        set uTmp(paramChanged) 1
      }
      set u($i,v) [array get uTmp]
    }
    ;# u(i,paramChanged)を更新
    if {$i == $u(i)} {
      set u($i,paramChanged) 0
    } else {
      set u($i,paramChanged) 1
    }
  }
}

#---------------------------------------------------
# 透過率の設定窓
#
proc setAlphaWindow {} {
  global alphaWindow v t
  if [isExist $alphaWindow] return

  toplevel $alphaWindow
  wm title $alphaWindow $t(setAlphaWindow,title)
  wm attributes $alphaWindow -topmost 1 -toolwindow 1
  bind $alphaWindow <Escape> "destroy $alphaWindow"
  set topg [split [wm geometry .] "x+"]
  set x [expr ([lindex $topg 0] + [lindex $topg 2]) / 2]
  set y [expr ([lindex $topg 1] + [lindex $topg 3]) / 2]
  wm geometry $alphaWindow "+$x+$y"
  wm resizable $alphaWindow 0 0
  scale $alphaWindow.s -variable v(alpha) -orient horiz -from 0.1 -to 1 -res 0.01 -showvalue 1 -command _changeAlpha
  pack $alphaWindow.s
}
proc _changeAlpha {val} {
  wm attributes .           -alpha $val
  wm attributes .entpwindow -alpha $val
}

#---------------------------------------------------
#   F1～F5キーを押したときの処理
#
proc KeyPressF {x y keyName paramName undoMessage {undoCel ""}} {
  global pressedKey recinfo v
  if {$pressedKey == ""
      && $x > $v(yaxisw)
      && $x < [winfo width .]
      && $y > [winfo height $recinfo]
      && $y <= [expr [winfo height $recinfo] + $v(cHeight)]} {
          setCellSelection $v(listSeq) [kind2c $paramName]
          if {$undoCel == ""} {
            pushUndo row $v(listSeq) $undoMessage
          } else {
            pushUndo cel $undoCel    $undoMessage
          }
          set pressedKey $keyName
          setParam $paramName [expr $x - $v(yaxisw) - 6]
  }
}

#---------------------------------------------------
#   F1～F5キーを離したときの処理
#
proc KeyReleaseF {} {
  global pressedKey
  if {$pressedKey != ""} {
    pushUndo agn
    set pressedKey ""
  }
}

#---------------------------------------------------
#   Alt+F1 or Alt+F3キーを押したときの処理
#
proc KeyPressAltF {x y keyName paramName undoMessage} {
  global pressedKey v recinfo
  if {$pressedKey == ""
      && $x > $v(yaxisw)
      && $x < [winfo width .]
      && $y > [winfo height $recinfo]
      && $y <= [expr [winfo height $recinfo] + $v(cHeight)]} {
          setCellSelection $v(listSeq) [kind2c $paramName]
          set lsList [changeRangeForAltF $v(listSeq)]
          set ls1 [lindex $lsList 0]
          set ls2 [lindex $lsList 1]
          pushUndo rct "$ls1,1,$ls2,5" $undoMessage
          set pressedKey $keyName
          if {$paramName == "S"} {
            setParam $paramName [expr $x - $v(yaxisw) - 6] 1
          } else {
            setParam $paramName [expr $x - $v(yaxisw) - 6] 0 1
          }
  }
}
