#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

# - パラメータバックアップ用配列を追加

# 2.0-b091104
# - 先行発声チェック用の設定配列を追加

# 2.0-b090720
# - 各ファイルへのパスを、exe(starkit)のときとtclのときとの両方に対応
# - ガイドBGM関係の設定を追加
# - メトロノーム音、ガイドBGM関係ファイルをguideBGM/に移動

# 2.0-b090706
# - oremo本体にあった大域変数を globalVar.tclにまとめた

#---------------------------------------------------
# 変数設定
#
set debug 0
set sv(appname) ""
set sv(version) ""
if {[info exists ::starkit::topdir]} {
  set topdir [file dirname [info nameofexecutable]]
} else {
  set topdir [file dirname $argv0]
}
set v(recListFile) "$topdir/reclist.txt"   ;# 収録する音名リストファイル
set v(typeListFile) "$topdir/typelist.txt" ;# 収録する発話タイプのリストファイル
;# 録音した音を保存するディレクトリ
if {[file exists "c:/Program Files/UTAU/voice"]} {
  set v(saveDir) "c:/Program Files/UTAU/voice"
} elseif {[file exists "c:/Program Files (x86)/UTAU/voice"]} {
  set v(saveDir) "c:/Program Files (x86)/UTAU/voice"
} else {
  set v(saveDir) "$topdir/result"
}
set v(ext) wav                  ;# 波形ファイルの拡張子
set v(autoSaveInitFile) 1       ;# 1=$topdir/setParam-init.tclを自動保存する、0=保存しない
set v(yaxisw) 40                ;# 縦軸表示の横幅
set v(timeh)  20                ;# 横軸表示の縦幅
set v(showWave) 1               ;# 1=波形表示, 0=非表示
set v(waveh)  100               ;# 波形パネルの縦幅
set v(wavehbackup) 100          ;# 波形表示の縦サイズのバックアップをとる
set v(wavehmin)  50             ;# 縮小した際の最小縦幅
set v(wavepps)  200             ;# pixel/sec。
set v(waveScale) 32768          ;# 波形表示縦軸の最大値。0でautoscale
set v(showWhole)  1             ;# 1=常にwav全体を表示させる、0=縮尺固定
set v(alwaysOnTop) 0            ;# 1=常に最前面表示
set v(alpha) 1                  ;# 1=完全不透明, 0=完全透明
set v(zoomRate) 100             ;# ユーザ指定の波形拡大率(単位は%)。
set v(sfont) {Helvetica 8 bold} ;# 目盛り表示のフォント
set v(bg) [. cget -bg]
set v(fg) black
set v(wavColor) black
set v(recStatus) 0       ;# 1=たった今録音した, 0=録音してない
set v(playStatus) 0      ;# 1=今再生中, 0=今再生してない
set v(playUttStatus) 0   ;# 1=現在発声タイミング再生中, 0=現在再生してない
set v(recList) {}        ;# 収録する音名を入れるリスト
set v(recSeq) 0          ;# 現在収録中の音番号
set v(recLab) ""         ;# 現在収録中の音名
set v(typeList) {""}     ;# 収録する発声タイプを入れるリスト
set v(typeLab) ""        ;# 現在収録中の発声タイプ
set v(typeSeq) 0         ;# 現在収録中の発声タイプ番号
set v(bigFontSize) 24    ;# フォントサイズ
set v(fontSize) 18       ;# フォントサイズ
set v(smallFontSize) 14  ;# フォントサイズ
set v(msg) ""            ;# ソフト最下段に表示するメッセージ
set v(sndLength) 0       ;# 現在表示している波形長(秒)
set v(dirHistory) {}     ;# フォルダ使用履歴
set v(pDirHistory) {}    ;# 親フォルダ使用履歴
set v(dirHistoryMax) 30  ;# フォルダ使用履歴数の上限
set v(autoFocus) "P"     ;# 表示行を変えたときにどのパラメータにフォーカスするか。 S,C,E,P,O,"none"

set v(showSpec) 0        ;# 1=スペクトル表示, 0=非表示
set v(spech)    0        ;# スペクトル表示の縦サイズ
set v(spechbackup) 140   ;# スペクトル表示の縦サイズのバックアップをとる
set v(spechmin) 50       ;# スペクトル表示の縦サイズ(縮小時の最小縦幅)
set v(topfr)    8000     ;# スペクトル表示の最高周波数
set v(cmap)     grey     ;# スペクトル配色
set v(contrast) 0        ;# スペクトルのコントラスト
set v(brightness) 0      ;# スペクトルの明るさ
set v(fftlen) 512        ;# FFT長
set v(winlen) 128        ;# 窓長
set v(window) Hamming    ;# スペクトル抽出窓
set v(preemph) 0.97      ;# スペクトル抽出のプリエンファシス

