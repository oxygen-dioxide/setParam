#!/bin/sh
# the next line restarts using wish \
exec /cygdrive/c/Tcl/bin/wish "$0" "$@"

# 2.0-b101009
# - アンドゥ関係のキーバインドを追加。
# - オプションメニューに、F9(左右ブランク両端をカット)のON/OFFを追加。

# 2.0-b100724　？
# - メニューに初期化ファイルの読み込みを追加した
# - パラメータ描画を高速化した(波形等の再描画をスキップするようにした)

# 2.0-b100410
# - メイン窓から編集メニューを削除し、一覧表の右クリックメニューを追加した
# - 波形拡大縮小(縦方向をShift-ホイールからControl-Shift-ホイールに変更した
# - Shift-ホイールで横スクロールするようにした
# - 波形描画キャンパスcと縦軸表示キャンバスcYaxisとに分けた
# - 波形画面の各データの縦幅をマウスでリサイズできるようにした
# - メイン窓幅をマウスでリサイズできるようにした

# 2.0-b100204
# - 原音パラメータのマージを追加(mergeParamFile)
# - 選択中の範囲の値を一括変更(ctrl-mまたは編集メニューから実行)
# - スタートアップファイルの優先順を変更(コマンドラインオプションを優先)。

# 2.0-b091205
# - アイコンにD&Dされた場合の処理
# - 発声タイミング補正モードを追加
# - メニューにust読み込みを追加
# - メニューに先行発声を動かした場合の設定を追加
# - マウスで位置設定を行う場合のふるまいを修正
#   (Alt-F1押→Alt離のときにAlt-F1の状態を保つように修正)

# 2.0-b091104
# - キーバインド追加。F8, 先行発声チェック試聴
# - オプションメニューに先行発声チェック設定を登録
# - 自動収録した連続音のパラメータ生成をツールメニューに登録
# - メニュー表記を一部変更("単独音用"or"連続音用"を明記)

# 2.0-b091007
# - 以前作った左右ブランクの自動推定をツールメニューに登録

# 2.0-b090903
# - F0が表示されないバグを修正。
# - キーバインド(波形画面)
#   - 変更: F1-F5, 押している間は各パラメータがマウス位置に追随
#   - 追加: Alt-F1, 同wavファイル内の全右ブランク位置を変える
#   - 追加: Alt-上下矢印, 前後のwavファイルへ
#   - 追加: マウスホイール, 前後の音へ
# - キーバインド(一覧表)
#   - 変更：ctrl+f, 右移動→検索に変更
#   - 追加：ctrl+h, ctrl+j, ctrl+k, ctrl+l, 移動(viライク)
#   - 追加：ctrl+g, 次を検索
#   - 追加：Shift+Tab 左のセルへ
#   - 追加: Alt-上下矢印, 前後のwavファイルへ
# - 編集メニューを追加。
#   - コピー、貼り付け、検索、次を検索、前を検索

# 2.0-b090822
# - オプションメニューに左ブランク値のふるまいの切り替えを追加
# - オプションメニューに右ブランク値のふるまいの切り替えを追加
# - ファイルメニューに現在の設定保存を追加

# 2.0-b090803
# - ツールメニューにDC成分一括除去を追加
# - ツールメニューにwavファイル名変更（冒頭に"_"を付ける)を追加
# - バインド修正。一覧表での再生をspace→ctrl+p, ctrl+space→ctrl+alt+pに変更
# - バインド追加。波形表示での再生で、ctrl+p, ctrl+alt+pも使えるよう追加
# - ガイドBGMのmid配布

# 2.0-b090727
# - バインド修正。shift+矢印での範囲指定時のエラーを修正。
# - マウスで範囲指定する際に、リリース時のセルがアクティブになるよう変更。

# 2.0-b090720
# - 1つのwavファイルに対して複数の原音設定があるoto.iniに対応した
# - 一覧表での行の複製、削除を実装した
# - 一覧表でspace,ctrl-spaceを有効にした
# - 一覧表を閉じるとsetParamを終了するようにした
# - 一覧表でspace,ctrl-spaceを有効にした
# - アクティブセルの色を濃い灰色にした

# 2.0-b090706
# - oremo本体は原音パラメータ関係のものを消し、収録に特化したものにした
# - 原音パラメータ関係はsetParamにまとめた
# - サブルーチンは proc.tcl にまとめた

# 2.0-b090613
# - 原音パラメータの読み込み/保存：上書き確認。ファイル名指定可にした
# - 原音パラメータを読み込んだら表示中の画面に即反映させるようにした
# - ファイルメニューの文を変更("oto.ini"→"原音パラメータ")

# 2.0-b090611
# - ファイルメニュー追加：音名リストの読み込み/保存、発声タイプの読み込み
# - 起動時にreclist.txt、typelist.txtが無い場合にダイアログを表示
# - コマンドラインからの起動時の第一引数で保存フォルダを指定
# - 波形再読み込み(cにキーバインド)

# 2.0-b090506
# oto.iniの読み込み

# 2.0-b090213
# - 音叉機能の機能向上(リピート再生、キーバインド割り当て)
# - 原音設定（手動設定(F1-F7にキーバインド)）
# - 原音設定（自動設定。左右ブランクのみ）
# - 原音設定（ファイル保存。oto.iniにパラメータを保存）
# - 動作モード切替（録音機能ON/OFF、原音設定機能ON/OFF）
# - 音名リスト取得（保存フォルダにあるwavファイルから音名リストを構成可能）
# - 画面構成変更（収録音がそこそこ長い文字列になっても表示可能に）
# - その他

package require -exact snack 2.2
#if {$::tcl_platform(platform) == "windows"} {
#  ttk::style theme use clam ;#xpnative
#}

package require Tktable
package require -exact tkdnd 2.8

