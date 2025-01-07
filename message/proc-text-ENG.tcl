#--------------------------------
# font setting
#
set t(fontName) "Arial"


#--------------------------------
# messages
#

# common dialog messages
set t(.confm)        "Confirmed"
set t(.confm.r)      "Load"
set t(.confm.nr)     "Don't Load"
set t(.confm.fioErr) "File I/O Error"
set t(.confm.yes)    "Yes"
set t(.confm.no)     "No"
set t(.confm.ok)     "OK"
set t(.confm.apply)  "Apply"
set t(.confm.run)    "Go"
set t(.confm.c)      "Cancel"
set t(.confm.errTitle) "Error"
set t(.confm.warnTitle) "Warning"
set t(.confm.delParam)  "All current voice configurations are removed.  OK?"
set t(undo)      "Undo"
set t(undo,undo) "Undo(Ctrl+z)"
set t(undo,redo) "Redo(Ctrl+y)"

# reading wave files in save folder
set t(makeRecListFromDir,q)  "Load voice configuration file?"
set t(makeRecListFromDir,a)  "Automatically Estimate Voice Configuration Parameters"

# wizard message at parameter auto estimation at startup
set t(genParamWizard,title)  "Voice Data Type"
set t(genParamWizard,q)      "Select the Type of Target Voice Data."
set t(genParamWizard,a0)     "CV  (Isolated Utterance) 1 (use auto-estimation of setParam)"
set t(genParamWizard,a1)     "CV  (Isolated Utterance) 2 (use auto-estimation of 'lib-an')"
set t(genParamWizard,a2)     "VCV (Continuous Utterance)"
set t(genParamWizard,ap)     "Auto estimation with plugin"

# reading initialisation file
set t(doReadInitFile,errMsg)    "Failed to load initialization file."
set t(doReadInitFile,errMsg2)   "Syntax error in initialization file. It allows 'set varname {value}' only."

# saving reclist.txt
set t(saveRecList,title)     "Save Voice List"
set t(saveRecList,errMsg)    "Failed to write to \$v(recListFile)."
set t(saveRecList,errMsg2)   "Failed to write voice names."
set t(saveRecList,doneMsg)   "Voice List is saved to \$v(recListFile)."

# reading utterance list
set t(readRecList,title1)    "Load Voice List"
set t(readRecList,errMsg)    "Failed to load recording voice name list (\$v(recListFile))."
set t(readRecList,errMsg2)   "Failed to load recording voice names."
set t(readRecList,doneMsg)   "Loaded \$v(recListFile)."

# reading utterance type list
set t(readTypeList,title)    "Load Utterance Type List"
set t(readTypeList,errMsg)   "Failed to load recording utterance type list (\$v(typeListFile))."
set t(readTypeList,errMsg2)  "Failed to load recording utterance types."
set t(readTypeList,doneMsg)  "Loaded \$v(typeListFile)."

# specify save folder
set t(choosesaveDir,title)   "Set Recording Folder"
set t(choosesaveDir,doneMsg) "Recording folder is modified."
set t(choosesaveDir,q)       "Load voice configuration parameter file as well?"

# F0 estimation
set t(waitWindow,title)      "Computing F0..."

# switching plus/minus of right blank value
set t(changeE,title)         "Adjust Existing Right Blank"
set t(changeE,q)             "Negative values are set to right blank.  Convert them?"
set t(changeE,a)             "Convert to end-of-file based notation. (Position preserved)"
set t(changeE,a2)            "Simply invert the sign to +. (Position changes)"
set t(changeE,a3)            "Don't convert."
set t(changeE,q2)            "Positive values are set to right blank.  Convert them?"
set t(changeE,a21)           "Convert to left-blank based notation. (Position preserved)"
set t(changeE,a22)           "Simply invert the sign to -. (Position changes)"
set t(changeE,undo)          "Change of +/- Sign"

set t(changeE,q,1)           "Minus value is exist in right blank. Do you want to change this?"
set t(changeE,a,1)           "Converting to time from the end of the file. (Not shift the current position. Change the value)"
set t(changeE,a2,1)          "Giving the '+' sign. (Shift the current position)"
set t(changeE,a3,1)            "Not Change"

