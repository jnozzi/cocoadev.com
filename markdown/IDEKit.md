I'm wondering where I should start using General/IDEKit?

*In your apps? At home? At work? Look at the example project that comes with it? What are you asking?*

What is General/IDEKit?  Build your own General/RealBasic ?

----

It's a fairly decent LGPL framework for writing a code editor (with a line number gutter, syntax coloring, etc) in Cocoa/General/GNUstep. [http://homepage.mac.com/gandreas/General/FileSharing.html] 
----
General/IDEKit seems to be dead, and is no longer accessible at the link above.  If someone has a copy, please mirror it somewhere (General/SourceForge?).
----
Are there any **alternatives** to the General/IDEKit framework that provides General/SyntaxHighlighting without diving into all the coding procedures?

*Theres General/UKSyntaxColoredTextDocument in General/ObjectLibraryViews. There's a lot of sample code around, but that's the only other one I know of that doesn't require doing most of the work yourself. I'm thinking about working on a class to parse General/SubEthaEdit syntax definition files, but secretly hoping someone beats me to it. ;)*

*Take a look at General/HighlighterKit.  It is relatively small and appears to do General/SyntaxHighlighting only.*