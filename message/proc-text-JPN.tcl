#--------------------------------
# ※特殊な設定
# 日本語フォントを設定する(ここで設定したフォントを使って以降の文字列を表示させる
#
set t(fontName) "ＭＳ ゴシック"


#--------------------------------
# メッセージ
#

# ダイアログによく出るメッセージ
set t(.confm)        "確認" 
set t(.confm.r)      "読み込む" 
set t(.confm.nr)     "読み込まない"
set t(.confm.fioErr) "ファイルI/Oエラー"
set t(.confm.yes)    "はい"
set t(.confm.no)     "いいえ"
set t(.confm.ok)     "OK"
set t(.confm.apply)  "適用"
set t(.confm.run)    "実行"
set t(.confm.c)      "キャンセル"
set t(.confm.errTitle) "エラー"
set t(.confm.warnTitle) "警告"
set t(.confm.delParam)  "現在の原音パラメータは消去されます。よろしいですか？"
set t(undo)      "アンドゥ"
set t(undo,undo) "取り消し(Ctrl+z)"
set t(undo,redo) "やり直し(Ctrl+y)"

# 保存フォルダにあるwavファイルを読み、リストに記憶する
set t(makeRecListFromDir,q)  "原音パラメータファイル(oto.ini)を読み込みますか？"
set t(makeRecListFromDir,a)  "パラメータを自動的に生成する"

# 起動時にパラメータ自動推定を行う際のウィザード
set t(genParamWizard,title)  "パラメータの自動推定"
set t(genParamWizard,q)      "パラメータを自動推定するなら、処理対象の音声データの種類を選んで下さい。"
set t(genParamWizard,a0)     "単独発声データ(setParamで自動推定)"
set t(genParamWizard,a1)     "単独発声データ(りぶあんで自動推定)"
set t(genParamWizard,a2)     "連続発声データ(setParamで自動推定)"
set t(genParamWizard,ap)     "プラグインで自動推定"

# 初期化ファイルを読み込む
set t(doReadInitFile,errMsg)    "初期設定ファイルを読み込めませんでした"
set t(doReadInitFile,errMsg2)   "初期設定ファイルに書けるのは「set 変数名 {内容}」のみです"

# reclist.txtを保存する
set t(saveRecList,title)     "音名リスト保存"
set t(saveRecList,errMsg)    "\$v(recListFile)に書き込めませんでした"
set t(saveRecList,errMsg2)   "音名を書き込めませんでした"
set t(saveRecList,doneMsg)   "音名リストを\$v(recListFile)に保存しました"

# 音名リストファイルを読み、リストに記憶する
set t(readRecList,title1)    "音名リストを開く"
set t(readRecList,errMsg)    "収録する音名リストファイル(\$v(recListFile))を読み込めませんでした"
set t(readRecList,errMsg2)   "収録音名を読み込めませんでした"
set t(readRecList,doneMsg)   "\$v(recListFile)を読み込みました"

# 発声タイプのリストファイルを読み、リストに記憶する
set t(readTypeList,title)    "発声タイプリストを開く"
set t(readTypeList,errMsg)   "収録する発声タイプリストファイル(\$v(typeListFile))を読み込めませんでした"
set t(readTypeList,errMsg2)  "収録する発声タイプリストを読み込めませんでした"
set t(readTypeList,doneMsg)  "\$v(typeListFile)を読み込みました"

# 保存ディレクトリを指定する
set t(choosesaveDir,title)   "保存フォルダの選択"
set t(choosesaveDir,doneMsg) "保存フォルダを変更しました"
set t(choosesaveDir,q)       "原音パラメータファイル(oto.ini)も読み込みますか？"

# F0計算中にキーボード、マウス入力を制限させるための窓
set t(waitWindow,title)      "F0計算中"

