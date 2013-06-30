One of the frameworks included with Mac OS X is called Message.framework, and in it are some classes that allow you to send email directly from you application (as opposed to sending it via Mail using the General/NSWorkspace technique described in General/SendingEmailMessages)

The first order of business is to add this framework to your project.  To do so select **Add Frameworks...** from the **Project** menu in Project Builder.  Message.framework is located in the directory **/System/Library/Frameworks/**.

The class in this framework that we use is called General/NSMailDelivery.  Check out the header file for this class to see what it's about.  One way to send email using this class is the method + (BOOL)deliverMessage:(General/NSString *)messageBody subject:(General/NSString *)messageSubject to:(General/NSString *)destinationAddress.  Note that this is a class method, so there is no need to first instantiate General/NSMailDelivery.  The following example of code shows how we can use this method in a simple email app.

The interface for this app consists of an General/NSTextView, in which the message body is typed, a "Subject:" text field, a "To:" text field, and a "Send" button.  The interface file might looks like the following:

    

#import <Cocoa/Cocoa.h>
#import <Message/General/NSMailDelivery.h>

@interface Controller : General/NSObject
{
    General/IBOutlet id messageBody;
    General/IBOutlet id subjectField;
    General/IBOutlet id toField;
}
- (General/IBAction)send:(id)sender;
@end



And the implementation

    
#import "Controller.h"

@implementation Controller

- (General/IBAction)send:(id)sender
{
    BOOL result;
    General/NSString *message = [messageBody string];
    General/NSString *recipient = [toField stringValue];
    General/NSString *subject = [subjectField stringValue];
    result = General/[NSMailDelivery deliverMessage:message subject:subject to:recipient];
  
    if ( result == NO ) {
        // Do something in case message doesn't send
    }
}

@end



----

I know, maybe my question is a bit off topic, but I found that this code doesn't work for me. I noticed that General/[NSMailDelivery hasDeliveryClassBeenConfigured] gives me NO. What's wrong with my system? Seems like I have to configure something...

----

You should set up a default e-mail account in System Preferences -> Internet -> Email.

-- General/FinlayDobbie

Thanks.

----

Does this require / to have it's permissions set correctly? By default, it is group writable, and sendmail complains about this (what the hell for I don't know!). 99% of new OS X users (i.e. the non-geek-people) will not have changed this, making it unreliable. Another question, how does this compare to system( "echo `some stuff` | mail me@myaddress.com" ); ?

* I'm only guessing here, but I think the answer is no. This is the framework Mail.app uses. *
----
So what does one have to do to send mails in Leopard? General/NSMailDelivery is deprecated, General/SMTPMailDelivery (which comes with General/ILCrashReporter) doesn't seem to work on Leopard, and I don't want to use the scripting bridge to use mail to send mails. Isn't there any code how to send mails?

----
General/EDMessage was just updated and works well with .MAC and gmail (SSL, authorization etc). Google it.

David