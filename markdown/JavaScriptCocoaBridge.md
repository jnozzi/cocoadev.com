

As of version 10.4 "Tiger", General/MacOS X includes a General/JavaScript Cocoa bridge which allows Dashboard Widgets to communicate with Objective-C objects.

----

The bridge is available as part of General/WebKit, but cannot be used separately from General/WebKit classes (as the General/JavaScriptCore framework that handles such things is private); you have to create a General/WebView and program things within the HTML page using the API to evaluate General/JavaScript<nowiki/>s. See the docs for the General/WebScripting protocol and Dashboard plugin creation for more info.