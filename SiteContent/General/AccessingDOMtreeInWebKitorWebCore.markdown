I've been exploring General/WebKit and General/WebCore a bit and I was wondering if there's a way to access or traverse the DOM tree for a document loaded in a web frame?

----

You can do it with General/JavaScript (with General/WebView's -stringByEvaluatingJavaScriptFromString:), but I'm not sure that it's possible to do it in a nice way in General/ObjC-code. I messed around a bit with General/WebCore and the DOM when working on General/IconaraDOM, but from lack of documentation I grew tired of it.

--General/TheoHultberg/Iconara

----

So I guess the DOM tree viewer is internal to Safari? Too bad....

----

Looks like there's a new DOM API in 10.3.9 and Tiger. I'm just starting to look into it, but hopefully it allows you to fully read and manipulate the DOM from General/ObjC.
-General/BlakeSeely