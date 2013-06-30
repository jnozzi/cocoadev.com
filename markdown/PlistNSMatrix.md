Hi All,
       I've been recently working with Plists and I have a General/NSMatrix (2 radio buttons) and i was wondering how to set in my Plist which is the selected cell/General/RadioButton??

----

I'm assuming your plist is a dictionary.
    
// Assume these are initialized elsewhere
General/NSDictionary *myPlist;
General/NSMatrix *myMatrix;


If your matrix is horizontal, do this:
    
General/NSNumber *selectedRow;
selectedRow = General/[NSNumber numberWithInt:[myMatrix selectedRow]];

[myPlist setObject:selectedRow forKey:@"General/SelectedRow"];


or if it's vertical:
    
General/NSNumber * selectedColumn;
selectedColumn = General/[NSNumber numberWithInt:[myMatrix selectedColumn]];

[myPlist setObject:selectedColumn forKey:@"General/SelectedColumn"];


-- Ibson

----

My General/NSMatrix is horizontal and the above code worked. Thanks alot... Now after reading from the plist file how do i assign the value? I ahave tried this but does not work..

    
[myMatrix selectCellWithTag:(int)[prefs objectForKey:@"General/SelectedRow"]];


--Syphor