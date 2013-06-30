One way to sort a table view that is expected by many users is to be able to click on a table column header cell to toggle the sort order. A prime example of this is found in the iTunes application.

----

One of the basic things you have to do is intercept mouse down events in order to get the table to sort itself. But there is no need to go the direct route, as the following discussion reveals:

Using 
    
tableView:(General/NSTableView *)tableView mouseDownInHeaderOfTableColumn:(General/NSTableColumn *)tableColumn

brings two problems. 

*First, since it's mouseDown, even a column resize triggers the sorting. I don't want this...
*Next, I don't know how to reverse the sorting. Are there any hints about the "sorted state" of a column?

----

It is much better to use this delegate method which only gets triggered **only** when clicking the header cell (not when resizing a column):

    
- (void)tableView:(General/NSTableView *)tableView didClickTableColumn:(General/NSTableColumn *)tableColumn
{
	// Either reverse the sort or change the sorting column
}


To reverse the sorting of a column, you should reverse the array that the table is getting data from. Something like this (category method which extends General/NSMutableArray):

    
@implementation General/NSMutableArray (General/ReverseArray)

- (void)reverse
{
	int i;

	for (i=0; i<(floor([self count]/2.0)); i++) {
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	}
}

@end


----

Here's a simple example that shows how to sort General/NSTableView columns in ascending or descending order by clicking the column header. It also illustrates two undocumented methods in General/NSTableView to display the familiar up and down arrows in the column header to indicate sorting order. (WARNING: Use undocumented method calls at your own risk. Apple could change or remove these without notice in a future release of OS X.)

Our example has two classes: the Cartoon class is used to represent cartoon characters, which will be shown in a table view.  The C**'artoonTableController class is used as the data source and delegate for the General/NSTableView.

The Cartoon class is very simple, it has three instance variables and three corresponding accessors.
    
// Cartoon.h
#import <Foundation/Foundation.h>
@interface Cartoon : General/NSObject {
    General/NSString * name;
    int shoeSize;
    General/NSString * tagLine;
}
- (id)initWithName:(General/NSString *)theName
          shoeSize:(int)theShoeSize
           tagLine:(General/NSString *)theTagLine;
- (General/NSString *) name;
- (int) shoeSize;
- (General/NSString *) tagLine;
@end


// Cartoon.m
#import "Cartoon.h"
@implementation Cartoon
- (id)initWithName:(General/NSString *)theName
          shoeSize:(int)theShoeSize
           tagLine:(General/NSString *)theTagLine {
    if (self = [super init]) {
        name = [theName retain];
        shoeSize = theShoeSize;
        tagLine = [theTagLine retain];
    }
    return self;
}
- (void) dealloc {
    [name release];
    [tagLine release];
    [super dealloc];
}
- (General/NSString *) name {
    return name;
}
- (int) shoeSize {
    return shoeSize;
}
- (General/NSString *) tagLine {
    return tagLine;
}
@end


Next, we create an extension to the Cartoon class containing methods to compare two Cartoon objects.

These methods could be put in Cartoon.h/.m, but we choose to put these methods in a separate file because they aren't part of the Cartoon's zen nature; they are only useful to the C**'artoonTableController object to sort the table. This is called creating a category. For details see General/ClassCategories.

Note that the names for these sort routines are in a specific form, closely related to the method names for the Cartoon accessors.
    
// Cartoon-Sorting.h.
#import "Cartoon.h"
@interface Cartoon(Sorting)
- (General/NSComparisonResult)nameComparison:
        (Cartoon *)otherCharacter;
- (General/NSComparisonResult)shoeSizeComparison:
        (Cartoon *)otherCharacter;
- (General/NSComparisonResult)tagLineComparison:
        (Cartoon *)otherCharacter;
@end

