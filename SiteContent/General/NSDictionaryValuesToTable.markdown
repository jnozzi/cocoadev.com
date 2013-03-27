I wonder if anyone knows how to implement a General/NSDictionary in a General/NSTableView? I have only seen examples of loading a General/NSTableView with an General/NSArray, but none with a dictionary.

The example in this page:
http://cocoadevcentral.com/articles/000063.php

describes how to do this. I wonder if anyone could tell me how to do the same app but with an General/NSMutableDictionary instead of the Array they use.

----

Well, considering that an General/NSDictionary is inherently unordered and that a table view implies an order existing, this may not be the most elegant solution for whatever projection you're working on, but it does it.

Assuming you just want to display the values (and not the keys) in the table view, a simple command like the following:
    
General/NSArray *myArray = [myDictionary allValues];

will give you an array that contains all the values in your dictionary and you can use that as the data source for your table view as the tutorial you mentioned above did.

--General/KevinPerry

----

Hehe     [myDict objectForKey:General/[NSString stringWithFormat:@"%d", rowIndex]]

----

You could also sort the keys/values into some order that is meaningful to the table. Jon H.

----

Is the intention to fill *two* columns of the table view, one with key and one with value, sorted perhaps alphabetically by key?