# 既存の右ブランク値の正負を書き換えて統一させる
set t(changeE,title)         "既存の右ブランク値の修正"
set t(changeE,q)             "既存の右ブランク値に負の値が設定されています。変更しますか？"
set t(changeE,a)             "ファイル末尾からの時間に変換する(今の位置をずらさない)"
set t(changeE,a2)            "符号を+にする(今と位置が変わる)"
set t(changeE,a3)            "変更しない"
set t(changeE,q2)            "既存の右ブランク値に0以上の値が設定されています。変更しますか？"
set t(changeE,a21)           "左ブランクからの時間に変換する(今の位置をずらさない)"
set t(changeE,a22)           "符号を-にする(今と位置が変わる)"
set t(changeE,undo)          "右ブランクの正負の変更"

set t(changeE,q,1)           "既存の右ブランク値に負の値が設定されています。変更しますか？"
set t(changeE,a,1)           "ファイル末尾からの時間に変換する(今の位置をずらさない)"
set t(changeE,a2,1)          "符号を+にする(今と位置が変わる)"
set t(changeE,a3,1)            "変更しない"

set t(changeE,q,-1)          "既存の右ブランク値に0以上の値が設定されています。変更しますか？"
set t(changeE,a,-1)          "左ブランクからの時間に変換する(今の位置をずらさない)"
set t(changeE,a2,-1)         "符号を-にする(今と位置が変わる)"
set t(changeE,a3,-1)         "変更しない"

# エイリアス追加登録
set t(aliasComplement,doneMsg)   "num個のエイリアスを追加登録しました"
set t(aliasComplement,doneTitle) "補完終了"
set t(aliasComplement,selMsg)    "併用する連続音oto.ini(原音設定済み)を選択"
set t(aliasComplement,q)         "別フォルダの連続音oto.iniを参照しますか？"
set t(aliasComplement,undo)      "エイリアス補完"

# 「を」が無い場合に「お」で補完
set t(woComplement,doneMsg)   "num個の「を」を補完しました"
set t(woComplement,doneTitle) "補完終了"
set t(woComplement,undo)      "「を」を「お」で補完"

# 保存フォルダ内の全wavファイル名冒頭に_を追加する
set t(addUnderScore,q)       "保存フォルダ内の全wavファイル名の冒頭に「_」を追加します(既に付いている場合は何もしません)。またoto.ini内のファイル名も書き換えます。さらにこの処理はアンドゥできません。よろしいですか？"
set t(addUnderScore,q2)      "保存フォルダ内の全wavファイル名や周波数ファイルの冒頭に「_」を追加します(既に付いている場合は何もしません)。またoto.ini内のファイル名も書き換えます。さらにこの処理はアンドゥできません。よろしいですか？"
set t(addUnderScore,doneMsg) "wavファイル名、oto.iniを変更しました。早めにoto.ini保存することをお勧めします。"
set t(addUnderScore,doneMsg2) "変更対象のファイルがありませんでした。"
set t(addUnderScore,doneMsg3) "wavファイル名その他、oto.iniを変更しました。早めにoto.ini保存することをお勧めします。"
set t(addUnderScore,doneTitle) "完了"

# 保存フォルダ内の全wavファイルをモノラルにする
set t(convertMonoAll,q)         "保存フォルダ内の全wavファイルをモノラル化します。この処理はアンドゥできません。よろしいですか？"
set t(convertMonoAll,doneMsg)   "モノラル化しました。"
set t(convertMonoAll,doneTitle) "完了"

# 保存フォルダ内の全wavファイルのDC成分を一括除去する
set t(removeDCall,q)         "保存フォルダ内の全wavファイルのDC成分を一括除去します。この処理はアンドゥできません。よろしいですか？"
set t(removeDCall,doneMsg)   "DC成分を除去しました。"
set t(removeDCall,doneTitle) "完了"

# 先行発声チェック用の設定窓
set t(uttTimingSettings,title)      "発声タイミングチェックの設定"
set t(uttTimingSettings,click)      "クリック音："
set t(uttTimingSettings,clickTitle) "クリック音の指定"
set t(uttTimingSettings,tempo)      "テンポ："
set t(uttTimingSettings,bpm)        "BPM = "
set t(uttTimingSettings,bpmUnit)    "msec/拍"
set t(uttTimingSettings,clickNum)   "最初に何回クリックを鳴らすか："
set t(uttTimingSettings,clickUnit)  "回"
set t(uttTimingSettings,mix)        "音声とクリックの音量バランス："

