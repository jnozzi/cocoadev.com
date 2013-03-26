Does anybody know, by any chance, how to define and implement a [[VarArg]] method in Objective-C?  Thanks!

----

Exactly the same as you do in C. For those (like me until a few moments ago) who don't know:

<code>
void varArgsCTest([[NSString]] ''a,...)
{
    [[NSString]] ''currentString;
    va_list argPtr;
    
    va_start(argPtr, a);
    currentString=a;
    
    do
    {
        [[NSLog]](@"C Test: %@",currentString);
        currentString=va_arg(argPtr,[[NSString]] '');
    } while(currentString!=nil);

    va_end(argPtr);
}

- (void)varArgsObjCTest:([[NSString]] '')a, ...
{
    [[NSString]] ''currentString;
    va_list argPtr;
    
    va_start(argPtr, a);
    currentString=a;
    
    do
    {
        [[NSLog]](@"Obj-C Test: %@",currentString);
        currentString=va_arg(argPtr,[[NSString]] '');
    } while(currentString!=nil);

    va_end(argPtr);
}
</code>

Calling these with:

<code>
varArgsCTest(@"1",@"2",@"3",@"4",nil);
    
[self varArgsObjCTest:@"1",@"2",@"3",@"4",nil];
</code>

Gives the expected output:

C Test: 1
C Test: 2
C Test: 3
C Test: 4
Obj-C Test: 1
Obj-C Test: 2
Obj-C Test: 3
Obj-C Test: 4

[[SamTaylor]]

----

A perhaps preferable model is to use a while() loop:

<code>while(temp = va_arg(argPtr, id))
{
    ...
}</code>

This has the benefit of mirroring common use of [[NSEnumerator]] fairly nicely.

-- [[RobRix]]

----

It does, but you have to treat the first item ('a' in this case) specially, as it isn't returned by va_arg.

----

True, but that's not necessarily a bad thing; [[NSLog]] would almost certainly want to, for instance. -- [[RobRix]]

----

A for loop will sort you out, too, assuming 'a' isn't NULL:

<code>
for ( currentString = a; currentString;
      currentString = va_arg(argPtr, id) )
    {
    ...
    }
</code>