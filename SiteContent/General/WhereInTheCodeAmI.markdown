You know how when you say <code> [[NSAssert]](NO, @"Some message"); </code> You get a pretty little dispplay of where in the code the exception was thrown?  You know, class, method, line number...  well, how can I [[NSLog]] something like that -- that's dynamically gotten out of the compiler -- and please, please don't say to handle a false assertion locally!  :)

----

The macros you want are <code>__FILE__</code> and <code>__LINE__</code>, I believe. As in:

<code>[[NSLog]](@"Blammo in %s at %s", __FILE__, __LINE__);</code>

Worth a try, anyhow.

Note: there are two (2) underscore before and after <code>FILE</code> and <code>LINE</code>

----

Dude!  That is awesome!  Thanks, a lot.  BTW, you want to say <code>[[NSLog]](@"Blammo in %s at %i", __FILE__, __LINE__);</code> -- ''__LINE__'' apparantly returns an int (decimal constant) -- surprise, surprise.  Wow!  Is this doc'd somewhere!?  Thanks again!


'''Section A 12.10 Predefined Names''' of ''The C Programming Language'' also defines

<code>__DATE__</code>, <code>__TIME__</code>, and <code>__STDC__</code>

''Good catch on the line number format. They're pretty common C preprocessor features; gcc's got documentation, and probably every other C compiler in existence does too.''