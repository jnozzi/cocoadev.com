


Can someone explain what the difference is between these two functions?

<code>
+ (id)stringWithCString:(const char '')cString;
+ (id)stringWithUTF8String:(const char '')bytes;
</code>

Is it just that <code>stringWithCString:</code> must end with a null character?

----

It's mainly that <code>stringWithCString:</code> is deprecated and should never be used. See [[StringWithCString]]

----

To be more specific, <code>stringWithCString:</code> uses an undefined encoding. The encoding it uses may or may not be the one you want, but at least with <code>stringWithUTF8String:</code> you get predictable results. That's why Apple deprecated <code>stringWithCString:</code>.

----

FTR, this also applies to -cString and the like. --''boredzo''

''And <code>[[[NSString]] defaultCStringEncoding]</code>. Although this will tell you what encoding the ''cString'' methods will use.''

that probably isn't too useful, though, unless you have a menu item in your application titled 'C String Encoding'. ;) --''boredzo''