set t(changeE,q,-1)          "There is plus value in the right blank fields. Do you want to change?"
set t(changeE,a,-1)          "Converting to time from the left blank. (Not shift the current position. Change the value)"
set t(changeE,a2,-1)         "Giving the '-' sign. (Shift the current position)"
set t(changeE,a3,-1)         "Not Change"

# adding alias
set t(aliasComplement,doneMsg)   "num aliases are added."
set t(aliasComplement,doneTitle) "Complementation completed."
set t(aliasComplement,selMsg)    "Select configured VCV (continuous utterance) oto.ini for reference"
set t(aliasComplement,q)         "Do you refer to a VCV (continuous utterance) oto.ini in other folder?"
set t(aliasComplement,undo)      "Alias Complement"

# complement some utterance entry
set t(woComplement,doneMsg)   "num counts of Japanese-'wo' are complemented."
set t(woComplement,doneTitle) "Complementation completed."
set t(woComplement,undo)      "Complement /wo/ with /o/"

# insert '_' to the head of wav file names
set t(addUnderScore,q)       "Insert '_' to the head of all the wav file names in the recording folder (do nothing to files already starting from '_').  OK?"
set t(addUnderScore,q2)      "Adding the '_' at the beginning of Wav & frq file name if they doesn't begin with it. Accordingly, rewriting the oto.ini. This process can't undo."
set t(addUnderScore,doneMsg) "File names are converted."
set t(addUnderScore,doneMsg2) "There was no file to be changed."
set t(addUnderScore,doneMsg3) "file names & oto.ini were changed. It's recommended that you save oto.ini as soon as possible."
set t(addUnderScore,doneTitle) "Completed"

# converte to monaural
set t(convertMonoAll,q)         "All wav files in the recording folder will be converted to monaural. OK?"
set t(convertMonoAll,doneMsg)   "Monauralisation Completed."
set t(convertMonoAll,doneTitle) "Conversion Completed"

# removing DC in wav files
set t(removeDCall,q)         "Remove DC offset of all the wav files in the recording folder.  OK?"
set t(removeDCall,doneMsg)   "DC offsets are removed."
set t(removeDCall,doneTitle) "Completed"

# utterance timing check
set t(uttTimingSettings,title)      "Utterance Timing Check Settings"
set t(uttTimingSettings,click)      "Click: "
set t(uttTimingSettings,clickTitle) "Click Sound Setting"
set t(uttTimingSettings,tempo)      "Tempo: "
set t(uttTimingSettings,bpm)        "BPM = "
set t(uttTimingSettings,bpmUnit)    "msec/beat"
set t(uttTimingSettings,clickNum)   "Preceding Click Counts: "
set t(uttTimingSettings,clickUnit)  "times"
set t(uttTimingSettings,mix)        "Volume Balance between Voice and Click: "

# utterance timing check
set t(doUttTimingSettings,errMsg)   "Please set the click counts to 20 or less."
set t(doUttTimingSettings,errMsg2)  "Please set the click counts to more than zero."

# test play for utterance timing check
set t(playUttTiming,msg)            "Only 20 voices or less can be played at a time.  First 20 voices are played."
set t(playUttTiming,playMsg)       "Start the Utterance timing check"
set t(playUttTiming,stopMsg)       "Stop the Utterance timing check"

# pitch guide
set t(pitchGuide,title)             "Pitch Guide"
set t(pitchGuide,sel)               "Guide Sound Setting: "
set t(pitchGuide,vol)               "Volume: "

