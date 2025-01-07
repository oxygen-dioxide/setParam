# --------------------------------
# Setparam Simplified Chinese localization file
# By:Raindropx
# Date:2019/03/03
# twitter.com/abclry
# abclry@qq.com
# Setparam version:4.0-b170506
# --------------------------------
# font setting
#

set t(fontName) "Microsoft YaHei UI"

#--------------------------------
# messages
#

# common dialog messages
set t(.confm)        "确认"
set t(.confm.r)      "加载"
set t(.confm.nr)     "不加载"
set t(.confm.fioErr) "文件读写错误"
set t(.confm.yes)    "是"
set t(.confm.no)     "否"
set t(.confm.ok)     "确定"
set t(.confm.apply)  "应用"
set t(.confm.run)    "好"
set t(.confm.c)      "取消"
set t(.confm.errTitle) "错误"
set t(.confm.warnTitle) "警告"
set t(.confm.delParam)  "当前的原音设定将会直接被删除,你确定?"
set t(undo)      "撤销"
set t(undo,undo) "撤销(Ctrl+z)"
set t(undo,redo) "重做(Ctrl+y)"

# reading wave files in save folder
set t(makeRecListFromDir,q)  "是否加载原音设定文件?"
set t(makeRecListFromDir,a)  "自动推算原音设定参数"

# wizard message at parameter auto estimation at startup
set t(genParamWizard,title)  "音源类型"
set t(genParamWizard,q)      "选择目标音源的"
set t(genParamWizard,a0)     "单独音 1 (使用默认推算方式)"
set t(genParamWizard,a1)     "单独音 2 (使用'lib-an'来推算)"
set t(genParamWizard,a2)     "连续音(VCV)"
set t(genParamWizard,ap)     "使用插件进行推算"

# reading initialisation file
set t(doReadInitFile,errMsg)    "加载配置文件失败"
set t(doReadInitFile,errMsg2)   "配置文件中有语法错误,只允许'set varname {value}'"

# saving reclist.txt
set t(saveRecList,title)     "保存录音表"
set t(saveRecList,errMsg)    "$v(recListFile)写入失败"
set t(saveRecList,errMsg2)   "写入失败"
set t(saveRecList,doneMsg)   "录音表已保存到$v(recListFile)."

# reading utterance list
set t(readRecList,title1)    "加载录音表"
set t(readRecList,errMsg)    "加载录音表($v(recListFile)失败."
set t(readRecList,errMsg2)   "无法加载"
set t(readRecList,doneMsg)   "$v(recListFile)已加载."

# reading utterance type list
set t(readTypeList,title)    "加载发音类型表"
set t(readTypeList,errMsg)   "加载发音类型表($v(typeListFile)失败."
set t(readTypeList,errMsg2)  "加载失败"
set t(readTypeList,doneMsg)  "$v(typeListFile)已加载."

# specify save folder
set t(choosesaveDir,title)   "设置音源文件夹"
set t(choosesaveDir,doneMsg) "音源文件夹已设定"
set t(choosesaveDir,q)       "是否加载原音设定文件?"

# F0 estimation
set t(waitWindow,title)      "正在计算F0..."

# switching plus/minus of right blank value
set t(changeE,title)         "调整已有的右边界"
set t(changeE,q)             "右边界的值是负数,要转换么?"
set t(changeE,a)             "转换为基于文件结尾的表示法(位置不动)"
set t(changeE,a2)            "把数值转换为正(改变位置)"
set t(changeE,a3)            "不转换"
set t(changeE,q2)            "右边界的值是正数,要转换么?"
set t(changeE,a21)           "转换为基于左边界数值的表示法(位置不动)"
set t(changeE,a22)           "把数值转换为负(改变位置)"
set t(changeE,undo)          "切换正负"

