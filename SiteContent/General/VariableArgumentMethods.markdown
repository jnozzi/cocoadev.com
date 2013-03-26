[[VariableArgumentMethods]] are methods that take a variable number of arguments, such as [[NSString]] stringWithFormat:.

stringWithFormat: accepts a formating argument, and then a number of arguments after that.

<code>
[[[NSString]] stringWithFormat: @"class is %@ and selector is %s", [[NSObject]], @selector(init)];
</code>

this will return the [[NSString]]: @"class is [[NSObject]] and selector is init"

but how is this method written?.. Apple's documentation doesn't tell you much about writting methods such as stringWithFormat:.

As an example of how to do it.. we'll write a function that appends a variable number of strings, here it is:

<code>
+([[NSString]] '')appendStrings:([[NSString]] '')first, ... {
    [[NSMutableString]] '' toReturn = [[[NSMutableString]] new];
    [[NSString]] '' nextString = first;
    va_list ap;
    va_start(ap,first);
    while([nextString hasSuffix: @"&"]){
	[toReturn appendString: [nextString substringToIndex: [nextString length] - 1]];
	nextString = va_arg(ap,id);
    }
    [toReturn appendString: nextString];
    va_end(ap);
    return toReturn;
}
</code>

This method expects all it's arguments to be [[NSStrings]].  Each argument should have a suffix of <code>@"&"</code> if there is another argument.

so the proper way to call it is something like:
<code>
[[[MyClass]] appendStrings: @"one &", @"two &", @"three &", @"four"];
</code>
this will return @"one two three four"

note that:
<code>
[[[MyClass]] appendStrings: @"one &", @"two &", @"three &", @"four ", @"five "];
</code>
will return the same thing, because the method will not know about the fifth argument

also:
<code>
[[[MyClass]] appendStrings: @"one &", @"two &", @"three &", @"four &"];
</code>
will crash at runtime, as the method looks for another argument after <code>@"four &"</code> and does not find one.


so... using variable argument methods means that you need to establish a convention about how they should be called.  Alternately, we could have written appendStrings: like this

<code>
+([[NSString]] '')appendStrings:(int)count, ... {
    [[NSMutableString]] '' toReturn = [[[NSMutableString]] new];
    [[NSString]] '' nextString;
    va_list ap;
    va_start(ap,count);
    while(count > 0){
	nextString = va_arg(ap,id);
	[toReturn appendString: nextString];
	count--;
    }
    va_end(ap);
    return toReturn;
}
</code>

for that method, we would establish the convention of passing an int describing the number of strings to append, followed by all the strings.
like this:
<code>
[[[MyClass]] appendStrings: 4, @"one ", @"two ", @"three ", @"four "];
</code>

We could even split up the arguments like this:
<code>
+([[NSString]] '')appendNumber:(int)count ofStrings:([[NSString]] '')first, ... {
    [[NSMutableString]] '' toReturn = [[[NSMutableString]] new];
    [[NSString]] '' nextString = first;
    va_list ap;
    va_start(ap,first);
    while(count > 0){
	[toReturn appendString: nextString];
	nextString = va_arg(ap,id);
	count--;
    }
    [toReturn appendString: nextString];
    va_end(ap);
    return toReturn;
}
</code>

and the convention would be like this:
<code>
[[[MyClass]] appendNumber: 4 ofStrings: @"one ", @"two ", @"three ", @"four"];
</code>



'''What are people's thoughts on the conventions for passing a variable number of arguments to a method?'''

Which of the two shown do you think is a better convention?  And... what other interesting conventions can you think of for this situation?  It is important to come up with a good memorable convention, because if you call it wrong you'll probably crash.

----

Both conventions stink.  Use the existing C/Cocoa Conventions: either have a format argument that defines what's coming later (think printf or [[NSString]]'s stringWithFormat:), or use a nil sentinel to indicate the end of a list of strings (like [[NSArray]]'s arrayWithObjects:".  No need to count items (hard to maintain, and a pain if you have more than a handful of items) or have some hack that you have to attach to your strings (if you decide to rearrange them).

----

I prefer the nil termination.  If that looks ugly you can have something like,

#define THE_ARGS(x) x, nil

then it might be a little more pleasing to the eye to see [[[NSArray]] arrayWithObjects: THE_ARGS(obj1,obj2,obj3)];

-[[FranciscoTolmasky]]
----
<code>
@interface [[NSMutableString]] ([[MYAdditions]])

- (void)appendStrings:([[NSString]] '')aString, ...;

@end

@implementation [[NSMutableString]] ([[MYAdditions]])

- (void)appendStrings:([[NSString]] '')aString, ...
{
	va_list ap;
	va_start(ap, aString);
	
	[[NSString]] ''str;
	
	[self appendString:aString];
	
	while (str = va_arg(ap, id))
		[self appendString:str];
	
	va_end(ap);
}

@end
.
.
.
	[[NSMutableString]] ''str = [[[NSMutableString]] string];
	if (nil != str) {
		[str appendStrings:@"How ", @"Now ", @"Brown ", @"Cow.", nil];
		[[NSLog]](str);
	}
</code>

However, the above does not support [str appendStrings:nil]. I recommend the following instead, which is simpler and supports [str appendStrings:nil]:

<code>
- (void)appendStrings:([[NSString]] '')aString, ...
{
	va_list ap;
	va_start(ap, aString);
	
	[[NSString]] ''str;
	
	for (str = aString; str; str = va_arg(ap, id))
		[self appendString:str];
	
	va_end(ap);
}
</code>

----

This is great and very useful, but what if you want to pass the argument list to another function?  For example it would be really convenient to write a function like:

<code>

- (void) doAlert:([[NSString]] '') msg withInfoFormat:([[NSString]] '') infoFormat,...
{
  //get the info string by calling stringWithFormat with argument list...
  [[NSString]] ''info = [[[NSString]] stringWithFormat:<THE ARGUMENT LIST>];

  ...
}

</code>

How would one refer to the argument list without iterating over it?  Or is that just not possible?


----

It's possible, but you have to use the [[NSString]] method specifically designed for it:

<code>
- (id)initWithFormat:([[NSString]] '')format arguments:(va_list)argList
</code>

----

here is an example that worked for me:

<code>
- (void) postFormattedErrorMessage:([[NSString]] '') format,...
{
  va_list args;
  va_start(args,format);

  [[NSString]] ''msg = [[[[NSString]] alloc] initWithFormat:format arguments:args];
  [self postErrorMessage:msg];
  
  va_end(args);
  [msg release];
}
</code>


----

gcc also supports variadic arguments in macros. For example, you can do this:

<code>
#define myMacro(a, b, ...) [ self myMethodWithA:a andVariableArgs:b, __VA_ARGS__ ]
</code>

--[[TimHart]]


To build on what Tim said, it also supports:

<code>
#define myMacro(a, b, ...) [ self myMethodWithA:a andVariableArgs:b, ## __VA_ARGS__ ]
</code>

If no variables are specified after b, then ## removes the trailing ',' from b and __VA_ARGS__ doesn't generate anything.

--[[BobWhite]]