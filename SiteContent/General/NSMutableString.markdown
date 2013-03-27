See also: http://developer.apple.com/mac/library/documentation/Cocoa/Reference/Foundation/Classes/NSMutableString_Class/Reference/Reference.html

----

I'm working on a way to make General/NSMutableString Key-Value Compliant. This doesn't work:
    
- (General/NSString *)string
{
	return General/[NSString stringWithString:self];
}


And neither does this:
    
- (General/NSString *)value
{
	return General/[NSString stringWithString:self];
}

- (void)setValue:(General/NSString *)newValue
{
	[self setString:newValue];
}


Both ways end up with an infinite retain loop on General/NSCFString -- I think it's setString that's the problem...
How else am I supposed to set General/NSMutableString's string?

But I think I'm getting there. I'm trying to use an array of strings from the user defaults as a table column's data source (through the value binding on General/NSTableColumn), and I know it's probably easier to use a dictionary but I'm just that stubborn type of guy :)

I'll post the solution up here when I'm done.

- General/JediKnil

[Edit: I give up for now...if anybody knows how to do it, please tell me. I'm going to use the stupid General/NSMutableDictionary method until further notice... -General/JediKnil]

[Edit: For some reason I can't use DND without binding the content, so I have General/NSArrayController with traditional datasource methods on one side and user defaults bindings on the other...how strange! - General/JediKnil]

----

Why don't you just cast?

*I guess I could, but I didn't :) The real reason is because if I change my string, it shouldn't change everyone else's string (unless updated by the bindings). Besides, I don't think that's where the problem is...but if you find a solution, please post it up here. --General/JediKnil*

----

I'm not sure what casting Dan is referring to.. but casting in General/ObjC rarely does anything besides shut up warnings from the compiler.  It's hard to see how any cast could help.

Knil, I just checked, and General/NSMutableString already implements     setValue:  – you accidentally overrode a built-in method!  Very likely the     setString: method calls     setValue:, and there's your recursion.  Why don't you try using a jk prefix for your key.
----
Wow, I forgot about this page...anyway the final solution has been up on General/BindingTableColumnToArrayOfStrings, along with a few possible issues. If anyone thinks it should be moved here, go ahead; you're probably right but I'm wary about duplicating information. The solution is really an General/NSString category anyway. --General/JediKnil