# 先行発声チェック用の設定
set t(doUttTimingSettings,errMsg)   "クリック音の回数を20回以下にして下さい。"
set t(doUttTimingSettings,errMsg2)  "クリック音の回数を0回以上にして下さい。"

# 先行発声を試聴
set t(playUttTiming,msg)            "試聴は一度に20音までです。冒頭20個のみ再生します。"
set t(playUttTiming,playMsg)       "発声タイミングチェック開始"
set t(playUttTiming,stopMsg)       "発生タイミングチェック停止"

# 自動収録した連続発声からoto.iniを生成
set t(genParam,title)  "連続発声用oto.ini生成"
set t(genParam,tempo)  "収録テンポ："
set t(genParam,bpm)    "単位： bpm"
set t(genParam,S)      "発声開始位置："
set t(genParam,unit)   "単位："
set t(genParam,haku)   "拍"
set t(genParam,darrow) "↓　↓"
set t(genParam,bInit)  "収録テンポから各値を初期化"
set t(genParam,bInit2) "現在表示中の設定を取得"
set t(genParam,O)      "オーバーラップ："
set t(genParam,msec)   "単位：msec"
set t(genParam,P)      "先行発声："
set t(genParam,C)      "固定範囲："
set t(genParam,E)      "右ブランク：" 
set t(genParam,do)     "パラメータ生成"
set t(genParam,aliasMax)          "※エイリアスが重複した際に通し番号を付けるか"
set t(genParam,aliasMaxNo)        "付けない(重複したままにする)"
set t(genParam,aliasMaxYes)       "付ける"
set t(genParam,aliasMaxNum)       "通し番号の上限(0=無制限)"
set t(genParam,autoAdjustRen)     "自動補正１(パワーベース)を使う"
set t(genParam,vLow)              "先行発声のパワー凹み："
set t(genParam,sRange)            "先行発声の移動可能範囲："
set t(genParam,f0pow)             "※上記以外にF0、パワーに関するパラメータも利用します。"
set t(genParam,db)                "単位：dB"
set t(genParam,autoAdjustRen2)    "自動補正２(MFCCベース,時間がかかる)を使う"
set t(genParam,autoAdjustRen2Opt) "オプション"
set t(genParam,autoAdjustRen2Pattern) "適用対象"
set t(genParam,alias)                 "エイリアスの設定"
set t(genParam,suffix)                "接尾辞："
set t(genParam,aliasRecList)          "エイリアス重複の優先順リスト(reclistまたはoto.ini)："
set t(genParam,aliasReclistTitle)     "エイリアス重複の優先順リストを開く"
set t(genParam,aliasSelect)           "選択"
set t(genParam,aliasReset)            "リセット"
set t(genParam,uscore)                "ファイル名内の'_'に関する処理の設定"
set t(genParam,uscoreIgnore)          "無視する"
set t(genParam,uscoreRest)            "一モーラ分の休符とみなす"
set t(genParam,uscoreDelimiter)       "一モーラの区切り記号とみなす"

# 連続発声のパラメータを自動生成する
set t(doGenParam,doneMsg) "連続音のパラメータを自動推定しました"

# 一覧表の検索窓
# + 一覧表の検索(先頭方向)
# + 一覧表の検索(末尾方向)
set t(searchParam,title)     "検索"
set t(searchParam,search)    "検索"
set t(searchParam,rup)       "先頭へ向けて検索"
set t(searchParam,rdown)     "末尾へ向けて検索"
set t(searchParam,doneTitle) "検索終了"
set t(searchParam,doneMsg)   "見つかりませんでした。"
set t(searchParam,rMatch1)   "完全一致"
set t(searchParam,rMatch2)   "部分一致"

