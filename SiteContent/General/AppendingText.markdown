Unlike General/NSMutableString, General/NSTextView has not implemented a convenient method to append text to its existing text object.

You can append text to an General/NSTextView by creating a category on General/NSTextView and using code similar to that shown below:

    

@interface General/NSTextView(Controller)
- (void) appendString: (General/NSString *)str
@end

@implementation General/NSTextView(Controller)
-(void)appendString:(General/NSString *)str
{
    int len = General/self textStorage] length];
    [self replaceCharactersInRange:[[NSMakeRange(len,0)withString:str];
}


Invoke as usual, e.g., (a, b, and c are all declared integer variables)

    [reportView appendString:General/[NSString stringWithFormat:@"%i.%i.%i", a, b, c]];