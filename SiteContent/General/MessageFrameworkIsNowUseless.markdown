Now that Panther has gotten rid of the "Internet" preferences pane that Message.Framework (especially General/NSMailDelivery)looked to for the server information to send emails, is Message.Framework worthless? I can't get a yes response from General/[NSMailDelivery hasDeliveryClassBeenConfigured].

--Freedom Dumlao

----

IMO, Message.framework was always useless. Look in General/ObjectLibrary for alternatives. I've had good experiences with the ED frameworks.

----

Wow!! The General/EDFrameworks are exactly what I needed! Thanks!!

--Freedom Dumlao

----

I didn't find any formal documentation on General/NSMailDelivery. I treat frameworks like those the same way I treat the frameworks in General/PrivateFrameworks or the private undocumented classes found in the blessed frameworks. Use it and you will be burned. Has Message.framework ever been documented/blessed? If not then it is hardly fair to call it useless.

I will also point out that from a quick investigation, Mail.app still uses (or at least links to) this framework.
    
% otool -L /Applications/Mail.app/Contents/General/MacOS/Mail


----

Of course Mail.app uses it, that's where General/NSMailDelivery looks for the default mail settings! It works perfectly if you can be absolutely certain that your user will be using Mail.app as their default email app. But however, if your user might be an Entorage user, then your General/NSMailDelivery based app will not work.

--Freedom Dumlao

----

The point is, why would would anyone use a virtually undocumented Apple framework that has not been officially blessed? I certainly hope this kind of code is NOT going into a commercial application!

----

For it to be a PUBLIC framework with PUBLIC HEADERS, it has to have been approved. -- General/FinlayDobbie

----

General/MessageFramework is documented at [http://developer.apple.com/documentation/General/AppleApplications/Reference/General/MessageFrameworkReference/index.html]
As of 11/02/2004