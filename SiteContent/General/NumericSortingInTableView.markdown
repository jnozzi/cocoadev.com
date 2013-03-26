I am trying to sort an [[NSMutableArray]] of [[NSStrings]] numerically. I tried using <code>compare: options:[[NSNumericSearch]]</code> as a sort selector in Interface Builder, but it wouldn't let me.

I have an idea that I could make a convenience method for <code>-([[NSComparisonResult]])compare:([[NSString]] '')''aString'' options:(unsigned)[[NSNumericSearch]]</code> called <code>-([[NSComparisonResult]])numericalCompare:([[NSString]] '')''aString''</code>, but I have no idea how to get Interface Builder to use this custom method as a sort selector. 

I have looked in the IB help, [[XCode]] docs, and several sites, but the information was very difficult to find. Can anyone help me?

----

Try to write a [[NSString]] category, and specify <code>numericalCompare:</code> as a sort selector.

<code>
@interface [[NSString]] (My<nowiki/>Additions)
@end

@implementation [[NSString]] (M<nowiki/>yAdditions)

-([[NSComparisonResult]])numericalCompare:([[NSString]] '')otherString {
  return [self compare:otherString options:NS<nowiki/>[[NumericSearch]]];
}

@end
</code>

-- [[DenisGryzlov]]