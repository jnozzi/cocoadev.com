General/PSMTabBarControl is an easy-to-use controller for an General/NSTabView that allows your app to have Safari-like tabs. Also see General/TabBarView class. General/PSMTabBarControl is used in Adium, iTerm, M<nowiki/>acVim, Vienna, Sequel Pro.

Originally created by John Pannell [http://www.positivespinmedia.com/dev/General/PSMTabBarControl.html], Currently hosted at: http://code.google.com/p/maccode/ .
----
11 Jan 2010. I cannot compile the maccode version of General/PSMTabBarControl with Xcode 3.2.1. It used to work in older versions of Xcode + IB. Which fork is the recommended one to contribute to? -- General/SimonStrandgaard
----
24 Jan 2010. Now I have tried several times making an ibplugin out of General/PSMTabBarControl, but without luck. I have managed to make it show tabs, but alas it crashes when dragging it around, some kind of observing keypath exception happens. I'm no expert in bindings, so now I'm pondering coding my own tabbar, so I can gain some more insight how ibplugins works, then eventually try again porting General/PSMTabBarControl.
----
There are forks of the project on Github:

* http://github.com/dparnell/psmtabbar/ [2010] - this is supposed to make it work with IB 3.0 but currently I'm having problems installing it.
* http://github.com/ciaran/psmtabbarcontrol [2008] - this one adds functionality to the original implementation.
* http://github.com/splicer/psmtabbarcontrol [2010] - A fork of robertjpayne's fork of the General/PSMTabBarControl project 
* http://github.com/nanoant/General/PSMTabBarControl [2010] - Fork of General/PSMTabBarControl updated to work with latest Xcode 3.2.x and a interface builder plugin for 3.2+ 
* https://github.com/dorianj/General/PSMTabBarControl [2011] - Fork of General/PSMTabBarControl updated to work with Xcode 4.

----
30 June 2011

I've ported and updated a copy of General/PSMTabBarControl via maccode to work with Snow Leopard 10.6 and Interface Builder 3.0. I had to patch a small feature out of it due to it relying on Carbon Framework ( holding spacebar while dragging tabs skips animation ). The General/IBPlugin is rough but it works.

Overall it may have a few bugs especially related to the General/IBPlugin but it will actually work and compile on 10.6. It includes a rebuilt demo app as well.

[http://codaset.com/robertjpayne/psmtabbarcontrol/]

If you find issues log them into the Ticket tracker and I'll update the project as needed. Or you can fix it and push your patches and I'll merge them appropriately.

-Robert Payne