source -encoding utf-8 [file join [file dirname [info script]] proc-setParam.tcl]         ;# サブルーチン読み込み
source -encoding utf-8 [file join [file dirname [info script]] globalVar.tcl]    ;# 大域変数読み込み
source -encoding utf-8 [file join [file dirname [info script]] proc-plugin.tcl]         ;# サブルーチン読み込み

#---------------------------------------------------
# main - メインルーチン (初期化)

set sv(appname) setParam
set sv(version) 4.0-b190504         ;# ソフトのバージョン番号
#set v(aepTool) "$topdir/plugins/utau_lib_analyze110/utau_lib_analyze.exe"
#set v(aepArg)  ""
set v(aepResult) "" ;# autoParamEstimationで上書きされる
set v(aepParamFile) "$topdir/plugins/inParam.txt"  ;# プラグインに渡すパラメータファイル
set v(listSeq) 1     ;# 一覧表の現在の行番号を入れる
set v(listC)   1     ;# 一覧表の現在の列番号を入れる
set v(labAlias) ""   ;# 現在のエイリアスを波形窓に表示する
set v(paramFile) "$v(saveDir)/oto.ini"   ;# 原音パラメータファイル
set v(openedParamFile) ""                ;# load/saveしたファイル名を保存する
set v(setE) 1   ;# 1=右ブランク値をファイル末尾からの相対値にする。-1=左blankからの相対値にする
set v(_setE) 1  ;# v(setE)の補助的な変数。
set v(setS) 1   ;# 1=左ブランク値を変えたときに他の数値を変える(絶対位置は変わらない)。0=他の数値は変えない(絶対位置は変わり相対位置は変わらない)
set v(setP) 1   ;# 1=先行発声値を変えたときに他のパラメータ値を変更しない。0=変更量と同じだけ他パラメータも動かし、相対的な位置関係を保つ。
set v(sdirection) 1 ;# 検索する方向。1=下。0=上。
set v(sMatch)  full ;# 検索方法。full=完全一致、sub=部分一致
set v(keyword) ""   ;# 検索キーワード
set v(timingAdjMode) 0   ;# 1=連続発声タイミング補正をマウスのみで行う
set v(cutBlank) 0        ;# 1=F9を押すと左右ブランクの両側をカットする
set startup(readRecList) 0
set startup(makeRecListFromDir) 1
set startup(choosesaveDir) 1
set startup(autoReadParamFile) 0
set startup(initFile)     $topdir/$sv(appname)-init.tcl    ;# 通常ユーザがカスタマイズ内容を保存するファイル
set startup(sysIniFile)   $topdir/$sv(appname)-setting.ini ;# フォルダ使用履歴などをシステムが保存するファイル
set startup(textFile)     $topdir/message/$sv(appname)-text-CHS.tcl
set startup(procTextFile) $topdir/message/proc-text-CHS.tcl
set paramUsize 0
set paramUsizeC 8
set v(minusO) 0     ;# 1=オーバーラップを負にしてもよい
set v(blankBroom) 1 ;# 1=左右ブランクの移動範囲を他パラメータより優先する

# メッセージファイルを読む
foreach fn $startup(textFiles) {
  if {[file exists $fn]} {
    doReadInitFile $fn
  } else {
    tk_messageBox -message "can not find textFile ($fn)" \
      -title "Error" -icon error
    exit
  }
}

# スタートアップを読む
if {[file exists $startup(initFile)]} {
  doReadInitFile $startup(initFile)
}

# 引数チェック
# memo: oremo.tcl -- -option とするのが無難。--がないとwishのオプションと思われる様子
set i 0
while {$i < $argc} {
  set opt [lindex $argv $i]
 
  switch $opt {
    "-saveDir" {
      incr i
      set v(saveDir) [lindex $argv $i]
    }
    "-script" {
      incr i
      set startup(initFile) [lindex $argv $i]
    }
    default {
      ;# アイコンにD&Dされたとき、プラグインとして起動した時の対応
      set opt [encoding convertfrom $opt]  ;# tcl/tk内部コード(utf-8)にする
      set opt [file normalize $opt]
      if [file isdirectory $opt] {                          ;# フォルダのD&D
        set v(saveDir) $opt
        set startup(choosesaveDir) 0
      } elseif [regexp -nocase -- {\.ini$} $opt] {          ;# iniファイルのD&D
        set v(saveDir) [file dirname $opt]
        set v(paramFile) $opt
        set startup(autoReadParamFile) 1
      } elseif [regexp -nocase -- {\.(ust|tmp)$} $opt] {    ;# プラグイン起動時に渡されるファイル(ust|tmp)のD&D
        utaup_readUst $opt
      } elseif [file isdirectory [file dirname $opt]] { ;# それ以外のファイル
        set v(saveDir) [file dirname $opt]
        set startup(choosesaveDir) 0
      } else {
        puts "error: invalid option: $opt"
        usage
      }
    }
  }
  incr i
}

audioSettings ;# オーディオデバイス関連の初期化
fontSetting   ;# 日本語フォントを設定する
setSinScale   ;# 平均律の各音階の周波数を求める

#---------------------------------------------------
#
# 窓の設定
#
snack::createIcons    ;# アイコンを使用する

# 0. 収録中の音名を表示するフレーム
set recinfo [frame .recinfo]
grid  $recinfo -row 0 -columnspan 2 -sticky nw

# 0-1. 収録中の音を表示するフレーム
frame $recinfo.showCurrent
grid  $recinfo.showCurrent -sticky nw
label $recinfo.showCurrent.lr -textvar v(recLab)  \
  -font bigkfont -fg black -bg white
label $recinfo.showCurrent.lt -textvar v(typeLab) \
  -font bigkfont -fg black -bg white
label $recinfo.showCurrent.la -textvar v(labAlias) \
  -font bigkfont -fg black
