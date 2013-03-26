I have a question about stringValue.  What I want to do is take a username and password from an [[NSTextField]] and an [[NSSecureTextField]] in a Preferences Panel.  I want the user to enter in their credentials into the panel and allow that user to log into the system.  My problem is getting the actual strings/values the user enters in those fields for later use (i.e. logging in).  Here's the code I've messed around with so far:
<code>
- ([[IBAction]])getEmail:(id)sender;
{
       [[NSString]] ''user_id = [user_id stringValue];

      [[NSLog]]("@E-mail Address %@", user_id); // print it to a log just for my reference right now
}
</code>

The same code above would be used for the password except "pword" would be substituted for "user_id" and the method would be getPassword instead.

I'm still a bit new to Cocoa and trying to learn it all and have searched the site but couldn't find anything that directly answers the question. Thanks for the help! -Ryan

----

It is certainly not a problem that is specific to the class [[NSString]]. The problem appears to be that you want that [[StringValue]] to persist outside the above method. If that is the case, you need to learn about Cocoa's [[MemoryManagement]] system. The <code>stringValue</code> method returns an '''autoreleased object'''. To learn about just what that means, read about [[RetainingAndReleasing]]. But above all, start with [[CocoaIntroduction]], which will give you a more orderly path to your destination.

---- Actually, he also has a problem in his code, as well. If you just copied and pasted it, you need to fix the [[NSLog]] line. Where you have '''"@E-mail''' should be @"E-mail. That should fix one problem, if the [[NSLog]] itself is what's not working.

----Mmhm. Good snag. And as such, that would be handled by my recent reclamation project, [[ParseError]].

----Thanks for the help.  I'm still a little stuck but I'll keep working on it and ask if I get stuck or need more help.  The [[NSLog]] isn't the problem though, but thanks for the fix. -Ryan 

----
I don't think this line is doing what you expect:
<code>
       [[NSString]] ''user_id = [user_id stringValue];
</code>

That's creating a new local variable named <code>user_id</code> (which is initialized as a pointer to garbage), sending it the message <code>stringValue</code> (which will likely crash), and then changing the pointer to point to the return value.

Try using a different name for the local variable (like <code>userIDString</code>), or renaming your <code>user_id</code> outlet to something else (like <code>userIDField</code>).
 -[[ChrisCampbell]]