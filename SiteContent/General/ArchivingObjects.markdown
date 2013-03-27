When you use General/NSKeyedArchiver encodeRootObject to archive a whole graph of objects, does it figure out the graph itself by following pointers, or do you need to specify the links yourself in your encodeWithCoder method?

e.g. If I have

    
@interface General/WikiWikiWeb : General/NSObject <General/NSCoding> {
    General/NSMutableArray * firstObject;
    General/NSDictionary * secondObject;
}



in my General/WikiWikiWeb.h, do I need 

    

(void)encodeWithCoder:(General/NSCoder *)coder
{
    [coder encodeObject:firstObject forKey:@"One"];
    [coder encodeObject:secondobject forKey:"@"Two"];
}


in General/WikiWikiWeb.m so that it knows how to form the graph, or will it figure it out from the class definitions?

Thanks.

General/ArthurLewis

----

You need to implement the General/NSCoding protocol, so yes. -- General/FinlayDobbie

----

Hi, firstly, this is a *brilliant* site. I have been software mashing for nearly 20 years and lately I have discovered General/ObjC and Cocoa, it has to be the *best* thing to develop with without actually getting to use Smalltalk. Sigh!

Anyway, to the point...today I tried to pickle an General/NSInvocation through General/NSArchiver and try as I might, I couldn't make it happen. I wanted to sent a pickled invocation back to my main thread via General/NSConnection. The connection works fine, as does the program because, thanks to http://cocoa.mamasam.com/ (I found a 'dodge' (casting General/NSInvocation to unsigned and setting it as the msgid), for which I was very happy to find.

Basically,


* Can you archive an General/NSInvocation, forgetting all issues about argument lifetimes etc etc I would be passing simple types  or things guaranteed to remain alive.
*If so, how? :-)


Thanks in advance,
Sean Charles
http://www.bumpybibbers.com

----

From The Fine Manual:

*Note: General/NSInvocation conforms to the General/NSCoding protocol, but only supports coding by an General/NSPortCoder. General/NSInvocation does not support archiving.*

----

I put together a tutorial on General/NSKeyedArchiver/General/NSKeyedUnarchiver and General/NSCoding:

http://cocoadevcentral.com/articles/000084.php  -- General/ScottStevenson