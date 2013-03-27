How would I go about catching ALL uncaught General/NSException's? Apps like Adium seem to catch any exception that occurs (and then launch a helper app). I desperately need something like this... anyone know how to do this? --General/KevinWojniak

Ok I found out how....

There is an General/ExceptingHandling.frameworking found in /System/Library/Frameworks which allows you to catch uncaught exceptions in your app. Here's what I used:

    
General/NSExceptionHandler *handler = General/[NSExceptionHandler defaultExceptionHandler];
[handler setExceptionHandlingMask:General/NSLogAndHandleEveryExceptionMask];
[handler setDelegate:self];


and then this is called on the delegate:

    
- (BOOL)exceptionHandler:(General/NSExceptionHandler *)sender
     shouldHandleException:(General/NSException *)exception mask:(unsigned int)aMask
{
	/* handle the exception */
}


----

I've heard this doesn't work, because no exception is ever unhandled -- General/NSApplication installs an any-exception handler of its own.

----

Well you heard wrong ;). I implemented it and it does work. It allows you to override General/NSApplication's default way of handling exceptions (General/NSLoging it and terminating).