# 再生/停止の切替
set t(togglePlay,stopMsg) "再生停止"
set t(togglePlay,playMsg) "再生中..."

# 色選択
set t(chooseColor,title) "色の選択"

# 波形色設定
set t(setColor,selColor) "色の選択"

# 音名の選択メニューをpackしたフレームを生成
set t(packToneList,play)   "再生"
set t(packToneList,repeat) "リピート再生"

# 初期化ファイルを指定して読み込む
set t(readSettings,title)     "初期化ファイルの選択"

#   現在の設定を保存する
set t(saveSettings,title)  "初期化ファイルの生成"

#   入出力デバイスを設定する窓
set t(ioSettings,title)    "オーディオI/O設定"
set t(ioSettings,inDev)    "入力デバイス："
set t(ioSettings,outDev)   "出力デバイス："
set t(ioSettings,inGain)   "入力ゲイン(デバイスによっては無効)："
set t(ioSettings,outGain)  "出力ゲイン(デバイスによっては無効)："
set t(ioSettings,latency)  "レイテンシ(デバイスによっては無効)："
set t(ioSettings,sndBuffer) "録音のバッファサイズ："
set t(ioSettings,bgmBuffer) "ガイドBGMのバッファサイズ："
set t(ioSettings,comment0) "※本設定窓はなるべくデフォルト(デバイス=Wave Mapper)のままでお使い下さい。"
set t(ioSettings,comment0b) "　 特にデバイスでDirectSoundを選ぶと動作不安定になります(日本語Windows)。"
set t(ioSettings,comment1) "※ 上記設定を変更したら必ず「適用」か「OK」を押してください。"
set t(ioSettings,comment2) "　 押さない限り設定は反映されません。"

# UTAU原音パラメータを自動推定する外部ツールを起動
set t(autoParamEstimation,title)     "外部ツール(パラメータ自動推定)の実行"
set t(autoParamEstimation,aepTool)   "外部ツール"
set t(autoParamEstimation,selTitle)  "外部ツールの指定"
set t(autoParamEstimation,option)    "外部ツール起動時に与える引数"
set t(autoParamEstimation,aepResult) "外部ツールが出力するファイル"
set t(autoParamEstimation,runMsg)    "外部ツールを起動します。"
set t(autoParamEstimation,resultMsg) "外部ツールの実行結果を読み込みます。"

# 単独音のUTAU原音パラメータS,Eを推定する際の設定窓
set t(estimateParam,title)       "原音パラメータの自動推定(単独音用)"
# set t(estimateParam,pFLen)       "パワー抽出間隔"
set t(estimateParam,frameLength) "推定間隔"
set t(estimateParam,preemph)     "プリエンファシス"
set t(estimateParam,pWinLen)     "パワー抽出窓長"
set t(estimateParam,pWinkind)    "窓の種類"
set t(estimateParam,pUttMin)     "発声中のパワー最小値"
set t(estimateParam,vLow)        "母音のパワー最小値"
set t(estimateParam,pUttMinTime) "最短発声時間"
set t(estimateParam,uttLen)      "発声中のパワーの揺らぎ"
set t(estimateParam,silMax)      "無音中のパワー最大値"
set t(estimateParam,silMinTime)  "最短無音時間"
set t(estimateParam,minC)        "子音長(固定範囲)の最小値"
set t(estimateParam,f0)          "※上記以外にF0に関するパラメータも推定に利用します。"
set t(estimateParam,target)      "推定対象"
set t(estimateParam,S)           "左ブランク"
set t(estimateParam,C)           "子音部"
set t(estimateParam,E)           "右ブランク"
set t(estimateParam,P)           "先行発声"
set t(estimateParam,O)           "オーバーラップ"
set t(estimateParam,overWrite)   "現在の原音パラメータを上書きします。よろしいですか？"
set t(estimateParam,runAll)      "全wavに対して実行"
set t(estimateParam,runSel)      "選択範囲に対して実行"
set t(estimateParam,default)     "デフォルト設定に戻す"
set t(estimateParam,ovl)         "オーバーラップの割合"
set t(estimateParam,ovlPattern)  "オーバーラップ推定を行う音"
set t(estimateParam,preEstimate) "以下の各パラメータをwav毎に自動設定"
set t(estimateParam,hpfPattern)  "ハイパスフィルタを使う音"
set t(estimateParam,lpfPattern)  "ローパスフィルタを使う音"
set t(estimateParam,hpfComment)  "(※対象音の冒頭一文字)"
set t(estimateParam,lpfComment)  "(※対象音の冒頭一文字)"
set t(estimateParam,edit)        "編集"

