

Ok, so I'm struggling with this one. It seems that there's a built in action in [[WebView]]... I've dragged the [[WebView]] control to the main window... instantiated an instance of a controller class based on [[NSObject]]. I am loading pages and all works great... but I want to add menu items to increase and decrease text sizes. So I added an Action to my controller, connected it with the menu item but [webView makeTextLarger]; gives me one of those "selector not recognized" errors. Checking the documentation, it states that it provides an action and it's not a function per say... 

But how do I access one of those built in actions from my controller class? If I try connecting my menu item with the [[WebView]] item in IB it only shows the methods for the controller.. not the built in actions...

Any suggestions? 

----
Add the actions to the [[FirstResponder]] "class" in your [[MainMenu]].nib, then connect your menu items to that. At runtime, when the [[WebView]] has focus, your items will [[JustWork]].

----
Seems my first responder is my controller class... Do I just delete my defined methods? I guess I have totally screwed something up.

----
In [[MainMenu]].nib, you will see an object called "First Responder". Double-click it. This will select the [[FirstResponder]] "class". ("Class" is in scare quotes because there isn't actually a class called [[FirstResponder]], it's just a placeholder.) Add your actions to that. Then connect your menu items to this First Responder object.

----
Awesome. Thanks so much for taking the time to help. It makes more sense now too. I'm going to have to do some reading on that so that I really grasp how it works. 

----
Follow the links to [[FirstResponder]] and [[ResponderChain]] to see what's going on here, and poke at the relevant sections of the docs on those subjects.