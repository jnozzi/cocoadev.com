How (in programming) can you utilize the microphone built in to most macs? I can't find any API for it. And please, if there is any other way, SPARE me from [[CoreAudio]]... there must be something else that uses the mic. 3rd party frameworks are great...

----

I used [[QuickTime]]'s Sequence Grabber (http://developer.apple.com/documentation/[[QuickTime]]/RM/[[CreatingMovies]]/[[SeqGrabComp]]/index.html )

- Davey

----

[[CoreAudio]] isn't as scary as it pretends to be anyway; there are some [[ObjC]] wrappers for it which can handle some [[AudioUnit]]-related things, though I'm unaware as to the extent of their device handling.

----

see [[HowToRecordSound]]