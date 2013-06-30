

Consists of a single class, General/NSMailDelivery, which enables you to send e-mail messages using the user's default SMTP server. See also General/SendingEmail and General/SendingEmailMessages. (Note: Message Framework is deprecated as of 10.5.)


For an example of using Message.framework to access Mail.app's local mailboxes, see http://bdash.bluewire.net.nz/2003/12/20/update-message-framework-from-pyobjc/.  Note that the code provided is in Python using General/PyObjC, but should be simple to translate to Obj-C.

----

Apple has documented General/MessageFramework at [http://developer.apple.com/documentation/General/AppleApplications/Reference/General/MessageFrameworkReference/index.html]

----

I just wish that the message framework wasn't so limited. I have yet to find a decent, easy to use smtp framework for cocoa. I am actually embedding General/PyObjC in my cocoa app to get decent mail functionality, as I do not want to re-write the wheel with smtp. If anyone has any good suggestions, I would love to hear them
General/DaveGiffin

*Have you tried General/EDFrameworks? I've been using it for years with no problems.*

Not at this point I haven't. Lack of documentation a couple years ago threw me off and I really wanted something with an ease of use like Python's smtplib.SMTP class, which makes sending mail as easy as
    
s = smtplib.SMTP()
s.connect("mail.yourdomain.com")
s.login(username, password) #login if needed
s.sendmail(mailfrom, mailto, mailbody)
s.quit()


I just don't see why sending a basic e-mail, or even an html e-mail should be difficult. Adding attachments, that should take a little overhead, but text e-mails should be a breeze. 
How easy is it to handle sending e-mails requiring smtp login with General/EDMessage? And adding headers like X-Mailer and content-type ?  And is it licensed so that it can be used in commercial software or shareware?
We could always do with some more info on those packages.

Thanks for the response,
General/DaveGiffin

----

See [http://www.mulle-kybernetik.com/software/General/EDFrameworks/Documentation/General/EDMessage/Classes/General/EDMailAgent.html]. Also I remember the framework headers were pretty well commented (I'm not at a Mac right now, so can't check)

The headers are in a General/NSMutableDictionary, so you can add whatever you like.  I'm not sure about SMTP authentication; I've never had to use it.

The license is BSD, so you can use it in commercial projects.

----

Thanks for the info. Embedding General/PyObjC was a bit of a challenge and I would be happy to use an obj-c only solution.

General/DaveGiffin

----

Ok, I'm looking at General/EdMessage and it seems cool. The only problem is I don't see any login abilities. Does anyone know if you can do SMTP login with General/EdMessage? And if so, what am I missing? 

Thanks,
General/DaveGiffin

----

I just found [http://sourceforge.net/projects/opmservices/] Maybe it does what you need?

---- 

I don't know... they don't appear to have any docs or files available for me to look at.
*UPDATE: I feel like a total idiot. I am so used to sourceforge projects having the files listed in the files area I didn't think to check the CVS. I guess 4 hours of sleep the last 3 days is finally getting to me*

General/DaveGiffin

----
General/OPMessageServices has not been updated in many years, and I could not get it to even compile recently. General/EDMessage was exactly what I wanted, but it too has not been touched in around 5 years and would not build. So, I downloaded General/EDMessage, moved all the source to a new Xcode 3 project, and got it to build and run. Then, I took bits and pieces of General/OPMessageServices, which had built on General/EDMessage, and back ported those (SSL, authentication). Right now I can connect on port 587 to my .MAC account from inside a firewalled corporation, and send email with attachments from my Cocoa app.

David

----

Has anyone checked Pantomime ( http://www.collaboration-world.com/pantomime/ )?
-General/OfriWolfus

----

General/EDMessage has been updated as of 1 Nov 2008. This framework requires General/EDCommon, which is available at the same place (just google General/EDMessage). These frameworks are Leopard+ only, and build 4-way universal. 

David