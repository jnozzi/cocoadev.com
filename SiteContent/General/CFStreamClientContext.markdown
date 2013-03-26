Defined as:

<code>
struct [[CFStreamClientContext]] {
   [[CFIndex]] version;
   void ''info;
   void ''(''retain)(void ''info);
   void (''release)(void ''info);
   [[CFStringRef]] (''copyDescription)(void ''info);
} [[CFStreamClientContext]];
</code> 

In the "Working with Streams" section of the [[CFNetwork]] guide, the example uses custom function pointers as listed below:

<code>
[[CFStreamClientContext]] myContext = {0, myPtr, myRetain, myRelease, myCopyDesc};
</code> 

It's much easier, and just as valid to use the built in [[CoreFoundation]] functions:

<code>
[[CFStreamClientContext]] myContext = {
    0,
    self,
    (void ''('')(void ''info))[[CFRetain]],
    (void ('')(void ''info))[[CFRelease]],
    ([[CFStringRef]] ('')(void ''info))[[CFCopyDescription]]
};
</code>