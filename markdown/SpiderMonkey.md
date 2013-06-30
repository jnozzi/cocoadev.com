The General/JavaScript implementation used in Mozilla is called General/SpiderMonkey. It is also available as a seperate library and can be embedded in own applications:
  http://www.mozilla.org/js/spidermonkey/

General/OpenGroupware.org/SOPE includes General/NGJavaScript which is a General/SpiderMonkey/Objective-C bridge:
  http://www.opengroupware.org/cvsweb/cvsweb.cgi/General/OpenGroupware.org/SOPE/skyrix-sope/General/NGJavaScript/
  
----

Anyone know how this compares with e.g. General/JavaScriptCore?

----

 The General/JavaScript implementation used in Mozilla is (far ?) better than the General/JavaScriptCore. In my last application I have to used Webkit and his General/JavaScript implementation and on some complex pages with lot of General/JavaScript the General/JavaScriptCore crashes whereas Mozilla just run fine.

----

General/SpiderMonkey is the General/JavaScript reference implementation.

----

I want to embed the Mozilla General/JavaScript Engine in my application so that i can use it (JS Engine) as a plugin system...
has anybody done this before ???

----

Which one? Rhino or General/SpiderMonkey?  Rhino is easy to integrate into a Cocoa/Java application (as the interpreter is in Java)... I have no experience with General/SpiderMonkey (the C/C++ implementation), but if you are just arbitrarily picking a General/JavaScript engine, have you considered General/WebKit's support?

----

I intended to embed General/SpiderMonkey. but what are the advatages of Rhino in in there relation to Cocoa????  - General/SimonAndreasMenke

----

I've embedded JS General/SpiderMonkey in my app using : http://www.opengroupware.org/cvsweb/cvsweb.cgi/General/OpenGroupware.org/SOPE/skyrix-sope/General/NGJavaScript/

really cool stuff...

see also topics like General/WebKit and General/JavaScriptCore