set t(changeE,q,1)           "右边界的值是负数,要转换么?"
set t(changeE,a,1)           "转换为基于文件结尾的表示法(位置不动)"
set t(changeE,a2,1)          "把数值转换为正(改变位置)"
set t(changeE,a3,1)            "不转换"

set t(changeE,q,-1)          "右边界的值是正数,要转换么?"
set t(changeE,a,-1)          "转换为基于左边界数值的表示法(位置不动)"
set t(changeE,a2,-1)         "把数值转换为负(改变位置)"
set t(changeE,a3,-1)         "不转换"

# adding alias
set t(aliasComplement,doneMsg)   "num个辅助记号已添加"
set t(aliasComplement,doneTitle) "补充完成"
set t(aliasComplement,selMsg)    "选择一个做完的连续音(VCV)的原音设定作为参照"
set t(aliasComplement,q)         "你要把其他文件夹中的连续音(VCV)的原音设定设为参照么?"
set t(aliasComplement,undo)      "辅助记号补充"

# complement some utterance entry
set t(woComplement,doneMsg)   "num个日语'wo'已补充"
set t(woComplement,doneTitle) "补充完成"
set t(woComplement,undo)      "用'o'补充'wo'"

# insert '_' to the head of wav file names
set t(addUnderScore,q)       "在wav文件名前面加入'_'(不影响已经带'_'的文件),你确定?"
set t(addUnderScore,q2)      "在wav和frq文件名前面加入'_',此操作会覆写oto.ini并且无法撤销"
set t(addUnderScore,doneMsg) "文件名转换完成"
set t(addUnderScore,doneMsg2) "没有找到可改动的文件名"
set t(addUnderScore,doneMsg3) "文件名与oto.ini已改动,建议尽快保存"
set t(addUnderScore,doneTitle) "已完成"

# converte to monaural
set t(convertMonoAll,q)         "音源文件夹里的所有wav都会被转换成单声道,你确定?"
set t(convertMonoAll,doneMsg)   "单声道转换完成"
set t(convertMonoAll,doneTitle) "转换完成"

# removing DC in wav files
set t(removeDCall,q)         "移除音源文件夹里所有wav的直流偏移,你确定?"
set t(removeDCall,doneMsg)   "直流偏移已移除."
set t(removeDCall,doneTitle) "完成"

# utterance timing check
set t(uttTimingSettings,title)      "发声时机检查设定"
set t(uttTimingSettings,click)      "采样: "
set t(uttTimingSettings,clickTitle) "节拍音设置"
set t(uttTimingSettings,tempo)      "节奏: "
set t(uttTimingSettings,bpm)        "BPM = "
set t(uttTimingSettings,bpmUnit)    "毫秒/拍"
set t(uttTimingSettings,clickNum)   "节拍数: "
set t(uttTimingSettings,clickUnit)  "次"
set t(uttTimingSettings,mix)        "发音与节拍音的音量平衡: "

# utterance timing check
set t(doUttTimingSettings,errMsg)   "请将节拍数设置为20或更少的数值"
set t(doUttTimingSettings,errMsg2)  "请将节拍数设置为0以上的数值"

# test play for utterance timing check
set t(playUttTiming,msg)            "仅能播放20个或更少的发音,将会播放前20个发音"
set t(playUttTiming,playMsg)       "开始检查"
set t(playUttTiming,stopMsg)       "停止检查"

# pitch guide
set t(pitchGuide,title)             "音高引导"
set t(pitchGuide,sel)               "设置引导音: "
set t(pitchGuide,vol)               "音量: "

