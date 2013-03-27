I am trying to sort an General/NSMutableArray of General/NSStrings numerically. I tried using     compare: options:General/NSNumericSearch as a sort selector in Interface Builder, but it wouldn't let me.

I have an idea that I could make a convenience method for     -(General/NSComparisonResult)compare:(General/NSString *)*aString* options:(unsigned)General/NSNumericSearch called     -(General/NSComparisonResult)numericalCompare:(General/NSString *)*aString*, but I have no idea how to get Interface Builder to use this custom method as a sort selector. 

I have looked in the IB help, General/XCode docs, and several sites, but the information was very difficult to find. Can anyone help me?

----

Try to write a General/NSString category, and specify     numericalCompare: as a sort selector.

    
@interface General/NSString (My<nowiki/>Additions)
@end

@implementation General/NSString (M<nowiki/>yAdditions)

-(General/NSComparisonResult)numericalCompare:(General/NSString *)otherString {
  return [self compare:otherString options:NS<nowiki/>General/NumericSearch];
}

@end


-- General/DenisGryzlov