pack $recinfo.showCurrent.lr $recinfo.showCurrent.lt $recinfo.showCurrent.la \
  -side left -fill x -expand 1 -anchor center

# 1. 設定関係のフレーム
set s [frame .s]
#grid  $s -row 1 -column 0 -sticky nw

# 1-1. 音名のリストボックス
frame $s.listboxes
#grid  $s.listboxes -sticky nw
set rec [listbox $s.listboxes.rec -listvar v(recList) -height 10 -width 5 \
  -bg $v(bg) -fg $v(fg) \
  -font kfont \
  -yscrollcommand {$srec set} \
  -selectmode single -exportselection 0]
set srec [scrollbar $s.listboxes.srec -command {$rec yview}]
#pack $rec $srec -side left -fill both -expand 1
#$rec selection set $v(recSeq)

# 1-2. 発声タイプのリストボックス
set type [listbox $s.listboxes.type -listvar v(typeList) -height 10 -width 4 \
  -bg $v(bg) -fg $v(fg) \
  -font kfont \
  -yscrollcommand {$stype set} \
  -selectmode single -exportselection 0]
set stype [scrollbar $s.listboxes.stype -command {$type yview}]
#pack $type $stype -side left -fill both -expand 1
#$type selection set $v(typeSeq)

# 2. 波形やスペクトルなどの図、保存フォルダなどを表示するフレーム
frame .fig
grid  .fig -row 1 -column 0 -sticky nw

# 2-1. 波形などを表示するフレーム
set wscrl [scrollbar .fig.xscrl -orient horizontal -command {$c xview}]
set v(cWidth)  [expr $v(winWidth) - [winfo width $s] -47] ;# XPで開発していた時は-4だった
set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
set c [canvas .fig.c -width $v(cWidth) -height $v(cHeight) \
  -bg $v(bg) \
  -xscrollcommand "$wscrl set"
]
set cYaxis [canvas .fig.cYaxis -width $v(yaxisw) -height $v(cHeight) \
  -bg $v(bg) \
]
grid $c      -row 0 -column 1 -sticky nw
grid $cYaxis -row 0 -column 0 -sticky nw
grid $wscrl  -row 1 -column 1 -sticky we
$c xview moveto 0

# 3. 収録中の音を保存するディレクトリを表示するフレーム
frame .saveDir
grid  .saveDir -row 2 -columnspan 2 -sticky new
label .saveDir.midashi -text $t(.saveDir.midashi) -fg $v(fg) -bg $v(bg)
button .saveDir.dir -textvar v(saveDir)  \
  -fg $v(fg) -bg $v(bg) -relief solid \
  -command {
    if [choosesaveDir] {
      makeRecListFromDir 1 ;# 保存フォルダからリストを生成する
      resetDisplay
      setCellSelection
    }
  }
button .saveDir.sel -image snackOpen -highlightthickness 0 -bg $v(bg) \
  -command {
    if [choosesaveDir] {
      makeRecListFromDir 1 ;# 保存フォルダからリストを生成する
      resetDisplay
      setCellSelection
    }
  }
if {[array names ustData "pluginMode"] == ""} {
  ;# 非プラグインモードの時に表示する
  pack .saveDir.midashi -side left
  pack .saveDir.dir -side left -fill x -expand 1
  pack .saveDir.sel -side left
}

;#tabを押してこれらのウィジェットにフォーカスを当てると
;#$cでF1などのキーバインドが効かなくなるのでフォーカスが当たらないようにする
bind .saveDir.dir <FocusIn> {focus .}
bind .saveDir.sel <FocusIn> {focus .}

# 4. メッセージを表示するフレーム
frame .msg
grid  .msg -row 3 -columnspan 2 -sticky new
pack [label .msg.msg -textvar v(msg) -relief sunken -anchor nw] -fill x

# 5. 詳細設定用などの窓
set swindow .settings
set cmwindow .changeMode
set epwindow .epwindow
set aepwindow .aepwindow
set entpwindow .entpwindow
set ioswindow .iosettings
set searchWindow .search
set genWindow .genParam
set prgWindow .progress
set playRangeWindow .playRangeWindow
set zcwindow .zerocross
set gpWindow .gpWindow
set bpmWindow .bpmWindow
set synWindow .synWindow
set afwindow .afwindow
set changeZoomWindow .changeZoomWindow 
set ruWindow .ruWindow
set alphaWindow .alphaWindow

wm protocol . WM_DELETE_WINDOW Exit
wm title . "$sv(appname) $sv(version)"
wm resizable . 0 0
wm attributes . -alpha $v(alpha)

makeEntParamWindow

