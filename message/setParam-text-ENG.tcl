#
# setParamメイン窓のトップメニュー
#
set t(option,setLanguage) "Read Language"

set t(file)                      "File"
set t(file,choosesaveDir)        "Set Save Folder"
set t(file,readParamFile)        "Load Voice Configurations (Ctrl+o)"
set t(file,saveParamFile)        "Save Voice Configurations (Ctrl+s)"
set t(file,saveParamFileAs)      "Save Voice Configurations as ... (Ctrl+Shift+s)"
set t(file,mergeParamFile)       "Merge Another oto.ini"
set t(file,readSettings)         "Load Specified Initialisation File..."
set t(file,saveSettings)         "Save Current Configurations to Initialisation File"
set t(file,readUstFile)          "Pick up Minimum Voices for a ust File"
set t(file,dirHistory)           "Open Recent Folder..."
set t(file,pDirHistory)          "Open The Parent of Recent Folder..."

set t(file,test)                 "Normally Unused Features"
set t(file,test,makeRecList)     "Generate Voice List from wav Files in Recording Folder"
set t(file,test,makeRecList,msg) "Updated Voice and Utterance Type Lists."
set t(file,test,readRecList)     "Load Voice List"
set t(file,test,saveRecList)     "Save Voice List"
set t(file,test,readTypeList)    "Load Utterance Type List"
set t(file,Exit)                 "Exit"


set t(edit)                      "Edit"
set t(edit,tk_tableCopy)         "Copy          (Ctrl+c)"
set t(edit,pasteCell)            "Paste         (Ctrl+v)"
set t(edit,searchParam)          "Find          (Ctrl+f)"
set t(edit,doSearchParam1)       "Find Again    (Ctrl+g, Ctrl+n)"
set t(edit,doSearchParam0)       "Find Previous (Ctrl+G, Ctrl+N)"
set t(edit,changeCell)           "Change The Values in the Selection (Ctrl+m)"
set t(edit,estimateParam)        "Parameter Automatic Estimation (for CV Diphones)"
set t(edit,zeroCross)            "Zero-cross Correction"
set t(edit,copyWithSpace)        "Copy & Paste"
set t(edit,copyCellWithSpace)    "Copy  (delimiter = space)"
set t(edit,pasteCellWithSpace)   "Paste (delimiter = space)"
set t(edit,duplicateEntp)        "Duplicate Parameter Row (Ctrl+i)"
set t(edit,deleteEntp)           "Delete Parameter Row  (Ctrl+d)"

set t(show)                      "Show"
set t(show,showSpec)             "Show Spectrum"
set t(show,showpow)              "Show Power"
set t(show,showf0)               "Show F0"
set t(show,pitchGuide)           "Show Pitch Guide"
set t(show,zoomTitle)            "Time Zoom"
set t(show,timeAxis)             "Time Axis"
set t(show,timeAxisSec)          "Second"
set t(show,timeAxisBar)          "Musical Bar"

set t(option)                    "Options"
set t(option,gui)                "Mouse and Key Settings"
set t(option,S)                  "When left blank is modified, "
set t(option,S,1)                "other parameters are modified accordingly to keep relative positions. (Shift+l)"
set t(option,S,2)                "other parameters keep their positions in the wav file. (Shift+l)"
set t(option,E)                  "Notation of Right Blank Parameter"
set t(option,E,1)                "From the End of File (Positive value, UTAU v0.2.43 and before only accepts this)"
set t(option,E,2)                "From the Left Blank (Negative value, available for UTAU v0.2.45beta and later)"
set t(option,P)                  "When preutterlance is modified, "
set t(option,P,1)                "other parameters are modified accordingly to keep relative positions. (Shift+p)"
set t(option,P,2)                "other parameters keep their positions in the wav file. (Shift+p)"
set t(option,minusO)             "Overlap value can be negative."
set t(option,blankBroom)         "Unconstrained editing of right and left blank"
set t(option,cutBlank)           "F9 crops the region between the right and left blanks."
set t(option,timingAdjMode)      "Utterance Timing Adjustment Mode"
#set t(option,unusual)            "本来使わない機能"
#set t(option,removeDC)           "録音後にDC成分を除去する"
#set t(option,rec)                "録音機能を使う"
set t(option,uttTimingSettings)  "Utterance Timing Check Settings"
set t(option,ioSettings)         "Audio I/O Settings"
set t(option,settings)           "Advanced Settings"
set t(option,setPlayRange)       "Region Play Settings"
set t(option,synTestWindow)      "Test Synthesis Settings (Play=F10)"
set t(option,clickPlayRangeMode) "Partial play by click"
set t(option,autoFocus)          "Auto Focus Settings"

set t(tool)                      "Tools"
set t(tool,auto)                 "Parameter Automatic Estimation"
set t(tool,auto,estimateParam)       "CV  (Isolated Utterances) (1)"
set t(tool,auto,autoParamEstimation) "CV  (Isolated Utterances) (2) (by External Tool 'lib-an')"
set t(tool,auto,genParam)            "VCV (Continuous Utterances)"
set t(tool,auto,plugin)              "Plugin"
set t(tool,removeDCall)          "Remove All DC Offsets"
set t(tool,addUnderScore)        "Insert '_' to the Head of wav File Name (VCV)"
set t(tool,addUnderScore2)       "Insert '_' to the Head of wav & frq File Name (VCV)"
set t(tool,test)                 "Testing"
set t(tool,cutWav)               "Trim wav Files"
set t(tool,changeAlias)          "Change Aliases"
set t(tool,convertMonoAll)       "Convert Stereo to Monaural"
set t(tool,wav)                  "Edit Wav Files"
set t(tool,zeroCross)            "Zero-cross correction"
set t(tool,runExplorer)          "Open the Save Folder with Explorer"

set t(tool,finish)                 "Post-processing Tools"
set t(tool,finish,aliasComplement) "Substitute CV (Isolated Utterances) Aliases for Lacking VCV (Continuous Utterances) Ones"
set t(tool,finish,woComplement)    "Substitute Japanese-'o' for Japanese-'wo' if It Is Lacking"
set t(tool,sort)                   "Sort the Parameter List"
set t(tool,sort,sortByVowel)       "Sort by KANA Order"
set t(tool,sort,sortByFID)         "Sort by Wav File Name Order"

set t(help)                      "Help"
set t(help,onlineHelp)           "On-line Manual"
set t(help,Version)              "Version"
set t(help,official1)            "Visit Official Web Page"
set t(help,official2)            "Visit Official Download Page"

#
# setParamメイン窓のその他のラベル
#
set t(.saveDir.midashi)     "Recording Folder: "


