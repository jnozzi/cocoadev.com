Recent version of General/QuickSilver has a "cube" animation UI kind of like the same slick animation that's used when you first set up your Mac. How do you build something like that? Do you need to use General/OpenGL? What if I wanted to create a windowless overlay with General/OpenGL and have controls on the face of the cube is that possible?

Thanks!
Danprime

----
Look into General/CoreImage.

----
Growl (http://growl.info/) is an open-source tool for displaying bezels like the ones used in Quicksilver.  The General/BezelServices API is undocumented and potentially unstable, so if Growl meets your needs it's probably best to just use it.  Growl implements a standardized form for displaying information in its notifications, so you wouldn't be able to do the rotating cube effect without some modification.  It also allows you to make the bezels respond to a click, but you can't provide multiple controls or much else in the way of custom behavior. --General/SeanUnderwood

----
Thanks for your help! The sample code on the General/CoreImage page was really helpful.

----
Quicksilver uses Core Graphics for its cube effect. More information is available at http://dev.lipidity.com/tutorial/xcode-transitions-core-graphics-image-2