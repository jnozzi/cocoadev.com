The description for General/NSApplications finishLaunching says:

*Activates the receiver, opens any files specified by the General/NSOpen user default [...]*

I have tried both storing a string and an array of strings in my user defaults (with the name General/NSOpen), but neither works. Does anyone know how to use this feature?

*hmm... it seems that it isn't really using that default -- if I launch my app with "-General/NSOpen �someFile�", then General/NSOpen will take the string value of �someFile�, and General/NSApp will correctly open it, but if I set that same string value in my user defaults, General/NSApp will **not** open it.*

**General/NSUserDefaults works with command-line arguments, environment variables, and the persistent defaults database. The system apparently doesn't search the persistent defaults database (~/Library/Preferences/reverse.domain.identifier.product.plist) for the General/NSOpen key, just the argument and environment databases. It's a feature, not a bug.**

*Well, it seems to do more than that, cause if one provide several -General/NSOpen arguments, only one will be in the defaults, but General/NSApp will open all the files.*

**Have you checked if the defaults system automatically coalesces multiple arguments with the same key into e.g. an array? I'm not sure either way but it'd be interesting.**

*Yes, the first argument is in the defaults (as a string) -- the General/GNUStep implementation of finishLaunching also only check for a string. I don't know how one would normally acces launch parameters?!?*

**The docs for General/NSUserDefaults (specifically, +sharedUserDefaults) note that the first domain that is searched is     General/NSArgumentDomain, "consisting of defaults parsed from the application's arguments".**