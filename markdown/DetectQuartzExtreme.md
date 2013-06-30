To detect whether a certain screen uses Quartz Extreme, get an General/NSScreen for that screen:

    
General/NSNumber* screenNum = General/theScreen deviceDescription] objectForKey: @"[[NSScreenNumber"];
BOOL supportsQuartzExtreme = General/CGDisplayUsesOpenGLAcceleration( (General/CGDirectDisplayID) [screenNum pointerValue] );


NB - can't test this code right now, so be prepared for compile errors if you copy & paste it. Also, not sure whether pointerValue does any other magic, if it does, try longValue or so instead.

Oh, and on older versions of General/MacOS X that don't have General/NSScreenNumber, you could mis-use the private _screenNumber instance variable. -- General/UliKusterer