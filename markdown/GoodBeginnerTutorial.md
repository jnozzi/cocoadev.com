*Redirect from General/GettingStarted*

Discussion and recommendations for pre-General/ObjectiveC and concurrent tutorials http://goo.gl/General/OeSCu

----

I'm new to Mac programming. I bought 2 books: General/BookTheMacXcodeTwoBook was for more advanced users; General/BookCocoaProgDummies started off good, but I found out that it was for an older version of xcode called General/ProjectBuilder. It looks the same but there are many things that are different in General/XCode and I can't do some of the tutorials.

I know no C, but even the tutorials on the apple website already assume that you know C.

What book should I get that starts off on the basics of Cocoa, General/XCode and General/ObjectiveC I guess.

----

*A good place would be to learn C! Objective C is a superset of C, so it won't be wasted effort. Try Googling for C tutorials, perhaps.*

I didn't know much C at all before picking up General/ObjectiveC. I had experience with some other languages, however, which made it easier. There are a number of other pages on this wiki that provide 'where to start' information. Perhaps you arrived here from one of them.

----

If General/XCode seems daunting, learn C with just the Terminal and a General/TextEditor, then move on up to General/ObjectiveC and General/XCode. 

----

I suggest General/BookCocoaProgMacOSX. It's demanding, but eventually rewarding. General/BookProgInObjC spends some time teaching basic structured programming concepts that go along with C programming, in the context of learning object-oriented programming with General/ObjectiveC.

----

An excellent book for basic knowledge and reference in C is "C Programming: A Modern Approach" by K.N. King.  I learned C from this book, and years latter I still pick it up and use it for reference material.

Here's the link on Amazon:
http://www.amazon.com/exec/obidos/tg/detail/-/0393969452/qid=1050616564/sr=1-3/ref=sr_1_3/002-2127829-3813603?v=glance&s=books

-- General/AndrewMiner 

----

I didn't bother learning C first.  Since General/ObjC is a superset of C I figure you'll learn C inherently if you learn General/ObjC.  The problem with learning C (for me) was that when I did start to take that route most of what I was reading was useless information.  I dont need to use getch() or printf() if I'm working with GUI elements.  I do think its a little lame that there are no materials that cover learning Obj-C fron the ground up, including _relevant_ C information, and I'd recomend getting a book on C just to keep as a reference & to learn syntax if you dont even know that, but as for becoming proficient in C before you start into Cocoa / Obj-C...  Most of the objects & methods you're going to use don't exist in C.  You don't need a whole book just to learn a few loops & if/then's.   You're programming because you want to *do* something with it. You might want to check out:

http://www.cocoadevcentral.com/articles/000081.php - A C tutorial forObj-C

Or: *Cocoadevcentral: Learn C with General/ProjectBuilder* http://cocoadevcentral.com/articles/000054.php

Also, I would recommend covering C material as you go, since it will help you in the long run (since it really is part of General/ObjC).  I just dont think one needs to come before the other.

----

Another good starting point is choosing a language you like, and getting ready to use that. A lot of people will say that it's easiest to learn the Cocoa API and whatever with General/ObjC, but you have tons of options. You can do General/RubyLang, Io, General/PythonLang, Java (sort of) and whatever else there are bridges for. In fact, there is even a General/LuA bridge!

An articulate argument for General/PythonLang as a natural starting point is found at

http://www-teaching.physics.ox.ac.uk/computing/General/ProgrammingResources/Oxford/handbook_Python_html/node7.html

----

You *do* have tons of options; however, most of the documentation and online resources assume (and give examples in) General/ObjectiveC. I disagree with the above advice. If you're learning an API, you should always learn it first in its native language if for no other reason than the bulk of its documentation and examples are given in that language. *Updated:* I see nothing in the argument link above that mentions using Python to learn an API. It only mentions using General/PythonLang as being useful as an introduction to programming. Language != API.

----

Using Python posits the additional task of learning the General/PyObjC bridge. Nothing in my recommendation of Python implies any confusion between language and API. But a point seemed to turn on whether learning the API was easier with General/ObjC or with some other language. It should not escape you that some of those coming to this wiki with questions not only do not have much grasp of the API, but are trying to learn fundamental programming concepts at the same time. Witness the number of straight C questions that pop up from time to time. To them, yes, I would recommend they learn C first, and then return to General/ObjC. Impatience among beginners learning on their own is the rule rather than the exception; nothing we write here will change that. By reorganizing this and other beginner pages, I certainly did not intend to open the what-language-is-best-for-beginners can of worms; that was done by the poster who originated the Discussion section on this page. Maybe we need a can opener, but this site already has numerous pages like General/CocoaBridges and General/CocoaResources (and for extended discussion, General/OtherLanguages).

