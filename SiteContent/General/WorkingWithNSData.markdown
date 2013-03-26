How does one initialize an [[NSData]] object with [[NSString]] data? (or integer data or any other data type?)
----
The easiest way is to use [[NSArchiver]] / [[NSUnarchiver]] or [[NSKeyedArchiver]] / [[NSKeyedUnarchiver]]. Look up this page on archives for more information: http://developer.apple.com/documentation/Cocoa/Conceptual/Archiving/index.html --[[JediKnil]]

----

<code>[[NSString]] ''string = @"This is some stuff.";
[[NSData]] ''stringData = [string dataUsingEncoding:[[NSASCIIStringEncoding]] allowLossyConversion:YES];
</code>

This does what you want; if you're okay with the [[NSData]] having unicode characters, use [[NSUnicodeStringEncoding]] instead of [[NSASCIIStringEncoding]]. -- [[AndyMatuschak]]

----
NSUTF8StringEncoding is almost always a better choice than [[NSASCIIStringEncoding]]. UTF-8 behaves exactly the same with ASCII characters, but behaves in a rational and predictable manner with non-ASCII characters.