#---------------------------------------------------
# バインド
bind . <Down>            nextList
bind . <KeyPress-2>      nextList
bind . <KeyPress-j>      nextList
bind . <KeyPress-s>      nextList
bind . <Alt-Down>        nextWav
bind . <Up>              prevList
bind . <KeyPress-8>      prevList
bind . <KeyPress-k>      prevList
bind . <KeyPress-w>      prevList
bind . <Alt-Up>          prevWav
bind . <Right>           { $c xview scroll  1 unit }
bind . <KeyPress-6>      { $c xview scroll  1 unit }
bind . <KeyPress-l>      { $c xview scroll  1 unit }
bind . <KeyPress-d>      { $c xview scroll  1 unit }
bind . <Left>            { $c xview scroll -1 unit }
bind . <KeyPress-4>      { $c xview scroll -1 unit }
bind . <KeyPress-a>      { $c xview scroll -1 unit }
bind . <KeyPress-h>      { $c xview scroll -1 unit }
bind . <KeyPress-q>      { $c xview moveto 0 }
#bind . <Control-Down>        { nextRec  -save 0 }
#bind . <Control-KeyPress-2>  { nextRec  -save 0 }
#bind . <Control-Up>          { prevRec  -save 0 }
#bind . <Control-KeyPress-8>  { prevRec  -save 0 }
#bind . <Control-Right>       { nextType -save 0 }
#bind . <Control-KeyPress-6>  { nextType -save 0 }
#bind . <Control-Left>        { prevType -save 0 }
#bind . <Control-KeyPress-4>  { prevType -save 0 }
bind . <Control-space>       playFromStoE
bind . <Control-Alt-p>       playFromStoE
bind . <Control-F1>          {playRange 1}
bind . <Control-F2>          {playRange 2}
bind . <Control-F3>          {playRange 3}
bind . <Control-F4>          {playRange 4}
bind . <Control-F5>          {playRange 5}
bind . <space>               togglePlay
bind . <Control-p>           togglePlay
bind . <KeyPress-5>          togglePlay
bind . <KeyPress-c>          {     ;# 波形再読み込み
  set power(fid) ""
  set f0(fid) ""
  readWavFile
  Redraw all
}
bind . <KeyPress-F8>         playUttTiming ;# 先行発声チェック試聴
bind . <KeyPress-F9>         cutBlank      ;# 左右ブランクの両側をカット
bind . <KeyPress-F10>        playSyn       ;# 合成音試聴

bind . <KeyPress-F6> nextList
bind . <KeyPress-F7> prevList
bind . <Control-F6>  nextList
bind . <Control-F7>  prevList
bind . <Alt-F6>      nextWav
bind . <Alt-F7>      prevWav

if {[array names ustData "pluginMode"] == ""} {
  # 通常(非プラグインモード)のとき
  bind . <Control-s>       {saveParamFile $v(paramFile)}
  bind . <Control-Shift-s> saveParamFile
  bind . <Control-o>      {readParamFile; resetDisplay}
}
bind . <Alt-F4>  Exit
bind . <Control-f>        searchParam
bind . <Control-g>        {doSearchParam 1}
bind . <Control-n>        {doSearchParam 1}
bind . <Control-G>        {doSearchParam 0}
bind . <Control-N>        {doSearchParam 0}

#bind . <Control-z>        undoParam
#bind . <Control-Z>        redoParam
#bind . <Control-y>        redoParam
#bind . <Control-w>        setUndoPoint
bind . <Control-z>     undo
bind . <Control-y>     redo
bind . <Control-Z>     redo
bind . <Control-Alt-@>    autoAdjustRen2sel  ;# 手動でMFCC補正ツールを実行
bind . <KeyPress-P> {
  if {$v(setP) == 0} {
    set v(setP) 1
  } else {
    set v(setP) 0
  }
  RedrawParam
}
bind . <KeyPress-L> {
  if {$v(setS) == 0} {
    set v(setS) 1
  } else {
    set v(setS) 0
  }
  RedrawParam
}

;# プラグインメニューのショートカット
if {[array names ustData "pluginMode"] == ""} {
  # 通常(非プラグインモード)のとき
  bind . <KeyRelease-n> {catch {tk_popup $rclickMenuA %X %Y}}
}

;# F1～F5のキーバインド
set pressedKey ""
bind . <KeyRelease-F1> KeyReleaseF
bind . <KeyRelease-F2> KeyReleaseF
bind . <KeyRelease-F3> KeyReleaseF
bind . <KeyRelease-F4> KeyReleaseF
bind . <KeyRelease-F5> KeyReleaseF
bind . <F1> { KeyPressF %x %y f1 S $t(setParam,undoS) }
bind . <F2> { KeyPressF %x %y f2 O $t(setParam,undoO) "$v(listSeq),2" }
bind . <F3> { KeyPressF %x %y f3 P $t(setParam,undoP) }
bind . <F4> { KeyPressF %x %y f4 C $t(setParam,undoC) "$v(listSeq),4" }
bind . <F5> { KeyPressF %x %y f5 E $t(setParam,undoE) }
bind . <Alt-F1> { KeyPressAltF %x %y F1 S $t(setParam,undoS) }
bind . <Alt-F3> { KeyPressAltF %x %y F3 P $t(setParam,undoP) }
$c bind Sl <ButtonPress-1> {
  if {$pressedKey == ""} {
    setCellSelection $v(listSeq) [kind2c S]
    pushUndo row $v(listSeq) $t(setParam,undoS)
    set pressedKey "f1"
    setParam S [expr %x - 2]
  }
}
$c bind Ol <ButtonPress-1> {
  if {$pressedKey == ""} {
    setCellSelection $v(listSeq) [kind2c O]
    pushUndo cel "$v(listSeq),2" $t(setParam,undoO)
    set pressedKey "f2"
    setParam O [expr %x - 2]
  }
}
bind $c <ButtonPress-1> {
  ;# 左ボタンでF3キー押とするモードであれば。
  if {$v(timingAdjMode)
      && $pressedKey == ""
      && %y > [winfo height $recinfo]
      && %y <= [expr [winfo height $recinfo] + $v(cHeight)]} {
          setCellSelection $v(listSeq) [kind2c P]
          pushUndo row $v(listSeq) $t(setParam,undoP)
          set pressedKey "f3"
          setParam P [expr %x - 2]
  } else {
    if {$v(clickPlayRangeMode) == 0} break  ;# 画面クリックで近傍パラメータ間再生を行わないならskip
    if {$pressedKey != ""} break    ;# パラメータ名をクリックしていたなら本処理を実行させない
    clickPlayRange %x    ;# 発声タイミング補正モードでない場合は、範囲指定再生を行う。
  }
}
$c bind Pl <ButtonPress-1> {
  if {$pressedKey == ""} {
    setCellSelection $v(listSeq) [kind2c P]
    pushUndo row $v(listSeq) $t(setParam,undoP)
    set pressedKey "f3"
    setParam P [expr %x - 2]
  }
}
# 発声タイミング補正モードでの操作
bind $c <Alt-Button-1>      {
  ;# 左ボタンでF3キー押とするモードであれば。
  if {$v(timingAdjMode)
      && %y > [winfo height $recinfo]
      && %y <= [expr [winfo height $recinfo] + $v(cHeight)]} {
          setCellSelection $v(listSeq) [kind2c P]
          set lsList [changeRangeForAltF $v(listSeq)]
          set ls1 [lindex $lsList 0]
          set ls2 [lindex $lsList 1]
          pushUndo rct "$ls1,1,$ls2,5" $t(setParam,undoP)
          set pressedKey "F3"
          setParam P [expr %x - 2] 0 1
  }
}