# oto.ini generation
set t(genParam,title)  "为连续音(VCV)生成oto.ini"
set t(genParam,tempo)  "录音节奏: "
set t(genParam,bpm)    "单位: bpm"
set t(genParam,S)      "发音起始: "
set t(genParam,unit)   "单位: "
set t(genParam,haku)   "节拍"
set t(genParam,darrow) "↓　↓"
set t(genParam,bInit)  "根据录音节奏来初始化"
set t(genParam,bInit2) "检索当前显示的设定"
set t(genParam,O)      "重叠(Ovl): "
set t(genParam,msec)   "单位: 毫秒"
set t(genParam,P)      "预发声(Pre): "
set t(genParam,C)      "固定范围(Con): "
set t(genParam,E)      "右边界(R): "
set t(genParam,do)     "生成参数"
set t(genParam,aliasMax)          "* 附加序号来区分重复的辅助记号?"
set t(genParam,aliasMaxNo)        "不用 (保留重复的辅助记号)"
set t(genParam,aliasMaxYes)       "好的 (附加序号)"
set t(genParam,aliasMaxNum)       "序号的最大值(0=不限制)"
set t(genParam,autoAdjustRen)     "使用参数自动纠正 1 (基于响度)"
set t(genParam,vLow)              "预发声前的响度低谷: "
set t(genParam,sRange)            "预发声的可移动范围: "
set t(genParam,f0pow)             "* F0和其他响度相关的参数将被使用."
set t(genParam,db)                "单位: dB"
set t(genParam,autoAdjustRen2)    "使用参数自动纠正 2 (基于MFCC,可能会很慢)"
set t(genParam,autoAdjustRen2Opt) "选项"
set t(genParam,autoAdjustRen2Pattern) "适用对象"
set t(genParam,alias)                 "辅助记号设定"
set t(genParam,suffix)                "后缀:"
set t(genParam,aliasRecList)          "重复辅助记号的优先级列表(录音表或oto.ini): "
set t(genParam,aliasReclistTitle)     "打开重复辅助记号的优先级列表"
set t(genParam,aliasSelect)           "选择"
set t(genParam,aliasReset)            "重设"
set t(genParam,uscore)                "文件名中的'_'的相关设定"
set t(genParam,uscoreIgnore)          "忽略"
set t(genParam,uscoreRest)            "视为休止符"
set t(genParam,uscoreDelimiter)       "视为分隔符"

# oto.ini generation
set t(doGenParam,doneMsg) "$v(paramFile)已加载"

# search
set t(searchParam,title)     "查找"
set t(searchParam,search)    "查找"
set t(searchParam,rup)       "向上查找"
set t(searchParam,rdown)     "向下查找"
set t(searchParam,doneTitle) "完成"
set t(searchParam,doneMsg)   "未找到"
set t(searchParam,rMatch1)   "完全匹配"
set t(searchParam,rMatch2)   "部分匹配"

# play/stop wave
set t(togglePlay,stopMsg) "已停止"
set t(togglePlay,playMsg) "播放中..."

# color selection
set t(chooseColor,title) "颜色设定"

# wave color selection
set t(setColor,selColor) "颜色设定"

# pitch list playing
set t(packToneList,play)   "播放"
set t(packToneList,repeat) "重复"

# read initialization file
set t(readSettings,title)     "选择配置文件"

# save current setting
set t(saveSettings,title)  "生成配置文件"

# Audio I/O setting
set t(ioSettings,title)    "音频输入/输出设置"
set t(ioSettings,inDev)    "输入设备: "
set t(ioSettings,outDev)   "输出设备: "
set t(ioSettings,inGain)   "输入增益(取决于设备): "
set t(ioSettings,outGain)  "输出增益(取决于设备): "
set t(ioSettings,latency)  "延迟(对于一些设备没有效果): "
set t(ioSettings,sndBuffer) "录音缓冲区大小: "
set t(ioSettings,bgmBuffer) "录音BGM缓冲区大小: "
set t(ioSettings,comment0) "* 我建议你保持默认值."
set t(ioSettings,comment0b) "* 特别是DirectSound在Snack-lib上表现不稳定(至少在日语Windows下是这样的)"
set t(ioSettings,comment1) "* 在按下'应用'或'确认'之前设置不会生效"
set t(ioSettings,comment2) ""

