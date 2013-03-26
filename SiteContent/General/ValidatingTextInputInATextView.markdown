One more question.  I have an [[NSTextView]] on-screen for which I am looking to have the user enter a string that looks like any of these examples:

1d8+1
5d12+7
99d4+123
1d10
d100+5

Basically it has to fit the format of 1-3 digits (with value > 1), the letter "d" in lowercase, 1-3 digits which must be numbers from the set: 3, 4, 6, 8, 10, 12, 20, 100, the symbol "+", 0-3 digits.

Is it possible to build some kind of formatter for this?  And include validation as the string is entered by the user?

I've read all the formatter info I could find and it appears that only numbers and dates can be formatted.  I could use a number formatter (probably) if it were predictable how many digits were going to be entered in each of the three number areas, but as you can see it is not predictable (they could enter single digits, no digits, or up to 3 digits, etc.)

Any thoughts?

Thanks so much.  You are all so very helpful.

[[KentSignorini]]
----
You can create your own subclass on [[NSFormatter]] and assign it to an [[NSTextField]] at runtime (but not to an [[NSTextView]] - the [[NSFormatter]] must be assigned to a subclass of [[NSControl]] or [[NSCell]]). 

Your subclass must implement %%BEGINCODESTYLE%%� stringForObjectValue:%%ENDCODESTYLE%% and/or %%BEGINCODESTYLE%%� getObjectValue:forString:errorDescription:%%ENDCODESTYLE%%, the former to create a string with correct formatting from your object, the latter to create an object based on the user's input string. I've implemented a one-sided sexagesimal formatter (converted an [[NSNumber]] for output using %%BEGINCODESTYLE%%� stringForObjectValue:%%ENDCODESTYLE%%).

With more work you can also make the formatter check and correct as the user types, but that seems a little low-payback to me. :-)

For details see chapter 21 of Aaron Hillegass's really great ''Cocoa Programming for Mac OS X''.

-Ralph Henderson

----

Any chance you could post an example of how you used it?  I don't have the book you mentioned.

Thanks again,

[[KentSignorini]]

----

There is a simple example of an [[NSFormatter]] subclass here:  http://www.lumacode.com/simon/developer.html