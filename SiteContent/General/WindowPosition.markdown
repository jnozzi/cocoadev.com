A window has a '''frame''' (an [[NSRect]] data structure obtained by something like the following:

<code>[[NSRect]] myWinFrame = [ myWindow frame ];</code>

The frame is always reckoned in screen coordinates, according to easily-accessible documentation.

An [[NSRect]] structure has the following <code>float</code> components:

<code>theRect.origin</code> and <code>theRect.size</code>    (if you don't understand the dot notation consult a C reference such as K &R)

the <code>origin</code> is the x-y position of the [[NSRect]] (the lower left-most corner, to be precise)
This in itself is an [[NSPoint]] data structure, and you can refer to the <code>float</code> component variables, e.g., by <code>aPoint.x</code> and <code>aPoint.y</code>
assuming an [[NSPoint]] variable declared as <code>aPoint</code>.

The <code>size</code> is the x-y ''dimensions'' of the [[NSRect]]
This is an [[NSSize]] data structure, with <code>float</code> components referred to as <code>aRect.width</code> and <code>aRect.height</code>

The worst it will ever get is if you want to refer to one of those subcomponents via the [[NSRect]] variable itself, to wit:

<code>myRect.origin.x</code> or <code>myRect.size.height</code>

----

Examples:
<code>
[[NSPoint]] myWinOrgin = [ myWin frame].origin;
[[NSSize]] myWinSize = [ myWin frame ].size;
float myWinLowerLeftX = myWinOrigin.x;
</code>

If you have trouble obtaining such data from one of your windows, make sure the window variable actually points to a window object.
This could happen, for example, if you have not connected a window outlet in [[InterfaceBuilder]], or perhaps your window initialization
failed. But those are subjects for A''''notherPage.
If myWindow is nil, then [myWindow frame].origin would cause a crash.

----

Here is something slick you can try with window positioning:

Change the origin to give the illusion of an item flying across the screen as it were with -setFrame:display:animate: 

<code>if(aWindow) {
[[NSRect]] newRect = [aWindow frame];
newRect.origin.y -= 30;
[[NSLog]](@"%.0f",newRect.origin.y);//Remember this is a float to log, but there is something there.
[aWindow setFrame:newRect display:YES animate:YES];
}</code>

Uses CPU while running, but there is no niftier sight :-).

----

The window resizing animation effect seen, for example in System Preferences is discussed further in [[WhereIsCoolSystemPrefsWindowEffect]]

For more details see [[AutoWindowResizing]] [[UFISpringyPanel]]