$c bind Cl <ButtonPress-1> {
  if {$pressedKey == ""} {
    setCellSelection $v(listSeq) [kind2c C]
    pushUndo cel "$v(listSeq),4" $t(setParam,undoC)
    set pressedKey "f4"
    setParam C [expr %x - 2]
  }
}

$c bind El <ButtonPress-1> {
  if {$pressedKey == ""} {
    setCellSelection $v(listSeq) [kind2c E]
    pushUndo row $v(listSeq) $t(setParam,undoE)
    set pressedKey "f5"
    setParam E [expr %x - 2]
  }
}

bind $c <Motion> {
  set x [expr %x - 2]
  switch $pressedKey {
    f1 {setParam S $x}     ;# F1なら
    F1 {setParam S $x 1}   ;# Alt-F1なら
    f2 {setParam O $x}     ;# F2なら
    f3 {setParam P $x}     ;# F3なら
    F3 {setParam P $x 0 1} ;# Alt-F3なら
    f4 {setParam C $x}     ;# F4なら
    f5 {setParam E $x}     ;# F5なら
    default { changeMouseCursor %y }
  }
}
bind $cYaxis <ButtonRelease-1> { ;# 時間軸の単位変更
  if {%y >= [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]} {
    if {$v(timeUnit) == "Bar"} {
      set v(timeUnit) "Sec."
    } else {
      set v(timeUnit) "Bar"
    }
    Redraw scale
  }
}
bind $cYaxis <ButtonRelease-3> { ;# 時間軸の設定
  setBPMWindow
}
bind . <FocusOut> { ;# キーを押しているときにフォーカスが外れたときの処理
  if {$pressedKey != ""} {
    pushUndo agn
    set pressedKey ""
  }
}

# リストボックスのマウス操作
#bind $rec  <<ListboxSelect>> { jumpRec  [$rec  curselection] }
#bind $type <<ListboxSelect>> { jumpType [$type curselection] }
#bind $rec  <Control-1>       { jumpRec  [$rec  nearest %y] -save 0}
#bind $type <Control-1>       { jumpType [$type nearest %y] -save 0}

# コンソールの表示
bind . <Control-Alt-d> {
  if {$conState} {
    console hide
    set conState 0
  } else {
    console show
    set conState 1
  }
}

# リストボックスでのホイールスクロール
#bind $rec <Enter>   {+set scrollWidget %W}
#bind $rec <Leave>   {+set scrollWidget ""}
#bind $srec <Enter>  {+set scrollWidget $rec}
#bind $srec <Leave>  {+set scrollWidget ""}
#bind $type <Enter>  {+set scrollWidget %W}
#bind $type <Leave>  {+set scrollWidget ""}
#bind $stype <Enter> {+set scrollWidget $type}
#bind $stype <Leave> {+set scrollWidget ""}
#bind . <MouseWheel> {+listboxScroll $scrollWidget %D}

# マウスホイール
bind . <MouseWheel> {
  if {[winfo height $recinfo] < %y && %y < [expr [winfo height $recinfo] + $v(cHeight) - $v(timeh)]} {
    # 前後の音へ
    if {%D > 0} {
      prevList
    } else {
      nextList
    }
  } else {
    # 波形を横スクロール
    if {%D > 0} {
      $c xview scroll -1 unit
    } else {
      $c xview scroll 1 unit
    }
  }
}
bind . <Alt-MouseWheel> {
  # 前後のwavへ(連続音向け)
  if {%D > 0} {
    prevWav
  } else {
    nextWav
  }
}

# 横スクロール
bind . <Shift-MouseWheel> {
  if {%D > 0} {
    $c xview scroll -1 unit
  } else {
    $c xview scroll 1 unit
  }
}


# 波形横方向拡大縮小 
bind . <Control-MouseWheel> {
  if {%x > [expr [winfo width $s] + $v(yaxisw)]} {
    if {%D > 0} {
      changeWidth 1 [expr %x - $v(yaxisw) - 6] ;# 上回転で拡大
    } else {
      changeWidth 0 [expr %x - $v(yaxisw) - 6] ;# 縮小
    }
  }
}
bind . <F11> { changeWidth 0 [expr %x - $v(yaxisw) - 6]}  ;# 縮小
bind . <F12> { changeWidth 1 [expr %x - $v(yaxisw) - 6]}  ;# 拡大

# 波形拡大縮小(縦方向, Control-Shift+マウスホイール)
bind . <Control-Shift-MouseWheel> {
  if {%y > [winfo height $recinfo] && %x > [winfo width $s]} {
    # マウスが波形画面上にある場合
    if {%D > 0} {
      set inc -20    ;# 上向き回転
    } else {
      set inc +20    ;# 下向き回転
    }
    set my [expr %y - [winfo height $recinfo]]
    if {$my <= $v(waveh)} {
      # 波形を拡大・縮小
      incr v(waveh) $inc
      if {$v(waveh) < $v(wavehmin)} {
        set v(waveh) $v(wavehmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech)]} {
      # スペクトルを拡大・縮小
      incr v(spech) $inc
      if {$v(spech) < $v(spechmin)} {
        set v(spech) $v(spechmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh)]} {
      # パワーを拡大・縮小
      incr v(powh) $inc
      if {$v(powh) < $v(powhmin)} {
        set v(powh) $v(powhmin)       ;# 縮小の最小値
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]} {
      # F0を拡大・縮小
      incr v(f0h) $inc
      if {$v(f0h) < $v(f0hmin)} {
        set v(f0h) $v(f0hmin)       ;# 縮小の最小値
      }
    }
    Redraw scale
  }
}

