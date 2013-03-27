Apple blurb:

With Dock extras, you could also access some system-wide preferences from the Dock. Rather than take up valuable Dock space, the Mac OS X version 10.1 menu bar now displays icons for battery life and General/AirPort signal strength, as well as controls for system audio, display settings and modem connection right next to the system clock. As with the clock, you can choose to show or hide these controls from the associated System Preference. And you can also change the clock to display with analog hands with the Date and Time Preference.

This is what they look like:
http://www.diggory.net/grazing/airportmenu.gif

More discussion: General/NSMenuExtraTutorial

Template: http://group.ithinksw.com/cgi-bin/download.cgi?General/SystemUIHackPack.dmg (Link broken)

Example: http://x-asm.sourceforge.net/

----

**Undocumented Goodness!**

Above is a description of Menu Extras (from someone else). This page is called General/NSMenuExtra, the Cocoa class used to create Menu Extras, which itself is Undocumented Goodness.

Basically, to create a menu extra, you do this:

*Get a tool called General/ClassDump.
*Install it in /usr/bin/.
*Run in Terminal: class-dump /System/Library/General/PrivateFrameworks/General/SystemUIPlugin.framework/Versions/A/General/SystemUIPlugin > ~/Documents/General/SystemUIPlugin.h 
*Create a new General/ProjectBuilder project of type Cocoa Bundle.

Ok, I'll finish these instructions later. I'll post a more detailed tutorial soon, anyway.

--General/AdamAtlas

----


See also General/CoreMenuExtra for some useful General/MenuExtra-related General/APIs.
----
I'm building a General/NSMenuExtra, and I have this problem, when I launch the .menu product it never displays the image for the icon.
Here is my code
    
- (id)initWithBundle:(General/NSBundle *)bundle
{
    self = [super initWithBundle:bundle];
    if( self == nil )
        return nil;
        
    theView = General/[[MenuExtraView alloc] initWithFrame:
    General/self view] frame] menuExtra:self];
    [self setView:theView];
    
    theMenu = [[[[NSMenu alloc] initWithTitle: @""];
    [theMenu setAutoenablesItems:NO];
    theImage = General/[[NSImage alloc]
           initWithContentsOfFile:General/self bundle] pathForImageResource:@"smartfolder.tiff";
    return self;
}

Thanks in advance. : )

--General/JoshaChapmanDodson

*I suggest you complete the tutorial at General/CocoaDevCentral ( http://cocoadevcentral.com/articles/000078.php ).  It and the following comments contain several links to open-source menu extras that should answer any questions you may have.*

----

It is not recommended to use Menu Extras. Given that users have to resort to using various hacks to even USE third party ones, there's really not much of a benefit to using them anymore, as the experience for the user is not as seamless as it used to be.

Also, if you can't figure out how to create a Menu Extra on your own, don't expect us to help you. Menu Extras and their API are private for a reason, that is, Apple owns them, and can change the API at any time. What are you going to do when Apple does? Are you going to come here and whine for help from us to fix your product, when you KNOW that Apple purposefully RESTRICTS developers from using this API?

No, use the closest thing to a recommended API, which is General/NSStatusBar/General/NSStatusItem.

*You've never written software to scratch an itch of your own?  I've written two menu extras, and I don't care if another soul ever uses them.  Besides, writing a menu extra does not preclude writing a status item; one even can include both in the same bundle (see General/WeatherPop).  I don't know if you're refusing to help because it's General/UndocumentedGoodness or he's General/JoshaChapmanDodson, but neither strikes me as a good reason.*

----

Did anybody notice, that if they make an General/NSMenuExtra under 10.3 that it doesn't get blocked?
You don't need any external Menu-Extra enablers to get it to work!

*I noticed exactly the opposite.  Are you sure you aren't running anything that embeds General/MenuCracker?*

The Keychain General/MenuExtra contains something that works the same way as General/MenuCracker, called "Enable.menu". If you ever loaded the Keychain General/MenuExtra, the Enable.menu General/MenuExtra would've been set to load as well, which would produce the behavior you're noting.\

----

Anyone know how to put text in the title with an General/NSMenuExtra?  This is easy with General/NSStatusItem but General/NSMenuExtra ignores -setTitle.  The corollary to this is how to expand the Rect dynamically to make room for the text you will put there :-)

-General/EcumeDesJours
----
When creating the General/NSMenu for the General/NSMenuItem you could use this;

    
theMenu = General/[[NSMenu alloc] initWithTitle: @"General/MenuName"];


--General/JoshaChapmanDodson

----

the problem with that is that the rect proportions dont change so the extra text (anything that doesnt fit in the rect) is simply truncated.  :-(

----

This all looks like old info - can anyone speak as to how menuExtra support is in 10.4?  Or better still, if there are any known changes for 10.5?  I realize it's a pretty general, vague question but I am looking at converting m existing General/NSStatusItem implementation to one of General/NSMenuExtra, because I want to be able to drag around the item.  i'd rather not do that if it looks like General/NSStatusItem will get pumped up or General/NSMenuExtra even more hosed...
thanks
----
Still works fine in 10.4. Don't know about 10.5.
----
Still works fine in 10.5. You still need something like General/MenuCracker though.