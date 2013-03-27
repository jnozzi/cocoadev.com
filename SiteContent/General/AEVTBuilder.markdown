General/AEVTBuilder is a small Objective-C library for building General/AppleEvents. It is vaguely similar to Apple's General/AEBuild function, except that General/AEVTBuilder uses Objective-C syntax instead of an embedded format string. General/AEVTBuilder is built with the philosophy of creating a mini-language to accomplish the task. As such, while it is completely legal Objective-C code, it looks completely different from "real" Objective-C.

The code can be downloaded from http://www.mikeash.com/software/General/AEVTBuilder/General/AEVTBuilder.zip

----

**Basics**

General/AppleEvents have similar structures to Cocoa General/PropertyList<nowiki/>s. They're generally made up of records (like dictionaries), with a General/FourCharCode key and a value that can be another record, or various primitives types.

The basic structure of an General/AEVTBuilder expression is like this:

    [KIND : value]

The     KIND is an all-caps identifier which specifies the General/AppleEvent type of the expression. The     value is the value for this expression, which can be a single parameter or many, depending on the identifier. What kind of things can be put for the value depends on the type. The available identifiers for     KIND can be found in the header file in the list of     extern id globals.

Every General/AEVTBuilder expression returns an General/NSAppleEventDescriptor, so it is possible to use an existing General/NSAppleEventDescriptor instead of an General/AEVTBuilder expression, or vice versa.

----

**Primitives**

The various primitive types are     TYPE,     INT,     ENUM,     DESC,     DATA, and     STRING.

The     TYPE,     INT,     ENUM, and     STRING types all have a single value following the colon. For     TYPE and     ENUM, this value is a General/FourCharCode. For     INT, the value is an integer, and for     STRING, the value is an General/NSString.

    DATA is a little different, because an General/AppleEvent     DATA specifier needs both a type code and the actual contents of the data. This identifer therefore takes two parameters, the first one being a General/FourCharCode with the type code, and the second one being an General/NSData with the contents.

    [DATA : 'code', myNSData]

And finally the     DESC type only exists in order to be able to generate a null General/AppleEvent descriptor. This is done by simply writing     [DESC null].

----

**Records**

A record is much like an General/NSDictionary, except that the keys are General/FourCharCode<nowiki/>s, and the values are General/AppleEvent descriptors.

A record is specified using the     RECORD identifier. The first value is the General/FourCharCode type for the record. After the first value, the contents of the record are specified in key/object form. Keys are specified by using the     KEY identifier, with the argument being the General/FourCharCode used for the key. An object is any expression, such as a primitive type, another record, or an existing General/NSAppleEventDescriptor. Finally, the record is terminated by using the     ENDRECORD identifier.

    
[RECORD : 'rcrd',
    [KEY : 'thng'], [STRING : @"Hello world"],
    ENDRECORD]


----

**Full Apple Events**

Now we have all of the pieces, but how about building a complete General/AppleEvent? The     AEVT identifier lets you do this. Unlike the others, it actually takes several parameters in more of an Objective-C style, using the     class:id:target: message. The     class and     id parameters are General/FourCharCode<nowiki/>s corresponding to the General/AppleEvent's class and id. The     target is a General/ProcessSerialNumber identifying the target of the General/AppleEvent. After the target, the contents of the General/AppleEvent are specified exactly like a record.

----

**Sending the Apple Event**

Once an General/AppleEvent is built, you can send it using various built-in mechanisms. General/AEVTBuilder also provides a convenience method,     sendWithImmediateReply, which sends the General/AppleEvent and returns an General/NSAppleEventDescriptor containing the reply.

----

**An Example**

Now we have everything we need to build and send an General/AppleEvent. Here's a quick example of how to use it. For this example, we'll write the General/AppleEvent equivalent of General/TextEdit's General/AppleScript     word 1 of front document. First, we need to find the General/AppleEvent that corresponds to that command. We do this by running Script Editor with General/AEDebugSends turned on:

    General/AEDebugSends=1 /Applications/General/AppleScript/Script\ Editor.app/Contents/General/MacOS/Script\ Editor

Then I write the corresponding General/AppleScript and run it, looking at the output in my Terminal window:

    
AE2000 (1176): Sending an event:
------oo start of event oo------
{ 1 } 'aevt':  core/getd (ppc ){
          return id: 77070347 (0x498000b)
     transaction id: 0 (0x0)
  interaction level: 64 (0x40)
     reply required: 1 (0x1)
             remote: 0 (0x0)
  target:
    { 2 } 'psn ':  8 bytes {
      { 0x0, 0x6700001 } (General/TextEdit)
    }
  optional attributes:
    { 1 } 'reco':  - 1 items {
      key 'csig' - 
        { 1 } 'magn':  4 bytes {
          65536l (0x10000)
        }
    }

  event data:
    { 1 } 'aevt':  - 1 items {
      key '----' - 
        { 1 } 'obj ':  - 4 items {
          key 'form' - 
            { 1 } 'enum':  4 bytes {
              'indx'
            }
          key 'want' - 
            { 1 } 'type':  4 bytes {
              'cwor'
            }
          key 'seld' - 
            { 1 } 'long':  4 bytes {
              1 (0x1)
            }
          key 'from' - 
            { 1 } 'obj ':  - 4 items {
              key 'form' - 
                { 1 } 'enum':  4 bytes {
                  'indx'
                }
              key 'want' - 
                { 1 } 'type':  4 bytes {
                  'docu'
                }
              key 'seld' - 
                { 1 } 'long':  4 bytes {
                  1 (0x1)
                }
              key 'from' - 
                { -1 } 'null':  null descriptor
            }
        }
    }
}

