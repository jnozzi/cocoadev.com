
In my multi-document application when I press the Esc key at any time, my window disappears--data and all.  Gone forever.

Why does this happen?

How do I fix it?

Thanks everyone,

General/KentSignorini

----

I believe this means that you are using an General/NSPanel rather than an General/NSWindow for your window's class; switch it back to General/NSWindow and that behavior should disappear. -- Bo

----

Thanks, Bo.  That was it.

General/KentSignorini