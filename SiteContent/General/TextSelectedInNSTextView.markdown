How do you get the text selected in an [[NSTextView]], and put it into an [[NSString]]?

----

If you look at the documentation for [[NSTextView]], you will find:

- ([[NSRange]])selectedRange

which returns the range of the selected text. Drilling up to the first superclass, [[NSText]], you will find:

- ([[NSString]] '')string

which returns the text as an [[NSString]]. Looking at the documentation for [[NSString]], you will find:

- ([[NSString]] '')substringWithRange:([[NSRange]])aRange

which returns a string from a substring of text. Putting it all together yields:

[[NSString]] ''substring = [[textView string] substringWithRange:[textView selectedRange]];

- [[MikeTrent]]

----

Right after posting this discussion, I tried doing it just like that, but the substring always has a length of 0.

----

Perhaps nothing is selected.

----

I have had thousands of characters selected at once, and still nothing.

----

Works fine for me.  Maybe your textView pointer isn't pointing to what you think it is?  -- Bo

----

Newbie development task - this is an ideal candidate for a category: make a category on [[NSString]] with a method -([[NSString]] '')selectedText which does the above. - John

----

Hmmm ... replacing one line of code with a one-line category kinda sounds like code-bloat to me . See also [[CategoriesAreBad]], [[CategoriesAreGood]]. 

As for the problem described above, break in the debugger and query the variables by hand. Does everything match your expectations? I.e., is textView non-nil? Is textView a text view, or is it something else? Do other method calls work? etc. etc.

-- [[MikeTrent]]

----

Well, if the category stays at one line, I agree, but I was thinking in the context of eventually populating the category with other 'left out' methods that make life easier. - John

----

Original Poster

I spent hours in the debugger, all the other methods work, only the one block of code that I need doesn't work.

----

Doesn't work "how"?

----

The length of the string is still 0, there is no text in the string.

----

Make a test project containing the bare minimum necessary for this to work (a window, a controller object and a [[NSTextView]] in this case) Add a button to the window that executes the above code and [[NSLogs]] the resulting string. This should help you figure out what's going wrong.