set v(showpow) 0        ;# 1=パワー表示, 0=非表示
set v(powh)    0        ;# パワー表示の縦サイズ
set v(powhmin) 50       ;# パワー表示の縦サイズ(縮小時の最小縦幅)
set v(powhbackup) 100   ;# パワー表示の縦サイズのバックアップをとる
set power(frameLength) 0.02  ;# パワー抽出刻み[sec]
set power(window)  Hanning    ;# パワー抽出時の窓
set power(preemphasis)  0.97  ;# パワー抽出時のプリエンファシス
set power(windowLength)  0.01 ;# パワー抽出窓長[sec]
set power(power) {}           ;# 抽出したパワー値系列を保存する
set power(powerMax) 0         ;# 抽出結果の最大値
set power(powerMin) 0         ;# 抽出結果の最小値
set v(powcolor) blue          ;# パワー曲線の色

array unset plugin
set plugin(N) 0               ;# プラグイン数
;# plugin(N)         ... プラグイン数
;# plugin(i,name)    ... i-th プラグイン名
;# plugin(i,execute) ... i-th 実行コマンド名
;# plugin(i,argv)    ... i-th 実行コマンドに与える引数
;# plugin(i,needF0)  ... i-th F0ファイルが必要か否かのフラグ(0 or 1)
;# plugin(i,F0unit)  ... i-th F0値の単位(Hz or semitone)
;# plugin(i,needPower) ... i-th パワーファイルが必要か否かのフラグ(0 or 1)

set power(uttLow)  28    ;# 無音とみなされる振幅の閾値[dB]
set power(uttHigh) 28    ;# 発話とみなされる振幅の閾値[dB]
set power(uttKeep) 5     ;# 発話中の音量のゆらぎとみなされる幅の閾値[dB]
set power(vLow)    40    ;# 母音とみなされる振幅の閾値[dB]
set power(uttLengthSec) 0.05  ;# 発話中とみなされる時間長[sec]
set power(uttLength) [sec2samp $power(uttLengthSec) $power(frameLength)]  ;# 発話中とみなされる時間長[sample]
set power(silLengthSec) 0.0  ;# ポーズとみなされる時間長[sec]
set power(silLength) [sec2samp $power(silLengthSec) $power(frameLength)]  ;# ポーズとみなされる時間長[sample]
set power(fid) ""                           ;# パワー抽出したファイルのFID