set resizingAxis ""  ;# リサイズ中のパネル略称を入れる

;# キャンバスの各パネル境界にきたらマウスカーソルを変化させる
proc changeMouseCursor {y} {
  global v c t resizingAxis

  if {$resizingAxis != "" \
      || [expr abs($y - $v(waveh))] < 5 \
      || [expr abs($y - $v(waveh) - $v(spech))] < 5 \
      || [expr abs($y - $v(waveh) - $v(spech) - $v(powh))] < 5 \
      || [expr abs($y - $v(waveh) - $v(spech) - $v(powh) - $v(f0h))] < 5} {
    $c configure -cursor sb_v_double_arrow  ;# based_arrow_down
  } else {
    $c configure -cursor arrow
  }
}

;# マウスで各パネルを拡大縮小　＋　発声タイミング補正モード
bind $c <B1-Motion> {
  if {$resizingAxis == "" && $pressedKey == ""} {
    # マウスで各パネルを拡大縮小
    if {[expr abs(%y - $v(waveh))] < 5} {
      set resizingAxis "w"
      $c configure -cursor sb_v_double_arrow ;#based_arrow_down
    } elseif {[expr abs(%y - $v(waveh) - $v(spech))] < 5} {
      set resizingAxis "s"
      $c configure -cursor sb_v_double_arrow ;#based_arrow_down
    } elseif {[expr abs(%y - $v(waveh) - $v(spech) - $v(powh))] < 5} {
      set resizingAxis "p"
      $c configure -cursor sb_v_double_arrow ;#based_arrow_down
    } elseif {[expr abs(%y - $v(waveh) - $v(spech) - $v(powh) - $v(f0h))] < 5} {
      set resizingAxis "f"
      $c configure -cursor sb_v_double_arrow ;#based_arrow_down
    }
  } elseif {$pressedKey != ""} {
    # 各パラメータをマウスドラッグで移動
    set x [expr %x - 2]
    switch $pressedKey {
      f1 {setParam S $x}     ;# F1なら
      F1 {setParam S $x 1}   ;# Alt-F1なら
      f2 {setParam O $x}     ;# F2なら
      f3 {setParam P $x}     ;# F3なら
      F3 {setParam P $x 0 1} ;# Alt-F3なら
      f4 {setParam C $x}     ;# F4なら
      f5 {setParam E $x}     ;# F5なら
    }
  }
}

bind . <ButtonRelease-1> {
  if {$resizingAxis != ""} {
    if {$resizingAxis == "w"} {
      set diff $v(waveh)
      set v(waveh) %y
      if {$v(waveh) < $v(wavehmin)} {
        set v(waveh) $v(wavehmin)
      }
      set diff [expr $v(waveh) - $diff]
    } elseif {$resizingAxis == "s"} {
      set diff $v(spech)
      set v(spech) [expr %y - $v(waveh)]
      if {$v(spech) < $v(spechmin)} {
        set v(spech) $v(spechmin)
      }
      set diff [expr $v(spech) - $diff]
    } elseif {$resizingAxis == "p"} {
      set diff $v(powh)
      set v(powh) [expr %y - $v(waveh) - $v(spech)]
      if {$v(powh) < $v(powhmin)} {
        set v(powh) $v(powhmin)
      }
      set diff [expr $v(powh) - $diff]
    } elseif {$resizingAxis == "f"} {
      set diff $v(f0h)
      set v(f0h) [expr %y - $v(waveh) - $v(spech) - $v(powh)]
      if {$v(f0h) < $v(f0hmin)} {
        set v(f0h) $v(f0hmin)
      }
      set diff [expr $v(f0h) - $diff]
    }
    set h [expr [winfo height .] + $diff]
    Redraw scale
    update
    wm geometry . "$v(winWidth)x$h"
    set resizingAxis ""
    $c configure -cursor arrow  ; update
  } else {
    if {$pressedKey != ""} {
      pushUndo agn
      set pressedKey ""
    }
  }
}

;# 中ボタン
$c bind Sl <ButtonPress-2> { playRange "" S}
$c bind Ol <ButtonPress-2> { playRange S  O}
$c bind Pl <ButtonPress-2> { playRange S  P}
$c bind Cl <ButtonPress-2> { playRange S  C}
$c bind El <ButtonPress-2> { playRange S  E}

;# 右クリックメニュー
bind $c <ButtonPress-3> { PopUpMenu %X %Y %x %y}

;# パラメータ一覧表の操作
;# この辺りのカーソル移動はevent addでまとめたいところだが、
;# なぜかまとめるとbindが効かなかったので個別に列挙してある。
proc bindCellLeft {w} {
  global v paramUsize
  if {$paramUsize <= 0} return
  setCellSelection $v(listSeq) [expr $v(listC) - 1]
  $w selection anchor active
}
bind Table <Alt-Left>       {bindCellLeft %W}
bind Table <Shift-Tab>      {bindCellLeft %W}

proc bindCellRight {w} {
  global v paramUsize
  if {$paramUsize <= 0} return
  setCellSelection $v(listSeq) [expr $v(listC) + 1]
  $w icursor 0
  $w selection anchor active
}
bind Table <Tab>            {bindCellRight %W}
bind Table <Alt-Right>      {bindCellRight %W}

