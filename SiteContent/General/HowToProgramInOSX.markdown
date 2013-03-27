This area is designed to help people get started programming in Cocoa in OSX.  No programming experience necessary! It is designed around questions someone starting in Cocoa might have.  Anyone is welcome to try to improve the utility of this page.

This page assumes you are running OSX 10.3 (Panther), 10.4 (Tiger), or 10.5 (Leopard) and will be using Apple's IDE General/XCode.  The most current version of General/XCode is 3.0 (as of 12/11/07).  If you are using OSX 10.2 or earlier, you be using General/ProjectBuilder instead of General/XCode.  Much of the following still applies, if this is the case.

**How do I program in OSX?**

**Before You Can Start**

You first need a compiler.  General/WhereToGetApplesCocoaCompiler will tell you as briefly as possible what a compiler is and where to obtain one.

**Now that I have the tools, how do I program?**

You will have to...

* Open General/XCode (or General/ProjectBuilder)
* Create a New Project - General/HowToCreateANewProjectInXcode
* Common interface widgets and general use of General/InterfaceBuilder

* General/HowToCreateAButton
* General/HowToCreateADrawer
* General/HowToAddAMenuItem
* General/HowToTestTheInterface
* General/HowToCreateAClassInInterfaceBuilder
* General/HowToInstantiateAClassInInterfaceBuilder
* General/HowToAddTabsInInterfaceBuilder
* General/HowToCreateAnActionMethodUsingInterfaceBuilder

* Write your program code - In most programs you will need to...

* write some code in General/XCode.  Here is some background information on programming in objective-C,

* General/UsefulCodeSnippets
* Objective-C specific information...

* General/HowToCreateAClassInXcode
* General/HowToMakeAnActionMethod
* General/DifferenceBetweenDotHAndDotMFiles
* General/AnatomyOfADotHFile
* General/AnatomyOfADotMFile
* General/HowToWriteDesignatedInitializerMethods
* General/HowToDeclareAVariable

*C specific information...

* General/HowToUseVariables
* General/LogicalOperators
* General/HowToUseConditionalStatements
* General/HowToUseLoops
* General/HowToComment
* General/WhatToKnowAboutCFunctions
* General/HowToUseStructures
* General/HowToUsePointers

* General/HowToConvert - converting data types

* do something like open a file, draw something to a window, change the text of a button, display a name in a text box, etc.

* General/HowToGetInputFromTheUser
* General/ValidatingUserInterface
* General/HowToDraw
* General/HowToSave
* General/HowToOpen
* General/HowToPrint
* General/HowToBeep
* General/HowToUseOutlets
* General/HowToGenerateRandomNumbers
* General/HowToOpenAnImageAndPutItInAnImageView
* General/HowToOpenAMovieAndPutItInAMovieView
*General/HowToOpenASheet


* Connect the interface to the code

* General/HowToCreateAControllerClass
* General/DelegationAndNotification - how to use a General/DelegateObject
* General/HowToSaveAClassCreatedInInterfaceBuilderToXcode
* General/HowToLinkAButtonToAnActionMethod

* Compile your project

* General/HowToCreateAFramework

  

Once you have done all that, you have just created the next great macintosh program.  But since you are just learning, the program may have a bug. Or two. So you may be interested in...

**Debugging your program**

* General/HowToDebug
* General/MemoryManagement
* Don't forget to follow these General/RulesOfThumb.


**Other issues**