# oto.ini generation
set t(genParam,title)  "Generate oto.ini for VCV"
set t(genParam,tempo)  "Recording Tempo: "
set t(genParam,bpm)    "Unit: bpm"
set t(genParam,S)      "Utterance Start: "
set t(genParam,unit)   "Unit: "
set t(genParam,haku)   "beat"
set t(genParam,darrow) "VV VV"
set t(genParam,bInit)  "Initialise according to Recording Tempo"
set t(genParam,bInit2) "Get the currently displayed setting"
set t(genParam,O)      "Overlap: "
set t(genParam,msec)   "Unit: msec"
set t(genParam,P)      "Pre-utterance: "
set t(genParam,C)      "Consonant: "
set t(genParam,E)      "Right Blank: "
set t(genParam,do)     "Generate Params"
set t(genParam,aliasMax)          "* Append Serial Numbers to Identify Duplicate Aliases?"
set t(genParam,aliasMaxNo)        "No (Aliases Remain Duplicate.)"
set t(genParam,aliasMaxYes)       "Yes (Append Serial Numbers.)"
set t(genParam,aliasMaxNum)       "Maximum of Serial Number (0=Unlimited)"
set t(genParam,autoAdjustRen)     "Use Parameter Auto Correction 1 (based on power)"
set t(genParam,vLow)              "Power Hollow before Pre-Utterance: "
set t(genParam,sRange)            "Search Range for Pre-Utterance: "
set t(genParam,f0pow)             "* F0 and other power related parameters are also used."
set t(genParam,db)                "unit: dB"
set t(genParam,autoAdjustRen2)    "Use Parameter Auto Correction 2 (based on MFCC, takes long time)"
set t(genParam,autoAdjustRen2Opt) "Option"
set t(genParam,autoAdjustRen2Pattern) "Target Morae"
set t(genParam,alias)                 "Alias Setting"
set t(genParam,suffix)                "Suffix:"
set t(genParam,aliasRecList)          "Repetition Alias Priority List (reclist or oto.ini): "
set t(genParam,aliasReclistTitle)     "Open the Repetition Alias Priority List"
set t(genParam,aliasSelect)           "Select"
set t(genParam,aliasReset)            "Reset"
set t(genParam,uscore)                "Setting for the underscore within file name"
set t(genParam,uscoreIgnore)          "Ignore"
set t(genParam,uscoreRest)            "Consider as Rest"
set t(genParam,uscoreDelimiter)       "Consider as Delimiter"

# oto.ini generation
set t(doGenParam,doneMsg) "Loaded \$v(paramFile)"

# search
set t(searchParam,title)     "Find"
set t(searchParam,search)    "Find"
set t(searchParam,rup)       "Find Forward"
set t(searchParam,rdown)     "Find Backward"
set t(searchParam,doneTitle) "Finished"
set t(searchParam,doneMsg)   "Not Found."
set t(searchParam,rMatch1)   "Whole Match"
set t(searchParam,rMatch2)   "Partial Match"

# play/stop wave
set t(togglePlay,stopMsg) "Stopped"
set t(togglePlay,playMsg) "Playing..."

# color selection
set t(chooseColor,title) "Colour Setting"

# wave color selection
set t(setColor,selColor) "Colour Setting"

# pitch list playing
set t(packToneList,play)   "Play"
set t(packToneList,repeat) "Repeat"

# read initialization file
set t(readSettings,title)     "Select Initialisation File"

# save current setting
set t(saveSettings,title)  "Generate Initialisation File"

# Audio I/O setting
set t(ioSettings,title)    "Audio I/O Settings"
set t(ioSettings,inDev)    "Input Device: "
set t(ioSettings,outDev)   "Output Device: "
set t(ioSettings,inGain)   "Input Gain (device dependent): "
set t(ioSettings,outGain)  "Output Gain (device dependent): "
set t(ioSettings,latency)  "Latency(IT doesn't work on some devices): "
set t(ioSettings,sndBuffer) "Buffer Size for Recording: "
set t(ioSettings,bgmBuffer) "Buffer Size for Guide-BGM: "
set t(ioSettings,comment0) "* I recommend you keep default values."
set t(ioSettings,comment0b) "* Especially, DirectSound is unstable on Snack-lib. of Japanese Windows."
set t(ioSettings,comment1) "* Modifications are not applied untill pressing 'Apply' or 'OK' button."
set t(ioSettings,comment2) ""