------oo  end of event  oo------


Now we want to translate that into General/AEVTBuilder code. First, we need the General/ProcessSerialNumber of General/TextEdit. This is beyond the scope of this page, but it's pretty easy to find using General/NSWorkspace functions. Then we simply translate the rest of the General/AppleEvent directly into code. The important bits are the part at the top where it says     core/getd, which is the class/id of the event, and then the stuff inside the     event data: section. The stuff which begins with     'aevt' is the top-level event record, which we'll translate into code.

    
General/NSAppleEventDescriptor *descriptor = [AEVT class:'core' id:'getd'
                                          target:textEditPSN,
    [KEY : '----'],
    [RECORD : 'obj ',
        [KEY : 'form'], [ENUM : 'indx'],
        [KEY : 'want'], [TYPE : 'cwor'],
        [KEY : 'seld'], [INT  : 1],
        [KEY : 'from'],
        [RECORD : 'obj ',
            [KEY : 'form'], [ENUM : 'indx'],
            [KEY : 'want'], [TYPE : 'docu'],
            [KEY : 'seld'], [INT  : 1],
            [KEY : 'from'], [DESC null],
            ENDRECORD],
        ENDRECORD],
    ENDRECORD];

General/NSAppleEventDescriptor *reply = [descriptor sendWithImmediateReply];


And from there, you can get the result out of the     reply descriptor.

-- General/MikeAsh

----

This really makes creating Apple Events so much easier. Thanks Mike!

I've made an addition that allows you to easily use an NSURL wherever an 'furl' is used via this syntax:
    
[URL : [NSURL fileURLWithPath:@"/Users/me/Desktop/aFile.txt"]]

You can download the code here: http://www.kainjow.com/code/General/AEVTBuilder.zip

Also here is another example for sending a file to iTunes (pass nil to source to use the main library):
    
- (void)addPath:(General/NSString *)path toPlaylist:(General/NSString *)playlist atSource:(General/NSString *)source
{
	General/NSAppleEventDescriptor *descriptor = [AEVT class:'hook' id:'Add ' target:[self iTunesProcess],
		[KEY : 'insh'],
			[RECORD : 'obj ',
				[KEY : 'form'],	[ENUM : 'name'],
				[KEY : 'want'], [TYPE : 'cPly'],
				[KEY : 'seld'], [STRING : playlist],
				[KEY : 'from'],
					(source == nil ? // use source 1
					[RECORD : 'obj ',
						[KEY : 'form'], [ENUM : 'indx'],
						[KEY : 'want'], [TYPE : 'cSrc'],
						[KEY : 'seld'], [INT : 1],
						[KEY : 'from'], [DESC null],
					ENDRECORD]
					:				// use source by name. source must exist
					[RECORD : 'obj ',
						[KEY : 'form'], [ENUM : 'name'],
						[KEY : 'want'], [TYPE : 'cSrc'],
						[KEY : 'seld'], [STRING : source],
						[KEY : 'from'], [DESC null],
					ENDRECORD]
					),
			ENDRECORD],
		[KEY : '----'], [URL : [NSURL fileURLWithPath:path]],
		ENDRECORD];

	[descriptor sendWithImmediateReply];
}

It's the equivalent of this General/AppleScript:
    
tell application "iTunes"
	add ("/Users/me/Desktop/someFile.mp3" as POSIX file) to (playlist "My Music" of source 1)
end tell


--General/KevinWojniak

----
Here's an General/NSWorkspace addition for use with General/AEVTBuilder to find the General/ProcessSerialNumber:
    
@implementation General/NSWorkspace (General/ProcessSerialNumberFinder)
- (General/ProcessSerialNumber)processSerialNumberForApplicationWithIdentifier:(General/NSString *)identifier
{
	General/ProcessSerialNumber psn = {0, 0};

	General/NSEnumerator *enumerator = General/self launchedApplications] objectEnumerator];
	[[NSDictionary *dict;
	while ((dict = [enumerator nextObject])) {
		if (General/dict objectForKey:@"[[NSApplicationBundleIdentifier"] isEqualToString:identifier]) {
			psn.highLongOfPSN = General/dict objectForKey:@"[[NSApplicationProcessSerialNumberHigh"] longValue];
			psn.lowLongOfPSN  = General/dict objectForKey:@"[[NSApplicationProcessSerialNumberLow"] longValue];
			break;
		}
	}
	
	return psn;
}
@end

Note that it only works with applications that present a UI, as these are the only ones General/NSWorkspace returns in launchedApplications.  I'd be interested to see how to do the same thing with faceless applications.

--General/EvanSchoenberg

----

To get faceless apps you have to use Carbon (note that this code has not been tested in any way, beware):

    
- (General/ProcessSerialNumber)processSerialNumberForApplicationWithIdentifier:(General/NSString *)identifier
{
    General/ProcessSerialNumber psn = { 0, kNoProcess };
    while(General/GetNextProcess(&psn) == noErr)
    {
        General/NSDictionary *info = (id)General/ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
        [info autorelease];
        
        General/NSString *thisIdentifier = [info objectForKey:(id)kCFBundleIdentifierKey];
        if([thisIdentifier isEqual:identifier])
            return psn;
    }
    
    General/ProcessSerialNumber notFound = { 0, kNoProcess };
    return notFound;
}


Note that the info dictionary will also contain keys for General/LSUIElement and General/LSBackgroundOnly, making it fairly easy to add a flag to the method to make it only look for visible apps. -- General/MikeAsh