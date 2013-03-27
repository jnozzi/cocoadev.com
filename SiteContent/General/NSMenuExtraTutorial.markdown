General/NSMenuExtra is gonna be huge once an established method 
of creating them is released.  In a few days I'll be posting my 
website dedicated to creating Menu Extra's and anything that 
has to do with them.

**Update (Oct 12)**: I'm still working on a solid example, however if anyone is ready to jump the gun, get ahold of an application called General/ClassDump.  Then head over to the directory ** /System/Library/General/PrivateFrameworks/General/SystemUIPlugin.framework/Versions/A/ ** <--  This is where the file General/SystemUIPlugin is located.  Use General/ClassDump to dissassemble the class header file and go to work.

-General/MattJarjoura

----

Well and good, but what the heck are they? Do we have a glossary page dealing with them? Should we? Are they 10.1 specific?

-- General/RobRix

----

General/NSMenuExtra was introduced in 10.1 and they are a "replacement" for Dock Extras, they're the little icons you see in the menubar in screenshots and allow global access to things like volume, monitor resolution, battery power, etc.

-- General/FinlayDobbie

----

Those aren't just glorified General/NSStatusItems, then? Hmm.

-- General/RobRix

----

Yes, they are -- in fact it's declared as General/NSMenuExtra:General/NSStatusItem in the framework hehe.

-- General/FinlayDobbie

----

Ah, interesting. For those who have 10.1 (we've had delays here), do you know if you can remove those things? I like my clock in that corner, but I'd rather not have anything else.

-- General/RobRix

----

Yes, you can. All the apple supplied ones have associated preferences panes where you can turn them off, and you can cmd-drag them around (to re-order, drag them off the menu bar and they disappear in a puff of smoke like dock items do).

-- General/FinlayDobbie

----

Apple sez this is a private API and 3rd parties shouldn't be messing with it. The way for apps to have global functionality is through Dock Menus

----

So? The Dockling API was private in 10.0, did that stop people? :rolleyes:

-- General/FinlayDobbie

----

Didn't 10.1 break many Docklings? (I've never been a huge fan of them anyway, but I think out of the 3 I've used, 2 didn't survive.)

-- General/JensBaumeister 

----

Nice...I like this bit of technology...

Now we need command-draggable menus in general. Bye bye, Apple Menu! Hey, I can always access the power-off, et cetera, from my power key. I don't use the Apple Menu at all as it is...

Also, Dock Menus are, it seems to me, for a different purpose. iTunes gets Dock Menus because it's a foreground app. Menu Extras are a little more discrete...you use them, I'd guess, for things not associated with a foreground application.

I, for one, would like to mess around with implementing a tear-offable menu extra (like General/NeXT! :)

-- General/RobRix, purveyor of UI tech...or something like that.

----

Hm, I've also heard that this about General/NSStatusItem being a private API, but since this page exists:

http://developer.apple.com/techpubs/macosx/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/General/StatusBar/index.html

I guess that it indeed is public.

--General/PeterLindberg

Hm, you probably mean the .menu bundles. --General/PeterLindberg

----

General/NSStatusItem is a public API and the Apple-recommended way of doing this type of thing. General/NSMenuExtra is a private API (it's a subclass of General/NSStatusItem).

-- General/FinlayDobbie

General/NSMenuExtra is however superior to the General/NSStatusItem way of doing things...You can't move status items around, and they can't be added simply by dropping a bundle on the menu bar...

-- General/DavidRemahl

----

The iThink Group has released versions 1.0 and 1.5 of General/SystemUIHackPack, which contains project builder templates for General/NSMenuExtra's, both icon-type, and text-type... Very easy to use, if I do say so myself.The way they were written also makes it very easy to create dual (both an image and text) Menu Extra's till we release 2.0.

http://group.ithinksw.com/forums/

-- General/JosephSpiros

----

So, does anyone know why Apple is reluctant to make General/NSMenuExtra public?  Originally, it was supposedly to keep the menu bar from being cluttered with 3rd part icons.  But with General/NSStatusItem, that's clearly not the reason.  In fact, all Apple has done by keeping General/NSMenuExtra private is introduce inconsistency between the way the two work -- i.e, you can drag General/NSMenuExtra icons around, you can't with General/NSStatusItem.  You can add/remove General/NSMenuExtra icons by dragging to and from  the menu bar -- you can't with General/NSStatusItems (leading to the extra inconsistency of General/NSStatusItems having things like Quit in them -- quit what?  the app you are in?).

I think Apple needs to either merge the two, or at the very least make General/NSMenuExtra a public API.  Keeping it private doesn't benefit anyone.

-- General/DennisMunsie

----

Trying to read sense into Apple's decisions is probably a worthless investment of effort. The only logical reason is they don't want third party code loaded into an address space they share with them, as happens with General/NSMenuExtra (you execute inside General/SystemUIServer), but not if you have an General/NSStatusItem (you execute within your own application). I'm not really a fan of Menu Extras, personally.

-- General/FinlayDobbie

----

The shared resources/address space issue is one reason, but that could be solved by making third-party General/MenuExtras live in a different address space (several ways to do this; could run each one as a separate process; could run all third-party General/MenuExtras in a single daemon seperate from General/SystemUIServer). The main reason is that Apple's UI group believes (or did believe at one time) that proliferation of these menus is a bad idea -- they don't want another morass like the Control Strip.

----

I agree with Apple that there should not be 5000 different menu items but its the users choice in what they put up there, not the developers. General/NSMenuExtra's were easier to remove from the Menubar for a user (drag & drop) and therefore are inherently better than General/NSStatusItem. Apple should allow us access to these menu items as its in the users benefit as well as ours. Choice is always better.

-- General/MatPeterson