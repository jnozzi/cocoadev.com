I am writing a debugging application, and want to display numbers in an appropriate hex format (32 or 64-bits) in an General/NSTextField.

However, the General/NSNumberFormatter is missing the hex option!  

What is the best way to achieve this result?

At the moment, I have a special accessor for each value, e.g.:

-(General/NSNumber*)value
{
  return value;
}

-(General/NSString*)valueAsHex
{
  return [ General/NSString stringWithFormat:@"0x%08x", [ General/NSNumber unsignedIntValue ] ];
}

but this feels wrong, since it essentially modifies the *model* to get a UI result.

----

You are free to derive your own General/NSFormatter(s).