proc bindDown {w} {
  global paramUsize
  if {$paramUsize <= 0} return
  nextList ; $w selection anchor active
}
bind Table <Down>           {bindDown %W}
bind Table <Return>         {bindDown %W}
bind Table <Control-j>      {bindDown %W}
#bind Table <Control-d>      {bindDown %W}   #←行削除キーとぶつかっていた
bind Table <F6>             {bindDown %W}
bind Table <Alt-Down>       nextWav

proc bindUp {w} {
  global paramUsize
  if {$paramUsize <= 0} return
  prevList ; $w selection anchor active
}
bind Table <Up>             {bindUp %W}
bind Table <Control-k>      {bindUp %W}
bind Table <Control-u>      {bindUp %W}
bind Table <F7>             {bindUp %W}
bind Table <Alt-Up>         prevWav
bind Table <KeyPress-F8>    playUttTiming ;# 先行発声チェック試聴

proc bindLeft {w} {
  global entpwindow paramUsize
  if {$paramUsize <= 0} return
  leftInCell  $w ; $entpwindow.t selection anchor active
}
bind Table <Left>           {bindLeft %W}
bind Table <Control-h>      {bindLeft %W}
bind Table <Control-b>      {bindLeft %W}

proc bindRight {w} {
  global entpwindow paramUsize
  if {$paramUsize <= 0} return
  rightInCell $w ; $entpwindow.t selection anchor active
}
bind Table <Right>          {bindRight %W}
bind Table <Control-l>      {bindRight %W}

bind Table <MouseWheel>       {+listboxScroll $entpwindow.t %D}
bind Table <Control-c>        {copyCell  %W ","}
bind Table <Control-x>        {copyCell  %W "," ; doChangeCell 0 "" 1 ""}
bind Table <Control-v>        {pasteCell %W ","}
bind Table <Control-i>        {duplicateEntp %W 1}
bind Table <Control-d>        {deleteEntp %W 1}
if {[array names ustData "pluginMode"] == ""} {
  # 通常(非プラグインモード)のとき
  bind Table <Control-s>        {saveParamFile $v(paramFile)}
  bind Table <Control-Shift-s>  saveParamFile
  bind Table <Control-o>        {readParamFile; resetDisplay}
}
bind Table <Control-f>        searchParam
bind Table <Control-g>        {doSearchParam 1}
bind Table <Control-n>        {doSearchParam 1}
bind Table <Control-G>        {doSearchParam 0}
bind Table <Control-N>        {doSearchParam 0}
bind Table <Control-m>        changeCell
bind Table <Control-p>        togglePlay
bind Table <Shift-space>      togglePlay
bind Table <Control-space>    playFromStoE
bind Table <Control-Alt-p>    playFromStoE
bind Table <Control-F1>       {playRange 1}
bind Table <Control-F2>       {playRange 2}
bind Table <Control-F3>       {playRange 3}
bind Table <Control-F4>       {playRange 4}
bind Table <Control-F5>       {playRange 5}
bind Table <ButtonRelease-1>  {+jumpList %W %x %y}
bind Table <Control-Alt-@>    autoAdjustRen2sel  ;# 手動でMFCC補正ツールを実行
bind Table <Control-Alt-d> {
  if {$conState} {
    console hide
    set conState 0
  } else {
    console show
    set conState 1
  }
}
bind Table <Alt-F4>           Exit

dnd bindtarget . text/uri-list <Drop> {procDnd %D}

bind Table <Button-3> { catch {tk_popup $rclickMenuTable %X %Y} }

#bind Table <Control-z>        undoParam
#bind Table <Control-Z>        redoParam
#bind Table <Control-y>        redoParam
#bind Table <Control-w>        setUndoPoint
bind Table <Control-z> undo
bind Table <Control-y> redo
bind Table <Control-Z> redo

#---------------------------------------------------
# メニューの設定
readSysIniFile
readPlugin
setMenu
set rclickMenu  [menu .popmenu   -tearoff false]
set rclickMenuZ [menu .popmenu.z -tearoff false]
set rclickMenuS [menu .popmenu.s -tearoff false]
set rclickMenuP [menu .popmenu.p -tearoff false]
set rclickMenuA [menu .popmenu.a -tearoff false]
set rclickMenuTable [menu .popmenu.table -tearoff false]
set rclickMenuExcel [menu .popmenu.excel -tearoff false]
setPopUpMenuTable
setRclickMenuS
setRclickMenuP
setRclickMenuA

#---------------------------------------------------
# プラグインモードの際に使わない機能を除去する
if {[array names ustData "pluginMode"] != ""} {
  .saveDir.dir configure -state disabled
  .saveDir.sel configure -state disabled
}

#---------------------------------------------------
# 初期化
update         ;# この段階でいったん窓を配置＆表示させる（プログレスバーを窓中央に出すため）
initDrawParam
if $startup(readRecList)        { readRecList $v(recListFile) }
if $startup(autoReadParamFile) {
  set startup(choosesaveDir) 0
  set startup(makeRecListFromDir) 0
  makeRecListFromDir 0
  if {[array names ustData "pluginMode"] != ""} {
    readParamFile $v(paramFile) 1 0
  } else {
    readParamFile $v(paramFile)
  }
} else {
  if $startup(choosesaveDir)      { choosesaveDir }
  if $startup(makeRecListFromDir) { makeRecListFromDir 1}
}
set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
set f0(guideFreqTmp) [tone2freq "$f0(guideTone)$f0(guideOctave)"]
resetDisplay
setCellSelection
setEPWTitle
clearUndo
event generate .entpwindow.t <ButtonPress-1> -x 150 -y 30
event generate .entpwindow.t <ButtonRelease-1> -x 150 -y 30 -when tail

