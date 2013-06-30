

Mac OS X since 10.0 has had a Cocoa framework class called General/NSCondition. You can access it using the following definition.

    @interface General/NSCondition : General/NSObject <General/NSLocking> {
    @private
    void* _priv;
}
- (void) wait;
- (BOOL) waitUntilDate:(General/NSDate*)limit;
- (void) signal; // wakes one waiting thread
- (void) broadcast; // wake all waiting threads
@end

----
What is it and where is it defined? Never heard of it, never found it... Sounds interesting, can you give us some more info on it?

-marcocoa

----
It appears to be a Cocoa interface to pthread condition variables. As far as where it's defined, it's a private class that you should avoid using if at all possible.

----
As of Mac OS X 10.5, General/NSCondition is a public class, so it need not be avoided. (And since it has actually always existed, it may be used in projects targeting earlier OS versions.)