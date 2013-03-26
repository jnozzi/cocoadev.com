I'm working on a commercial application (utility) for graphics/web designers. Up to now, I've normally written apps using Java but I expect this new utility to do best in the OS X world. It doesn't make much sense (to me, at least) to develop in Java for something that isn't intended to run on other platforms, so I want to give this a shot using Obj-C. 

Aside from all of the typical "learning curve" issues, I've run into a more fundamental one, namely that I'd like to make use of some 10.3 features (meaning the app would require 10.3+) but don't know what that means in terms of potential users. Put another way, if I develop for 10.2+ then the app will work for all Jaguar and Panther users but won't be quite as good (or easy to develop/maintain) as if I target 10.3 instead. I haven't been able to tell how many Jaguar users there still are (Apple doesn't appear to like sharing figures like this) so I really can't tell how big a difference (in number of potential users) choosing 10.3+ instead of 10.2+ makes.

I don't imagine I'm the first to wonder about this so I'm hoping others might be able to shed some light on how to go about making a choice like this.

-Paul
----

I have a few free apps that I expect are downloaded mostly by power users, and even among that base there are still a lot of 10.2 users.  If I were writing something commercial I'd definitely be a worried about making it 10.3+.  But I don't really know the answers to your questions either.

What features of 10.3 are attractive to you?  Bindings, for example, seem to me to be a sweetness that one can do without if necessary.  You can also use bindings in prototyping, then once things are fairly set go ahead and write the old style glue code in the controller.  Similarly, you can use key-value observing in prototyping, then switch to hand-coded notifications as your interfaces stabilize.  I do this, and I haven't had a problem expunging 10.3-only code.

Some other 10.3 features you may be able to use as 'added-value' for your 10.3 customers.  This is an artificial example, but if you wanted to use <code>[[NSAlert]]</code> for something you could say:

<code>
Class Alert = [[NSClassFromString]](@"[[NSAlert]]");

if (Alert != nil)
{
   id obj = [[Alert alloc] init]; // etc.
}
</code>

That's probably a bad example because an alert panel is probably integral to your program, you can't just leave it out for 10.2 customers.  But it's a 10.3 only class that I can think of off the top of my head. :-)

''[[NSShadow]] is the canonical 10.3-only class foruse with [[NSClassFromString]]() examples.''

----

Bindings would certainly make the development/maintenance process easier. One GUI feature I really wanted to use is the ability to display tooltips when the window is inactive. There are also some controls (and/or controls sizes) that would be nice to use. I don't think there's anything I get with 10.3 that is going to "make" my app or any changes I'd have to make for 10.2 that will "break" it. Still, not knowing how many 10.2 vs. 10.3 users there are makes the decision feel a little like guess work. It would be nice if it could be more of an informed business decision.

Thanks for taking the time to respond.

-Paul
----
I just noticed that [[BBEdit]]'s newest release requires 10.3.5+ so apparently ''they'' at least think the 10.3 market is large enough ...

-Paul
----

[[OmniGroup]] has posted the anonymous data gathered from their software update mechanism at  [http://update.omnigroup.com/]. Panther 92.5% over Jaguar.

----

I want the [[OmniGroup]] to have my omni baby.  It's of course worth remembering that people who use pay money for browsers are probably not typical users.  Still, 92.5%?  mmmm.

''The stats are for all their products, not just [[OmniWeb]]. [[OmniGraffle]] is pretty popular too. And it's worth noting that both [[OmniGraffle]] and [[OmniOutliner]] were (are?) bundled with new Macs.''

----

The # of [[CPUs]] statistics are interesting... I would've thought more people had 2, given that most of Apple's desktops for the past 2-3 years have had dual [[CPUs]]. I guess they really do sell a lot of [[PowerBooks]]. Well, iMacs too, I guess...

----
'''First things first:'''

Thanks for the [[OmniGroup]] link, whoever you are. Much appreciated!

Regarding [[OmniGraffle]] and [[OmniOutliner]] being bundled with new Macs: they still are (at least new iMacs).

Omni babies... Every parent's dream: well behaved babies with functional interfaces.

'''And then:'''

Have to say that those are some surprising (and puzzling) statistics. At first thought, it would seem to indicate that there was a mass exodus of sorts from Jaguar to Panther. More likely, perhaps, is that most of their data is coming from folks registering versions that were bundled with their new Mac (as they would all, or mostly, have Panther installed -- hasn't the bundling of their products only been going on since Panther was released?). 

Wish I could say that all this new info has made the choice completely obvious. It's certainly put two big plus signs in the "Develop for 10.3" column, though.

-Paul
----

Graffle & Outliner were bundled since 10.2. The data is from their software update check, which happens whether or not the app is registered. So anyone that even launched the apps is included. I don't know how far back it goes though.

Personally, I wouldn't worry too much about being 10.3-only. Bear in mind that if you're starting this project '''now''', by the time it's ready for release, you may be trying to decide between Tiger or Leopard.