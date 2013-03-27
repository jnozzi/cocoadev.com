

Unless I'm missing something in the Cocoa Docs, there is no list of methods that throw exceptions. It'd be nice to have a per-Class list of methods that might throw an exception, so it'd be easy to check if your code is dealing with exceptions properly.

In Javadoc documentation (and in the O'Reilly Java Nutshell Book) for each exception, there is a list of methods that throw it. That'd be nice to have too.

Usually there's a note by the method, but this isn't as useful as it could be. A reverse index is needed. I've described the idea, and if anyone who has more time wants to write a quick script that walks the docs, grabs all the exceptions, and lists them out, I think it'd be a great contribution.

----
An incomplete example of what I propose:


**General/NSString:**

*characterAtIndex:(unsigned)index - Raises an General/NSRangeException if index lies beyond the end of the receiver.
*compare:options:range:(General/NSRange)range locale: - Raises an General/NSRangeException if index lies beyond the end of the receiver.
*getCharacters:(unichar *)buffer range:(General/NSRange)aRange - Raises an General/NSRangeException if any part of aRange lies beyond the end of the receiver.
*cString - Raises an General/NSCharacterConversionException if the receiver can't be represented in the default C string encoding without loss of information. 
*fileSystemRepresentation - Raises an General/NSCharacterConversionException if the receiver can't be represented in the file system's encoding.
*propertyList - Raises an General/NSParseErrorException if the receiver can not be parsed as a property list.


**General/NSArray:**

*objectAtIndex:(unsigned)index - Raises an General/NSRangeException if index lies beyond the end of the receiver.


**General/NSDictionary:**

* setObject:(id)value forKey:(id)key - Raises an General/NSInvalidArgumentException if key sent is nil