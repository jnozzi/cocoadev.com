How do I display an image in an General/NSMenuItem?

----

All right, in Lodestone's General/LSToolGroup, I have the following method:

    
-(void)setUpMenu
{
	General/NSEnumerator *e = [tools objectEnumerator];
	General/LSTool *tool;
	[menu removeAllItems];
	
	while(tool = [e nextObject])
	{
		General/NSMenuItem *mi = [menu addItemWithTitle:[tool name] action:@selector(selectTool:) keyEquivalent:@""];
		[mi setTarget:self];
		[mi setImage:[tool icon]];
		[mi setRepresentedObject:tool];
	}
	
	selectedTool = [tools objectAtIndex:0];
}


The only really interesting thing to note there is     [mi setImage:[tool icon]]--what you're not seeing is that General/LSTool's icon implementation is just using     General/[NSImage imageWithName:...]. Easy!

-- General/RobRix
----
I thought I'd note that even though addItemWithTitle:... returns     id <General/NSMenuItem> the General/NSMenuItem protocol is marked as deprecated. From the documentation:
    

**WARNING:** The General/NSMenuItem protocol is being removed from the Application Kit;
you must use the General/NSMenuItem class instead.
This change does not affect binary compatibility between different versions of projects,
but might cause failures in project builds.
To adapt your projects to this change, alter all references to the protocol (for example,
<General/NSMenuItem>) to references to the class (General/NSMenuItem).*



----

Good catch, thanks; I've updated the source on this page and will update Lodestone accordingly.

-- General/RobRix

----

I'm writing code for General/NSPopUpButton items: how would I add a submenu to a item, and then have items in that submenu.

