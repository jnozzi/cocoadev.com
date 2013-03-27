I'm trying to do a simple task, but being overwhelmed by the size of the General/NSText class, I can't find what I'm looking for.

I want to put a specific piece of text in a General/NSTextView. That text comes from a General/NSMutableAttributedString. I will eventually need to do the opposite : put the General/NSTextView's content into a General/NSMutableAttributedString. Anyone know how to do that simply ?

-- Trax

----

Sure. 
    
 [textView setString:string];

--General/CharlieMiller


----

Also, the text storage for the General/NSTextView ( retrieved with <code>[textView textStorage]</code>) is a subclass of General/NSMutableAttributedString, so you can just read that instead of creating a new string when you want to examine the General/NSTextView's contents. Or you can copy it with <code>General/[[NSMutableAttributedString alloc] initWithAttributedString:[textView textStorage]]</code>. -- Bo
----
Well, [textView setString:string]; works, but only with General/NSString objects. I want to do such a thing with an General/NSAttributedString.

-- Trax

----

The idea is that you already have an General/NSMutableAttributedString that's holding the text view's contents in the form of its text storage; since you can do anything with an General/NSTextStorage that you could with an General/NSMutableString, there shouldn't be much of a need to copy in or out.  However, for when you must, the text storage's -setAttributedString: method lets you copy in an external General/NSAttributedString and its -mutableCopy method copies out.  -- Bo