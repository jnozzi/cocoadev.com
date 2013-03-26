I need to modify the contents of my text view programatically but also allow the user to undo the operation - how do you do this?
----
Before you modify the text view, manually push the opposite operation onto the [[NSUndoManager]] stack. Write a small method along the lines of this:
<code>
- (void)undoableReplaceTextviewCharactersInRange:([[NSRange]])range withString:([[NSString]] '')string
{
    [[NSRange]] inverseRange = [[NSMakeRange]](range.location, [string length]);
    [[NSString]] ''inverseString = [[textView string] substringWithRange:range];
    [[undoManager prepareWithInvocationTarget:self] undoableReplaceTextviewCharactersInRange:inverseRange withString:inverseString];
    [[textView textStorage] replaceCharactersInRange:range withString:string];
}
</code>