

Is it possible to transfer a custom class, a subclass of [[NSObject]] over an [[NSConnection]]?

Right now when I try to hand it over to the remote object, the client crashes after trying to read it (ie. via an [[NSLog]]()). I  believe it may have to do with [[NSCopying]] not being implemented? Any ideas?

----

what does your [[NSLog]]() look like? does it crash without it?

----

<code>
[[NSLog]](@"Object: %@", [remoteConnection sendMeMyObject]);
</code>

It does not crash without it. With it, the output is sent, I see an Array of the objects I want transfered over and all looks good, but next comes the crash :)

----

This array... how does it get created? You need to terminate an <code>arrayWithObjects:</code> list with a nil, for example. What happens if you just call <code>remoteConnection sendMeMyObject]</code> without trying to log it?


----

My array is fine ;-) The problem is that it contains an [[NSImage]] and [[NSConnection]] doesn't know how to get it across I think.

---- 

If you don't show any real code, no one can help you..

[[NSConnection]] works by proxying an object, not by literally copying it.

----

from my experience with Distributed Object, the usage of [[NSLog]]() on remote objects is not recommended... be sure to implement the "description" method of your class, but even with this method, i've seen many of my program crashing when using [[NSLog]] and DO... i've bannished [[NSLog]] now. Some of those programs works 24/24 since many years with very few restart :)

----

Just got done implementing something along these lines, and thought I would post for posterity... all info needed was found in Apple docs.

To send an object "across the wire" in DO, your object needs to implement the [[NSCoding]] protocol.  As an additional note (that I didn't encounter in Apple docs), the object that does the coding in DO ([[NSPortCoder]]) does not seem to support keyed coding, so be sure your encodeWithCoder: and initWithCoder methods are old school, and not keyed.

Your object needs to also implement the following method, in order to tell the [[NSPortCoder]] to package up and send your actual object contents, not just a reference to the object:
<code>

- (id)replacementObjectForPortCoder:([[NSPortCoder]] '')encoder {
    if ([encoder isByref]){
        return [[[NSDistantObject]] proxyWithLocal:self connection:[encoder connection]];
    } else {
        return self;
    }
}

</code>

Finally, make sure the appropriate method signature specifies the "bycopy" keyword.  The [[NSPortCoder]] checks this to see what to send.

HTH! - [[JohnPannell]]