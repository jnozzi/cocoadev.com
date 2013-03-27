Hi,

I am not building a document based application, and so have not built one (plain Cocoa app chosen in General/XCode, not Doc based).

However, although I don't need a document based application, I do require the saving of the data within my app off to file, and loading it in again. I have implemented all General/NSCoding for the relevant objects, and also in the root class of the app have implemented -(General/NSData *)dataRepresentationOfType:(General/NSString *)aType, and -(BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType.

This is enough for a document based app to just go ahead and sort everything else out. Not so for a normal app it seems. What extra steps must I take to invoke the save and load dialogs, and get data in and out of a standard Cocoa app (non-document based).

Thanks for any help in advance!

----

Check out General/NSSavePanel and General/NSOpenPanel, also if you would like to keep things really simple I highly recommend working with Property Lists and skip using General/NSCoding. --zootbobbalu

----

I don't recommend skipping General/NSCoding, but you'll also want to check out General/NSKeyedArchiver and General/NSKeyedUnarchiver and read Apple's notes on archives and how to make them. It's vaguely something like this:

    General/[[NSKeyedArchiver archivedDataWithRootObject:aRootObject] writeToFile:@"/path/to/where/you/want/it.extension" atomically:YES];

----

I do recommend using property lists if you want to keep things really simple. Property Lists can be easily shared between applications, plists can be easily shared with the pasteboard and plists are more simple to use. General/NSCoding requires more attention to detail, archived objects require more hoops to jump through when distributing between applications and General/NSCoding is not a "really simple solution". --zootbobbalu

*And yet, it's probably easier, especially when he's already done all the General/NSCoding work.*

----

You are speaking in past tense and I'm speaking in future tense. My comments are recommendations for keeping things simple for future projects. Are you suggesting that General/NSCoding is the best way to keep things simple? --zootbobbalu

*I'm suggesting that it's a very good system, and the consistency and encapsulation which it provides are probably worth it 9 times out of 10.*

----

I agree that General/NSCoding is a very good system, and I guess I am assuming that the original poster is looking for a quick and simple way to persist data. Personally, I find Property Lists to be easier to use than General/NSCoding, so this is why I recommend them. This whole discussion is in context of persisting data in a non document based application. I guess you are more pro encapsulation than an advocate of XML. --zootbobbalu

----

Original Poster: Thanks for all of your input. Everything is working fine now, although I still have to implement all of the good stuff that the General/NSDocument would do automatically (such as 'Open recent...' menu items). I am rather new to Cocoa, but have found General/NSCoding to be very simple indeed to understand and implement in my classes, so am surprised that one would recommend against it for simplicity. Perhaps I am using it only for one of its functions? Or in more complex scenarios it would be more difficult to use?

----

I guess if you don't mind the extra lines of code involved with archiving objects and find the process simple there really isn't much of a debate. BTW, why did you choose to use a non document based application instead of a document based app? --zootbobbalu

----

If I were a super XML advocate I'd probably recommend using General/NSXMLParser and so on (:

----

Some people might have trouble finding this: you can implement the "Open Recent" menu through the General/NSDocumentController for a non-document based application. To do this, use General/NSDocumentController's     noteNewRecentDocumentURL: method. There are a few other things General/NSDocumentController handles for non-document based apps.

I created a single window document-based application. You might want to do this to represent documents in tabs or a popup menu rather then each document having its own window. This was extremely awkward to implement with Apple's current document structure, but after much struggling I managed to do it. If this is the reason you are not going with a document based application, I still suggest using Apple's implementation for the file management is provides. I have some tips on creating single window doc apps if you need them, but that should go under another topic.

-- General/RyanBates