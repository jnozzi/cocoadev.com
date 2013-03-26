Text editor included with Mac OS X. Supports rich text, basic HTML display, pictures, embedded applications, kerning, ligatures and other such Cocoa text-related features. The full source of [[TextEdit]], both in Objective-C and in Java, is included with the Developer Tools ([file://localhost/Developer/Examples/[[AppKit]]/[[TextEdit]]/] - has not been updated for Panther).

[[TextEdit]] made its debut with [[OpenStep]]. [[NeXTSTEP]] included a far superior (for developers, and IMO) editor called Edit.app. It had features like piping text to external scripts,  code folding and so on.

[[TextEdit]] is also the name of the obsolete text handling manager that was used in the original Mac OS, and is now part of Carbon.

----

[[TextEdit]] is also a good example of how crappy the interface ends up when you use file paths as file primitives. If you move a file [[TextEdit]] will either complain it can't find a file or it will passively overwrite whatever is at the old path. Not knowing this beforehand can result in data loss.

Compare this with any app using [[NSDocument]] or most Carbon apps.

Apple's Aqua HI Guidelines are clearly incomplete since this has ramifications in the behavior of commands like Save and Revert.

-[[PaulBayley]]

----

Whatever happened to [[PaulBayley]] a.k.a strobe anarkhos? Did he discover girls? Or Chipmunks? Or maybe he just ran out of things to bitch about in OSX and has moved on to Windows?

It's funny that every one of the projects listed on his page are either dead or stillborn.

----

You can enhance [[TextEdit]] into a fairly capable source code editor using [[TextExtras]].

''"embedded applications"? What does that mean? Also, [[TextEdit]] was also the name of the original [[MacToolbox]] text editing API. The one that couldn't handle >32k at a time.''

----

I think that [[TextEdit]] would be much more successful for Apple if they had a programmer sit down and rewrite it using [[NSDocument]].

''I don't think it would be. Or at least, if they do they should keep the old code available. There are cases where you have to manually do things that the document architecture does automatically, and the [[TextEdit]] source is a good place to look for that. There are plenty of [[NSDocument]] examples around.''

Well, I meant that they would be more successful getting end users to use it as a simple text editor.

''Why? What do end users care what classes it uses? Does [[TextEdit]]'s current behavior differ from the standard [[NSDocument]] behavior?''

Last time I looked at the [[TextEdit]] code it had a comment mentioning that they needed to switch it over to [[NSDocument]]. I get the impression there aren't too many people working on [[TextEdit]].

''it's a shame too; the editor that shipped with [[NeXTSTEP]] was in many ways far more advanced.''

----
OSXHINTS has a thread with several suggested ways to change the [[TextEdit]] preset margins. 

----

You can easily add regex matching to [[TextEdit]] by doing the following (taken from a mailinglist post by [[OgreKit]]'s creator)

FROM: Isao Sonobe
DATE: 2003-12-14 09:06


It is very easy to integrate [[OgreKit]]'s Find Panel into [[TextEdit]] (or other applications).
What you have to do is following three step with zero lines of code:

1. Add [[OgreKit]].framework to [[TextEdit]]'s project. 
   (cf. http://cocoadevcentral.com/articles/000042.php#000042 )

2. Open Edit.nib of [[TextEdit]]. 

   Drop a header file [[OgreKit]].framework/Headers/[[OgreTextFinder]].h into the window of Edit.nib.

   Instantiate [[OgreTextFinder]].

3. Build.

----

From the [[PortlandPatternRepository]] wiki's page on [[TextEdit]]:

''Hidden functionality: To create a page break, type Control-q followed by Control-l (i.e. a lowercase letter L).''