wm resizable . 1 1                             ;# メイン窓幅を変更可能にする
set v(winHeightMin) 136
if {$v(waveh) > 0} { incr v(winHeightMin) $v(wavehmin) }
if {$v(spech) > 0} { incr v(winHeightMin) $v(spechmin) }
if {$v(powh)  > 0} { incr v(winHeightMin) $v(powhmin)  }
if {$v(f0h)   > 0} { incr v(winHeightMin) $v(f0hmin)   }
wm minsize . $v(winWidthMin) $v(winHeightMin)
if {$v(alwaysOnTop)} {
  wm attributes .           -topmost 1
  wm attributes .entpwindow -topmost 1
} else {
  wm attributes .           -topmost 0
  wm attributes .entpwindow -topmost 0
}

proc windowPlacement {} {
  global v entpwindow
  update
  # ウィンドウが縦に並ぶよう配置する
  set winG [split [wm geometry .] "x+"]
  set entX [lindex $winG 2]
  set entY [expr [lindex $winG 1] + [lindex $winG 3] + 60]
  set yb [expr $entY + [winfo height $entpwindow]]
  if {$yb < [winfo screenheight .]} {
    wm geometry $entpwindow "+$entX+$entY"
  } elseif {[expr $yb - [lindex $winG 3]] < [winfo screenheight .]} {
    set entY  [expr $entY  - [lindex $winG 3]]
    wm geometry $entpwindow "+$entX+$entY"
    wm geometry . "+$entX+0"
  }
}
windowPlacement


#bind . <Configure> {
#  set w [winfo width  .]
#  set h [winfo height .]
#  if {$v(winWidth) != $w || $v(winHeight) != $h} {
#    set v(winWidth)  $w
#    set v(winHeight) $h
#    set cWidthOld $v(cWidth)
#    set v(cWidth)  [expr $w - $v(yaxisw) - 8]  ;# 4はキャンバス境界のマージン
#    ;# 
#    if {$v(sndLength) > 0} {
#      if {$v(showWhole) != 0 || $v(wavepps) == [expr $cWidthOld / $v(sndLength)]} {
#        set v(wavepps) [expr $v(cWidth) / $v(sndLength)]  ;# wav全体を表示
#      }
#    }
#    Redraw scale
#  }
#}

after 1000 { bind . <Configure> {changeWindowBorder} } ;# 1sec後にbind。afterがないとボタンなどのwidgetが表示されないケースがあったため

proc changeWindowBorder {} {
  global v sv c

  set w [winfo width  .]
  set h [winfo height .]
  if {$v(winWidth) == $w && $v(winHeight) == $h} return

  set v(winWidth)  $w
  set v(winHeight) $h
  set cWidthOld $v(cWidth)
  set v(cWidth)  [expr $w - $v(yaxisw) - 8]  ;# 4はキャンバス境界のマージン
  #set v(cWidth)  [expr $w - $v(yaxisw)]  ;# place用(utawaview)
  ;#
  if {$v(sndLength) > 0} {
    if {$v(showWhole) != 0 || $v(wavepps) == [expr $cWidthOld / $v(sndLength)]} {
      set waveppsOld $v(wavepps)
      set v(wavepps) [expr $v(cWidth) / $v(sndLength)]  ;# wav全体を表示
      $c scale regions 0 0 [expr $v(wavepps) / $waveppsOld] 1
    }
  }
  set diff [expr $v(winHeight) - ([winfo y .msg] + [winfo height .msg])]
  if {$diff > 0} {
    if {$v(f0h) > 0} {
      set v(f0h) [expr $v(f0h) + $diff]
    } elseif {$v(powh) > 0} {
      set v(powh) [expr $v(powh) + $diff]
    } elseif {$v(spech) > 0} {
      set v(spech) [expr $v(spech) + $diff]
    } elseif {$v(waveh) > 0} {
      set v(waveh) [expr $v(waveh) + $diff]
    }
  } elseif {$diff < 0} {
    if {$v(f0h) > 0} {
      set old $v(f0h)
      set v(f0h) [expr $v(f0h) + $diff]
      if {$v(f0h) < $v(f0hmin)    } { set v(f0h) $v(f0hmin) }
      set diff [expr $diff - ($v(f0h) - $old)]
    }
    if {$diff < 0 && $v(powh) > 0} {
      set old $v(powh)
      set v(powh) [expr $v(powh) + $diff]
      if {$v(powh) < $v(powhmin)  } { set v(powh) $v(powhmin) }
      set diff [expr $diff - ($v(powh) - $old)]
    }
    if {$diff < 0 && $v(spech) > 0} {
      set old $v(spech)
      set v(spech) [expr $v(spech) + $diff]
      if {$v(spech) < $v(spechmin)} { set v(spech) $v(spechmin) }
      set diff [expr $diff - ($v(spech) - $old)]
    }
    if {$diff < 0 && $v(waveh) > 0} {
      set old $v(waveh)
      set v(waveh) [expr $v(waveh) + $diff]
      if {$v(waveh) < $v(wavehmin)} { set v(waveh) $v(wavehmin) }
      set diff [expr $diff - ($v(waveh) - $old)]
    }
  }
  # set winHeightMinNew [expr [winfo y $c] + $v(timeh)]
  # if {$v(showWave)} { set winHeightMinNew [expr $winHeightMinNew + $v(wavehmin)] }
  # if {$v(showSpec)} { set winHeightMinNew [expr $winHeightMinNew + $v(spechmin)] }
  # if {$v(showPow) } { set winHeightMinNew [expr $winHeightMinNew + $v(powhmin) ] }
  # if {$v(showF0)  } { set winHeightMinNew [expr $winHeightMinNew + $v(f0hmin)  ] }
  # wm minsize . $sv(winWidthMin) $winHeightMinNew
  Redraw scale
}