// Cartoon-Sorting.m
#import "Cartoon-Sorting.h"
@implementation Cartoon(Sorting)
- (General/NSComparisonResult)nameComparison:
        (Cartoon *) otherCharacter {
    return [name caseInsensitiveCompare: [otherCharacter name]];
}
- (General/NSComparisonResult)shoeSizeComparison:
        (Cartoon *) otherCharacter {
   if (shoeSize < [otherCharacter shoeSize])
      return General/NSOrderedAscending;
   else if (shoeSize > [otherCharacter shoeSize])
      return General/NSOrderedDescending;
   else
      return General/NSOrderedSame;
}
- (General/NSComparisonResult)tagLineComparison:
        (Cartoon *) otherCharacter {
    return [tagLine compare: [otherCharacter tagLine]];
    // case-sensitive compare
}
@end


Finally, let's create the C**'artoonTableController class. It has four instance variables to manage the list of Cartoon objects and keep sorting information.  It also implements the General/NSTableDataSource protocol to act as a data source for the General/NSTableView, and one of the table view's delegate methods to respond to clicks in a column header.
    
// General/CartoonTableController.h
#import <General/AppKit/General/AppKit.h>
@interface General/CartoonTableController : General/NSObject {
    General/NSMutableArray * characters; // array of Cartoon objects
    General/NSTableColumn * lastColumn;  // track last column chosen
    SEL columnSortSelector;      // holds a method pointer
    BOOL sortDescending;         // sort in descending order
}
// General/NSTableView data source/delegate methods
- (int)  numberOfRowsInTableView: (General/NSTableView *) tableView;
- (id)                 tableView: (General/NSTableView *) tableView
       objectValueForTableColumn: (General/NSTableColumn *) tableColumn
                             row: (int) row;
- (void)               tableView: (General/NSTableView *) tableView
             didClickTableColumn: (General/NSTableColumn *) tableColumn;
@end


The -tableView:didClickTableColumn: method is where we handle the user's column click action. We determine whether the clicked column is already selected, determine the new sorting order and re-sort the table. It constructs a selector name as a string, and uses General/NSSelectorFromString to find the selector by that name, which is stored in the columnSortSelector instance variable.

Note the two class method calls General/[NSTableView _defaultTableHeaderSortImage] and General/[NSTableView _defaultTableHeaderReverseSortImage], which return General/NSImage objects; these calls will generate warning messages during compile, since the method names are not declared in the General/NSTableView header file.

Finally, the [tableView setHighlightedTableColumn: tableColumn]; method call makes the selected column header display in blue. If you don't want this behavior, just remove that line.
    
// General/CartoonTableController.m
#import "General/CartoonTableController.m"

#import "Cartoon.h"
#import "Cartoon-Sorting.m" // don't really need this import statement

// To prevent compiler warnings, declare the two undocumented methods
@interface General/NSTableView(General/SortImages)
+ (General/NSImage *) _defaultTableHeaderSortImage;
+ (General/NSImage *) _defaultTableHeaderReverseSortImage;
@end

@implementation General/CartoonTableController
- (void) awakeFromNib {
    // create demo characters array
    characters = General/[[NSMutableArray arrayWithObjects:
        General/[Cartoon alloc] initWithName: @"Fred Flintstone"
                              shoeSize: 12
                               tagLine: @"Yabba, Dabba, Do!!!!!!"]
                                                      autorelease],
        [[[Cartoon alloc] initWithName: @"Popeye"
                              shoeSize: 9
                               tagLine: @"I'm Popeye, the sailor man!"]
                                                      autorelease],
        [[[Cartoon alloc] initWithName: @"Scooby Doo"
                              shoeSize: 2
                               tagLine: @"Ruh-Roh!"] autorelease],
        [[[Cartoon alloc] initWithName: @"Bart Simpson"
                              shoeSize: 5
                               tagLine: @"Don't have a cow, man!"]
                                                      autorelease],
        nil] retain];
}

// The next two functions implement the [[NSTableView's
// data source protocol
- (int) numberOfRowsInTableView: (General/NSTableView *) tableView {
    return [characters count];
}