# external parameter estimation
set t(autoParamEstimation,title)     "External Tool (Automatic Parameter Estimation) Exection"
set t(autoParamEstimation,aepTool)   "External Tool"
set t(autoParamEstimation,selTitle)  "External Tool Location"
set t(autoParamEstimation,option)    "External Tool Start-up Script"
set t(autoParamEstimation,aepResult) "External Tool Output File"
set t(autoParamEstimation,runMsg)    "Launch External Tool"
set t(autoParamEstimation,resultMsg) "Retrieve External Tool Result"

# estimate boundary of both side of utterance
set t(estimateParam,title)       "Automatic Voice Parameter Estimation (CV diphones)"
set t(estimateParam,frameLength) "Frame Length"
set t(estimateParam,preemph)     "Pre-emphasis"
set t(estimateParam,pWinLen)     "Power Sampling Window Width"
set t(estimateParam,pWinkind)    "Window Type"
set t(estimateParam,pUttMin)     "Minimum Power during Utterance"
set t(estimateParam,vLow)        "Minimum Power of Vowel"
set t(estimateParam,pUttMinTime) "Minimum Utterance Duration"
set t(estimateParam,uttLen)      "Utterance Power Jitter"
set t(estimateParam,silMax)      "Maximum Power during Silence"
set t(estimateParam,silMinTime)  "Minimum Silence Durationn"
set t(estimateParam,minC)        "Minimum Consonant length"
set t(estimateParam,f0)          "* The F0 extraction parameters are also used."
set t(estimateParam,target)      "Estimation Target"
set t(estimateParam,S)           "Left Blank"
set t(estimateParam,C)           "Consonant"
set t(estimateParam,E)           "Right Blank"
set t(estimateParam,P)           "Pre-Utterance"
set t(estimateParam,O)           "Overlap"
set t(estimateParam,overWrite)   "Current Parameters are Overwritten.  OK?"
set t(estimateParam,runAll)      "Apply to All WAV Files"
set t(estimateParam,runSel)      "Apply to Selected WAV Files"
set t(estimateParam,default)     "Reset to Default Setting"
set t(estimateParam,ovl)         "Position Ratio of Overlap"
set t(estimateParam,ovlPattern)  "Overlap Estipation Target"
set t(estimateParam,preEstimate) "Automatically Set Each Parameters"
set t(estimateParam,hpfPattern)  "High-Pass-Filter Target"
set t(estimateParam,lpfPattern)  "Low-Pass-Filter Target"
set t(estimateParam,hpfComment)  "(Forward Match)"
set t(estimateParam,lpfComment)  "(Forward Match)"
set t(estimateParam,edit)        "Edit"

# parameter estimation
set t(doEstimateParam,startMsg)  "Estimating Parameters..."
set t(doEstimateParam,doneMsg)   "Parameters Estimated"

# zero cross adjustment
set t(zeroCross,title)           "Zero-cross correction"
set t(zeroCross,target)          "Correction Target"
set t(zeroCross,S)               "Left Blank"
set t(zeroCross,C)               "Consonant"
set t(zeroCross,E)               "Right Blank"
set t(zeroCross,P)               "Pre-Utterance"
set t(zeroCross,O)               "Overlap"
set t(zeroCross,sec)             "Sec."
set t(zeroCross,runAll)          "Apply all wav files"
set t(zeroCross,runSel)          "Apply selected region"

# auto focus
set t(autoFocus,none)  "no focus"

# execte plugin
set t(runPlugin,undo) "Run Plugin"

# read parameter
set t(readParamFile,selMsg)   "Voice Configuration Parameter Selection"
set t(readParamFile,startMsg) "Loading voice configuration parameters..."
set t(readParamFile,errMsg)   "\$v(paramFile) refers to unexistent wav file in \$v(saveDir) / ."
set t(readParamFile,example)  "e.g.: "
set t(readParamFile,errMsg2)  "Missing entries are added to \$v(paramFile)."
set t(readParamFile,doneMsg)  "Loaded \$v(paramFile)."

# save parameters
set t(saveParamFile,selFile)  "Save Voice Configuration Parameters"
set t(saveParamFile,startMsg) "Saving voice configuration parameters..."
set t(saveParamFile,doneMsg)  "Saved voice configuration parameters."
set t(saveParamFile,confm)    "is already exist. Overwrite it?"

