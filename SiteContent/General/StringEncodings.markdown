See also:

[Topic]

I have a textfield where users can enter text in different languages, but how do I know what string encoding the entered text string is using?

----

The question does not make sense. All Cocoa objects deal with strings as simply strings with no given encoding. Encodings only come into play when you want to create things which aren't [[NSStrings]], such as C strings or external files.

----

Thanks! I am trying to write the text entered by user into a structure as C String. And I need to know if it was Unicode or ANSI..

----

Ummm, if you really want to do this, [[NSString]] does use Unicode. ANSI is also a group that creates standards -- perhaps you meant ASCII? If you want to get the UTF-8 representation of the string (which is the same as a C string for ASCII characters, which include basic punctuation and English letters and numbers; UTF-8 also supports other languages), copy the results of the <code>UTF8String</code> method of [[NSString]] into your own <code>char</code> array (a.k.a. C String). --[[JediKnil]]

----

In 10.4 following group of statements are valid.

char pszName[20] = "12345";
[[NSMutableString]] ''stringTitle = [[[NSString]] stringWithCString:pszName encoding:[[NSUnicodeStringEncoding]]];

and
[[NSString]] ''title = [anObject copy];
const char pszName[230];
[title getCString:pszName maxLength:226 encoding:m_UseEnc];

how to do this in 10.2 & 10.3? [[THanks]] a lot!

----

Use the <code>initWithData:</code> method. You'll have to get the length of the string using <code>strlen()</code>, and create an [[NSData]] from that.

To go the other way, use the <code>dataUsingEncoding:</code> method, which you can transform into a C string by appending a single null byte to the end.

see also [[NSStringToNSData]]