- (id)              tableView: (General/NSTableView *) tableView
    objectValueForTableColumn: (General/NSTableColumn *) tableColumn
                          row: (int) row {
    Cartoon * character = [characters objectAtIndex:
        (sortDescending ? [characters count] - 1 - row : row)];
    return [character valueForKey: [tableColumn identifier]];
}

// General/NSTableView delegate function
- (void)      tableView: (General/NSTableView *) tableView
    didClickTableColumn: (General/NSTableColumn *) tableColumn {
    if (lastColumn == tableColumn) {
        // User clicked same column, change sort order
        sortDescending = !sortDescending;
    } else {
        // User clicked new column, change old/new column headers,
        // save new sorting selector, and re-sort the array.
        sortDescending = NO;
        if (lastColumn) {
            [tableView setIndicatorImage: nil
                inTableColumn: lastColumn];
            [lastColumn release];
        }
        lastColumn = [tableColumn retain];
        [tableView setHighlightedTableColumn: tableColumn];
        columnSortSelector = General/NSSelectorFromString(General/[NSString
            stringWithFormat: @"%@Comparison:",
            [tableColumn identifier]]);
        [characters sortUsingSelector: columnSortSelector];
    }
    // Set the graphic for the new column header
    [tableView setIndicatorImage: (sortDescending ?
        General/[NSTableView _defaultTableHeaderReverseSortImage] :
        General/[NSTableView _defaultTableHeaderSortImage])
        inTableColumn: tableColumn];
    [tableView reloadData];
}
@end

That's it for the code. If you want to try this example, create a new Cocoa app, add the code above, and create C**'artoonTableController and General/NSTableView objects in Interface Builder. The table view should have three columns: Name, Shoe Size, and Tag Line that have identifiers of "name", "shoeSize", and "tagLine" respectively. Wire it all up, be sure to connect the table's data source and delegate to the General/CartoonTableController object.

Enjoy!

<fergy/>
pdferguson@attbi.com

----
- For info about how to avoid using private methods (that might be removed) for sort arrows, see this link: http://cocoa.mamasam.com/MACOSXDEV/2001/06/1/7790.php

- Resorting the array everytime the user clicks on a table header, just to change the order, isn't necessary and is often a bad idea. Instead just sort the array when you really need to (when new items are added or the user changes the column that decides the sort criteria). See http://forums.macnn.com/cgi-bin/ultimatebb.cgi?ubb=get_topic&f=34&t=002351 for info on this subject.

/Tobias

----
Thanks, Tobias. I incorporated your suggestion about only re-sorting when necessary. It also halves the number of comparison methods needed on the Cartoon class, and simplifies the didClickTableColumn method.

<fergy/>

----

Hillegass implements table sorting in an example in the second edition of his book using bindings and General/NSArrayController and sort descriptors.
Nary an     General/NSComparisonResult in view (although perhaps behind the scenes?)

(*Note: Bindings are nice, but be aware that they are only available on Panther (10.3) and newer.*)

See General/JaguarOrPanther. This is no longer a limitation in most cases.

----

The documented way for displaying sorting arrows is using General/[NSImage imageNamed:@] as follows:
    
[aTableView setIndicatorImage: (sortDescending ?
     General/[NSImage imageNamed:@"General/NSDescendingSortIndicator"] :
     General/[NSImage imageNamed:@"General/NSAscendingSortIndicator"])
     inTableColumn: aTableColumn];

I'm leary of using private methods as they may change in the future.

----

But is there any way to know if the last clicked column is ascending or descending ? Or do you have to create the mecanism "by hand" ?

----

Why not just override - (void)tableView:(General/NSTableView *)tableView sortDescriptorsDidChange:(General/NSArray *)oldDescriptors 
in your table view data source (General/NSTableDataSource)?

    
- (void)tableView:(General/NSTableView *)tableView sortDescriptorsDidChange:(General/NSArray *)oldDescriptors
{
    [myTableDataArray sortUsingDescriptors:[tableView sortDescriptors]];
    [tableView reloadData];
}


Do this in conjunction with setting sort keys for each table column (can be done in Interface Builder) and you are done.

----