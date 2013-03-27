

Currently working on a few things including:

* A chess position trainer, including a custom evaluation engine.
* A graphical front-end to the Crafty chess engine.
* A board game app that allows users keep track of PBEM Axis & Allies (no AI).
* A Cocoa version of my favorite board game (not Axis & Allies).
 
 
----

**General/NedO's Gripe of the Day**
No gripes all weekend or today. I guess that means I'm getting the hang of things as I move from C to Cocoa/Obj-C.

----

A few thoughts I've had today.

**MVC**
The whole MVC concept is a bit more complicated that I first thought. It is my understanding that:

Events are passed to Controller(s). The Controller(s) then undertake some action that affects other Controller(s), Model(s) and/or View(s). Some Controller(s) have actions that define them as Model-Controller(s), while other Controller(s) have actions that define them as View-Controller(s). The line between Model-Controller(s) and View-Controller(s) is a fuzzy one. Controllers contain application-specific code.

Some Controller(s) (typically Model-Controller(s)) own and manage Model(s). They may change the data or properties of the Model(s). Model(s) do not communicate their changes directly to View(s) that are dependent upon them. Instead Model(s) post notifications that specify that their data and/or properties have changed. View(s) are set to listen for those notifications and request updates if the notification warrants such. View(s) may get data from Model(s) but may not change the data or properties of the Model(s).

Some Controller(s) (typically View-Controller(s)) own and manage View(s). They may change the properties of the View(s). If the changes in properties warrant, the View(s) may refresh/request addition data as provided by the Model(s).

View-Controller(s) and Model-Controller(s) may have application specific intercommunication.

I'm left with a few questions that I intend to look up tonight and in the coming days:

* View(s) can request data from the Model(s). Am I correct in my understanding that this does not necessarily require any Controller intermediary? *I read General/MVCDifferences for the technical reasons why it does in Apple's MVC interpretation.*
* I have read at http://www.cocoadevcentral.com/articles/000080.php that "...Cocoa Bindings are synonymous with the controller layer, though bindings is the preferred term." Based on my reading of several MVC sites this seems incorrect. What am I misunderstanding? *Again, reading General/MVCDifferences and a few other places it is now my understanding that Apple's MVC isn't theoretically 'pure' and that Controller(s) are indeed interposed between the View(s) and the Model(s).*
* Model(s) and View(s) are, at least theoretically, not application-specific, correct?


I'm sure there are more, but that's what I can think of now.

-General/NedO

----

Your reading seems to have been with regard to Smalltalk's MVC model.  Smalltalk, Cocoa and Java all have different conceptions of MVC, and probably other stuff does too.

The General/ModelViewController page sets out cocoa's version pretty well.

----

Busy week so far, I didn't even get to work on any Cocoa stuff today (Wed) I was so swamped with other work. Debugging and assertion work mostly on Tuesday, not terribly exciting. Sometime this week I'm going to dig into endianness issues for the bitboards (64 bit numbers used to repesent chess positions -- an unsigned long long) in two of my projects. I can hardly control my excitement *sarcasm*.

-General/NedO