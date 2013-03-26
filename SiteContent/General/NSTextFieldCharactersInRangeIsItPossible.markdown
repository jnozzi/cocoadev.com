

Hey all, just wondering if someone knows how to take a [[NSTextField]] and take, say, the first 5 characters from the field?  I've tried a few things, but the documentation doesn't show anything about doing this.  I know how to do it in an [[NSTextView]] but I really need to use a [[TextField]] in this particular project, any suggestions?

Thanks,
 - Daniel

----

Just call -substringWithRange: on the text field's string, e.g. <code>[[myTextField stringValue] substringWithRange:[[NSMakeRange]](0,5)];</code> -- Bo

----

It's probably better to check the string length before getting a range five characters wide.

<code>
[[NSString]] ''string = [myTextField stringValue];
[string substringWithRange:[[NSMakeRange]](0, ([string length] >= 5) ? 5 : [string length])];
</code>

----

You could also just use <code>string substringToIndex:5</code>

----

My pretty version:

<code>
[[NSString]] ''theString;
[[NSString]] ''subString;

theString = [textField stringValue];
subString = [theString length] < 5 ? theString : [theString substringToIndex:5];
</code>

----

All right, I got that first problem solved, Thanks!  But now I have another problem...  I can't seem to pass a [[NSNumber]] to a method, I keep getting an error like so:

<code>
[[MyDocument]].m:50: passing arg 2 of `printLine:fromIndex:' makes pointer from integer without a cast
</code>

And here's the code I'm using:

<code>
- ([[IBAction]])parseText:(id)sender {
    [[NSString]] ''parseString, ''subString;

    parseString = [commandTextField stringValue];
    subString = [parseString length] < 6 ? parseString : [parseString substringToIndex:6];

    if (subString = @"emote ") {
        [self printLine:parseString fromIndex:6];  //This is the line that is bugging out''
        [[NSLog]](@"Emote was the command!");
    }
}

- (void)printLine:([[NSString]] '')printThis fromIndex:([[NSNumber]] '')insertPoint {
    [[NSMutableAttributedString]] ''sendString;
    [[NSString]] ''parsedString;
    
    parsedString = [printThis substringFromIndex:insertPoint];  //This line also bugs out'''
    [parsedString stringByAppendingString:myReturn];               //Problem here too'''''
    sendString = [[[[[NSMutableAttributedString]] alloc] initWithString: parsedString] autorelease];
    [sendString
        addAttribute:[[NSForegroundColorAttributeName]]
               value:[[[NSColor]] whiteColor]
               range:[[NSMakeRange]](0, [sendString length])];
    [[gameTextView textStorage] appendAttributedString: sendString];
    [gameTextView scrollRangeToVisible:[[NSMakeRange]]([[gameTextView string] length], 0)];
}
</code>

''If I change the line of code to look like [self printLine:parseString fromIndex:[[[NSNumber]] numberWithFloat:6.0]]; the code works, but then the second line(the one with the ''' by it) gets a weird malloc error and the program crashes.

'''This line is getting this error:  [[MyDocument]].m:60: passing arg 1 of `substringFromIndex:' makes integer from pointer without a cast.   I'm confused.  I've looked at a few other example files and my code looks as though it should work, but it just isn't.

'''''The problem with this one is, I have a static set for myReturn and it's set to "\r" but for some reason no matter how I add it into the line of text the carriage return is not done.  Everything that is entered is on one continous line.  This is very frustrating.  Sorry about all the questions.

Any help would be greatly appreciated,
 - Daniel

----

An assignment operator is used to assign a  value to a variable (e.g. <code>[[NSString]] ''string = @"hello world"</code>).

An equality operator is used to test a condition of equality (e.g. <code>if (x == 10) [[NSLog]](@"x is equal to 10")</code>)

The line where you test a string to see if it is equal to another string has two mistakes -> <code>if (subString = @"emote ")</code>

The first problem with this line is you are using an assignment operator to test for equality. The line should look like -> <code> if (subString == @"emote ")</code>

The other problem is you have to understand what object pointers are. "subString" is a pointer to an object. This variable is a memory address. Equality operators can only test for the equality of the basic C types (e.g. <code>int, float,  short, char, unsigned int...</code>). Equality operators CAN test for the equality of a pointer (<code>if (subString == anotherSubstring) [self doSomething]</code>), but what you are testing for in this conditional statement is the equality of two memory addresses not the equality of two strings. 

I posted some sample code that should help clear this up ([[NSStringAssignmentsAndEquality]])

The other problem with your code is you seem to be confused with what objects are and what simple C types are. An [[NSNumber]] is an object. The value "6" is a C type. The line that bugs out is passing the value "6" to a method implementation that expects to receive an [[NSNumber]] object. Hopefully you read [[NSStringAssignmentsAndEquality]] and now understand what an object pointer is. When you pass the value 6 with the method call <code>printLine:fromIndex:</code>, you are actually trying to pass an address value of 6 not a numerical value of 6. The line <code>[self printLine:parseString fromIndex:6];</code> is bugging out becuase the compiler expects to see an argument of type ([[NSNumber]]), not a number of undefined type. 

To correct this problem you have to change the method implementation for <code>printLine:fromIndex:</code> to

<code>
- (void)printLine:([[NSString]] '')printThis fromIndex:(int)insertPoint {
    [[NSMutableAttributedString]] ''sendString;
    [[NSString]] ''parsedString;
    
    parsedString = [printThis substringFromIndex:insertPoint];  //This line also bugs out'''
    [parsedString stringByAppendingString:myReturn];               //Problem here too'''''
    sendString = [[[[[NSMutableAttributedString]] alloc] initWithString: parsedString] autorelease];
    [sendString
        addAttribute:[[NSForegroundColorAttributeName]]
               value:[[[NSColor]] whiteColor]
               range:[[NSMakeRange]](0, [sendString length])];
    [[gameTextView textStorage] appendAttributedString: sendString];
    [gameTextView scrollRangeToVisible:[[NSMakeRange]]([[gameTextView string] length], 0)];
}
</code>

----

Thanks for the advice!  That does make more sense.  Thanks for taking the time to type that up.  I'm sure I'm not the only one who will get some valuable knowledge from it.

Also, does anyone know how to add a carriage return to the end of a line?  I tried to do it by appending a string containing "\r" to the end of another string, but it didn't work.  I'm lost on this one.

Cheers,
 - Daniel

----

no prob, You might want to stick with "\n" instead of "\r". --zootbobbalu

----

Ok, I got it working.  Doesn't matter if I use '\n' or '\r', I changed the code around and appended the '\r' to the end of the string before I even sent it to the printLine method.  It all works now.  Thanks for all the help!  I'll be sure to ask more questions, see if I can puzzle you all.  ''grins''

Cheers,
 - Daniel