

[[WebCore]] is a framework for Mac OS X that takes the cross-platform KHTML library (part of the KDE project) and combines it with an adapter library specific to [[WebCore]] called KWQ that makes it work with Mac OS X technologies. KHTML is written in C++ and KWQ is written in Objective C++, but [[WebCore]] presents an Objective C programming interface. [[WebCore]] requires the [[JavaScriptCore]] framework.

The current version of [[WebCore]] is based on the KHTML library from KDE 3.0.2. Changes that are specific to [[WebCore]] are marked with #if APPLE_CHANGES. Other changes to improve performance and web page compatibility are intended for integration into future versions of the KHTML library.

-- http://developer.apple.com/darwin/projects/webcore/

[[WebCore]] is not intended for third party application developers to write directly to. If you just want to drop HTML rendering into your Cocoa application, use [[WebKit]] - [[WebCore]] is quite low-level in comparison (the [[OmniGroup]] use it directly in [[OmniWeb]] because it gives them greater flexibility, but it took Tim quite a long time to figure it out enough to be able to use it).

----

It seems that the interesting class is [[WebCoreBridge]]. You can install it in an [[NSView]] and tell it to open a URL. Has anyone tried it using yet? --[[PeterLindberg]]

----

You can also try running class-dump on [[WebKit]].framework and [[WebFoundation]].framework inside Safari.  They include a subclass of [[NSView]] to hold HTML rendered content. --[[OwenAnderson]]

----

I don't get it: all headers in [[WebCore]].framework are private. How are you supposed to use it?  --[[PeterLindberg]]

----

If you download the source code, the headers are available.
--[[GormanChristian]]

----

You can also extract the headers from the binary framework using class-dump.  Just include the generated header and link against [[WebCore]].framework.  --[[OwenAnderson]]

----

I realized that you can import the headers even though they are in [[PrivateHeaders]], but it doesn't matter that much: [[WebCoreBridge]] is an abstract class that is subclassed in [[WebKit]], a framework private to Safari. I guess/hope that [[WebKit]] (or an equivalent) will become a public framework eventually. My take is that they released the framework more as an illustration of what they have done with KHTML. You can't use (without a lot of trial and error) the framework as it is. --[[PeterLindberg]]

----

You can use the class-dump trick on [[WebKit]].framework also, and get a complete list of the classes in there.  An industrious hacker might be able to assemble something out of it.  --[[OwenAnderson]]

----

Class dumping and relying on a private framework is not an option for me, especially since Safari is in beta. I guess the rationale of keeping [[WebKit]] private is that it should stabilize as Safari evolves into 1.0., after which it can be made public. Until then, Apple are free to make dramatic changes to the interfaces. When it is made public, users must be able to rely on the framework, so that a future version doesn't break their apps. I'm reluctant to use anything but public frameworks. --[[PeterLindberg]]

----

See [[SafariAndCocoa]] for more discussion along the same lines. ''Something'' along the lines of [[WebKit]] is coming to Cocoa, according to the ADC News e-mail (quoted on the other page).

Please elaborate on using a header generated from class-dump. I am interested to hear how that works. Do you just import the gargantuan header file it generates into a PB project and then just link against the framework? Does that give you access to all of the classes and such defined in the "header file"? --[[MarcWeil]]

----

Yes. Another option is to split it up into other header files, but that would be tedious, and PB's class browser is a nice alternative to that.

And [[WebKit]] itself is indeed going to be released. I don't know if it too will be open source, but it will eventually at least be a public framework. I posted a little about that (including David Hyatt's two-sentence reply to my inquiry about that) on the [[SafariAndCocoa]] page.

-- [[AdamAtlas]]

----

It looks like [[TheOmniGroup]] figured it out- [[OmniWeb]] 4.5 is using it, and they're already providing semi-functional sneakypeek builds. Hmmm...

-- [[AdamAtlas]]

Now that I have a job, I might buy [[OmniWeb]] just to see where they go with it now. I hold them in high esteem. -- [[RobRix]]
----
I think [[OmniGroup]] has produced a more "pumped up" version of [[WebKit]], that [[OmniWeb]] uses. It to is availble to Users. --[[JoshaChapmanDodson]]

''Where and how? ([[URLs]] appreciated.)''

Check out http://www.omnigroup.com/ftp/pub/software/Source/[[MacOSX]]/Frameworks/ and download the [[WebCore]] dmg.