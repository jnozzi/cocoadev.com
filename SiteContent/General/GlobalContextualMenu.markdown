I want to write a global contextual menu (well, one that works in the finder at least). Any suggestions on where to start? Are there any API's available, how should the bundle look and where to put it?


contextual menus are used much to seldom in the finder, I think.


General/TheoHultberg/Iconara

----

See Menus.h for the API (it's General/CFPlugin-based). Then see http://developer.apple.com/samplecode/Sample_Code/Human_Interface_Toolbox/General/SampleCMPlugIn.htm for some sample code :)

-- General/FinlayDobbie