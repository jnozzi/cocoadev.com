I have an app that stores it's General/NSTableView information in a .plist General/PropertyList. But it won't work because of a image colomn. Any Help?

----

You'll want to encode the image, or discard with it altogether. The image can probably be encoded in an General/NSData instance.