What's wrong with this code?

<code>
[[NSString]] ''string = [[[NSString]] stringWithString:@"hello world"];
if (string = @"hello world") [[NSLog]](@"hello world");
</code>

An assignment operator is used to assign a  value to a variable (e.g. <code>[[NSString]] ''string = @"hello world"</code>).

An equality operator is used to test a condition of equality (e.g. <code>if (x == 10) [[NSLog]](@"x is equal to 10")</code>).

The line that tests a string to see if it is equal to another string has two mistakes -> <code>if (string = @"hello world")</code>

The first problem with this line is an assignment operator is being used to test for equality. The line should look like -> <code> if (string == @"hello world")</code>

The other problem is one needs to understand what object pointers are. <code>string</code> is a pointer to an object. This variable is a memory address. Equality operators can only test for the equality of the basic C types (e.g. <code>int, float,  short, char, unsigned int...</code>). Equality operators CAN test for the equality of a pointer (<code>if (string == anotherSubstring) [anObject doSomething]</code>), but what you are testing for in this conditional statement is the equality of two memory addresses not the equality of two strings. 

Try the following code:

<code>
    [[NSString]] ''string1 = @"string";
    [[NSString]] ''string2 = @"string";
    [[NSString]] ''string3 = [[[NSString]] stringWithString:@"string"];
    [[NSString]] ''string4 = [[[NSString]] stringWithString:@"string"];
    
    [[NSLog]](@"address for string1: 0x%08x address for string2: 0x%08x", string1, string2);
    [[NSLog]](@"address for string3: 0x%08x address for string4: 0x%08x", string3, string4);

    if (string1 == string2) [[NSLog]](@"string1 address equals string2 address");
    else [[NSLog]](@"string1 address does not equal string2 address");
    
    if (string3 == string4) [[NSLog]](@"string3 address equals string4 address");
    else [[NSLog]](@"string3 address does not equal string4 address");
    
    if ([string1 isEqualToString:@"string"]) [[NSLog]](@"string1 is equal to the string: \"string\"");
    if ([string2 isEqualToString:@"string"]) [[NSLog]](@"string2 is equal to the string: \"string\"");
    if ([string3 isEqualToString:@"string"]) [[NSLog]](@"string3 is equal to the string: \"string\"");
    if ([string4 isEqualToString:@"string"]) [[NSLog]](@"string4 is equal to the string: \"string\"");

</code>

The first four lines appear to be assigning the same value to the [[NSString]] pointers <code>string1, string2, string3</code> and <code>string4</code>

<code>
    [[NSString]] ''string1 = @"string";
    [[NSString]] ''string2 = @"string";
    [[NSString]] ''string3 = [[[NSString]] stringWithString:@"string"];
    [[NSString]] ''string4 = [[[NSString]] stringWithString:@"string"];
</code>

What is actually going on here is <code>string1</code> and <code>string2</code> are being assigned the value for a memory address that points to a globally shared string object for the string "string". The line 

<code>
[[NSLog]](@"address for string1: 0x%08x address for string2: 0x%08x", string1, string2); 
</code>

reveals that <code>string1</code> and <code>string2</code> are the same memory address. The output for this line is:

<code>
2003-11-28 07:59:28.596 test[830] address for string1: 0x0009a000 address for string2: 0x0009a000
</code>

<code>string3</code> and <code>string4</code> are being assigned two different instances of a string object that contains the string "string". The line 

<code>
[[NSLog]](@"address for string3: 0x%08x address for string4: 0x%08x", string3, string4);
</code>

reveals that <code>string3</code> and <code>string4</code> do not have the same memory address. The output for this line is:

<code>
2003-11-28 07:59:28.598 test[830] address for string3: 0x0030d5c0 address for string4: 0x0030d950
</code>

This is one of the easiest things to get confused with when learning Objective C. You have to understand that an object pointer is only a memory address and when you test to see if one object pointer is (<code><, >, <=, >= or ==</code>) to another object pointer, you are only testing the condition of the memory address of these object pointers. The lines 

<code>
if (string1 == string2) [[NSLog]](@"string1 address equals string2 address");
else [[NSLog]](@"string1 address does not equal string2 address");
</code>

tests to see if the address to <code>string1</code> is equal to the address of <code>string2</code>. The output for this line is:

<code>
2003-11-28 07:59:28.598 test[830] string1 address equals string2 address
</code>

This makes sense because both <code>string1</code> and <code>string2</code> point to the same globally shared string object for the string "string". The lines 

<code>
if (string3 == string4) [[NSLog]](@"string3 address equals string4 address");
else [[NSLog]](@"string3 address does not equal string4 address");
</code>

tests to see if the address to <code>string3</code> is equal to the address of <code>string4</code>. The output for this line is:

<code>
2003-11-28 07:59:28.598 test[830] string3 address does not equal string4 address
</code>

the memory address for <code>string3</code> does not equal the memory address for <code>string4</code>, so you would expect this conditional statement to be false when using the statement <code>(string3 == string4)</code>. 

If you want to test the equality of strings you have to ask one string object to see if it is equal to another string object. This is true with all Objective C objects. If you want to see if one object is eqaul to another object, there has to be a method implementation to perform this operation because all objects will not be able to test for equality with a simple <code>==</code> operator. [[NSNumbers]] are able to be tested for equality with the <code>==</code> operator, but you have to access the encapsulated values first before you can test two [[NSNumber]] objects for equality

<code>
[[NSNumber]] ''aNumberObject = [[[NSNumber]] numberWithInt:6];
[[NSNumber]] ''anotherNumberObject = [[[NSNumber]] numberWithInt:6];
if ([aNumberObject intValue] == [anotherNumberObject intValue]) [[NSLog]](@"aNumberObject is equal to anotherNumberObject");
</code>

Strings fall into the group of objects that are unable to test for equality with a simple <code>==</code> operator, so the class "[[NSString]]" has to implement a method to test for equality. This method is "isEqualToString:". [[NSString]] will check every character in one string against every character in another string before deciding if the two strings are equal. 

So, if you test all of the strings above to see if they equal the string "string", you will see that the sequence of characters of one string is equal to the sequence of characters for the string "string". Therefore the lines

<code>
if ([string1 isEqualToString:@"string"]) [[NSLog]](@"string1 is equal to the string: \"string\"");
if ([string2 isEqualToString:@"string"]) [[NSLog]](@"string2 is equal to the string: \"string\"");
if ([string3 isEqualToString:@"string"]) [[NSLog]](@"string3 is equal to the string: \"string\"");
if ([string4 isEqualToString:@"string"]) [[NSLog]](@"string4 is equal to the string: \"string\"");
</code> 

will log that <code>string1, string2, string3</code> and <code>string4</code> are all equal to the sequence of characters for the string "string". The output is:

<code>
2003-11-28 07:59:28.598 test[830] string1 is equal to the string: "string"
2003-11-28 07:59:28.599 test[830] string2 is equal to the string: "string"
2003-11-28 07:59:28.599 test[830] string3 is equal to the string: "string"
2003-11-28 07:59:28.599 test[830] string4 is equal to the string: "string"
</code>

--zootbobbalu