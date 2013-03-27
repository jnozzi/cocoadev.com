

To understand what the General/NotificationCenter is, we first need to understand Notifications:

Notifications are messages that certain events happened or are about to happen.

For example, a window sends out a notification to the General/NotificationCenter before it closes. Other objects can register themselves as observers of this notification with the General/NotificationCenter. To do that, they'll have to tell the General/NotificationCenter that they want to get the notification when the window object sends it out and they also should implement a method dealing with that notification when it comes.

This could be used, for example, for objects deallocating themselves when a window closes or any other actions that should be performed when something happens to another object. (One can also implement own notifications.)

A Notification's function is similar to that of a General/DelegateObject - the main difference is that only one object can be the delegate for another object whereas many objects can react to a single object's notification.

More on this subject can be found here: http://www.stepwise.com/Articles/Technical/2000-03-03.01.html

Check out "Vermont Recipes" from General/CocoaTutorials for an excellent example app that includes (among many other things) sample code for dealing with notifications.

----

Notifications & Notification Centers implement the "Observer" design pattern.  

If you are familiar with General/PowerPlant, a Notification Center is like an General/LBroadcaster, except you use an instance of it rather than subclassing it.  (There is no General/LListener -- any class can observe a notification center).  

Notifications themselves don't really have a parallel in General/PowerPlant, except maybe if you imagine that the Message/Param pair passed around by General/LBroadcasters was replaced by an object.

----

I added some example code to General/NotificationSampleCode

General/TomWaters

----

*For notifications within the **same thread** use General/NSNotificationCenter
*For notifications between different **threads** use General/DistributedObjects or a third-party class such as General/InterThreadMessaging
*For notifications between different **processes** use General/NSDistributedNotificationCenter - i.e. different apps


----

a metaphor for a General/NotificationCenter is a Mailing List Server  
- registering your object in the General/NotificationCenter is like subscribing to a list on the server, 
- posting a notification to the General/NotificationCenter is like sending an email to the list.  (all the registered observers get it.)
- there can be different mailing lists on a server -  Notifications can have different names.