# UTAU原音パラメータの推定
set t(doEstimateParam,startMsg)  "パラメータ推定中… "
set t(doEstimateParam,doneMsg)   "パラメータ推定終了"

# 各パラメータを右上がりゼロクロス位置に移動する際の設定
set t(zeroCross,title)           "各パラメータのゼロクロス補正"
set t(zeroCross,target)          "補正対象"
set t(zeroCross,S)               "左ブランク"
set t(zeroCross,C)               "子音部"
set t(zeroCross,E)               "右ブランク"
set t(zeroCross,P)               "先行発声"
set t(zeroCross,O)               "オーバーラップ"
set t(zeroCross,sec)             "秒"
set t(zeroCross,runAll)          "全wavに対して実行"
set t(zeroCross,runSel)          "選択範囲に対して実行"

# 表示行を変えたときに特定のパラメータに自動フォーカスさせるための設定窓
set t(autoFocus,none)  "フォーカスしない"

# プラグインの実行
set t(runPlugin,undo) "プラグインの実行"

# 原音パラメータを読み込む
set t(readParamFile,selMsg)   "原音パラメータの選択"
set t(readParamFile,startMsg) "原音パラメータを読み込み中..."
set t(readParamFile,errMsg)   "\$v(paramFile)が\$v(saveDir)/下に存在しないwavファイルを参照しています。"
set t(readParamFile,example)  "例："
set t(readParamFile,errMsg2)  "\$v(paramFile)にエントリ行が足りないので追加します。"
set t(readParamFile,doneMsg)  "\$v(paramFile)を読み込みました"

# 原音パラメータを保存する
set t(saveParamFile,selFile)  "原音パラメータの保存"
set t(saveParamFile,startMsg) "原音パラメータを保存中… "
set t(saveParamFile,doneMsg)  "原音パラメータを保存しました"
set t(saveParamFile,confm)    "は既に存在します。上書きしますか？"

# 波形拡大率の変更
set t(changeZoomX,title)      "波形拡大率の数値指定"
set t(changeZoomX,unit)       "(単位=%。100%で画面に波形全体を表示)"
set t(changeZoomX,change)     "変更"

# 詳細設定
set t(settings,title)        "詳細設定"
set t(settings,wave)         "＜波形＞"
set t(settings,waveColor)    "波形の色："
set t(settings,waveScale)    "縦軸最大値(0-32768,0は自動縮尺)"
set t(settings,sampleRate)   "サンプリング周波数(単位=Hz)："
set t(settings,spec)         "＜スペクトル＞"
set t(settings,specColor)    "スペクトルの色："
set t(settings,maxFreq)      "最高周波数(単位=Hz)："
set t(settings,brightness)   "明るさ："
set t(settings,contrast)     "コントラスト："
set t(settings,fftLength)    "FFT長(単位=サンプル)："
set t(settings,fftWinLength) "窓長(単位=サンプル)："
set t(settings,fftPreemph)   "プリエンファシス："
set t(settings,fftWinKind)   "窓の種類"
set t(settings,pow)          "＜パワー＞"
set t(settings,powColor)     "パワー曲線の色："
set t(settings,powLength)    "パワー抽出間隔(単位=秒)："
set t(settings,powPreemph)   "プリエンファシス："
set t(settings,winLength)    "窓長(単位=秒)："
set t(settings,powWinKind)   "窓の種類："
set t(settings,f0)           "＜F0(ピッチ)＞"
set t(settings,f0Color)      "F0曲線の色："
set t(settings,f0Argo)       "抽出アルゴリズム："
set t(settings,f0Length)     "F0抽出間隔(単位=秒)："
set t(settings,f0WinLength)  "窓長(単位=秒)："
set t(settings,f0Max)        "最高F0(単位=Hz)："
set t(settings,f0Min)        "最低F0(単位=Hz)："
set t(settings,f0Unit)       "表示単位："
set t(settings,f0FixRange)   "描画範囲を固定する"
set t(settings,f0FixRange,h) "最大値："
set t(settings,f0FixRange,l) "最小値："
set t(settings,grid)         "各音の線を描画する"
set t(settings,gridColor)    "線の色："
set t(settings,target)       "発声したい音の線を描画する"
set t(settings,targetTone)   "ターゲット音："
set t(settings,targetColor)  "線の色："
set t(settings,autoSetting)  "ターゲットに合わせて他のパラメータを変更："

