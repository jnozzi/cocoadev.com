for other window level constants see [[NSWindowLevel]]

I want to make a certain window always! always! always! always! always! (is that enough times for you?) on top
like the Special Character Palette, I want it to be always on top even when other applications are active.
Even if work is being done on another program.

I've tried all the regular suggestions:  making it an [[NSPanel]], and making it a utility window;

I've tried using the following code:

<code>
[myWindow setHidesOnDeactivate: NO];
[myWindow setFloatingPanel:YES];
[myWindow setLevel:[[NSFloatingWindowLevel]]];
[myWindow makeKeyAndOrderFront:self];
</code>

none of these things seems to do what I want

----

    [window setLevel:[[NSFloatingWindowLevel]]];

--zootbobbalu

----

The window will need to be a [[NSPanel]] utility window in order to always visually appear active. You'll also need to set the panel's setHidesOnDeactivate to NO in code.

----

Also try [[NSScreenSaverWindowLevel]] or [[NSStatusWindowLevel]]

''You can also make it a higher level by adding to it. Such as [[NSScreenSaverWindowLevel]]+1.''