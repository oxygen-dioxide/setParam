# --------------------------------
# Setparam Simplified Chinese localization file
# By:Raindropx
# Date:2019/03/03
# twitter.com/abclry
# abclry@qq.com
# Setparam version:4.0-b170506
# --------------------------------

set t(option,setLanguage) "语言设置"

set t(file)                      "文件"
set t(file,choosesaveDir)        "设置保存文件夹"
set t(file,readParamFile)        "加载原音设定(Ctrl+o)"
set t(file,saveParamFile)        "保存原音设定(Ctrl+s)"
set t(file,saveParamFileAs)      "原音设定另存为 ... (Ctrl+Shift+s)"
set t(file,mergeParamFile)       "与另一个oto.ini合并"
set t(file,readSettings)         "加载配置文件..."
set t(file,saveSettings)         "将当前设置保存为配置文件"
set t(file,readUstFile)          "选出UST工程里所需的发音"
set t(file,dirHistory)           "打开最近的文件夹..."
set t(file,pDirHistory)          "打开当前文件夹的父文件夹..."

set t(file,test)                 "一般用不到的功能"
set t(file,test,makeRecList)     "从当前音源生成录音表"
set t(file,test,makeRecList,msg) "更新录音表和发音类型表"
set t(file,test,readRecList)     "加载录音表"
set t(file,test,saveRecList)     "保存录音表"
set t(file,test,readTypeList)    "加载发音类型表"
set t(file,Exit)                 "退出"


set t(edit)                      "编辑"
set t(edit,tk_tableCopy)         "复制          (Ctrl+c)"
set t(edit,pasteCell)            "粘贴         (Ctrl+v)"
set t(edit,searchParam)          "查找          (Ctrl+f)"
set t(edit,doSearchParam1)       "查找下一个    (Ctrl+g, Ctrl+n)"
set t(edit,doSearchParam0)       "查找上一个 (Ctrl+G, Ctrl+N)"
set t(edit,changeCell)           "改变选区的数值 (Ctrl+m)"
set t(edit,estimateParam)        "自动推算参数 (单独音)"
set t(edit,zeroCross)            "矫正零交叉"
set t(edit,copyWithSpace)        "复制&粘贴"
set t(edit,copyCellWithSpace)    "复制"
set t(edit,pasteCellWithSpace)   "粘贴"
set t(edit,duplicateEntp)        "重复当前行(Ctrl+i)"
set t(edit,deleteEntp)           "删除当前行(Ctrl+d)"

set t(show)                      "视图"
set t(show,showSpec)             "显示频谱"
set t(show,showpow)              "显示力度"
set t(show,showf0)               "显示F0"
set t(show,pitchGuide)           "显示音高引导"
set t(show,zoomTitle)            "横向缩放"
set t(show,timeAxis)             "时间轴参考"
set t(show,timeAxisSec)          "按秒"
set t(show,timeAxisBar)          "按小节"

set t(option)                    "选项"
set t(option,gui)                "键盘与鼠标设定"
set t(option,S)                  "当左边界(L)被移动时"
set t(option,S,1)                "其他参数以相对位置的关系同时移动(Shift+l)"
set t(option,S,2)                "其他参数的位置保持不动(Shift+l)"
set t(option,E)                  "右边界参数的表示法"
set t(option,E,1)                "从文件末端的数值开始计算 (正数,UTAU v0.2.43及之前的版本只支持这个)"
set t(option,E,2)                "从左边界的数值开始计算 (负数,UTAU v0.2.45beta及更高的版本可以使用)"
set t(option,P)                  "当预发声(Pre)被移动时 "
set t(option,P,1)                "其他参数以相对位置的关系同时移动(Shift+p)"
set t(option,P,2)                "其他参数的位置保持不动(Shift+p)"
set t(option,minusO)             "重叠(Ovl)的值可以是负数"
set t(option,blankBroom)         "不约束左右边界的数值"
set t(option,cutBlank)           "按下F9切除左右边界范围之外的部分"
set t(option,timingAdjMode)      "发声时机调整模式"
#set t(option,unusual)            ""
#set t(option,removeDC)           ""
#set t(option,rec)                ""
set t(option,uttTimingSettings)  "发声时机检查设定(按下F8可检查)"
set t(option,ioSettings)         "音频输入/输出设定"
set t(option,settings)           "高级设定"
set t(option,setPlayRange)       "局部播放设定"
set t(option,synTestWindow)      "测试合成效果(按下F10合成)"
set t(option,clickPlayRangeMode) "单击播放当前部分"
set t(option,autoFocus)          "自动聚焦设定"

set t(tool)                      "工具"
set t(tool,auto)                 "自动推算参数"
set t(tool,auto,estimateParam)       "单独音"
set t(tool,auto,autoParamEstimation) "单独音(使用附加工具'lib-an')"
set t(tool,auto,genParam)            "连续音"
set t(tool,auto,plugin)              "使用插件"
set t(tool,removeDCall)          "移除所有直流偏移"
set t(tool,addUnderScore)        "在wav的文件名前面加入'_'(连续音)"
set t(tool,addUnderScore2)       "在wav和frq的文件名前面加入'_'(连续音)"
set t(tool,test)                 "测试中"
set t(tool,cutWav)               "修剪wav文件"
set t(tool,changeAlias)          "批量修改辅助记号(别名)"
set t(tool,convertMonoAll)       "立体声转换为单声道"
set t(tool,wav)                  "编辑wav文件"
set t(tool,zeroCross)            "矫正零交叉"
set t(tool,runExplorer)          "使用资源管理器打开保存文件夹"

set t(tool,finish)                 "完成后的辅助工具"
set t(tool,finish,aliasComplement) "用单独音的辅助记号来替换连续音里缺少的"
set t(tool,finish,woComplement)    "如果缺少日语'wo',则使用日语'o'代替"
set t(tool,sort)                   "参数列表的排序方式"
set t(tool,sort,sortByVowel)       "按假名顺序"
set t(tool,sort,sortByFID)         "按wav文件名顺序"

set t(help)                      "帮助"
set t(help,onlineHelp)           "在线手册"
set t(help,Version)              "版本"
set t(help,official1)            "访问官方网站"
set t(help,official2)            "访问官方下载页"


set t(.saveDir.midashi)     "录音文件夹: "