# zoom
set t(changeZoomX,title)      "Zoom Rate Setting"
set t(changeZoomX,unit)       "(unit=%. 100%=Show Whole Waveform)"
set t(changeZoomX,change)     "Change"

# advanced settings
set t(settings,title)        "Advanced Settings"
set t(settings,wave)         "<Waveform>"
set t(settings,waveColor)    "Waveform Colour: "
set t(settings,waveScale)    "Max Value of Vertical Axis(0-32768, 0=autoscale)"
set t(settings,sampleRate)   "Sampling Frequency \[Hz\]: "
set t(settings,spec)         "<Spectrum>"
set t(settings,specColor)    "Spectrum Colour: "
set t(settings,maxFreq)      "Maximum Frequency \[Hz\]: "
set t(settings,brightness)   "Brightness: "
set t(settings,contrast)     "Contrast: "
set t(settings,fftLength)    "FFT Length \[sample\]: "
set t(settings,fftWinLength) "Window Width \[sample\]: "
set t(settings,fftPreemph)   "Pre-emphasis: "
set t(settings,fftWinKind)   "Window Type"
set t(settings,pow)          "<Power>"
set t(settings,powColor)     "Power Curve Colour: "
set t(settings,powLength)    "Power Sampling Unit \[sec\]: "
set t(settings,powPreemph)   "Pre-emphasis: "
set t(settings,winLength)    "Window Width \[sec\]: "
set t(settings,powWinKind)   "Window Type: "
set t(settings,f0)           "<F0 (Pitch)>"
set t(settings,f0Color)      "F0 Curve Colour: "
set t(settings,f0Argo)       "Analysis Algorithm: "
set t(settings,f0Length)     "F0 Sampling Frequency \[sec\]: "
set t(settings,f0WinLength)  "Window Width \[sec\]: "
set t(settings,f0Max)        "Maximum F0 \[Hz\]: "
set t(settings,f0Min)        "Minimum F0 \[Hz\]: "
set t(settings,f0Unit)       "Display Unit: "
set t(settings,f0FixRange)   "Fix Display Area: "
set t(settings,f0FixRange,h) "Maximum: "
set t(settings,f0FixRange,l) "Minimum: "
set t(settings,grid)         "Show Key Grids"
set t(settings,gridColor)    "Grid Colour: "
set t(settings,target)       "Show Target Tone"
set t(settings,targetTone)   "Target Tone: "
set t(settings,targetColor)  "Target Tone Colour: "
set t(settings,autoSetting)  "Parameter Change According to Target: "

# drawing canvas
set t(Redraw,S) "L"
set t(Redraw,C) "Con"
set t(Redraw,P) "Pre"
set t(Redraw,O) "Ovl"
set t(Redraw,E) "R"

# exit
set t(Exit,q1) "Voice configuration parameters are not saved.  Save them?"
set t(Exit,q2) "Current voice wav file is not saved.  Save it?"
set t(Exit,a1) "Save and Exit"
set t(Exit,a1b) "Save as Another File and Exit"
set t(Exit,a2) "Exit without Save"
set t(Exit,a3) "Cancel"

# right click menu
set t(PopUpMenu,showWave)   "Show Waveform"
set t(PopUpMenu,showSpec)   "Show Spectrum"
set t(PopUpMenu,showPow)    "Show Power"
set t(PopUpMenu,showF0)     "Show F0"
set t(PopUpMenu,pitchGuide) "Show Pitch Guide"
set t(PopUpMenu,settings)   "Preferences"
set t(PopUpMenu,zoomTitle)  "Time Zoom"
set t(PopUpMenu,zoom0)      "x1 (Always Show Whole Waveform)"
set t(PopUpMenu,zoom100)    "x1 (Show Whole Waveform)"
set t(PopUpMenu,zoom1000)   "x10"
set t(PopUpMenu,zoom5000)   "x50"
set t(PopUpMenu,zoom10000)  "x100"
set t(PopUpMenu,zoomMax)    "Maximum Zoom"
set t(PopUpMenu,changeZoomX) "Zoom Rate Setting"
set t(PopUpMenu,alwaysOnTop) "Always On Top"
set t(PopUpMenu,setAlpha)    "Set Transparency Rate"

