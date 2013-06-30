My program leaks memory (according to General/MallocDebug) on calls to General/[NSArray objectEnumerator] is this normal?  Given, it's only a few hundred bytes... but my program is meant to stay running indefinitely (so these few hundred bytes might add up).  Any ideas why this might be happening and if there's anything I can do to plug the leak?

Thanks,

Joe

Hi Joe.  My hunch is that General/MallocDebug has been out sniffing glue.  - General/[NSArray objectEnumerator] (and every other NS collection class enumerator call) uses autorelease (General/object retain] autorelease]) to ensure that the object the - [[[NSEnumerator nextObject] methods returns a valid object.  If your program expects that the last object returned by enumerator be dealloc'ed before the autorelease pool has had a chance to send release messages to its conents, you'll get a memory "leak".  Why General/MallocDebug tells you you have a memory leak I'm not sure, but my bet is that if you run objectAlloc you won't see your memory consumption grow (provided it isn't supposed to grow).  The only other explanation I can think of is that you're checking retainCount somewhere and using that instead of keeping track of the retains and releases in your own code.

----

Joe,

Is your program a Foundation non-GUI program? You mentioned that it is meant to run indefinitely so I had to ask. If so, depending on the structure of your program, you may have to manage an secondary General/NSAutoreleasePool yourself.

----

My program is not a Foundation non-GUI program, but what you said got me thinking.  My program is threaded and I think that may be the issue.  My memory leak seems to occur within a call to _startDrawingThread.  I am detaching a General/NSThread via the call: General/[NSApplication detachDrawingThread:toTarget:withObject:];

I was under the assumption that I did not need to manage an General/NSAutoReleasePool, but a few code samples I've come across have managed one.  The Apple documentation for detachDrawingThread reads as follows:

"Creates and executes a new thread, automatically creating an General/NSAutoreleasePool for the thread. This method is a convenience wrapper for General/NSThread�s detachNewThreadSelector:toTarget:withObject:."

Must I do something to release the automatically created General/NSAutoreleasePool?  Or should I just create my own pool?

Thanks,
Joe

----

Not sure, I have never used General/[NSApplication detachDrawingThread:toTarget:withObject:]. I have always used General/[NSThread detachNewThreadSelector:toTarget:withObject:] setting up my own General/NSAutoreleasePool and never had a problem with leaks.