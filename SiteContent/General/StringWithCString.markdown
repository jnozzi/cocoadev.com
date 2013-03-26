


[[NSString]] has several methods with "C string" in the name, such as +stringWithCString: and -cString. Please don't use them. They use the "system encoding", which is not defined to be anything in particular, and so these methods will not behave in a predictable manner when used with non-ASCII data. Instead, use their counterparts, +stringWithUTF8String and -UTF8String. The UTF8 variants of these methods behave in a predictable and useful manner on non-ASCII data, and produce exactly what you want when used on ASCII data.

----

Except, of course, when you are using data from a standard C function (I don't know why you would, but maybe you need to integrate it with someone else's library...). Any string declared using <code>""</code> and not <code>@""</code> is a standard C string. It's best to avoid this whenever possible.

----

To my knowledge, <code>-initWithUTF8String:</code> is just as likely to [[DoTheRightThing]] with [[CString]]<nowiki/>s as <code>-initWithCString:</code>, and at least its behavior is predictable.

----

If you're getting data from a standard C string, there are two possible scenarios. If the string only contains ASCII, then -stringWithCString and stringWithUTF8String will produce ''exactly'' the same result. If the string contains non-ASCII characters, -stringWithUTF8String is vastly more likely to behave in a reasonable manner. (I did cover this up above; read more closely! ;-)

----

Exactly, As the "System Encoding" at the BSD/POSIX level (Especially for IO functions) is currently UTF8. This is covered in Apple's documentation.

----

FWIW, <code>[[[NSString]] defaultCStringEncoding]</code> will return the [[NSStringEncoding]] constant the various c string methods will use.

----

Guys, can you cite a source for the info that cString, stringWithCString et.al. use the default system encoding?  From discussion on mailing lists I've always thought that cString was wonkier than that, that maybe it was screwing with stuff in a crazier way.

----

According to TFM:

''Returns a representation of the receiver as a C string in the default C-string encoding.''

The docs for <code>+defaultCStringEncoding</code> don't say a thing about what it is or how it's determined. That's why these functions are useless.

----

When using POSIX or other C [[APIs]] that need <code>char ''</code> data for path or filenames, one should always use <code>-fileSystemRepresentation</code> and not <code>-cString</code>. Why? It's quite simple: <code>-cString</code> only does the right thing when confronted with ASCII data. With non-ASCII data, it will either throw an exception or return stuff that simply won't properly resolve. Any code that uses <code>-cString</code> will only work with ASCII paths, which is a bad policy when OS X natively supports full Unicode in filenames and encourages its use.

----

Actually that's not entirely correct. <code>-cString</code> is documented as using the default C-string encoding, which is system-dependent (and certainly may not be able to correctly represent all strings, and certainly might not be correct for representing a given filesystem path). Its use has been discouraged for some time. Use UTF-8 instead (<code>-UTF8String</code>), or if it's a path use <code>-fileSystemRepresentation</code>. Having said that, I'm not really sure what the different between the two will be for paths, I think that certain characters may be decomposed differently by the latter.

----

Yes, the decomposition will be different. To avoid filenames composed of the same glyphs but different characters/code points, HFS+ defines a standard Unicode decomposition ("canonical decomposition") for filenames. <code>-UTF8String</code> is not guaranteed to return the proper composition; <code>-fileSystemRepresentation</code> is. (See http://developer.apple.com/technotes/tn/tn1150.html#[[UnicodeSubtleties]] for more details.)

----

Also, in the unlikely event that Apple ports Cocoa to a system which doesn't use UTF-8 for paths, <code>-fileSystemRepresentation</code> will continue to return correct strings.