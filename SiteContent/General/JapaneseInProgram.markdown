There. I want to make a prog to learn Katakana, one of the japanese syllabaries, but it seems that the Nib file can't take it. When I try to build my app (I did not write any like of code yet), I get 4 errors and 214 warnings. I converted my .m file into Unicode 8. What should I do to make it work ?

-- Trax

----

You might consider looking at a book on the subject:

CJKV Information Processing: Chinese, Japanese, Korean & Vietnamese Computing [http://www.oreilly.com/catalog/cjkvinfo/] is generally considered the best source.

Unicode Demystified, Richard�Gillam, also by O'Reilly may be of some interest since Unicode was mentioned below.

Agfa (font and imaging company) also has information on CJK [http://www.opentype.com/software/cjk_info.asp]

----

Nothing in your nib file should cause any errors in your code; that's not loaded until your program runs.  Maybe you should post the error messages along with the lines of code that are effected.  One common problem is trying to initialize an General/NSString like this,     General/NSString* aString = @"(some japanese character)"; this won't work since the @"" idiom only supports ascii strings.  -- Bo
----

After searching a bit, I found what was the trouble. I converted main.m into Unicode. Anyway. Since you said you can't insert japanese characters into a @"", then how can I implement an array with japanese characters in it ? For example : char kata[2]; kata[0] = (some japanese character); etc....

-- Trax

----

It might be best to load it from file, because otherwise it seems to me that you're going to have to use unichars and set them with Unicode values... which could be... tedious. If you decide you've got to do that, use the Character Palette input method as reference, I think it displays unicode values for specific characters.

And that is all I know.

*
I used the Character Palette to provide the Kana necessary for some buttons in an application I'm building. It seems to be working fine. I have the Button Title set to be the Kana I want and then pass the Title to an General/NSTextView for editing when the button is clicked. When I do an General/NSLog on that transaction, the Unicode equivalent of the Kana character gets written to the log. I am not doing any special encoding of the General/NSString that will be output to the General/NSTextView, however, I did set the default Font for General/NSTextView to be Osaka
*

    

General/NSString *osaka18;
....
osaka18 = General/[NSFont fontWithName:@"Osaka" size:14.0];
....
[trTextView setFont:osaka18];



*
Something like that. --General/SabinDensmore
*

----

More specifically,

1) Your source code files should continue to use a standard 7 or 8 bit encoding. I strongly recommend sticking with normal 7-bit ASCII, since that's the safest, most portable thing to do

2) You should look up all of your localized strings from an external source. You have the following options

* A nib file
* A strings file
* A data file format of your choosing...

Nib files are obviously a propriety binary format. By convention, strings files are saved in UTF-16 unicode. And obviously you can do whatever you want with file formats of your own choosing.

I would recommend using a strings file to hold these localized phrases -- you can find information about strings files scattered about the documentation for General/NSBundle and documentation for localizing/internationalizing software. The best reference I've seen in a while is up at developer.apple.com -- I forget the link exactly. The strings file will let you easily map an English General/NSString (@"ha") to a Japanese General/NSString ("?"). You could create separate strings files for Katakana and Hiragana, and easily switch between the two simply by switching the file reference.

Since strings files are designed to work with arbitrary UI strings, this approach is really best for a program that quizzed you on Japanese phrases (?????????????). For something simple like individual kana characters, you might:

3) just use a lookup table built from the individual unicode values. You can get the unicode values for kana in most high-quality English <-> Japanese dictionaries, or you can figure it out from a little experimentation. The idea here is instead of trying to embed Japanese characters in your source files, store the numeric unicode values that represent those values; use those unicode values to build an General/NSString later on. Finally,

4) You may be able to embed Japanese characters in static strings using specific numeric escape sequences. I'm not a big fan of this approach, but it's worth mentioning.

-- General/MikeTrent

Heh .. looks like our General/WikiCantHandleJapaneseText either ... 

-- General/MikeTrent

----

I'm pretty sure any string created with     @"" is really just a wrapper around a     char *, so it will only support 8-bit characters;  OTOH,     General/[NSString stringWithUTF8String:"(japanese characters)"] seems to work as long as your file is encoded in UTF-8 too. -- Bo

----

I thought about allocating a simple C array for each one (katakana and hiragana), but it's just too bad that I can't store them at once. Since the corresponding unicodes don't follow any logical rule, I can't loop the process. Anyway, storing the characters in a file would be a good alternative...

-- Trax

----

When we experienced the same issue we simply created a plist with the corresponding characters in it. -- General/MatPeterson