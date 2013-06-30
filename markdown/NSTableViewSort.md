

Hi!
I need som help on howto sort the content in a table.

Is it also possible to sort images?

Tnx

----

Assuming you're familiar with setting up an General/NSTableView's delegate and datasource (see General/NSTableDataSource for more info)...

It all depends on the data you're displaying in your General/NSTableView (ie: the Model part of General/ModelViewController). Assuming you've stored your data in an General/NSMutableArray, you should probably use one of the sortUsing... methods (described at http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSMutableArray.html). You'll have to implement a variant of the     -(General/NSComparisonResult)compare:(id)otherObject method for the objects in the General/NSMutableArray if they're not standard General/NSNumbers, General/NSStrings or whatever (see http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSString.html#//apple_ref/doc/uid/20000154/compare_ for a description of the method). 

So if, for example, you have an General/NSMutableArray full of General/NSStrings, you'd sort your data in alphabetical order using     [myMutableArray sortUsingSelector:@selector(compare:)];, and then you'd probably call     [myTableView reloadData]; to ensure your General/NSTableView displays your newly sorted data.

When you say "is it also possible to sort images", what do you mean? What information about any given image will you be using as the basis for comparing it with another image? If your General/NSTableView is just displaying a list of image file names, then you're really asking whether it's possible to sort an array of General/NSStrings... so the answer's "yes, see above". the same applies to any other information about an image that you can easily convert to a string or a number, including file format, dimensions, colorspace, encoding scheme, resolution... you get the idea. 

But if you're asking whether it's possible to sort a bunch of images based on the image itself... hum... that's a pretty big ask. 

If you're wondering how to get your table column to sort when the user clicks in the column header:

implement your delegate's     - (void)tableView:(General/NSTableView *)tableView mouseDownInHeaderOfTableColumn:(General/NSTableColumn *)tableColumn method and do the sorting there. You may also be interested to know that General/NSTableView provides the     - (General/NSImage *)indicatorImageInTableColumn:(General/NSTableColumn *)aTableColumn and     - (void)setIndicatorImage:(General/NSImage *)anImage inTableColumn:(General/NSTableColumn *)aTableColumn methods, which allow you to display icons alongside text in table column headings. You can use     General/[NSImage imageNamed:@�General/NSAscendingSortIndicator�] and     General/[NSImage imageNamed:@�General/NSDescendingSortIndicator�] to indicate to your user whether a table column is sorted, and how.


--General/ToM