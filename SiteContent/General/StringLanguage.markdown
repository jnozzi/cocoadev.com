Good day.

I have some questions:

What is the simplest way to detect language of [[NSString]](or character of [[NSString]])?
How can i detect active keyboard layout?
Where can i read about working with (active) keyboard layout(s)?

Thanks.

''What language a string is in? I'm not aware of any way to do that without writing an AI parser. You could search the string for common words from common languages, I guess. 'the' would mean English, 'le' would mean French, 'el' would mean Spanish, and so on.''

The <code>[[AppleLanguages]]</code> key in the [[NSGlobalDomain]] of user defaults contains the current OS language.

http://developer.apple.com/documentation/Cocoa/Conceptual/[[UserDefaults]]/Concepts/[[DefaultsDomains]].html

Take a look at [[HIToolbox]]/Keyboards.h
----

[[NSString]](s) have encodings. See [[NSStringEncoding]].

For input managers and what not, see:


http://developer.apple.com/documentation/Cocoa/[[TextInternational]]-date.html

- [[NeilVanNote]]

Hello, I might be able to help you in case you're looking for special cases in terms of language. There's [[NSCharacterSet]], a cool class which lets you define a range of letters and symbols. That way I wrote a parser to divide German/Persian text files into seperate strings. Check the manual or mail me at info a.t sprachwerker.de