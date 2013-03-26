

If I create a class such as
<code>
@interface [[ExampleClass]] : [[NSObject]]
{
    [[IBOutlet]] [[NSTextField]]'' name;
}

// methods...
@end
</code>
without any accessor methods, can [[InterfaceBuilder]] still set the outlet?  If so, how?

----
Yes, and look through the nifty [[ObjC]] runtime API in <code>/usr/include/objc</code> for how.