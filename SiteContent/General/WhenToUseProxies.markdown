Hello, all.

Just a quick question regarding [[NSProxy]]: when is it a good idea to subclass it instead of [[NSObject]]? I know all that stuff about an object standing in for another one, but what advantages does it have over [[NSObject]] for those situations? http://goo.gl/[[OeSCu]]

Thanks -- [[RobRix]]

----

Okay, one (minor) answer I've provided for myself is that [[NSProxy]] is a different root class so categories on [[NSObject]] ''do not apply to your proxy objects''. This happens to be quite vital in my current situation. But honestly, there's got to be more to it than that. Anyone? -- [[RobRix]]

----

Rob, are you familiar with interprocess communications (IPC)? One purpose of an [[NSProxy]] is to wrap message passing, synchronization and shared memory issues involved with letting an object in one thread/process communicate with an object in another thread/process. A multithreaded or distributed app is a good candidate to utilize an [[NSProxy]] (check out the [[NSConnection]] class) -- zootbobbalu

----

Yesss... but this doesn't (necessarily) involve subclassing [[NSProxy]], and it's pretty much the only documented example of [[NSProxy]] use that I can find. I've used [[NSProxy]] and [[NSDistantObject]] in [[DistributedObjects]]; right now I'm trying to figure out whether a custom class I'm working on should be a subclass of [[NSProxy]] or if I can just leave it with [[NSObject]].

So yeah, I'm familiar with IPC, and it's great that we've got this, I'm just wondering what the heck advantage it gave anybody in the first place over [[NSObject]]. Why didn't they just go with [[NSObject]] for [[DistributedObjects]]? -- [[RobRix]]

----

Probably convenience.  The reason for a proxy object is for it to be a stand-in for another object (hence the name).  I would think it'd be easier to start off with a class that does next to nothing, rather than hacking around everything that [[NSObject]] brings to the table.  The advantage of [[NSProxy]] over [[NSObject]] is that [[NSObject]] does a whole lot of stuff that can get in the way of what the proxy needs to do.

----

Okay, fair enough. But the advantage for me is...? -- [[RobRix]], who notes that his trampoline class "just works" whether its superclass is [[NSObject]] or [[NSProxy]]

----

Rob, The advantage for you is an [[NSProxy]] can tie your shoes for you ;-) 

just kidding......

Are you just trying to stir an intellectual discussion on the merits of an [[NSProxy]]? Like the post before your last post mentioned, I think an [[NSProxy]] is only intended to be a convenient way to implement a "proxy" for an object. I don't think an [[NSProxy]] is an alternative for an [[NSObject]] because I'm not sure an [[NSProxy]] can initialize an object. 

There is a great book titled Design Patterns: Elements of Reusable Object-Oriented Software by Erich Gamma, Richard Helm, Ralph Johnson and John Vlissides (the Gang of Four - GOF). This book does a nice job of explaining the value of a "proxy" design pattern (GOF Proxy). The cocoa implementation of a GOF Proxy is only one of the types of proxies GOF talks about. Scott Anguish (Stepwise) does a nice job of explaining the difference between a GOF Proxy and an [[NSProxy]] in Cocoa Programming - SAMS Publishing. Apple also talks about [[NSProxy]] in the online book titled The Objective-C Programming Language: 

http://developer.apple.com/techpubs/macosx/Cocoa/[[ObjectiveC]]/4objc_runtime_overview/index.html

GOF Patterns mirror a bunch of the Cocoa API and the book was written way after Smalltalk and [[NeXTStep]] came out, so I wonder who inspired who.

Answering your question is kind of hard because I'm not sure there is a direct answer. Is there an advantage you would like to get out of an [[NSProxy]], or are you just curious what the general advantages an [[NSProxy]] has over an [[NSObject]]? -- zootbobbalu

----

You know, after thinking about it some more I think I understand your question. I created my own "proxy" like object once and I sub-classed [[NSObject]] not [[NSProxy]], so I see why you're puzzled. In my case I was using simple POSIX services and not relying on anything specific to the Mach microkernel. I guess I have no idea why an [[NSProxy]] is a better superclass for creating "proxy" objects.

Good Question!! -- zootbobbalu

----

Yes, I am just looking for general advantages. So far the only one I've come up with is:


* Categories (et cetera) on [[NSObject]] will not affect [[NSProxy]]; this insulation means that your proxy won't be trying to perform methods you don't want it to.


Thanks, -- [[RobRix]] (Robbat)

----

[[NSProxy]] returns YES to isProxy, neh? ''grin''

I think the point of [[NSProxy]] is it has fewer methods in than [[NSObject]], so those methods can be redirected to the object being proxied without needing to override them explicitly. Things like inheritsFrom: and conformsTo:, if I have the names correct.

-- [[KritTer]]

----

Tip: you can quickly solve many problems using [[NSProxy]] simply by inserting:
<code>[[NSLog]]([[[NSString]] stringWithCString:selector]);</code> at the start of - methodSignatureForSelector:selector in your [[NSProxy]] subclass. Then you can see every message they receive.

Look for selectors that [[NSProxy]] doesn't respond to. Hope this helps. -- [[MikeAmy]]

----

Actually [[NSProxy]] works different than [[NSObject]]... so do all of it's sublasses... They automatically respond to EVERY selector possible... calling their -(void)forwardInvocation:([[NSInvocation]]'') method to handle the invocation... the default one checks if you actually respond to the selector and then calls it, but the one in [[NSDistantObject]] confers with the object it's connected with in the other process... If the object doesn't respond it throws the same kind of error you get when calling a method an [[NSObject]] subclass doesn't respond to.  I built similar functionality (but with limits) in [[FSObject]] before I knew about [[NSProxy]]... And after trying to subclass [[NSProxy]] to accomplish the same thing cleaner I have found that the methods you need to override to take advantage of this (forwardInvocation: and methodSignatureForSelector:) are more difficult to override than they first appear... I would like to hear from somebody who has had success in doing this... [[MooreSan]]