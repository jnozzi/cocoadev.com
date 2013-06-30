The Core Foundation version of key-value pairs. Like many other basic General/CoreFoundation types, General/CFDictionary is toll-free bridged with Cocoa's General/NSDictionary, which means you can safely cast an     General/NSDictionary * to a     General/CFDictionaryRef and vice versa.

General/CFDictionary retains it keys, in contrast to General/NSDictionary which copies its keys.

http://www.carbondev.com/site/?page=General/CFDictionary