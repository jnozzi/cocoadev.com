Apple's documentation:
http://developer.apple.com/documentation/[[CoreFoundation]]/Reference/[[CFStringRef]]/Reference/reference.html
----

Thanks to [[TollFreeBridging]] a [[CFStringRef]] is equivalent to an [[NSString]]''

<code>
// Casting a [[CFStringRef]] to an [[NSString]] object:
[[CFStringRef]] cfString;
[[NSString]] ''nsString = ([[NSString]]'')cfString;
</code>

<code>
// Casting an [[NSString]] object pointer to a [[CFStringRef]]:
[[NSString]] ''nsString;
[[CFStringRef]] cfString = ([[CFStringRef]])nsString;
</code>

But don't forget to call [[CFRelease]] on [[CFStringRef]]'''s created using [[CoreFoundation]] methods when you're done with it! eg. [[CFStringCreate]](...)
An example is when converting [[PascalString]]'s to [[NSString]]'s, as only [[CoreFoundation]] methods exist to do so.