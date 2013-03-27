*If security (and system stability) are not an issue at present, then build your app in Distribution style (so zero-link doesn't catch you up), log in as root (assuming you've enabled it using General/NetInfo) and run your app. **BE CAREFUL** - running anything as root can be extremely dangerous. Be sure you know precisely what you're doing - in most cases, you won't get a second chance.*


There is lots of information about this on General/CocoaDev:
http://cocoadev.com/index.pl?search=Authorization

The General/SecurityFramework page deals with the fundamentals -- where you should look for this functionality, and where to read apple's docs on it.

There is discussion regarding this at General/ExecutingCommandWithRootPriveleges and General/AuthorizationExecuteWithPrivilegesAndStdout and General/CocoaAppsWithAdminstratorPrivs, but finally: General/AuthenticatedNSStringWriteToFile has an example on how to solve it in an easy way for a situation just like yours (if I understand it correctly) General/EnglaBennny