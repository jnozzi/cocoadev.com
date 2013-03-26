What's IMP?  And can I use it from a method to obtain the selector of the method within which the calling code resides?

----

An IMP is an implementation. That is, it's a pointer to the actual C function implementing the method, bypassing the regular <code>[object message]</code> syntax and the whole dynamic binding thing.

If you want the selector, just use <code>@selector(message)</code>.

-- [[RobRix]]

----

If you want the selector of the method within which the calling code resides, better yet, use <code>_cmd</code>. The IMP takes at least two arguments, the first sets <code>self</code> (quite useful!!) and the second is <code>_cmd</code>, so you get them both in your method.
[[CharlesParnot]]

----

Sometimes you'll see people cache [[IMPs]] because it speeds things up. I'd be wary of this. It makes a difference when you are calling a method more than once, say calling it for all objects in an array. [[ObjectiveCee]] primarily uses selectors to select methods, so what if one element of the array uses a different IMP for the original selector? You'll use the wrong IMP. - [[MikeAmy]]