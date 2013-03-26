[[AEVTBuilder]] is a small Objective-C library for building [[AppleEvents]]. It is vaguely similar to Apple's [[AEBuild]] function, except that [[AEVTBuilder]] uses Objective-C syntax instead of an embedded format string. [[AEVTBuilder]] is built with the philosophy of creating a mini-language to accomplish the task. As such, while it is completely legal Objective-C code, it looks completely different from "real" Objective-C.

The code can be downloaded from http://www.mikeash.com/software/[[AEVTBuilder]]/[[AEVTBuilder]].zip

----

'''Basics'''

[[AppleEvents]] have similar structures to Cocoa [[PropertyList]]<nowiki/>s. They're generally made up of records (like dictionaries), with a [[FourCharCode]] key and a value that can be another record, or various primitives types.

The basic structure of an [[AEVTBuilder]] expression is like this:

<code>[KIND : value]</code>

The <code>KIND</code> is an all-caps identifier which specifies the [[AppleEvent]] type of the expression. The <code>value</code> is the value for this expression, which can be a single parameter or many, depending on the identifier. What kind of things can be put for the value depends on the type. The available identifiers for <code>KIND</code> can be found in the header file in the list of <code>extern id</code> globals.

Every [[AEVTBuilder]] expression returns an [[NSAppleEventDescriptor]], so it is possible to use an existing [[NSAppleEventDescriptor]] instead of an [[AEVTBuilder]] expression, or vice versa.

----

'''Primitives'''

The various primitive types are <code>TYPE</code>, <code>INT</code>, <code>ENUM</code>, <code>DESC</code>, <code>DATA</code>, and <code>STRING</code>.

The <code>TYPE</code>, <code>INT</code>, <code>ENUM</code>, and <code>STRING</code> types all have a single value following the colon. For <code>TYPE</code> and <code>ENUM</code>, this value is a [[FourCharCode]]. For <code>INT</code>, the value is an integer, and for <code>STRING</code>, the value is an [[NSString]].

<code>DATA</code> is a little different, because an [[AppleEvent]] <code>DATA</code> specifier needs both a type code and the actual contents of the data. This identifer therefore takes two parameters, the first one being a [[FourCharCode]] with the type code, and the second one being an [[NSData]] with the contents.

<code>[DATA : 'code', myNSData]</code>

And finally the <code>DESC</code> type only exists in order to be able to generate a null [[AppleEvent]] descriptor. This is done by simply writing <code>[DESC null]</code>.

----

'''Records'''

A record is much like an [[NSDictionary]], except that the keys are [[FourCharCode]]<nowiki/>s, and the values are [[AppleEvent]] descriptors.

A record is specified using the <code>RECORD</code> identifier. The first value is the [[FourCharCode]] type for the record. After the first value, the contents of the record are specified in key/object form. Keys are specified by using the <code>KEY</code> identifier, with the argument being the [[FourCharCode]] used for the key. An object is any expression, such as a primitive type, another record, or an existing [[NSAppleEventDescriptor]]. Finally, the record is terminated by using the <code>ENDRECORD</code> identifier.

<code>
[RECORD : 'rcrd',
    [KEY : 'thng'], [STRING : @"Hello world"],
    ENDRECORD]
</code>

----

'''Full Apple Events'''

Now we have all of the pieces, but how about building a complete [[AppleEvent]]? The <code>AEVT</code> identifier lets you do this. Unlike the others, it actually takes several parameters in more of an Objective-C style, using the <code>class:id:target:</code> message. The <code>class</code> and <code>id</code> parameters are [[FourCharCode]]<nowiki/>s corresponding to the [[AppleEvent]]'s class and id. The <code>target</code> is a [[ProcessSerialNumber]] identifying the target of the [[AppleEvent]]. After the target, the contents of the [[AppleEvent]] are specified exactly like a record.

----

'''Sending the Apple Event'''

Once an [[AppleEvent]] is built, you can send it using various built-in mechanisms. [[AEVTBuilder]] also provides a convenience method, <code>sendWithImmediateReply</code>, which sends the [[AppleEvent]] and returns an [[NSAppleEventDescriptor]] containing the reply.

----

'''An Example'''

Now we have everything we need to build and send an [[AppleEvent]]. Here's a quick example of how to use it. For this example, we'll write the [[AppleEvent]] equivalent of [[TextEdit]]'s [[AppleScript]] <code>word 1 of front document</code>. First, we need to find the [[AppleEvent]] that corresponds to that command. We do this by running Script Editor with [[AEDebugSends]] turned on:

