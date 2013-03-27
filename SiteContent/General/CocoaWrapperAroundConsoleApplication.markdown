

see General/PortingUnixAppsToCocoa for information about where to get sources (or, for that matter, pre-built binaries) to wrap, and discussion of intellectual property issues

How can you run a terminal script behind a Cocoa interface? I have a UNIX script precompiled that asks the user for input during its run. How could I interact with it in, e.g., an General/NSTextView?

----

The best example is the Moriarity sample code from Apple (see just below).

Understanding the Apple documentation on the classes *General/NSTask* and *General/NSPipe* is essential to progressing with this type of project.

There are also such applications as Pashua or Platypus that are intended to help with this, if the interaction is fairly simple.

----

**Building AQUA Interfaces for Terminal Applications**

Using a combination of the Foundation classes General/NSTask and General/NSPipe, we can start a task and communicate with it using stdin and stdout.
The main General/NSTask page presents a simple example that uses the UNIX     ls command, with arguments.

There are several tutorial examples of how to do this with a more complicated interface:

Apple: Moriarity - http://developer.apple.com/samplecode/Sample_Code/Cocoa/Moriarity.htm

Cocoadevcentral Tutorial: http://cocoadevcentral.com/articles/000025.php

----

When working with Foundation tools, General/NSFileHandle provides a handy means of interacting with stdin, stdout, and stderr.

Since     availableData (and other) methods of  General/NSFileHandle return an General/NSData, you can extract that data into an General/NSString by calling:

    
[data getBytes:buffer];
someString* = General/[NSString stringWithUTF8String:buffer];


Where data is your data object, and buffer is a char array (char buffer[20]).

-- General/RobRix

----

What about sending stdin (General/StandardInput) to a terminal app?

Command-line arguments are easy, but I haven't seen any sample code for sending stdin... 

----

I tried it recently, but it seemed like the terminal app never got the end-of-file I sent using closeFile: on the fileHandleForWriting: . Any General/TipsAndTricks or General/SampleCode for this?

-- General/MichaelMcCracken

----

**Setting up ongoing communication**

I am trying to write a cocoa interface to a console app.  Now there are a lot of examples showing how to wrap a one-off tool such as 'ls' with General/NSTask.  Basically the task waits until the result is ready and returns that.  Great.  What about when the task you are wrapping is an ongoing one, such as a server, or a perl application?  Then General/NSTask essentially hangs your cocoa app waiting for the terminal task to finish, which it never does since it isnt meant to without an explicit quit command.  

So how to get the data from General/NSTask while the wrapped app is still running?  After some more sleuthing in examples I realized I need to use a filehandle that readsInBackgroundAndNotifies so that control is returned to the main loop.  That much worked fine.  However, any attempts to read from the filehandle with [myFilehandle readDataToEndOfFile] followed by another [myFilehandle readInBackgroundAndNotify] in the notification's selector method didn't work as expected.  I was hoping that this would read the data and clear the filehandle to wait for more data.  In the end I am using the returned data from the notification: General/notification userInfo]objectForKey:[[NSFileHandleNotificationDataItem]; This works fine but I am worried that I am introducing unnecessary latency or inefficiency by not reading from the filehandle directly.  Can anyone comment on this?

General/EcumeDesJours

----

I think the best way would be to use a separate thread for the communication between your application and your tool.

-- General/EricForget

----

It sounds like the problem is that you are trying to     readDataToEndOfFile which will wait for the communications pipe to close.  If you just use the     availableData you may do better.

----

**Further applicability** (though this Q-and-A appears redundant in relation to the above)

I'm messing around with an app that'll let me control some basic functions on my mac using a PDA, over http.

How can I make my app run an external executable? I have this piece of code:

    
if ([response isEqualToString:General/[[NSString alloc] initWithString:@"1"]]) {
	[statusBox setStringValue:General/statusBox stringValue] stringByAppendingString:@"\nThe server has indicated that a connection should be established.\nLaunching executable...";
	//The executable should be launched here
	[statusBox setStringValue:General/statusBox stringValue] stringByAppendingString:@"\nResetting connection indicator...";
	NSURL *URL2 = [NSURL General/URLWithString:@"http://www.exdev.dk/connector/reset.php"];
	General/NSData *data2 = [URL2 resourceDataUsingCache:NO];
	General/NSString *response2 = General/[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:General/NSASCIIStringEncoding];
} else {
	[statusBox setStringValue:General/statusBox stringValue] stringByAppendingString:@"\nThe server reported no awaiting connections.";
	}


----
If it's a command-line tool, check out General/NSTask. Otherwise, General/NSWorkspace might be the way to go. --General/JediKnil

----

Quick example of running a task (ls -l) synchronously (this will block on long tasks, probalby not good to run in the main thread) and getting the
stderr and stdout into a single General/NSString:

    

    General/NSTask *task = General/[NSTask new];
    [task setLaunchPath:@"/bin/ls"];
    [task setArguments:General/[NSArray arrayWithObject:@"-l"]];
    [task setStandardOutput:General/[NSPipe pipe]];
    [task setStandardError:[task standardOutput]];
    [task launch];
    General/NSData* output = General/[task standardOutput] fileHandleForReading] readDataToEndOfFile];
    [[NSString* out_string = General/[[[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding] autorelease];
    General/NSLog(out_string);



----

> How can you run a terminal script behind a Cocoa interface? I have a UNIX script precompiled that asks the user for input during its run.  How could I interact with it in, e.g., an General/NSTextView?

Have a look at the source code of General/PseudoTTY.app.

http://amath.colorado.edu/pub/mac/programs/

In General/PseudoTTY/General/PtyView.m replace

General/NSString * cmd = @"/bin/sh";

with your interactive command line app

General/NSString * cmd = @"/path/to/interactive/cliapp";