# キャンバス再描画
set t(Redraw,S) "左"
set t(Redraw,C) "子"
set t(Redraw,P) "先"
set t(Redraw,O) "オ"
set t(Redraw,E) "右"

# ファイルを保存して終了
set t(Exit,q1) "原音パラメータが未保存です。どうしますか？"
set t(Exit,q2) "現在表示されている波形が未保存です。どうしますか？"
set t(Exit,a1)  "上書き保存して終了"
set t(Exit,a1b) "名前を付けて保存して終了"
set t(Exit,a2) "保存せず終了"
set t(Exit,a3) "終了しない"

# 右クリックメニュー
set t(PopUpMenu,showWave)   "波形を表示"
set t(PopUpMenu,showSpec)   "スペクトルを表示"
set t(PopUpMenu,showPow)    "パワーを表示"
set t(PopUpMenu,showF0)     "F0を表示"
set t(PopUpMenu,settings)   "詳細設定"
set t(PopUpMenu,zoomTitle)  "横軸の拡大"
set t(PopUpMenu,zoom0)      "常にwav全体を表示する"
set t(PopUpMenu,zoom100)    "1倍 (wav全体を表示)"
set t(PopUpMenu,zoom1000)   "10倍"
set t(PopUpMenu,zoom5000)   "50倍"
set t(PopUpMenu,zoom10000)  "100倍"
set t(PopUpMenu,zoomMax)    "拡大率最大"
set t(PopUpMenu,changeZoomX) "波形拡大率の数値指定"
set t(PopUpMenu,alwaysOnTop) "常に最前面表示"
set t(PopUpMenu,setAlpha)    "画面を透過する"

# バージョン情報表示
set t(Version,msg) "バージョン情報"

# ParamUを初期化
set t(initParamU,0) "音"
set t(initParamU,1) "左ブランク"
set t(initParamU,2) "overlap"
set t(initParamU,3) "先行発声"
set t(initParamU,4) "固定範囲"
set t(initParamU,5) "右ブランク"
set t(initParamU,6) "エイリアス"
set t(initParamU,7) "コメント"

# 一覧表のタイトルを更新する
set t(setEPWTitle) "原音パラメータ一覧"

# パラメータ一覧表の行を複製する
set t(duplicateEntp,msg)   "複数行を選択した状態では行複製できません。"
set t(duplicateEntp,title) "行複製のエラー"
set t(duplicateEntp,undo)  "行の複製"

# パラメータ一覧表の行を削除する
set t(deleteEntp,msg)   "複数行を選択した状態では行削除できません。"
set t(deleteEntp,title) "行削除のエラー"
set t(deleteEntp,undo)     "行の削除"

# 保存フォルダの各wavの両端を指定秒カット(設定窓)
set t(cutWav,title)    "wavの両端をカット"
set t(cutWav,L)        "冒頭からのカット長"
set t(cutWav,R)        "末尾からのカット長"
set t(cutWav,sec)      "秒"
set t(cutWav,adjSE)    "カット後に左右ブランク値を補正してパラメータ位置がずれないようにする\n(ただしブランク値よりも長くカットした場合はずれます)"

