Part of the iPhone [[UIKit]] framework.

Little is known about the elusive yet omnipresent [[GSEvent]], though researchers believe the GS stands for "[[GraphicsServices]]". One very useful function is

%%BEGINCODESTYLE%%[[CGRect]] GSE<nowiki/>ventGetLocationInWindow([[GSEvent]]'' event);%%ENDCODESTYLE%%

Other known functions are:

%%BEGINCODESTYLE%%int GSE<nowiki/>ventIsChordingHandEvent([[GSEvent]] ''ev);%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%int GSE<nowiki/>ventGetClickCount([[GSEvent]] ''ev);%%ENDCODESTYLE%%

Maybe worth looking at:

[[GSEventGetDeltaX]]

[[GSEventGetDeltaY]]

[[GSEventVibrateForDuration]]