*Look at the General/NSPopupButton documentation. Here:* [http://developer.apple.com/documentation/Cocoa/Conceptual/General/MenuList/index.html]

----

**Additional discussion**

I have a General/NSDocument app, when I run the app, then try to save I get these two errors in runtime.

    

*2004-03-05 21:12:13.892 General/HTMLEdit[9159] *** Assertion failure in -General/[NSMenuItem setSubmenu:], Menus.subproj/General/NSMenuItem.m:449
*2004-03-05 21:12:13.898 General/HTMLEdit[9159] Menu to be set as submenu is already a submenu of some menu.



----

Apparently the menu to be set as submenu is already a submenu of some menu.

----

Assertion failures are exceptions. See General/DebuggingTechniques, especially the section about breaking on exceptions.

----

I'm getting a runtime error

    
2004-02-15 12:43:33.148 General/HTMLEdit[25367] *** Assertion failure in -General/[NSMenu itemAtIndex:], Menus.subproj/General/NSMenu.m:638
2004-02-15 12:43:33.155 General/HTMLEdit[25367] Invalid parameter not satisfying: (index >= 0) && (index < (_itemArray ? General/CFArrayGetCount(_itemArray) : 0))


----
Since you are asking for help, I needed some info before I could provide any useful information. The build error:
    
2004-02-15 12:43:33.148 General/HTMLEdit[25367] *** Assertion failure in -General/[NSMenu itemAtIndex:], Menus.subproj/General/NSMenu.m:638
2004-02-15 12:43:33.155 General/HTMLEdit[25367] Invalid parameter not satisfying: (index >= 0) && (index < (_itemArray ? General/CFArrayGetCount(_itemArray) : 0))

led me to believe that     sourcePopUp did not have an item at an index value of 0, so I ask you to report back what the state of the runtime was at that particular line of code. That's all.....
----

The source follows

    
-(void)setSourcePopUp
{
        General/NSRect rect;
        rect = General/NSMakeRect(20,20, 50, 50);
        
	//Main Menu
        [sourcePopUp removeAllItems];
        
        General/NSMenuItem *item;
	[sourcePopUp addItemWithTitle:@"Source"];
	item = [sourcePopUp itemAtIndex:0];
	[item setImage:General/[NSImage imageNamed:@"package"]];

        General/NSMenuItem *objects;
        [sourcePopUp addItemWithTitle:@"Objects"]; 
        objects = [sourcePopUp itemAtIndex:1];
        [objects setImage:General/[NSImage imageNamed:@"smartfolder"]];

        General/NSMenuItem *punctuation;
        [sourcePopUp addItemWithTitle:@"Punctuation"];
        punctuation = [sourcePopUp itemAtIndex:2];
        [punctuation setImage:General/[NSImage imageNamed:@"smartfolder"]];
        
        General/NSMenuItem *characters;
        [sourcePopUp addItemWithTitle:@"Punctuation"];
        characters = [sourcePopUp itemAtIndex:3];
        [characters setImage:General/[NSImage imageNamed:@"smartfolder"]];
        
        General/NSMenuItem *headtags;
        [sourcePopUp addItemWithTitle:@"Head Tags"];
        headtags = [sourcePopUp itemAtIndex:4];
        [headtags setImage:General/[NSImage imageNamed:@"smartfolder"]];
}


----

I'll give you a hint: file:///Developer/Documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSMenuItem.html

Log the number of items before asking for an itemAtIndex and let us know what happens...

    
	[sourcePopUp addItemWithTitle:@"Source"];
        General/NSLog(@"number of items: %i", [sourcePopUp numberOfItems]);
	item = [sourcePopUp itemAtIndex:0];


----

For adding a General/NSMenuItem to a General/NSMenu,..
    
-(void)newFolder:(id)sender
{
	General/NSMenuItem *folderItem = General/[theMenu addItemWithTitle:[folderName stringValue] action: nil keyEquivalent: @""] setTarget:self]; 	
        [folderItem setImage:[[[NSImage imageNamed:@"folder"]];
	[folderWindow orderOut:nil]; 
}


----
Since we're on the discussion of Menu Items, I have a quick question.  

How do users/developers feel about color images for menu bar icons/items instead of plain black/white?

-General/TriLateral
----
Concerning color icons in the menu bar (as General/NSStatusItems ?) I had used a color icon in my app but people requested it be grayscale for consistency. -- General/KevinWojniak

----

IMO color is OK if it indicates some kind of alert state (in a General/NSStatusItem), but not as a normal icon, or for normal menu items.

----

Of course, the best thing to do is to include both color and grayscale icons and rely on user preference.
----
My menu extra program (Dockyard) uses a color icon (just because it looks a lot better) and it looks fine to me. However, I agree with the previous (anonymous) poster for the most part...being able to change icons might help the user. Even so, Apple's Input menu (for changing your text input mode) shows color flags, and the Spotlight icon in Tiger has the normal Spotlight blue. I would guess the original reason for avoiding color is to keep from clashing with the Apple menu, but it seems even Apple doesn't always follow this guideline. Oh, by the way, to add a separator item to a menu, just do this. --General/JediKnil
    
[menu addItem:General/[NSMenuItem separatorItem]];


----

I was wondering if anyone knows how to provide custom drawing for General/NSMenuItem. I've looked into General/HIToolbox but when I override the methods for drawing the items I can't do things like edit the drawing of the title. I've tried *many* times to override those methods correctly but the drawing never works correctly. I'm making a theme framework and this is essential.

Please help! ~Alan

----

Is there a way to connect a menu item to a method *in code*, well after the app has been running (and not in IB).  I already have an General/NSMenuItem variable set up and connected, so I can call methods of (i.e. send messages to) my General/NSMenuItem.  How do I use code to connect my menu item to a method?

Many thanks -- General/DarelRex@gmail.com
----
- setTarget:
- setAction:

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSActionCell_Class/Reference/Reference.html

See also http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaFundamentals/General/CoreAppArchitecture/chapter_7_section_6.html
http://developer.apple.com/documentation/Cocoa/Conceptual/General/EventOverview/General/EventArchitecture/chapter_2_section_6.html

Buy yourself one of the lovely books available: General/CocoaBooks 
----
Thanks!!!  That helps tremendously.  --General/DarelRex@gmail.com