# external parameter estimation
set t(autoParamEstimation,title)     "执行外部工具(自动推算工具)"
set t(autoParamEstimation,aepTool)   "外部工具"
set t(autoParamEstimation,selTitle)  "外部工具位置"
set t(autoParamEstimation,option)    "外部工具启动脚本"
set t(autoParamEstimation,aepResult) "外部工具输出文件"
set t(autoParamEstimation,runMsg)    "启动外部工具"
set t(autoParamEstimation,resultMsg) "检索外部工具执行结果"

# estimate boundary of both side of utterance
set t(estimateParam,title)       "自动推算参数(单独音)"
set t(estimateParam,frameLength) "帧长度"
set t(estimateParam,preemph)     "预加重"
set t(estimateParam,pWinLen)     "响度采样窗口长度"
set t(estimateParam,pWinkind)    "窗口类型"
set t(estimateParam,pUttMin)     "发音的最小响度"
set t(estimateParam,vLow)        "元音的最小响度"
set t(estimateParam,pUttMinTime) "发音的最短时长"
set t(estimateParam,uttLen)      "响度抖动"
set t(estimateParam,silMax)      "静音区的响度最大值"
set t(estimateParam,silMinTime)  "静音区最短持续时间n"
set t(estimateParam,minC)        "固定范围的最小值"
set t(estimateParam,f0)          "* 也会使用F0提取参数"
set t(estimateParam,target)      "推算对象"
set t(estimateParam,S)           "左边界"
set t(estimateParam,C)           "固定范围"
set t(estimateParam,E)           "右边界"
set t(estimateParam,P)           "预发声"
set t(estimateParam,O)           "重叠"
set t(estimateParam,overWrite)   "当前的参数会被覆盖,OK么?"
set t(estimateParam,runAll)      "应用到所有wav文件"
set t(estimateParam,runSel)      "应用到选中的wav文件"
set t(estimateParam,default)     "恢复默认设置"
set t(estimateParam,ovl)         "重叠(Ovl)的位置比"
set t(estimateParam,ovlPattern)  "重叠(Ovl)的推算对象"
set t(estimateParam,preEstimate) "自动设置每一项的参数"
set t(estimateParam,hpfPattern)  "高通滤波对象"
set t(estimateParam,lpfPattern)  "低通滤波对象"
set t(estimateParam,hpfComment)  "(目标发音的第一个字母)"
set t(estimateParam,lpfComment)  "(目标发音的第一个字母)"
set t(estimateParam,edit)        "编辑"

# parameter estimation
set t(doEstimateParam,startMsg)  "正在自动推算参数..."
set t(doEstimateParam,doneMsg)   "推算完成"

# zero cross adjustment
set t(zeroCross,title)           "矫正零交叉"
set t(zeroCross,target)          "矫正目标"
set t(zeroCross,S)               "左边界"
set t(zeroCross,C)               "固定范围"
set t(zeroCross,E)               "右边界"
set t(zeroCross,P)               "预发声"
set t(zeroCross,O)               "重叠"
set t(zeroCross,sec)             "秒"
set t(zeroCross,runAll)          "应用到所有wav文件"
set t(zeroCross,runSel)          "应用到选区"

# auto focus
set t(autoFocus,none)  "不聚焦"

# execte plugin
set t(runPlugin,undo) "运行插件"

# read parameter
set t(readParamFile,selMsg)   "选择原音设定文件"
set t(readParamFile,startMsg) "正在加载原音设定..."
set t(readParamFile,errMsg)   "$v(paramFile)指向了$v(saveDir) /中不存在的wav文件 ."
set t(readParamFile,example)  "例如: "
set t(readParamFile,errMsg2)  "缺少的条目已添加到$v(paramFile)."
set t(readParamFile,doneMsg)  "$v(paramFile)已加载."

