###################################################################

  setParam - parameter setting tool for making UTAU voice bank

  version 4.0-b190504
  Download URL  http://nwp8861.web.fc2.com/soft/setParam/index.html

###################################################################

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
<< Abstract >>

  setParam is a free tool for configuring oto.ini of UTAU voicebank.
  For example, you can use following functions..
    - make oto.ini automatically (CV / VCV)
    - view various panel:
      * waveform
      * spectrogram
      * F0(pitch)
      * power
    - various play functions:
      * partial play between two parameters
      * pre-utterance check play
      * test synthesis play
    - alias batch conversion
    - Undo / Redo of operations
    - and so on..

  Almost all translation is by Mia Naito (@mianaito).

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
<< Simple Operation Guide >>

  [ auto setting parameter ]

      You can try to use automatic parameter setting functions. 
      Although these functions are not perfect, they would help you.
      I hope your operation will become easier by using them. 

      Auto setting tools are available from 'tool' menu.
      Or, tools dialog window is shown 
      when you open a wavefile folder.

  [ setting parameter by hand ]

    Following keys are available on waveform panel.

      F1 ... utterance start position. ('left blank' or 'left offset')
      F2 ... cross fade length between the wav and preceding wav ('overlap')
      F3 ... onset position ('onset' or 'pre-utterance')
      F4 ... end of consonant ('consonant')
      F5 ... start of amplitude declination ('right blank' or 'right offset')
      space ... play sound
      control-space    ... play sound between 'F1' and 'F5'
      F6 or down arrow ... next wav
      F7 or up   arrow ... previous wav
      F8               ... play for checking 'pre-utterance'
      F10              ... play synthesized speech
      F11 and F12      ... time zoom (horizontal zoom)
      control+s        ... save oto.ini file

    Following mouse operation are available on waveform  panel.

      parameter name dragging ... shift parameter
      wheel down    ... move to next or previous wav
      shift-wheel   ... time scroll (horizontal scroll)
      control-wheel ... time zoom (horizontal zoom)
      control-shift-wheel ... vertical zoom for waveform, spectol, power, F0

      dragging horizontal border ... vertical zoom for waveform, spectol, power, F0
      right click ... popup menu

    Following mouse operation are available in parameter table

      right click ... popup menu
      dragging    ... select regions for copy, paste and so on

    Following keys are available in parameter table

      arrow     ... move cell
      control-c ... copy
      control-v ... paste
      control-i ... duplicate the row
      control-d ... delete the duplicated row
      control-s ... save oto.ini file
      control-f ... search
      control-n ... search next
      control-N ... search previous
      control-m ... parameter change by rule
      shift-space   ... play
      control-space ... play sound between 'F1' and 'F5'
      control-v ... paste

      you can change values directly in parameter table.

    In fact, setParam has more operation & functions. 
    However, it's difficult to describe all in English for me.
    So please discover and enjoy various functions.

<< License >>

  setParam is destributed under GPL license. 
  setparam is using Tcl/Tk, snack and SPTK. 
  Please see Licenses folder to check each licence term.

