

CEO, General/TriLateral Systems - http://www.trilateralsystems.com
Creator, General/MacBetaGroup.com - http://www.macbetagroup.com

----

**Recent Information**

*Successfully created the first true external plugin architecture for an General/AppleScript Studio application.


As far as I am aware, General/SynaptikDesk, the application alluded to above, is the only General/AppleScript Studio application that utilizes a true external plugin architecture (read: plugins are not located within the application bundle).  I have heard of at least one called General/MailMerge that does have a plugin architecture, but the plugins are located within the application bundle.  Typically this style of architecture is used for dynamic code loading by the app's developer.  Obviously dynamic loading is nothing new and Cocoa is an excellent example of this method.  However, and correct me if I'm wrong, no other General/AppleScript Studio application exists that has the ability to load interface files (.nib files) and code files (.scpt files) from an external plugin.  Plugins that can be created by any General/AppleScript Studio developer by converting an "almost" standard General/AppleScript Studio application into a .synaptik bundle by utilizing the included Synaptik Creator (which was also developed as an General/AppleScript Studio app).  Just for information, it's undergoing internal testing now and will be available as a public beta in June on the General/MacBetaGroup.com website.  Another aspect of General/SynaptikDesk that sets it apart from other General/AppleScript Studio applications is its ability to allow .synaptik plugins to utilize non-standard (e.g. Borderless) windows.