# save parameters
set t(saveParamFile,selFile)  "Save Voice Configuration Parameters"
set t(saveParamFile,startMsg) "Saving voice configuration parameters..."
set t(saveParamFile,doneMsg)  "Saved voice configuration parameters."
set t(saveParamFile,confm)    "is already exist. Overwrite it?"

# zoom
set t(changeZoomX,title)      "缩放比例设定"
set t(changeZoomX,unit)       "(单位=%. 100%=显示整个波形)"
set t(changeZoomX,change)     "修改"

# advanced settings
set t(settings,title)        "高级设定"
set t(settings,wave)         "<波形>"
set t(settings,waveColor)    "波形颜色: "
set t(settings,waveScale)    "纵轴最大值(0-32768, 0=自动调整)"
set t(settings,sampleRate)   "采样率 \[Hz\]: "
set t(settings,spec)         "<频谱>"
set t(settings,specColor)    "频谱颜色: "
set t(settings,maxFreq)      "最高频率 \[Hz\]: "
set t(settings,brightness)   "明亮度: "
set t(settings,contrast)     "对比度: "
set t(settings,fftLength)    "FFT长度 \[sample\]: "
set t(settings,fftWinLength) "窗口长度 \[sample\]: "
set t(settings,fftPreemph)   "预加重: "
set t(settings,fftWinKind)   "窗口类型"
set t(settings,pow)          "<响度>"
set t(settings,powColor)     "响度曲线颜色ur: "
set t(settings,powLength)    "响度采样单位 \[秒\]: "
set t(settings,powPreemph)   "预加重: "
set t(settings,winLength)    "窗口长度 \[秒\]: "
set t(settings,powWinKind)   "窗口类型: "
set t(settings,f0)           "<F0 (音高)>"
set t(settings,f0Color)      "F0曲线颜色ur: "
set t(settings,f0Argo)       "分析算法: "
set t(settings,f0Length)     "F0采样率 \[sec\]: "
set t(settings,f0WinLength)  "窗口长度 \[sec\]: "
set t(settings,f0Max)        "F0最大值 \[Hz\]: "
set t(settings,f0Min)        "F0最小值 \[Hz\]: "
set t(settings,f0Unit)       "显示单位: "
set t(settings,f0FixRange)   "固定显示范围: "
set t(settings,f0FixRange,h) "最大值: "
set t(settings,f0FixRange,l) "最小值: "
set t(settings,grid)         "显示网格"
set t(settings,gridColor)    "网格颜色: "
set t(settings,target)       "显示目标音高"
set t(settings,targetTone)   "目标音高: "
set t(settings,targetColor)  "目标音高音色: "
set t(settings,autoSetting)  "根据目标来修改参数: "

# drawing canvas
set t(Redraw,S) "左"
set t(Redraw,C) "固定"
set t(Redraw,P) "预"
set t(Redraw,O) "重叠"
set t(Redraw,E) "右"

# exit
set t(Exit,q1) "原音设定未保存,你想要保存么?"
set t(Exit,q2) "当前的wav文件未保存,你想要保存么?"
set t(Exit,a1) "保存并退出"
set t(Exit,a1b) "另存为并退出"
set t(Exit,a2) "不保存"
set t(Exit,a3) "取消"

# right click menu
set t(PopUpMenu,showWave)   "显示波形"
set t(PopUpMenu,showSpec)   "显示频谱"
set t(PopUpMenu,showPow)    "显示响度"
set t(PopUpMenu,showF0)     "显示音高曲线(F0)"
set t(PopUpMenu,pitchGuide) "显示音高向导"
set t(PopUpMenu,settings)   "高级设定"
set t(PopUpMenu,zoomTitle)  "横向缩放"
set t(PopUpMenu,zoom0)      "x1 (总是显示整个波形)"
set t(PopUpMenu,zoom100)    "x1 (显示整个波形)"
set t(PopUpMenu,zoom1000)   "x10"
set t(PopUpMenu,zoom5000)   "x50"
set t(PopUpMenu,zoom10000)  "x100"
set t(PopUpMenu,zoomMax)    "放到最大"
set t(PopUpMenu,changeZoomX) "设置缩放率"
set t(PopUpMenu,alwaysOnTop) "总是置顶"
set t(PopUpMenu,setAlpha)    "窗体透明度"