<code>[[AEDebugSends]]=1 /Applications/[[AppleScript]]/Script\ Editor.app/Contents/[[MacOS]]/Script\ Editor</code>

Then I write the corresponding [[AppleScript]] and run it, looking at the output in my Terminal window:

<code>
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
      { 0x0, 0x6700001 } ([[TextEdit]])
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
</code>

Now we want to translate that into [[AEVTBuilder]] code. First, we need the [[ProcessSerialNumber]] of [[TextEdit]]. This is beyond the scope of this page, but it's pretty easy to find using [[NSWorkspace]] functions. Then we simply translate the rest of the [[AppleEvent]] directly into code. The important bits are the part at the top where it says <code>core/getd</code>, which is the class/id of the event, and then the stuff inside the <code>event data:</code> section. The stuff which begins with <code>'aevt'</code> is the top-level event record, which we'll translate into code.

<code>
[[NSAppleEventDescriptor]] ''descriptor = [AEVT class:'core' id:'getd'
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

[[NSAppleEventDescriptor]] ''reply = [descriptor sendWithImmediateReply];
</code>

And from there, you can get the result out of the <code>reply</code> descriptor.

-- [[MikeAsh]]

----

This really makes creating Apple Events so much easier. Thanks Mike!

I've made an addition that allows you to easily use an NSURL wherever an 'furl' is used via this syntax:
<code>
[URL : [NSURL fileURLWithPath:@"/Users/me/Desktop/aFile.txt"]]
</code>
You can download the code here: http://www.kainjow.com/code/[[AEVTBuilder]].zip

Also here is another example for sending a file to iTunes (pass nil to source to use the main library):
<code>
- (void)addPath:([[NSString]] '')path toPlaylist:([[NSString]] '')playlist atSource:([[NSString]] '')source
{
	[[NSAppleEventDescriptor]] ''descriptor = [AEVT class:'hook' id:'Add ' target:[self iTunesProcess],
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
</code>
It's the equivalent of this [[AppleScript]]:
<code>
tell application "iTunes"
	add ("/Users/me/Desktop/someFile.mp3" as POSIX file) to (playlist "My Music" of source 1)
end tell
</code>

--[[KevinWojniak]]

----
Here's an [[NSWorkspace]] addition for use with [[AEVTBuilder]] to find the [[ProcessSerialNumber]]:
<code>
@implementation [[NSWorkspace]] ([[ProcessSerialNumberFinder]])
- ([[ProcessSerialNumber]])processSerialNumberForApplicationWithIdentifier:([[NSString]] '')identifier
{
	[[ProcessSerialNumber]] psn = {0, 0};

	[[NSEnumerator]] ''enumerator = [[self launchedApplications] objectEnumerator];
	[[NSDictionary]] ''dict;
	while ((dict = [enumerator nextObject])) {
		if ([[dict objectForKey:@"[[NSApplicationBundleIdentifier]]"] isEqualToString:identifier]) {
			psn.highLongOfPSN = [[dict objectForKey:@"[[NSApplicationProcessSerialNumberHigh]]"] longValue];
			psn.lowLongOfPSN  = [[dict objectForKey:@"[[NSApplicationProcessSerialNumberLow]]"] longValue];
			break;
		}
	}
	
	return psn;
}
@end
</code>
Note that it only works with applications that present a UI, as these are the only ones [[NSWorkspace]] returns in launchedApplications.  I'd be interested to see how to do the same thing with faceless applications.

--[[EvanSchoenberg]]

----

To get faceless apps you have to use Carbon (note that this code has not been tested in any way, beware):

<code>
- ([[ProcessSerialNumber]])processSerialNumberForApplicationWithIdentifier:([[NSString]] '')identifier
{
    [[ProcessSerialNumber]] psn = { 0, kNoProcess };
    while([[GetNextProcess]](&psn) == noErr)
    {
        [[NSDictionary]] ''info = (id)[[ProcessInformationCopyDictionary]](&psn, kProcessDictionaryIncludeAllInformationMask);
        [info autorelease];
        
        [[NSString]] ''thisIdentifier = [info objectForKey:(id)kCFBundleIdentifierKey];
        if([thisIdentifier isEqual:identifier])
            return psn;
    }
    
    [[ProcessSerialNumber]] notFound = { 0, kNoProcess };
    return notFound;
}
</code>

Note that the info dictionary will also contain keys for [[LSUIElement]] and [[LSBackgroundOnly]], making it fairly easy to add a flag to the method to make it only look for visible apps. -- [[MikeAsh]]