# version
set t(Version,msg) "Version"

# ParamU initialization
set t(initParamU,0) "Voice"
set t(initParamU,1) "Left Blank"
set t(initParamU,2) "Overlap"
set t(initParamU,3) "Pre-utterance"
set t(initParamU,4) "Consonant"
set t(initParamU,5) "Right Blank"
set t(initParamU,6) "Alias"
set t(initParamU,7) "Comment"

# parameter table window title
set t(setEPWTitle) "Voice Configuration Paramer List"

# duplicate line in parameter table
set t(duplicateEntp,msg)   "Only one line can be duplicated at a time."
set t(duplicateEntp,title) "Line Duplication Error"
set t(duplicateEntp,undo)  "Duplicate Parameter Row"

# delete line in parameter table
set t(deleteEntp,msg)   "To delete a row, select one row only"
set t(deleteEntp,title) "Parameter Row Deletion Error"
set t(deleteEntp,undo)     "Delete Parameter Row"

# wave trimming
set t(cutWav,title)    "Trim wav Files"
set t(cutWav,L)        "Head Cutoff"
set t(cutWav,R)        "Tail Cutoff"
set t(cutWav,sec)      "sec"
set t(cutWav,adjSE)    "Adjust R/L blank after trimming so that parameter positions do not move.\n(They move if cutoff length is longer than blank.)"

# wave trimming
set t(doCutWav,q)         "All the wav files in the recording folder are trimmed.  OK?"
set t(doCutWav,doneMsg)   "wav files are trimmed."
set t(doCutWav,doneTitle) "Completed"
set t(doCutWav,errMsg)   "Cutoff length must be 0sec or more."

# wave trimming confirm
set t(cutBlankConfirm,q) "Enabling the wave cut mode (F9 key). Undo history is cleared whenever performing this operation. Is it OK?"

# change alias
set t(changeAlias,title)      "Change Aliases"
set t(changeAlias,trans)      "Renaming Rule: "
set t(changeAlias,delPreNum)  "Number of Letters to Remove from the Head"
set t(changeAlias,delPostNum) "Number of Letters to Remove from the Tail"
set t(changeAlias,tips0)      "%m = Lyric Name (ex: 'a', 'a ka')"
set t(changeAlias,tips0b)     "%s = Suffix (ex: '2' of 'ka2')"
set t(changeAlias,tips1)      "%a = Alias Name"
set t(changeAlias,tips2)      "%f = File Name (w/o File Extention)"
set t(changeAlias,tips3)      "%r = Serial Number for Duplicate Alias"
set t(changeAlias,ex1)        "(Example 1) When setting alias of 'a.wav' as 'a2', set the rule to '%f2' and leave other boxes blank."
set t(changeAlias,aliasMaxNum)       "Maximum of %r (0=infinity)"
set t(changeAlias,runAll)     "Run for All Wav Files"
set t(changeAlias,runSel)     "Run for Selected Wav Files"

# make target list from ust file
set t(readUstFile,doneMsg)    "Finished preparing the minimum set."
set t(readUstFile,startMsg)   "Specify a ust-file, and make the minimum set of voices for rendering the song."
set t(readUstFile,modeComment) "Insert comment into the necessary entries"
set t(readUstFile,comment)     "comment:"
set t(readUstFile,modeDelete)  "Delete the unnecessary entries"
set t(readUstFile,errMsg)      "Failed to construct the list.  Please run the operation again from loading voice configuration file."
set t(readUstFile,undo)        "Load Ust File"
set t(readUstFile,limit)       "Limit of Duplicate Number(0=Unlimited)"