# version
set t(Version,msg) "版本"

# ParamU initialization
set t(initParamU,0) "发音"
set t(initParamU,1) "左边界"
set t(initParamU,2) "重叠"
set t(initParamU,3) "预发声"
set t(initParamU,4) "固定范围"
set t(initParamU,5) "右边界"
set t(initParamU,6) "辅助记号"
set t(initParamU,7) "注释"

# parameter table window title
set t(setEPWTitle) "原音设定参数表"

# duplicate line in parameter table
set t(duplicateEntp,msg)   "一次只能克隆一行"
set t(duplicateEntp,title) "克隆失败"
set t(duplicateEntp,undo)  "克隆行"

# delete line in parameter table
set t(deleteEntp,msg)   "要删除行,请仅选中一行"
set t(deleteEntp,title) "删除出错"
set t(deleteEntp,undo)     "删除行"

# wave trimming
set t(cutWav,title)    "修剪wav文件"
set t(cutWav,L)        "切头"
set t(cutWav,R)        "砍尾"
set t(cutWav,sec)      "秒"
set t(cutWav,adjSE)    "在修剪后调整左右边界的数值以使它们的位置不动\n(如果切掉的长度比空白区域长的话它们就会移动)"

# wave trimming
set t(doCutWav,q)         "文件夹里的所有wav都会被修剪,OK么?"
set t(doCutWav,doneMsg)   "wav文件修剪完成"
set t(doCutWav,doneTitle) "大成功!!!"
set t(doCutWav,errMsg)   "切除的长度必须为0秒或者更长"

# wave trimming confirm
set t(cutBlankConfirm,q) "开启wav修剪模式(按F9键)。进行这项操作时撤销记录会被清空。OK么?"

# change alias
set t(changeAlias,title)      "批量修改辅助记号"
set t(changeAlias,trans)      "重命名规则: "
set t(changeAlias,delPreNum)  "从开头开始删除的字符数"
set t(changeAlias,delPostNum) "从末尾开始删除的字符数"
set t(changeAlias,tips0)      "%m = 歌词名 (例如: 'a', 'a ka')"
set t(changeAlias,tips0b)     "%s = 后缀 (例如: 'ka2'的 '2')"
set t(changeAlias,tips1)      "%a = 辅助记号名"
set t(changeAlias,tips2)      "%f = 文件名 (不带扩展名)"
set t(changeAlias,tips3)      "%r = 给重复的辅助记号添加序号"
set t(changeAlias,ex1)        "(栗子 1) 如果你要把'a.wav'的辅助记号设为 'a2',把规则写成'%f2',不用填写其他选项"
set t(changeAlias,aliasMaxNum)       "%r的最大值(0=无限)"
set t(changeAlias,runAll)     "应用到所有wav文件"
set t(changeAlias,runSel)     "应用到选定的wav文件"

# make target list from ust file
set t(readUstFile,doneMsg)    "UST最小发音集整理完成"
set t(readUstFile,startMsg)   "选择一个UST文件,并且选出合成这首歌所需的最小发音集"
set t(readUstFile,modeComment) "在必要的发音后附加注释"
set t(readUstFile,comment)     "注释:"
set t(readUstFile,modeDelete)  "删除不必要的音"
set t(readUstFile,errMsg)      "失败了,请再试一次"
set t(readUstFile,undo)        "加载UST文件"
set t(readUstFile,limit)       "重复数量限制(0=不限制)"

# utterance timing adjustment mode
set t(timingAdjMode,startMsg) "启用发声时机调整模式。如有必要,请重新配置右边界的表示法和移动预发声时的行为"
set t(timingAdjMode,doneMsg)  "关闭发声时机调整模式。"
set t(timingAdjMode,on)       "发声时机(Pre)调整模式已开启"
set t(timingAdjMode,off)      "发声时机(Pre)调整模式已关闭"

