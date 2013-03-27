I want an effect kinda like General/ButtonWithTwoStatesAndThreeAlternateImages but instead of toggling through them on click I want to choose from a menu.  What I am thinking of is an image that I can click on, have it popup a menu with choices about the display of the image.

What I thought I'd do is subclass General/NSPopupButton and override it's drawRect: method to draw the image based on the state of the submenu (which it gets with [self titleOfSelectedItem])  Is this a good way to do it? will the drawRect: method get called after the menu goes away? will I break something or is there an easy pitfall? (I have never subclassed any General/NSView before, but this time I need to do a couple and this seemed like the easiest one to start with)

----

Couldn't you just set the image for the General/NSPopupButton's menu items? Or use a General/NSImageView subclass with its     mouseDown:(General/NSEvent *)theEvent method overridden to show its     menu. Or use a General/NSPopupButton with the General/PullDown style. There are a few ways to do this, depending on exactly what you're trying to achieve - I don't think you need to subclass General/NSPopupButton.

----

Initial testing shows it works... I don't want image menu items, (because some of the states are related to text anyways),  I am not sure about showing and hiding menus... that seemed like more work than I wanted... I also don't want to show an arrow button.  Subclassing General/NSPopupButton and over-riding drawRect: was exactly the effect I wanted for how it works... now I just have to figure out the drawing bits...

----

further testing reveals the pitfalls of subclassing an General/NSControl.. I wanted to display images but I think that because General/NSPopupButton is an General/NSControl and uses an General/NSCell, they're all not antialiased. (ie. they are pixely!)  At anyrate, first responder... you were right... I just need to figure out the menu hiding and showing and then I should make it an General/NSView subclass (not General/NSImageView... that uses an General/NSCell too... wait-a-minute.... hmmmm)

----

Problem solved: see General/ImageAntialiasing