# 保存フォルダの各wavの両端を指定秒カット
set t(doCutWav,q)         "保存フォルダ内の全wavファイルから両端をカットします。この処理を行うとこれまでのアンドゥの履歴が消去されます。よろしいですか？"
set t(doCutWav,doneMsg)   "各wavの両端をカットしました"
set t(doCutWav,doneTitle) "完了"
set t(doCutWav,errMsg)   "カットする秒数は0以上の数にして下さい"

# wavの左右カットを有効にするか確認する
set t(cutBlankConfirm,q) "wavカット機能(F9キー)を有効にします。なおカット処理を行う度にそれまでのアンドゥの履歴は消去されます。よろしいですか？"

# エイリアス一括変換
set t(changeAlias,title)      "エイリアス一括変換"
set t(changeAlias,trans)      "変換規則："
set t(changeAlias,delPreNum)  "現在のエイリアス冒頭から削除する文字数"
set t(changeAlias,delPostNum) "現在のエイリアス末尾から削除する文字数"
set t(changeAlias,tips0)      "%m = 各欄の音名（例：「あ」や「a い」）"
set t(changeAlias,tips0b)     "%s = 各欄の接尾辞（例：「あ強」の「強」）"
set t(changeAlias,tips1)      "%a = 各エイリアス欄に既に入力されている文字列"
set t(changeAlias,tips2)      "%f = 各欄のファイル名(拡張子は除く)"
set t(changeAlias,tips3)      "%r = 重複する音の通し番号"
set t(changeAlias,ex1)        "(補足)%mと%sは、各エイリアス欄に文字列が入っている場合はそちらから文字列を抽出します\n（そうでない場合はファイル名から抽出します）。"
set t(changeAlias,aliasMaxNum)       "%rの上限値(上限を超えたエントリは削除する。0=上限なし)"
set t(changeAlias,runAll)     "全wavに対して実行"
set t(changeAlias,runSel)     "選択範囲に対して実行"
#set t(changeAlias,ex1)        "(例1)「あ.wav」を「あ強」にするなら変換規則を「%m強」か「%f強」とし、他を空欄にする。"
#set t(changeAlias,ex2)        "(例2)「あ強」を「あ」にするなら変換規則を「%a」とし、「～末尾から削除する文字数」を1にする。"

# ustファイルを読んで編集対象リストを作る
set t(readUstFile,doneMsg)     "ustファイルを読み込みました"
set t(readUstFile,startMsg)    "指定したustを読み込み、それを歌わせるために必要なデータを絞り込みます。"
set t(readUstFile,modeComment) "対象データにコメント追記"
set t(readUstFile,comment)     "挿入文字列："
set t(readUstFile,modeDelete)  "対象外データを削除"
set t(readUstFile,errMsg)      "リストを構成できませんでした。原音パラメータの読み込みからやり直してください。"
set t(readUstFile,undo)        "編集対象の絞り込み"
set t(readUstFile,limit)       "重複数の上限(0=無制限)"

# 発声タイミング補正モード
set t(timingAdjMode,startMsg) "発声タイミング補正モードをONにします。右ブランク値の表現方法、先行発声を動かしたときのふるまいを適宜設定し直して下さい。"
set t(timingAdjMode,doneMsg)  "発声タイミング補正モードを解除します。"
set t(timingAdjMode,on)       "発声タイミング(先行発声)補正モードON"
set t(timingAdjMode,off)      "発声タイミング(先行発声)補正モードOFF"

# 画面クリックで範囲指定再生
set t(clickPlayRangeMode,errMsg) "本機能を有効にするには発声タイミング補正モードを無効にして下さい。"

