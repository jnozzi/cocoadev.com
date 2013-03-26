

OK. Here we go. All I need to do is take several floats in an array - let's call it myArray [6] - and concatenate them into a single string, separated by a delimiter. This will be sent out to a text field (called myTextField). I'd like to do something like
<code>
[myTextField setStringValue:(@"%d, %d, %d, %d, %d, %d",
    myArray [5], myArray [4], myArray [3],
    myArray [2], myArray [1], myArray [0])];
</code>
but I think I need some kind typecasting.

If someone would be so kind as to advice this poor n00b (me), I'd appreciate it!

- [[GeeFourOliver]]

----

OK! I got it with help from http://developer.apple.com/documentation/Cocoa/Conceptual/[[DataFormatting]]/Tasks/[[FormatStrings]].html.

I went as such:
<code>
[myTextField setStringValue:
    [[[NSString]] stringWithFormat:@"%g, %g, %g, %g, %g, %g",
    myArray [5], myArray [4], myArray [3],
    myArray [2], myArray [1], myArray [0])]];
</code>

- [[GeeFourOliver]]