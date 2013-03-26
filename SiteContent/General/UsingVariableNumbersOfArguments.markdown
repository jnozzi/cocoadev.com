

Okay, so maybe this is a total newbie question, and maybe it's even a question better placed in a site about C, but here goes anyway: how do you allow a method to use variable numbers of arguments?

I seem to recall somebody saying on one of the lists that it was just the same as in C, but since I don't know how to do it in C either, I have to ask anyhow.

Thanks,

-- [[RobRix]]

----

You might want to start your journey at 'man stdarg'. Then check the archives for both Apple's cocoa-dev list and Omni's macosx-dev list.

-- [[DaveHenderson]]

----

Thanks very much, Dave. As it happens, I had saved an e-mail containing exactly the information I was looking for, but, being me, forgot I had saved it. Here are the contents, for any interested parties:

Daniel Staudigel wrote:
>
> How do you declare and implement a method in obj-c (like [[NSArray]]'s
> arrayWithObjects:(id)firstObj, ...)?

Declare a varargs list, e.g:

va_list
  args;

call the start macro:

va_start(args, firstObj);

and then call va_arg(args, typeOfWhatYouWantToRead) to get each argument in the list.


Here's the way I did it a few weeks back:

<code>
- ([[NSString]] '') stringByAppendingStrings:([[NSString]] '') aString, ...
/''"This instance method returns an autoreleased string which
 is the result of contatenating the reciever and all of the
 arguments given in a nil-terminated list."''/
	{
	va_list strings;
		
	[[NSString]] ''thisString, ''result = [self stringByAppendingString:aString];
		
	va_start(strings, aString);
	
	while (thisString = va_arg(strings, id))
	  result = [result stringByAppendingString:thisString];
	
	va_end(strings);
	return result;
	}
</code>

I didn't deal with the pathological case of someone handing me just a nil.

You might also want to have a look at the man page for varargs.

-jcr

Thanks also to John C. Randolph who wrote the above e-mail. Anyhow, that's it.

-- [[RobRix]]

The following version is able to handle an "empty" list (i.e. one with just a nil):
<code>
- ([[NSString]] '') stringByAppendingStrings:([[NSString]] '') aString, ...
/''"This instance method returns an autoreleased string which
 is the result of contatenating the reciever and all of the
 arguments given in a nil-terminated list."''/
{
	va_list strings;
	
	[[NSMutableString]] ''result = [[[NSMutableString]] stringWithString:self];
	
	va_start(strings, aString);
	
	[[NSString]] ''thisString;
	for (thisString = aString; thisString; thisString = va_arg(strings, id))
		[result appendString:thisString];
	
	va_end(strings);
	return result;
}
</code>

See also: [[VariableLengthArgumentLists]]