# region play
set t(clickPlayRangeMode,errMsg) "要启用这个播放功能,请关闭发声时机矫正模式"

# change value at selected cells
set t(changeCell,title)   "改动选中单元格的值"
set t(changeCell,r1)      "加上"
set t(changeCell,r2)      "减去"
set t(changeCell,r3)      "设为"
set t(changeCell,r4)      "转换为整数"
set t(changeCell,l)       "数值: "
set t(changeCell,rtitle)  "<限制范围>"
set t(changeCell,rr1)     "不限制"
set t(changeCell,rr2)     "等于"
set t(changeCell,rr3)     "以上"
set t(changeCell,rr4)     "以下"
set t(changeCell,rl)      "限制值: "

# merge oto.ini
set t(mergeParamFile,selMsg)   "选择oto.ini"
set t(mergeParamFile,startMsg) "开始合并"
set t(mergeParamFile,doneMsg)  "合并完成"

# regino play
set t(setPlayRange,title)  "局部播放设定"
set t(setPlayRange,start)  "播放的起始位置"
set t(setPlayRange,end)    "播放的结束位置"
set t(setPlayRange,head)   "文件开头"
set t(setPlayRange,tail)   "文件末端"
set t(setPlayRange,guide)  "* Ctrl+t...播放"

# auto backup
set t(autoBackup,q)     "找到了一个备份文件,在上一次使用中程序可能异常退出。要还原备份的话,把setparam文件夹里的'backup.ini'移动到你的音源文件夹,并重命名为oto.ini"
set t(autoBackup,a1)    "退出setParam"
set t(autoBackup,a2)    "删除backup.ini并继续操作"

# paste from clipboard
set t(pasteCell,q1)     "目标和来源的数值区间不一致,你是否要粘贴?"
set t(pasteCell,undo)   "粘贴"


# time axis setting
set t(setBPMWindow,title)  "时间轴设定"
set t(setBPMWindow,tempo)  "节奏="
set t(setBPMWindow,offset) "偏移="
set t(setBPMWindow,sec)    "(秒)"

# change value keyboard input
set t(changeParam,undo) "修改单元格数值"

# change value by using mouse
set t(setParam,undoS) "移动左边界(L)"
set t(setParam,undoC) "移动固定范围(Con)"
set t(setParam,undoE) "移动右边界(R)"
set t(setParam,undoP) "移动预发声(Pre)"
set t(setParam,undoO) "移动重叠(Ovl)"

# test synthesis
set t(synWindow,title)     "合成测试设定"
set t(synWindow,syn)       "合成引擎: "
set t(synWindow,synSelect) "选择合成引擎"
set t(synWindow,setPitch)  "音高: "
set t(synWindow,setLength) "长度(毫秒): "
set t(synWindow,setFlag)   "参数(Flags,默认为无参)"
set t(synWindow,setVolume) "音量(默认为100)"
set t(synWindow,setMod)    "移调(默认为0)"
set t(synWindow,setCSpeed) "辅音速度(默认为100)"
set t(playSyn,errMsg)      "未选择合成引擎"

# reset undo
set t(clearUndo,q)         "清空撤销记录,OK么?"

# transparency rate
set t(setAlphaWindow,title)  "窗体透明度"

# plugin mode
set t(utaup_readUst,err1) "无法打开"
set t(utaup_readUst,err2) "获取目标信息失败"
set t(utaup_readUst,err3) "无法定位缓存文件夹,请先保存UST工程"
set t(utaup_readUst,err4) "无法写入"
set t(utaup_readUst,err5) "启动插件模式失败: 无法找到目标波形文件夹"
set t(utaup_updateTargetParamFile,err1) "更新oto.ini失败"

