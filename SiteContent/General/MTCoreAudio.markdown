The General/MTCoreAudio framework is a Cocoa-flavored Objective-C wrapping around the Hardware Abstraction Layer (HAL) of Apple's General/CoreAudio library.

http://aldebaran.armory.com/~zenomt/macosx/General/MTCoreAudio/

----

Anyone know how to save the recorded audio - it would be really appreciated.

Look at the /Developer/Example/General/CoreAudio/General/PublicUtility/General/AudioFile-new for recording streams. The standard OSX audio disclaimer stands: audio is hard, you CANNOT 'pick it up and go', you will have to invest time in understanding it. If you are looking for something simple, then you can go with the General/SndKit, which is massive. Unfortunatley there are few good general purpose user oriented sound API's out there, I hope to release one with C++/Cocoa/Python support pretty soon.
Good luck - Jeremy Jurksztowicz

----

try:

http://www.macedition.com/bolts/bolts_20030509.php

should get you started.

- mhanna