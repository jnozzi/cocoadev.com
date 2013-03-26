Open <Foundation/[[NSCompatibility]].h>

This is probably totally trivial, but what were the declarations that used to be there?? And why hasn't it been removed??? <eerie music sounding like it is from an old horror movie echoes throughout the room> It is just so mysterious..... :-)

----

Currently (probably Dec 2002 dev tools) it contains this:

<code>
#warning This header file is obsolete.
#warning We do not know what you were trying to get from this header, but the declarations
#warning are gone, and that was probably not the right way to go about things anyway.
#warning This header will be removed completely December 1, 2002.
</code>

----

In 10.1 it contained a 1994-2001 copyright, and an import of [[NSCoder]].h.

<code>
#import <Foundation/[[NSCoder]].h>
</code>

----

In 10.0 it contained a 1994-2000 copyright, an import of [[NSCoder]].h, and an extra comment.

<code>
Obsolete header file
</code>

----

I don't have any pre-10.0 machines around to test with. It probably dates back to [[NeXTStep]] or at least DP1. Whatever it is, it had something or other to do with [[NSCoder]] ... maybe it's so old that nobody at Apple can remember the reason it exists, or what harmful effects removing it might cause, so they wanted to give you a fair warning before ditching it. :-)