

[[TollFreeBridging]] is what allows you to take [[CoreFoundation]] types and typecast them to Cocoa types (and vice versa).

So, if you have to call a [[CoreFoundation]] function that takes a [[CFString]], but you have an [[NSString]], you can just pass it your [[NSString]] with:

<code>
[[CFStringRef]] myCFString = ([[CFStringRef]])someNSString;
</code>

And if you need to get an [[NSString]] from a [[CFString]], you can do this:

<code>
[[NSString]]'' myNSString = ([[NSString]]'')someCFString;
</code>

see also: [[HowToCreateTollFreeBridgedClass]]

See which classes are [[TollFreeBridged]].