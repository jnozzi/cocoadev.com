Is there a framework available that can be used to call CVS commands from within Cocoa?

thanks,

General/KoenvanderDrift

----
You will need to use General/NSTask to invoke a CVS command.  Or else get the CVS source and see if you can extract the useful logic from the command.  If you can use subversion, it has an easy to use client API.
----
General/NSTask it will be then, not too difficult :)
Thanks.