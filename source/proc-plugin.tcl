#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

array unset ustData       ;# 元のustデータを入れる。

#---------------------------------------------------
# サブルーチン
#---------------------------------------------------

#---------------------------------------------------
# プラグイン起動時に渡されるファイルからデータを読み、編集用の$v(paramFile)を作る。
# うまく行かない時はexitする
#
proc utaup_readUst {inFile} {
  global ustData v startup t

  ;# プラグイン起動時に渡されるustファイルを開く
  if [catch {open $inFile r} in] {
    tk_messageBox -message "error: $t(utaup_readUst,err1) $inFile" -title error -icon warning
    exit
  }
  array unset ustData
  set ustData(pluginMode) 1    ;# プラグインとして起動したことを示す
  set ustData(voiceDir) ""     ;# 音源ディレクトリ
  set ustData(cacheDir) ""     ;# キャッシュディレクトリ
  set ustData(tmpParamFile) "tmp-setParamPlugin-oto.ini" ;# 作業用oto.ini。フォルダパスを含まない
  set ustData(targetParamFile)    {} ;# 書き換え対象のoto.ini。フォルダパスを含む
  set ustData(targetParamFileSeq) {} ;# 書き換え対象のoto.iniの行番号。最初は1行。
  set ustData(lyric)    {}     ;# 原音設定対象の歌詞
  set ustData(noteNum)  {}     ;# 原音設定対象のノートナンバー
  set ustData(lyricMapped) {}  ;# 原音設定対象の歌詞(prefixMap適用後)
  set section ""
  while {![eof $in]} {
    set l [gets $in]

    if {[regexp {^\[#} $l]} {
      # エラーチェック
      if {[llength $ustData(lyric)] != [llength $ustData(noteNum)]} {
        tk_messageBox -message "error: $t(utaup_readUst,err2)" \
            -title $t(.confm.fioErr) -icon warning
        exit
      }
      set section $l
      continue
    }

    if {$section == "\[#SETTING\]"} {
      if {[regexp {^VoiceDir=(.*)$} $l dummy str]} {
        regsub -all -- {\\} $str "/" ustData(voiceDir)
        if {[string index $ustData(voiceDir) end] == "/"} {
          set ustData(voiceDir) [string trimright $ustData(voiceDir) "/"]
        }
      }
      if {[regexp {^CacheDir=(.*)$} $l dummy str]} {
        regsub -all -- {\\} $str "/" ustData(cacheDir)
        if {[string index $ustData(cacheDir) end] == "/"} {
          set ustData(cacheDir) [string trimright $ustData(cacheDir) "/"]
        }
      }
      continue
    }

    if {[regexp {^\[#[0-9]} $section]} {
      if {[regexp {^Lyric=(.*)$} $l dummy str]} {
        lappend ustData(lyric) $str
      }
      if {[regexp {^NoteNum=(.*)$} $l dummy str]} {
        lappend ustData(noteNum) $str
      }
      continue
    }
  }
  close $in

  # 休符を除去
  for {set i [expr [llength $ustData(lyric)] - 1]} {$i >= 0} {incr i -1} {
    if {[lindex $ustData(lyric) $i] == "R"} {
      set ustData(lyric)   [lreplace $ustData(lyric)   $i $i]
      set ustData(noteNum) [lreplace $ustData(noteNum) $i $i]
    }
  }

  # エラーチェック
  if {$ustData(voiceDir) == "" || [llength $ustData(lyric)] <= 0 || [llength $ustData(noteNum)] <= 0} {
    tk_messageBox -message "error: $t(utaup_readUst,err2)" \
        -title $t(.confm.fioErr) -icon warning
    exit
  }
  if {$ustData(cacheDir) == ""} {
    tk_messageBox -message "error: $t(utaup_readUst,err3)" \
        -title $t(.confm.fioErr) -icon warning
    exit
  }

  # prefixMapをlyricに適用
  utaup_applyPrefixMap

  # prefixMap適用済みlyricの重複するものを削除する
  for {set i 0} {$i < [llength $ustData(lyricMapped)]} {incr i} {
    for {set j [expr [llength $ustData(lyricMapped)] - 1]} {$j > $i} {incr j -1} {
      if {[lindex $ustData(lyricMapped) $i] == [lindex $ustData(lyricMapped) $j]} {
        set ustData(lyricMapped) [lreplace $ustData(lyricMapped) $j $j]
        set ustData(lyric)       [lreplace $ustData(lyric)       $j $j]
        set ustData(noteNum)     [lreplace $ustData(noteNum)     $j $j]
      }
    }
  }

  # oto.iniのリストを作る
  set otoList {}
  set otoListAdd [glob -nocomplain [format "%s/*/oto.ini" $ustData(voiceDir)]]
  if {[llength $otoListAdd] > 0} {
    set otoList [concat $otoList $otoListAdd]
  }
  if {[file readable "$ustData(voiceDir)/oto.ini"]} {
    lappend otoList "$ustData(voiceDir)/oto.ini"
  }

  # $v(paramFile)に書き込むファイルポインタ$outを得る
  set v(saveDir)   $ustData(voiceDir)
  set v(paramFile) "$ustData(voiceDir)/$ustData(tmpParamFile)"
  if [catch {open $v(paramFile) w} out] {
    tk_messageBox -message "error: $t(utaup_readUst,err4) $v(paramFile)" \
        -title $t(.confm.fioErr) -icon warning
    exit
  }

  for {set i 0} {$i < [llength $ustData(lyric)]} {incr i} {
    # prefixMap適用済みの歌詞→非適用の歌詞の順にサーチする
    set found 0
    foreach oto [list [lindex $ustData(lyricMapped) $i] [lindex $ustData(lyric) $i]] {
      set subDir ""
      if {[regexp {\\} $oto]} {
        regexp {^(.+)\\(.+)$} $oto dummy subDir
      }

      # oto.iniのエイリアスを検索し、一致するものを探す。見つかったら処理終了。
      foreach otoFile $otoList {
        if {[utaup_searchEntry $out $otoFile $oto 1] > 0} {
          set found 1
          break
        }
      }
      if {$found} break

      # wavファイル名を検索し、一致するものを探す
      # oto.iniにエントリがあるかでなくwavファイルがあるかで調べる方が良い？
      set subDir ""
      if {[regexp {\\} $oto]} {
        regexp {^(.+)\\(.+)$} $oto dummy subDir oto   ;# こちらの$otoにはパスを含めない
      }
      if {$subDir != ""} {
        set otoFile "$ustData(voiceDir)/$subDir/oto.ini"
      } else {
        set otoFile "$ustData(voiceDir)/oto.ini"
      }
      if {[utaup_searchEntry $out $otoFile "$oto.wav" 0] > 0} {
        set found 1
        break
      }
    }
  }

  close $out

  # 設定対象が見つかったとき
  if {[llength $ustData(targetParamFile)] > 0} {
    set startup(autoReadParamFile) 1
    return 0
  } else {
    # 設定対象が見つからない時
    tk_messageBox -message "error: $t(utaup_readUst,err5)" -title error -icon warning
    exit
  }
;#koko,oremoのpowerコマンドにもcatchを入れるべし。
;#koko,oremoで最大化等をやって問題無いか確認する。changeWindowBorderでupdateを外してみる。

}

#---------------------------------------------------
# 書き換え対象oto.iniに原音設定結果を反映する
#
proc utaup_updateTargetParamFile {} {
  global v t ustData

  # 編集結果をファイルから読む
  set newData {}
  if [catch {open $v(paramFile) r} in] {
    tk_messageBox -message "error: $t(utaup_updateTargetParamFile,err1)" -title error -icon warning
    return
  } else {
    while {![eof $in]} {
      lappend newData [gets $in]
    }
    close $in
  }

  set doneList {}
  for {set i 0} {$i < [llength $ustData(targetParamFile)]} {incr i} {
    set targetParamFile    [lindex $ustData(targetParamFile)     $i]
    set targetParamFileSeq [lindex $ustData(targetParamFileSeq)  $i]
    set targetSubDir [string range [file dirname $targetParamFile] [expr [string length $v(saveDir)] + 1] end]

    # 既に処理済みのエントリならskip
    set done 0
    foreach d $doneList {
      if {$d == $targetParamFile} {
        set done 1
        break
      }
    }
    if {$done} continue
    lappend doneList $targetParamFile

    # 処理対象の行リストを作る
    set seqList {}
    for {set j 0} {$j < [llength $ustData(targetParamFile)]} {incr j} {
      if {$targetParamFile == [lindex $ustData(targetParamFile) $j]} {
        lappend seqList [lindex $ustData(targetParamFileSeq) $j]
      }
    }

    # 書き換え対象となる元のoto.iniを読む
    set targetData    {"dummy"}
    set targetDataOrg {"dummy"}
    if [catch {open $targetParamFile r} in] {
      tk_messageBox -message "error: $t(utaup_updateTargetParamFile,err1)" -title error -icon warning
      return
    }
    set N 0
    set Nseq 0
    while {![eof $in]} {
      incr Nseq
      set line [gets $in]
      lappend targetDataOrg $line
      if {[lsearch $seqList $Nseq] < 0} {
        incr N
        lappend targetData $line
      }
    }
    close $in

    # 元のoto.iniを書き換える
    if [catch {open $targetParamFile w} out] {
      tk_messageBox -message "error: $t(utaup_updateTargetParamFile,err1)" -title error -icon warning
      return
    }

    # 変更の有るデータを書き込む
    foreach line $newData {
      if {$line == ""} continue
      if {$targetSubDir == ""} {
        if {! [regexp ".+/" $line]} {
          puts $out $line
        }
      } elseif {[regexp "^$targetSubDir/" $line]} {
        regsub -- "^$targetSubDir/" $line "" line
        puts $out $line
      }
    }

    # 変更の無いデータを書き込む
    for {set j 1} {$j <= $N} {incr j} {
      if {[lindex $targetData $j] == ""} continue
      puts $out [lindex $targetData $j]
    }

    # 変更の有るデータのキャッシュwavを削除する
    set delList {}
    foreach line $newData {
      if {$line == ""} continue
      regsub -nocase -- {\.wav=.*$} $line "" wav
      regsub -all -- {[\\/]} $wav "_" wav
      if {[lsearch $delList $wav] < 0} {
        lappend delList $wav
        set delWavList [glob -nocomplain [format "%s/*_%s_*.wav" $ustData(cacheDir) $wav]]
        foreach del $delWavList {
          file delete $del
        }
      }
    }

    close $out
  }
}

#---------------------------------------------------
# fnameで指定したoto.iniファイル内に、
# searchWordで指定した音名があればその行番号(最初は1行)を返す。
# また、ヒットした行を$v(paramFile)すなわち
# "$ustData(voiceDir)/$ustData(tmpParamFile)"として保存する。
# 無ければ-1を返す。
# 
proc utaup_searchEntry {out fname searchWord col} {
  global ustData v
  if [catch {open $fname r} in] {
    return 0
  }
  set seq 0
  while {![eof $in]} {
    set l [gets $in]
    incr seq

    set a [lindex [split $l "=,"] $col]  ;# col=1…alias, col=0…wavファイル名
    if {$col == 0} {
      set a [string tolower $a]
      set searchWord [string tolower $searchWord]
    }
    if {$a == $searchWord} {
      # 既に編集対象にしているものなら対象から除外する
      for {set i 0} {$i < [llength $ustData(targetParamFile)]} {incr i} {
        if {$fname == [lindex $ustData(targetParamFile)    $i] &&
            $seq   == [lindex $ustData(targetParamFileSeq) $i]    } {
          close $in
          return -1
        }
      }

      lappend ustData(targetParamFile)    $fname
      lappend ustData(targetParamFileSeq) $seq

      set subdir  [string range [file dirname $fname] [expr [string length $v(saveDir)] + 1] end]
      if {[string length $subdir] > 0} {
        set l "$subdir/$l"
      }
      puts $out $l    ;# ヒットした行を書き込む
      close $in
      return $seq
    }
  }
  close $in
  return -1
}

#---------------------------------------------------
# 歌詞にprefixMapを適用する
proc utaup_applyPrefixMap {} {
  global ustData

  set ustData(lyricMapped) {}

  for {set i 0} {$i < [llength $ustData(lyric)]} {incr i} {
    set lyric   [lindex $ustData(lyric)   $i]
    set noteNum [lindex $ustData(noteNum) $i]

    # 歌詞冒頭に?があるかチェック
    if {[regexp {^\?} $lyric]} {
      regsub -- {^\?} $lyric "" oto
      lappend ustData(lyricMapped) $oro
      continue
    }

    set note [utaup_notenum2tonename $noteNum]

    set inFile "$ustData(voiceDir)\\prefix.map"
    regsub -all -- {\\} $inFile "/" inFile

    if [catch {open $inFile r} in] {
      # prefixmapが無ければそのまま返す
      lappend ustData(lyricMapped) $lyric
      continue
    }
    set pref ""
    set suff ""
    set hit 0
    while {![eof $in]} {
      set l [gets $in]
      if {[regexp "^$note\t" $l]} {
        set data [split $l "\t"]
        set pref [lindex $data 1]
        set suff [lindex $data 2]
        lappend ustData(lyricMapped) "$pref$lyric$suff"   ;# prefixmapを適用して返す
        set hit 1
        break
      }
#      if {[regexp "^$note\t(.*)\t(.*)$" $l pref suff]} {
#        close $in
#        set pref [string trim $pref]
#        set suff [string trim $suff]
#        return "$pref$ustData(lyric)$suff"   ;# prefixmapを適用して返す
#      }
    }
    close $in
    if {$hit == 0} {
      lappend ustData(lyricMapped) $lyric   ;# prefixmapでヒットしなければそのまま返す
    }
  }
}

#---------------------------------------------------
# ノート番号に対応する音高文字列("C1"など)を返す
# (NoteNum=24) == C1
# 
proc utaup_notenum2tonename {noteNum} {
  global sv

  set octave [expr ($noteNum - 24) / 12 + 1]
  set tone   [lindex $sv(toneList) [expr ($noteNum - 24) % 12]]
  return "$tone$octave"
}