# utterance timing adjustment mode
set t(timingAdjMode,startMsg) "Enable utterance timing adjustment mode.  Please reconfigure the notation type of right blank and behaviour when pre-utterance parameter is modified if necessary."
set t(timingAdjMode,doneMsg)  "Disable utterance timing adjustment mode."
set t(timingAdjMode,on)       "Utterance Timing (Pre-utterance) Adjustment Mode is ON"
set t(timingAdjMode,off)      "Utterance Timing (Pre-utterance) Adjustment Mode is OFF"

# region play
set t(clickPlayRangeMode,errMsg) "To enable this play function, disable the utterance timing correction mode"

# change value at selected cells
set t(changeCell,title)   "Change about Selected Cells"
set t(changeCell,r1)      "Addition"
set t(changeCell,r2)      "Subtraction"
set t(changeCell,r3)      "Set to"
set t(changeCell,r4)      "Convert to Integer"
set t(changeCell,l)       "Value: "
set t(changeCell,rtitle)  "<Scope Restriction>"
set t(changeCell,rr1)     "Unrestricted"
set t(changeCell,rr2)     "equal"
set t(changeCell,rr3)     "Greater than or Equal"
set t(changeCell,rr4)     "Less than of Equal"
set t(changeCell,rl)      "Restiction Value: "

# merge oto.ini
set t(mergeParamFile,selMsg)   "Select oto.ini"
set t(mergeParamFile,startMsg) "Merge start"
set t(mergeParamFile,doneMsg)  "Merge completed"

# regino play
set t(setPlayRange,title)  "Region Play Settings"
set t(setPlayRange,start)  "Play Start Position"
set t(setPlayRange,end)    "Play End Position"
set t(setPlayRange,head)   "Head of File"
set t(setPlayRange,tail)   "Tail of File"
set t(setPlayRange,guide)  "* Ctrl+t...Play"

# auto backup
set t(autoBackup,q)     "A backup file is found.  The program may have terminated irregularly last time.  In order to restore the previous state, move 'backup.ini' in the same folder as setParam.exe to your WAV folder, and rename it to oto.ini (to overwrite existing one, if any)."
set t(autoBackup,a1)    "Exit setParam"
set t(autoBackup,a2)    "Delete backup.ini and Continue Operation"

# paste from clipboard
set t(pasteCell,q1)     "Area sizes between source and destination are different. Would you want to paste?"
set t(pasteCell,undo)   "Paste"


# time axis setting
set t(setBPMWindow,title)  "Time Axis Settings"
set t(setBPMWindow,tempo)  "Tempo="
set t(setBPMWindow,offset) "Offset="
set t(setBPMWindow,sec)    "(sec)"

# change value keyboard input
set t(changeParam,undo) "Change Cell Value"

# change value by using mouse
set t(setParam,undoS) "Move Left Blank"
set t(setParam,undoC) "Move Consonant"
set t(setParam,undoE) "Move Right Blank"
set t(setParam,undoP) "Move Pre-Utterance"
set t(setParam,undoO) "Move Overlap"

# test synthesis
set t(synWindow,title)     "Test Synthesis Settings"
set t(synWindow,syn)       "Synthesis Engine: "
set t(synWindow,synSelect) "Synthesis Engine Selection"
set t(synWindow,setPitch)  "F0: "
set t(synWindow,setLength) "Duration(msec): "
set t(synWindow,setFlag)   "Flags(default=none)�F"
set t(synWindow,setVolume) "Volume(default=100)�F"
set t(synWindow,setMod)    "Modulation(default=0)�F"
set t(synWindow,setCSpeed) "Consonant Speed(default=100)�F"
set t(playSyn,errMsg)      "Synthesis Engine is not selected"

# reset undo
set t(clearUndo,q)         "Undo history is initialized. Is it OK?"

# transparency rate
set t(setAlphaWindow,title)  "Transparency Setting"

# plugin mode
set t(utaup_readUst,err1) "can not open"
set t(utaup_readUst,err2) "failed to get target information"
set t(utaup_readUst,err3) "Can not specify cache directory. Save ust file first."
set t(utaup_readUst,err4) "Can not write to"
set t(utaup_readUst,err5) "failed to start pluginMode: can not found target wave entry"
set t(utaup_updateTargetParamFile,err1) "failed to update oto.ini"