* General/HowToAccessMethodsAndVariablesFromADifferentClass
* General/HowToCreateAThread - making your application multithreaded
* General/HowToAddAProgressBar
* General/HowToGetMetalLookingWindows
* General/HowToMakeAquaIcons
* General/HowToSupportAppleScript
* Check out more General/CocoaSampleCode
* General/CocoaBooks - look here for the latest books on Cocoa and reviews of same
* General/HowToCreateAScreenSaver - see the website [http://macedition.com/bolts/bolts_20020514.php] - see also General/ScreenSaver.
* General/CocoaGlossary - look here to find out the meaning for General/ActionMethod, General/AnObject, and much more...
* Need suggestions for projects to get your feet wet?  see General/NewbieProjectIdeas
* If you want to learn how to write a simple C program using General/XCode see this website - [http://cocoadevcentral.com/articles/000054.php].


**Cocoa Tutorials**

* O'Reilly's Cocoa Tutorials - [http://www.oreillynet.com/pub/ct/37]
* Tutorials at Project Omega - [http://www.projectomega.org/subcat.php?lg=en&php=tuts_cocoa]
* Cocoa Dev Central - Serving Cocoa Newbies since (++2000) - [http://www.cocoadevcentral.com/]
* Tutorial on Cocoa Bindings (Panther or later) - General/CurrencyConverterWithBindings has links


**Cocoa Discussion Groups**

* Apple's Developer Discussions - [http://discussions.info.apple.com/General/WebX?13@50.EcPJaYSKg6q.5@.eee3b3a]
* Google Groups comp.sys.mac.programmer.help - [http://groups.google.com/groups?group=comp.sys.mac.programmer.help]


**Common questions**

*How do I go from my project in General/XCode to the project interface in Interface Builder?*

Double click on the file "General/MainMenu.nib".

*I try to run my program, but General/XCode cannot find some of my files, what do I do?*

The most common reason for this is that you have moved your project files.  Use the command "Clean All Targets" and then recompile.  Should work now.

*When I try to implement a progress bar, it will not disappear (either programmatically or using the Interface Builder info panel).  What is going on?*

Make sure to go into Interface Builder and check to make sure in Preferences -> General that under Nib Compatibility, the radio button is set to "10.2 and later format".  It is actually set to "Pre-10.2 format" as a default for some reason which limits functionality on projects you normally would want to develop for 10.2.  Strange.

----
Annotations
----


This is a General/WikiWikiWeb page.  Feel free to make the changes you suggest.  --General/AlexanderD

You might want to look into General/HowToUseTopics. Making a single word like "class" linkable sounds like you want to know either General/HowToUseFootnotes or the names of some entries in the General/CocoaGlossary. As for text indenting, well, lists and pre-formatted text (BEGINCODE and BEGINCODESTYLE, I believe) are pretty much the only options. -- General/RobRix

You're gonna need to provide the wannabe developer with some basic background before jumping into the constructs of the C language -- perhaps start with Boolean logic (easy to explain) and then pointers (difficult to explain clearly).

Why did the full URL not get included for Project Omega or Google Groups? -- General/AlexanderD

There are still several "stub" links as they say at Wikipedia (General/WhatToKnowAboutCFunctions and General/HowToPrint), if anyone wants to help fill these in that would be great.  Also, if you have other ideas for what to include, please do. -- General/AlexanderD      

If you know unix-programming already, I can't see how you can't handle Mac OS X-programming, since it IS a Unix-operating system (Darwin, the foundation of Mac OS X, is based on General/FreeBSD running on a Mach3 kernel). --Anonymous (Ed. Note Mach3 is a razor, Mach is the kernel) [Maybe Mach is a cutting-edge kernel? ;) -M]

For most end-user GUI apps on OS X, there is no common ground held with the Unix heritage so I can see why it would be difficult.  The only reason why anyone would find moving to OS X trivial is if they had already done work in General/GNUStep or on General/NeXTStep.  Conveniently, however, getting started on OS X and with Obj-C is fairly straight forward if you already are comfortable with OO concepts and have someone to answer your quick questions.  --General/JeffDisher

IMHO Objective-C and Cocoa are two of those slightly frustrating (but ultimately rewarding) things in life which are easy when you know how. This great site and this page (great work, guys :) ) plus a good reference book such as General/BookCocoaProgramming should assist you in making rapid progress. -- General/DerekBolli
 Pour vous inscrire Orange et garder votre  numéro, vous aurez  peuvent avoir votre compte   propriétaire  ( signal ) [http://obtenir-rio.info numéro rio]. Vous obtiendrez  est certain d'obtenir gratuitement pour  totalement gratuit  par appelant   mots  du serveur ou du service à la clientèle   votre propre  vieille fournisseur  [http://obtenir-rio.info/rio-bouygues code rio bouygues] . Vous ne  CAN   acquérir  un SMS avec votre . Avec  du  [http://obtenir-rio.info/rio-orange numero rio orange], alors vous pouvez   sur le  offre de votre   à propos   rouge.