----

Which of these "tons of options" allow you to avoid the General/MemoryManagement issues that sometimes cause difficulties for beginners? Is it even a good idea to avoid those issues (assuming you even can) when learning an API whose native language is C and General/ObjC?

----

If you know General/AppleScript from the beginning, you can start easy with doing an General/AppleScript project in General/ProjectBuilder, and you will get to know PB and General/InterfaceBuilder. To start off with that go to www.cocoadevcentral.com, which has a General/AppleScript tutorial at the top (right now atleast).

When done that, or you just want to go directly on the beef - Cocoa - you can read other tutorials at cocoadevcentral. They have lots of them - click Tutorials: Bare Basics in sidebar and start at the bottom.

Also, read /Developer/Documentation/Cocoa/Obj****C****Tutorial/objctutorial.pdf on your harddrive. You can try, when you want to get deeper insights, to read /Developer/Documentation/Cocoa/General/ObjectiveC/General/ObjC.pdf too, although you can skip it if you don't feel like reading it.

What else did help me was the tutorials at www.oreillynet.com. Try http://www.oreillynet.com/pub/ct/37 (start at the bottom here too).

Good Luck - General/EnglaBenny

----

Learning C is considered by many to be a pre-requisite. General/ObjectiveC is a (small-ish) superset of C.

-- General/MatPeterson

----

You absolutely should not skip General/ObjC.pdf. Read it six or seven times. Sleep with it under your pillow. Print a copy, read it, then liquify and ingest it. It really is worth it.

-- General/RobRix

----

I'm definitely a huge proponent of General/ObjC.pdf--but as for a pre-language, Smalltalk would be just as suitable a programming background as C, and the experience learning how to use the objects that come with a Smalltalk distribution would help greatly with grokking the Cocoa frameworks. Smalltalk is sort of my pet language, of course, so take this for what it's worth.

If I could use Smalltalk and Cocoa, I'd be most happy. (:
Maybe another feature for my source code editor-- automatic smalltalk-->objc translation.  Now that'd be nuts.

Oh, yeah, you can find a good distribution of Smalltalk at www.squeak.org.

--General/JoeOsborn

----

**Having Trouble Learning Cocoa**

I'm trying to learn Objective-C and Cocoa and am having trouble. I have no expierience in any language except General/REALbasic. I'm used to that way of doing things - i.e. you take the object, and modify it/tell it to do something like this:

PushButton1.Caption="Whatever here"

or

TextField1.text="Really cool text"

I can't figure out how to do this in Obj-C and Cocoa. I didn't have enough HD space to install the docs... are they available on Apple's developer site?

----

----

Also read the General/XCode docs. General/XCode is a very different environment than General/RealBasic, and you'll do a lot of stumbling around in it without the docs. [http://developer.apple.com/documentation/General/DeveloperTools/Tools.html]

Sure, here is the General/AppKit:
http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/index.html

Here is Foundation:
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/index.html

There are lots of development sites which can help you out.  A good place to look for beginner tutorials is Cocoa Dev Central:
http://www.cocoadevcentral.com/

The best thing you could do is get one of excellent introductory General/CocoaBooks.  They cover all of this. Until then look at the General/NSButton docs for things like [pushbutton1 setTitle: @"Whatever"] or [textfield1 setStringValue: @"cool text"].  Or use Interface builder.  It's much easier than doing it with code.

The libraries in my area have the General/BookLearningCocoaObjCSecond. If you live in a big area yours probably will too.  Or at least you might find something similar.  You would be surprised at what you can find at the library.

You should really get one good book (in General/CocoaBooks). One is enough to get you started. Just one. I promise. Then you can get everything from the web. Also remember to read some good C introduction at some point (on the web... or maybe a very cheap old book ;-).

----

Apple has some really simple examples to show you how Interface Builder and General/XCode work together.  It is a remade version of the same tutorial and, I am sure, many others here used to learn their way around the tools and the Cocoa framework.  Check out the currency converter:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjCTutorial/index.html

--General/JeffDisher

----

Check out the General/MacDevCenter Cocoa Programming pages at www.macdevcenter.com/pub/ct/37