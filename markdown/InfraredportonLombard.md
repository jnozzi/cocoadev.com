How do I access the General/IrDA port using Cocoa?  There are various discussions on building lists of i/o devices using Carbon routines, but is there a Cocoa API?

The General/IOKit is not Carbon. It is a C API, but it isn't Carbon. Look it up on Apple's site, or in the /Developer/Documetation or /Developer/Examples folders.

see here:

http://developer.apple.com/samplecode/Sample_Code/Devices_and_Hardware/Serial/General/SerialPortSample.htm

It's well written easy to read code (with lots of comments) - read it through a couple of times and add lots of General/NSLogs to find out how it works.  Also read the Apple documentation of all the different functions they use.

I think once you've got the fileDescriptor you can use a bit more Cocoa, especically General/NSFileHandle.

Search Cocoa.mamasam.com for General/NSFileHandle and serial and that should help too.

----

Or you could look at the General/AMSerial class here:
http://www.harmless.de/cocoa.html