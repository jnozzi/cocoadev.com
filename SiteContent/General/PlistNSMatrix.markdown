Hi All,
       I've been recently working with Plists and I have a [[NSMatrix]] (2 radio buttons) and i was wondering how to set in my Plist which is the selected cell/[[RadioButton]]??

----

I'm assuming your plist is a dictionary.
<code>
// Assume these are initialized elsewhere
[[NSDictionary]] ''myPlist;
[[NSMatrix]] ''myMatrix;
</code>

If your matrix is horizontal, do this:
<code>
[[NSNumber]] ''selectedRow;
selectedRow = [[[NSNumber]] numberWithInt:[myMatrix selectedRow]];

[myPlist setObject:selectedRow forKey:@"[[SelectedRow]]"];
</code>

or if it's vertical:
<code>
[[NSNumber]] '' selectedColumn;
selectedColumn = [[[NSNumber]] numberWithInt:[myMatrix selectedColumn]];

[myPlist setObject:selectedColumn forKey:@"[[SelectedColumn]]"];
</code>

-- Ibson

----

My [[NSMatrix]] is horizontal and the above code worked. Thanks alot... Now after reading from the plist file how do i assign the value? I ahave tried this but does not work..

<code>
[myMatrix selectCellWithTag:(int)[prefs objectForKey:@"[[SelectedRow]]"]];
</code>

--Syphor