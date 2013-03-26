Hi there !

I have set up an [[NSTextView]] so that it doesn't wrap long lines by passing [[NSTextView]]'s setMaxSize: and [[NSTextContainer]]'s setContainerSize: a very large size (FLT_MAX). Which is the method I've seen in numerous examples around.

It's working, but I have a weird problem.

While the view doesn't wrap lines unless I type a carriage return (which is the behavior I'm expecting), it still wraps the line if I insert some tabs successively.

The text view shouldn't wrap lines at all, unless the user types a carriage return (or the enter key).

To reproduce this, simply subclass [[NSTextView]] and insert this code somewhere :

<code>[self setMaxSize:[[NSMakeSize]]( FLT_MAX , FLT_MAX )] ;
		
[[self textContainer] setContainerSize:[[NSMakeSize]]( FLT_MAX, FLT_MAX )] ;
</code>

Type some text, it shouldn't wrap. But if you insert tabs at the beginning of the line, it will wrap.

I'm probably missing something.

Any ideas ?

----

Getting a [[NSTextView]] to not wrap can be tricky. Are you telling the  text container to not track it's text views width?

[http://developer.apple.com/documentation/Cocoa/Conceptual/[[TextUILayer]]/Tasks/[[TextInScrollView]].html]