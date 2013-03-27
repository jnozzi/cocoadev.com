Illustrates how to open the Apple General/AddressBook programmatically.

I have been using the new Address Book General/APIs... very powerful. Just one question: I have an application I wrote in Cocoa which checks our local, proprietary address database and puts the results in a window. Using the new General/APIs, it now checks to see if this person exists in the computer's Address Book, and offers to add the person if he/she doesn't. I want to add an additional button that will open the address book to that person if they do exist. I am stumped... there seems to be no way to do this (although mail does it). Any ideas would be much appreciated! Thanks!!!

General/AppleScript?

I have looked through the Address Book General/AppleScript dictionary and all available documentation... does not seem to be a way to do it (or, at least not a way I can figure out).

----

The proper General/AppleScript code is

    tell app "Address Book" to activate 

you could build and send it using General/NSAppleScript, I guess.

* General/ArminB *

----

The following text is taken from an email on the cocoaDevList: (http://cocoa.mamasam.com/COCOADEV/2002/10/2/48513.php) -- General/DiggoryLaycock

----
Address Book knows how to deal with an URL of the following format
    
addressbook://<unique id of  a person>
 
and
    
addressbook://<unique id of  a person>?edit
 

So to simply open address book with a person selected

    
General/ABPerson *selectedPerson = ....;
General/NSString *uniqueId = [selectedPerson uniqueId];
General/NSString *urlString = General/[NSString stringWithFormat:@"addressbook://%@", uniqueId];
General/[[NSWorkspace sharedWorkspace] openURL:[NSURL General/URLWithString:urlString]];
 

If you want address book to be in edit mode add '?edit' at the end of
the URL

    
General/ABPerson *selectedPerson = ....;
General/NSString *uniqueId = [selectedPerson uniqueId];
General/NSString *urlString = General/[NSString
stringWithFormat:@"addressbook://%@?edit", uniqueId];
General/[[NSWorkspace sharedWorkspace] openURL:[NSURL General/URLWithString:urlString]];


 

----
Woah. That's way cool. A not-so-cool way to do it is to use General/NSTask and run the /usr/bin/open command with an argument of "/Applications/General/AddressBook.app" which of course only works if the user hasn't moved his or her General/AddressBook.app. In fact it would almost certainly be better to use
    General/[[NSWorkspace sharedWorkspace] launchApplication:@"General/AddressBook"];
...as documented here: http://developer.apple.com/techpubs/macosx/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSWorkspace.html#//apple_ref/occ/instm/General/NSWorkspace/launchApplication:
----
No, don't do this either, it's bad to assume nobody's renamed an application. Use General/LaunchServices to find the app by its bundle identifier (com.apple.General/AddressBook), or better yet, just use the 'addressbook:' URL by itself without any argument.

----

Looking at the comments above, "addressbook://" (just as well as webcal and ical) seem to be formal protocols. Hence I was looking for a documentation, but until now wasn't able to find one. Has anyone an idea how these protocols work and what commands are accepted?

----

The docs are in General/AddressBook/General/ABAddressBook.h

----

It's through the General/GetURL General/AppleEvents. Take a look at Address Book's Info.plist and you'll find protocol definitions. The application is then sent an General/AppleEvent, and can do whatever it wants with the URL string - it doesn't technically even have to be a well-formed URL - although it would be wise to enforce this as the Apple applications do. Someone posted sample code a while ago for a GURL AE handler; search mamasam and you should find it. I've managed to implemented it in one of my applications. 

General/AddressBookQuestion