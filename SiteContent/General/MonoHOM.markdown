

[[MonoHOM]] is a [[HigherOrderMessaging]] framework which doesn't use <code>-forwardInvocation:</code> or <code>-methodSignatureForSelector:</code> to bounce messages, but instead the lower-level <code>-forward::</code> and <code>-performv::</code> (specified by the [[ObjC]] runtime).

On the plus side, this means that <code>-select</code> and <code>-reject</code> Just Work�.

On the minus side, this means that iterating over the arguments (which you'd want to do to implement e.g. <code>-inject:</code>) is a bit trickier since you're dealing with a <code>marg_list</code> instead of a nice little [[NSInvocation]] instance.

Get it:

http://capefish.org/monohom/trunk/ (Subversion, and browse-via-your-web-browser-if-you're-so-inclined)

Oh yeah, I'm not sure how well this will work on OS X/Intel; I don't currently have such a machine to test on, for one. For another, messages returning floating point numbers have their own <code>objc_msgSend</code> variant on Intel, and this may interact with this code in "interesting" ways. Likewise I have not currently tested anything returning a <code>struct</code>, for example an <code>[[NSPoint]]</code> or <code>[[NSRect]]</code>, so I don't know how this will interact with the struct-returning <code>objc_msgSend</code> variant.

E-mail me ([[RobRix]]) if anything strikes you about this.

(Why "Mono" HOM? Nothing to do with the excellent mono project; it's cos my business is Monochrome Industries. I guess you could say that the framework is singular in its approach as well, but I might be pushing this a bit.)

-- [[RobRix]]

----

A funnier name would have been [[MonocrHOM]] :) -- [[EmanueleVulcano]] aka l0ne

----

Darnit! Why didn't I think of that! (: Seriously, mind if I rename it to that? (Depends on my copious free time whether I will or not, but still...) -- [[RobRix]]

----
How is it that <code>-select</code> and <code>-reject</code> Just Work? My understanding is that they fail because the compiler sees the BOOL return type and generates code in the ''caller'' that strips off the top three bytes. If that were the case then it wouldn't matter what the called code does. What am I misunderstanding? -- [[MikeAsh]]

----
I'm probably wrong, but my impression was that was not happening in compilation, but in [[NSInvocation]]/[[NSMethodSignature]]. Not using them prevents having to futz around with types, period. I'll do some more investigation, but I do trust the tests I've written, and they're (all of them) passing... -- [[RobRix]]

----
The compiler still has to generate code in the caller to read the type properly, so both sides have to work together. The [[NSInvocation]] approach could be worked around similarly by using an [[NSMethodSignature]] with a faked return type, but that still won't fix the code in the caller. It's possible that this problem has changed in later versions of gcc, as when I was first reading about/struggling with this problem it was way before gcc 4. I think gcc 3.1 would have been current at that time, or possibly even gcc 2.95. It wouldn't surprise me too greatly if gcc 4 no longer had this problem. -- [[MikeAsh]]

----

Faking out [[NSMethodSignature]] is a lot harder than it sounds (: In any case, whatever the cause, <code>forward::</code> is working quite handily. -- [[RobRix]]

----
Unfortunately, <code>-forward::</code> is never called on Leopard (Mac OS X 10.5), so this HOM implementation does not work. -- [[AlastairHoughton]]