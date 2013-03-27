

I started working on an General/NSSlider subclass (let's call it General/XSlider) that draws its background in a special way (via a matching General/NSSliderCell subclass called General/XSliderCell).  Got that working, so far, so good.  I can drag out an General/NSSlider in IB, change its class to General/XSlider, and there I go.  Along the way, I found that overriding +cellClass wasn't working for things loaded from IB, so I programmatically set the cell in -initWithCoder:.

When I started playing with the slider in IB though (changing between regualar/small/mini, showing ticks or not, etc), I got weirdness when when those objects were loaded from the nib;  It turns out that most of those parameters are actually stored in the General/NSSliderCell instance in the nib file (rather than in the General/XSliderCell instance), so when I manually set a new General/XSliderCell instance in initWithCoder:, most of that info is lost, resulting in weird drawing.

I can't find any way to specify the cell class for my General/XSlider within IB, so I figured I would build a palette.  I made a palette containing General/XSlider and General/XSliderCell, put both General/XSlider and General/XSliderCell into my palette.table, put an General/XSlider into my General/XSliderPalette.nib (by dragging out an General/NSSlider and changing its class).  Since my subclass doesn't allow any customization at this level beyond what General/NSSlider provies, I made use of the standard General/NSSlider inspector controls by returning @"General/IBSliderInspector" from -General/[XSlider inspectorClassName].

The palette compiled and loaded into IB fine, except that the sliders in the palette looked like normal General/NSSliders, not like my fancy General/XSliders (but I put that on the back burner for the moment).  I rebuilt my interface using General/XSliders dragged in from the new palette, rebuilt my app, and...  I still have the same problem as before!

The reason is that even the General/XSliders I pull in from the new palette were, themselves, originally General/NSSliders from the normal palette, and are therefore still making use of General/NSSliderCell instead of General/XSliderCell!  This is, of course, also why the sliders in my new palette look like normal sliders:  they are being drawn by General/NSSliderCell.

The solution, it turns out, is to create the palette nib in a slightly different way:  Instead of dragging an General/NSSlider into the view, I drag in a General/CustomView and then set its class to General/XSlider.  Doing so ensures that a new General/XSlider is created, which will use its +cellClass method to create an General/XSliderCell.  Now, I can drag in General/XSliders from my palette, reconfigure them with the normal slider inspector panels, and everything looks and works as it should both in IB and in my project.  

This posting started out as a plea for help, but about halfway through, just writing it down helped me figure out the solution myself.  Thanks, me!  I figured I may as well post it here anyway, to document it for posterity.

// General/JackNutting
----
Sounds like a great solution to a (relatively) common problem, but I have one question. If you rebuilt your palette using an early version of your palette (bootstrapping, I guess), doesn't that mean that your palette requires your palette to load? Will it still work if you remove all of the versions of the palette from IB (using the Preferences window)? --General/JediKnil

----
Actually, it works fine.  The nib file for my palette doesn't really know about General/XSlider and General/XSliderCell, other than that they exist.  That's what dragging out a custom view gives you, the ability to put arbitrary classes into your GUI.  As long as they're there at runtime in the compiled app, that's all you need.  Incidentally, when I look at the nib for my palette, I don't see my slider the way it really looks, I just see the dark gray custom-view box.  When the compiled palette is loaded in IB however, the slider appears as it should.

// General/JackNutting