set sv(toneList) {C C# D D# E F F# G G# A A# B} ;# ガイド音名リスト1oct分
set sv(sinScaleMin) 2     ;# ガイドsin音の最低オクターブ
set sv(sinScaleMax) 5     ;# ガイドsin音の最高オクターブ
set sv(sinScale) {}       ;# ガイドsin音の周波数リスト
set sv(sinNote) {}   ;# ガイドsin音の周波数に対応する音名
set f0(checkVol) 4000    ;# 詳細設定窓で再生するsin音の振幅初期値
set f0(guideVol) 4000    ;# ガイドsin音の振幅初期値
set f0(tgtTone) [lindex $sv(toneList) 0] ;# ターゲット音名
set f0(tgtOctave) $sv(sinScaleMin)       ;# ターゲット音のオクターブ
set f0(tgtFreq) 0                        ;# ターゲット音の周波数
set f0(showToneLine) 0                   ;# 1=各音の横線をF0パネルに表示
set  v(toneLineColor) #fffff0            ;# 各音の横線の色
set f0(showTgtLine) 0                    ;# 1=ターゲット音をF0パネルに表示
set f0(fid) ""                           ;# F0抽出したファイルのFID
set f0(extractedMin) 0                   ;# 抽出したF0の最小値
set f0(extractedMax) 0                   ;# 抽出したF0の最大値

set v(showf0) 0           ;# 1=F0表示, 0=非表示
set v(f0h)    0           ;# F0表示の縦サイズ
set v(f0hmin) 50          ;# F0表示の縦サイズ(縮小時の最小縦幅)
set v(f0hbackup) 100      ;# F0表示の縦サイズのバックアップをとる
set f0(method) ESPS       ;# F0抽出アルゴリズム
set f0(frameLength) 0.01  ;# F0抽出間隔[sec]
set f0(windowLength) 0.01 ;# F0抽出の窓長[sec]
set f0(max) 800           ;# 想定される最高F0
set f0(min) 60            ;# 想定される最低F0
set f0(showMax) 400       ;# F0表示の範囲[Hz]
set f0(showMin) 60        ;# F0表示の範囲[Hz]
set f0(showMinTone)   [lindex $sv(toneList) 0]   ;# F0表示の範囲
set f0(showMinOctave) $sv(sinScaleMin)           ;# F0表示の範囲
set f0(showMaxTone)   [lindex $sv(toneList) end] ;# F0表示の範囲
set f0(showMaxOctave) $sv(sinScaleMax)           ;# F0表示の範囲
set f0(guideTone)   C  ;# 音叉音
set f0(guideOctave) 3  ;# 音叉音
set f0(guideFreqTmp) 131 
set f0(f0) {}             ;# 抽出したF0系列
set v(f0color) blue       ;# F0曲線の色
set v(tgtf0color) red     ;# ターゲットF0の色
set f0(fixShowRange) 1    ;# 1=F0表示スケールを固定にする
set f0(unit) semitone     ;# F0表示スケール。semitone, Hz

;#set v(removeDC) 0         ;# 1=録音後DC成分を除去する
set v(autoBackup) 5       ;# 1以上=定期的にバックアップファイルを保存する。(単位=分)
set v(backupParamFile) ""  ;# 定期バックアップファイル(backup.ini)

set v(cWidth) 500                          ;# 波形画面キャンバスの横幅
set v(cWidthMin) [expr $v(yaxisw) + 100]   ;# 波形画面キャンバスの横幅最小値
set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
                                           ;# 波形画面キャンバスの縦幅
set v(winWidth) 640
set v(winWidthMin) 350
set v(winHeightMin) 136
set v(winWidthMax) [lindex [wm maxsize .] 0]
set v(winHeight) 0

set conState 0  ;# console がshowなら1、hideなら0であることをあらわす
set scrollWidget ""      ;# 現在マウスがリストボックスにあればそのパスを入れる

set v(sampleRate) 44100  ;# 音声のサンプリング周波数[Hz]
set v(paramChanged) 0    ;# 1=原音パラメータが未保存,0=保存済み
set v(keyword) ""        ;# 検索キーワード
set v(timeUnit) "Sec."          ;# 時間軸の表示方法。Sec. or Bar
set v(bpm) 120                  ;# 拍単位の時間軸(単位=BPM)
set v(bpmTmp) $v(bpm)           ;# 拍単位の時間軸、入力用(単位=BPM)
set v(bpmOffset) 0              ;# 拍単位の時間軸の左側オフセット値(単位=sec)
set v(bpmOffsetTmp) $v(bpmOffset) ;# 拍単位の時間軸の左側オフセット値、入力用(単位=sec)
set v(pmStartDelay) 0 ;# 再生バーの表示開始を遅れさせる秒数。発声タイミング試聴で使う
set v(pmPlayStart)  0 ;# 再生バーの再生開始位置

# テスト合成
set v(synFile) "$topdir/temp/testsynth.wav" ;# テスト合成用
set v(playSynStatus) 0  ;# 1=合成音再生中、0=停止中
if {[file exists "c:/Program Files (x86)/UTAU/resampler.exe"]} {
  set v(synEngine) "c:/Program Files (x86)/UTAU/resampler.exe"
} elseif {[file exists "c:/Program Files/UTAU/resampler.exe"]} {
  set v(synEngine) "c:/Program Files/UTAU/resampler.exe"
} else {
  set v(synEngine) "指定なし";
}
set v(synLength) 1000        ;# 合成音の長さ
set v(synFlag)   ""          ;# 合成フラグ
set v(synVolume) 100         ;# 合成音の音量
set v(synMod)    0           ;# 合成音のモジュレーション
set v(synCSpeed) 100         ;# 合成音の子音速度
set f0(synTone)   C          ;# 合成音の高さ
set f0(synOctave) 4          ;# 合成音の高さ

# アンドゥ
set v(undoLimit) 50    ;# 単位=MByte。アンドゥスタックの保存量がこの値を超えたら古い方の履歴から順に削除する
set v(undoLimitWeight) 8   ;# アンドゥの保存量計算時にかける重み係数
set v(undoLimitStrLen) [expr $v(undoLimit) * 1000000 / $v(undoLimitWeight)]  ;# アンドゥの保存上限(文字数)

# スペクトル配色
set sv(grey) " "
set sv(color1) {#000 #004 #006 #00A #00F \
               #02F #04F #06F #08F #0AF #0CF #0FF #0FE \
               #0FC #0FA #0F8 #0F6 #0F4 #0F2 #0F0 #2F0 \
               #4F0 #6F0 #8F0 #AF0 #CF0 #FE0 #FC0 #FA0 \
               #F80 #F60 #F40 #F20 #F00}
set sv(color2) {#FFF #BBF #77F #33F #00F #07F #0BF #0FF #0FB #0F7 \
               #0F0 #3F0 #7F0 #BF0 #FF0 #FB0 #F70 #F30 #F00}

set startup(readRecList) 1    ;# 1=起動時にreclist.txtを読む
set startup(readTypeList) 1   ;# 1=起動時にtypelist.txtを読む

set startup(textFiles) [list $topdir/message/setParam-text-CHS.tcl $topdir/message/proc-text-CHS.tcl]

;# setParam-init.tclに保存する配列のリスト
set startup(arrayForInitFile) {v f0 power startup dev uttTiming genParam estimate pZeroCross}
;# setParam-init.tclに保存しないキーのリスト
set startup(exclusionKeysForInitFile,aName) { startup v power f0 estimate }
set startup(exclusionKeysForInitFile,startup) { \
  arrayForInitFile choosesaveDir \
  exclusionKeysForInitFile,aName \
  exclusionKeysForInitFile,startup \
  exclusionKeysForInitFile,v \
  exclusionKeysForInitFile,power \
  exclusionKeysForInitFile,f0 \
  exclusionKeysForInitFile,estimate \
  autoReadParamFile \
}
set startup(exclusionKeysForInitFile,v) { \
  paramChanged msg ext \
  sndLength \
  recList recLab recSeq typeList typeLab typeSeq listSeq listC dirHistory pDirHistory \
  labAlias \
  recStatus playStatus playOnsaStatus playMetroStatus \
  openedParamFile \
  ext undoLimit undoLimitWeight undoLimitStrLen
}
set startup(exclusionKeysForInitFile,power) { power fid }
set startup(exclusionKeysForInitFile,f0) { f0 extractedMin extractedMax fid }
set startup(exclusionKeysForInitFile,estimate) { tmpWav }

set v(setPlayRange,1,start) "0 ファイル先頭"  ;# 範囲指定再生の再生開始位置
set v(setPlayRange,1,end)   "1 左ブランク"    ;# 範囲指定再生の再生終了位置
set v(setPlayRange,2,start) "1 左ブランク"    ;# 範囲指定再生の再生開始位置
set v(setPlayRange,2,end)   "2 overlap"       ;# 範囲指定再生の再生終了位置
set v(setPlayRange,3,start) "1 左ブランク"    ;# 範囲指定再生の再生開始位置
set v(setPlayRange,3,end)   "3 先行発声"      ;# 範囲指定再生の再生終了位置
set v(setPlayRange,4,start) "1 左ブランク"    ;# 範囲指定再生の再生開始位置
set v(setPlayRange,4,end)   "4 固定範囲"      ;# 範囲指定再生の再生終了位置
set v(setPlayRange,5,start) "1 左ブランク"    ;# 範囲指定再生の再生開始位置
set v(setPlayRange,5,end)   "5 右ブランク"    ;# 範囲指定再生の再生終了位置
set v(clickPlayRangeMode) 1   ;# 1=画面クリックで近傍パラメータ間を再生する。0=再生しない。

# 値一括変更用の設定
array unset chCell
set chCell(w) .chaWindow
set chCell(ccMode) 1
set chCell(ccVal)  0
set chCell(restrictMode) 1
set chCell(rVal) 0
set chCell(undoOpt) ""
set chCell(target) {}

# エイリアス一括変換
array unset chAlias
set chAlias(traWindow) .traWindow
set chAlias(transRule)  ""
set chAlias(delPreNum)  0
set chAlias(delPostNum) 0
set chAlias(aliasMax)   0

# 保存フォルダの各wavの両端を指定秒カット
array unset ctWav
set ctWav(w) .cutWindow
set ctWav(L) 0
set ctWav(R) 0
set ctWav(adjSE) 1  ;# 1=wav両端をカットしたらS,E値を自動補正する

# 先行発声チェック用の設定
array unset uttTiming
set uttTiming(clickWav) "$topdir/guideBGM/click.wav"        ;# メトロノームの音
set uttTiming(tempo) 100                                    ;# チェック速度[BPM]
set uttTimingMSec(tempo) [expr 60000.0 / $uttTiming(tempo)] ;# チェック速度[msec]
set uttTiming(preCount) 3                 ;# 音声再生前にメトロノームを鳴らす回数
set uttTiming(mix) 0.5                    ;# メトロノームと音声の混合比率。
snack::sound uttTiming(clickSnd) -rate $v(sampleRate)

# 連続発声のパラメータ自動生成用の設定
array unset genParam
set genParam(bpm)  100
set genParam(bpmU) bpm
set genParam(S)    0
set genParam(SU)   msec
set genParam(O)    0
set genParam(OU)   msec
set genParam(P)    0
set genParam(PU)   msec
set genParam(C)    0
set genParam(CU)   msec
set genParam(E)    0
set genParam(EU)   msec
set genParam(autoAdjustRen) 1
set genParam(vLow)      5
set genParam(sRange) 300
set genParam(avePPrev) 0   ;# 一つ前の平均パワーを保存する
set genParam(autoAdjustRen2)    0
set genParam(autoAdjustRen2Opt) "-s1 200 -s2 10 -l 2048 -p 128 -m 30 -t 1.0 -d tools"
set genParam(autoAdjustRen2Pattern) "あ い う え お ん"
set genParam(suffix) ""        ;# 接尾辞
set genParam(useAliasMax) 0    ;# 0=重複をそのままにする,1=通し番号を付ける
set genParam(aliasMax) 0       ;# 重複番号の最大値
set genParam(aliasRecList) ""  ;# エイリアス重複カウントの優先順リストファイル名
set genParam(underScoreMode) 0 ;# 0=ファイル名の_を無視、1=一モーラ分の休符、2=一モーラの区切り記号

# 単独音のパラメータ自動推定用の設定
array unset estimate
set estimate(S)    1  ;# 1=パラメータ自動推定を行う
set estimate(E)    1  ;# 1=パラメータ自動推定を行う
set estimate(C)    1  ;# 1=パラメータ自動推定を行う
set estimate(P)    1  ;# 1=パラメータ自動推定を行う
set estimate(O)    1  ;# 1=パラメータ自動推定を行う
set estimate(minC) 0.001  ;# 子音部長の最小値(子音部=0でUTAUがエラーになるのを防ぐ)
set estimate(ovl) 0.4 ;# 先行発声値に対するオーバーラップ値の割合
set estimate(frameLength) 0.002 ;# フレーム周期。単位:秒。
set estimate(preEstimateParam) 1  ;# 1=自動推定の各パラメータをwav毎に自動推定
set estimate(hpfPattern) "が ぎ ぐ げ ご な に ぬ ね の ば び ぶ べ ぼ ヴ ま み む め も や ゆ よ ら り る れ ろ g n b v m y r"   ;# パワー抽出時にハイパスフィルタをかける音リスト。このリストは先頭一モーラとする（例："り"があれば"りゃ"等も適用対象にする。
set estimate(lpfPattern) "ざ じ ず ぜ ぞ だ ぢ づ で ど z j d"   ;# パワー抽出時にローパスフィルタをかける音リスト。このリストは先頭一モーラとする（例："り"があれば"りゃ"等も適用対象にする。
set estimate(tmpWav) "tmpFiltered.wav"

# ustを読んで編集対象を絞り込む
set v(readUstFileComment) ""
set v(readUstFileLimit) 0

# パラメータのゼロクロス補正
array unset pZeroCross
set pZeroCross(S)  1  ;# 1=ゼロクロスに補正する
set pZeroCross(C)  1  ;# 1=ゼロクロスに補正する
set pZeroCross(E)  1  ;# 1=ゼロクロスに補正する
set pZeroCross(P)  1  ;# 1=ゼロクロスに補正する
set pZeroCross(O)  1  ;# 1=ゼロクロスに補正する

# パラメータのバックアップ用配列
array unset paramS_bk
array unset paramU_bk
set paramS_bk(N) -1
set paramU_bk(N) -1
set paramS_bk(i) -1
set paramU_bk(i) -1

# キャンバス上の各パラメータのIDを入れる配列
array unset cParamID

snack::debug $debug
snack::sound snd -channels Mono -rate $v(sampleRate) -debug $debug
snack::sound sndUtt -channels Mono -rate $v(sampleRate)
snack::sound onsa -channels Mono -rate $v(sampleRate)
snack::sound metro
snack::sound bgm    ;# 収録ガイドBGMイントロ部
snack::sound sndSyn ;# テスト合成用

