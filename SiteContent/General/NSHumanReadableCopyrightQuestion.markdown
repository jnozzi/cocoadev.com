I borrowed some code that reads General/NSHumanReadableCopyright in to display it in my About Box.  How do I _set_ the value for this field - it is null now.  Thanks.


blakespot

----

Look at the General/InfoPlist.strings file in your project.  It should start out set to something like "Copyright 2004 __MyCompanyName__".  -- Bo