# 選択中の欄の値を変更する
set t(changeCell,title)   "選択範囲のデータ一括変更"
set t(changeCell,r1)      "加算"
set t(changeCell,r2)      "減算"
set t(changeCell,r3)      "セット"
set t(changeCell,r4)      "整数化"
set t(changeCell,l)       "内容："
set t(changeCell,rtitle)  "＜選択範囲を以下の条件で更に制限＞"
set t(changeCell,rr1)     "制限なし"
set t(changeCell,rr2)     "一致"
set t(changeCell,rr3)     "以上"
set t(changeCell,rr4)     "以下"
set t(changeCell,rl)      "制限値："

# 新たに原音パラメータを読み込んで読み込み済みのものにマージする
#set t(mergeParamFile,delParam) "現在のパラメータの一部あるいは全部が上書きされます。よろしいですか？"
set t(mergeParamFile,selMsg)   "パラメータファイル(oto.ini)の選択"
set t(mergeParamFile,startMsg) "マージします"
set t(mergeParamFile,doneMsg)  "マージしました"

# 範囲指定再生の設定
set t(setPlayRange,title)  "範囲指定再生の設定"
set t(setPlayRange,start)  "再生開始位置"
set t(setPlayRange,end)    "再生終了位置"
set t(setPlayRange,head)   "ファイル先頭"
set t(setPlayRange,tail)   "ファイル末尾"
set t(setPlayRange,guide)  "※Ctrl+tで指定範囲を再生"

# 定期バックアップ機能
set t(autoBackup,q)     "バックアップファイルが見つかりました。前回異常終了した可能性があります。データを復旧させる場合はsetParam.exeと同フォルダにあるbackup.iniを音源フォルダに手動で移動してご利用下さい。"
set t(autoBackup,a1)    "setParamを終了する"
set t(autoBackup,a2)    "backup.iniを削除し、作業を続行する"

# クリップボード貼り付け
set t(pasteCell,q1)     "コピー元と貼り付け先との領域サイズが異なります。貼り付けますか？"
set t(pasteCell,undo)   "貼り付け"


# 拍単位の時間軸用の設定窓
set t(setBPMWindow,title)  "時間軸の設定"
set t(setBPMWindow,tempo)  "テンポ="
set t(setBPMWindow,offset) "オフセット="
set t(setBPMWindow,sec)    "(秒)"

# 原音パラメータを数値入力で変更する
set t(changeParam,undo) "セル入力"

# 原音パラメータをマウスで変更する
set t(setParam,undoS) "左ブランクの移動"
set t(setParam,undoC) "固定範囲の移動"
set t(setParam,undoE) "右ブランクの移動"
set t(setParam,undoP) "先行発声の移動"
set t(setParam,undoO) "オーバーラップの移動"

# 合成テスト
set t(synWindow,title)     "合成テストの設定"
set t(synWindow,syn)       "合成エンジン："
set t(synWindow,synSelect) "合成エンジンの選択"
set t(synWindow,setPitch)  "音の高さ："
set t(synWindow,setLength) "音の長さ(ミリ秒)："
set t(synWindow,setFlag)   "フラグ(default=空欄)："
set t(synWindow,setVolume) "音量(default=100)："
set t(synWindow,setMod)    "モジュレーション(default=0)："
set t(synWindow,setCSpeed) "子音速度(default=100)："
set t(playSyn,errMsg)      "合成エンジンが指定されていません"

# アンドゥスタックを初期化する
set t(clearUndo,q)         "この処理を行うとアンドゥ用の履歴が初期化されます。よろしいですか？"

# 透過率の設定
set t(setAlphaWindow,title)  "透過設定"

# プラグインモード
set t(utaup_readUst,err1) "ファイルを開けませんでした"
set t(utaup_readUst,err2) "設定対象情報の取得に失敗しました"
set t(utaup_readUst,err3) "ustファイルを保存した上でsetParamを起動して下さい"
set t(utaup_readUst,err4) "ファイル書き込み失敗"
set t(utaup_readUst,err5) "プラグインモードでの起動に失敗しました。設定対象wavが見つかりませんでした"
set t(utaup_updateTargetParamFile,err1) "oto.iniの更新に失敗しました"
