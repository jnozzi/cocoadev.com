

Hi All,

I am creating textfields dynamically, much the same way General/InterfaceBuilder does. What I am trying to achieve here is an object with Inspector, with 2-way communication, one way to the inspector, the other from the inspector to my objects. 

    
2006-07-31 07:28:50.458 General/AppName[421] Registered Window with notification center
2006-07-31 07:28:54.806 General/AppName[421] Registered NEW General/TextBox with notification center
2006-07-31 07:28:56.888 General/AppName[421] Registered NEW General/TextBox with notification center
2006-07-31 07:28:59.424 General/AppName[421] Registered NEW General/TextBox with notification center
2006-07-31 07:29:04.329 General/AppName[421] Sending Notification General/TextBoxSelected
2006-07-31 07:29:04.329 General/AppName[421] Received Notification: General/NSConcreteNotification 3806b0 {name = General/TextBoxSelected; object = <General/MyTextSub: 0x397110>}
2006-07-31 07:29:07.112 General/AppName[421] Sending Notification General/TextBoxSelected
2006-07-31 07:29:07.112 General/AppName[421] Received Notification: General/NSConcreteNotification 3102b0 {name = General/TextBoxSelected; object = <General/MyTextSub: 0x392600>}
2006-07-31 07:29:09.984 General/AppName[421] Sending Notification General/TextBoxSelected
2006-07-31 07:29:09.984 General/AppName[421] Received Notification: General/NSConcreteNotification 3806b0 {name = General/TextBoxSelected; object = <General/MyTextSub: 0x37ac10>}
2006-07-31 07:29:28.530 General/AppName[421] Sending Notification General/InspectorChanged
2006-07-31 07:29:28.530 General/AppName[421] Received Notification: General/NSConcreteNotification 3102b0 {name = General/InspectorChanged; object = <General/NSTextField: 0x363260>}
2006-07-31 07:29:28.530 General/AppName[421] Received Notification: General/NSConcreteNotification 3102b0 {name = General/InspectorChanged; object = <General/NSTextField: 0x363260>}
2006-07-31 07:29:28.530 General/AppName[421] Received Notification: General/NSConcreteNotification 3102b0 {name = General/InspectorChanged; object = <General/NSTextField: 0x363260>}


From the above run log, you can see when I create the textfields using my subclass of General/NSTextField (i do this programatically, not via IB), it registers them with the notification center. I have overridden the mouse-down event in my subclass so that I send a notification to General/MyDocument class, so as above, you can see I have created 3 textboxes, and clicked on all 3 in turn to send a notification.

At the same time, you can see the notification being received by the General/MyDocument class, which updates another textfield on my inspector with the string value of my dynamically created textfields.

Now that is fine and great! However, now I want to change the value sent to the inspector, and send it back to my dynamically created textbox. So, I registered my inspector with the notification center too (see first line in log above).

The notification is sent to my subclass all fine, however when sending back the new string value, it updates all the dynamically created textfields, rather than the one I last clicked. Here's the method that gets called: 

    
- (void)changeMyBoxProperties:(General/NSNotification *)note
{
General/NSLog(@"Received Notification: %@", note);
General/NSTextField *sender = [note object];
General/NSString *textboxString = [sender stringValue];

[self setStringValue:textboxString];
}


I assume, because I am using [self setStringValue:]; I am seeing the change in all 3 subclass instances. Is there a way to change this, so that when the notification is sent, it only communicates with the last clicked textfield? 

Ideally, I need to register the last clicked textfield as the one to communicate with when the method above is called.

Any help would be great! Thanks