

If you are unfamiliar with nib files read this article before moving on:

http://cocoadevcentral.com/articles/000064.php

This project will build an [[NSMatrix]] view that uses [[NSTableView]]'s for cells. So here we go....


*Launch [[XCode]] and create a new Cocoa Application named [[TableViewMatrix]]
*Create a new Objective-C [[NSView]] subclass named "[[TableViewMatrix]]" (File -> New File -> Objective-C [[NSView]] subclass)
*Open "[[TableViewMatrix]].h" in an editor, delete everything and paste the following code into this header


'''[[TableViewMatrix]].h'''
<code>
#import <[[AppKit]]/[[AppKit]].h>

@class [[TVMatrix]], [[TVCell]], [[TVTableView]], [[TVScrollView]];

@interface [[MainScrollView]] : [[NSScrollView]] {
    [[TVMatrix]] ''tvMatrix;
}
@end

@interface [[TVMatrix]] : [[NSMatrix]] {
    [[NSMutableArray]] ''registeredCells;
    [[NSMutableDictionary]] ''chalkboard;
    float minCellWidth;
    float minCellHeight;

}
- (void)setMinCellWidth:(float)value;
- (void)setMinCellHeight:(float)value;
- (float)minCellWidth;
- (float)minCellHeight;

@end

@interface [[TVScrollView]] : [[NSScrollView]] {
    [[TVMatrix]] ''tvMatrix;
    [[NSPoint]] mouseDownPoint;
    [[NSSize]] mouseDownCellSize;
    [[TVCell]] ''tvCell;
    [[NSTimer]] ''timer;
}
- (void)setTVCell:([[TVCell]] '')cell;
- (void)setTVMatrix:([[TVMatrix]] '')matrix;
@end


@interface [[TVTableView]] : [[NSTableView]] {
    [[TVMatrix]] ''tvMatrix;
}
- (void)setTVMatrix:([[TVMatrix]] '')matrix;
@end


@interface [[TVCell]] : [[NSCell]] {
    [[NSRect]] scrollFrame;
    [[TVTableView]] ''tableView;
    [[IBOutlet]] [[TVScrollView]] ''scrollView;
    BOOL isTableConfigured;
    [[NSMutableArray]] ''tableData;
    [[NSArray]] ''nibObjects;
    [[TVMatrix]] ''tvMatrix;
}
- (void)setTVMatrix:([[TVMatrix]] '')matrix;
- ([[NSMutableArray]] '')tableData;
- ([[NSTableView]] '')tableView;
- ([[NSScrollView]] '')scrollView;
@end

</code>



*Open "[[TableViewMatrix]].m" in an editor, delete everything and paste the following code


'''[[TableViewMatrix]].m'''
<code>
#import "[[TableViewMatrix]].h"

[[NSNib]] ''[[TableViewResourceNib]] = nil;
[[NSImageRep]] ''[[ResizeIcon]] = nil;

@implementation [[MainScrollView]]

- (void)setup {
    [self setHasVerticalScroller:YES];
    [self setHasHorizontalScroller:YES];
    tvMatrix = [[[[TVMatrix]] alloc] initWithFrame:[self frame]];
    [self setDocumentView:tvMatrix];
}
- (void)dealloc {[tvMatrix autorelease]; [super dealloc];}
- (void)viewDidMoveToWindow {if (!tvMatrix) [self setup];}

@end


@implementation [[TVMatrix]]

- (void)instantiateTVMatrixResources {
    [[TableViewResourceNib]] = [[[[NSNib]] alloc] initWithNibNamed:@"[[TableViewMatrix]]" 
                                        bundle:[[[NSBundle]] mainBundle]];
    [[NSImage]] ''imageBuffer = [[[[NSImage]] alloc] initWithSize:[[NSMakeSize]](18.0f, 18.0f)];
    [imageBuffer lockFocus];
    [[[[NSColor]] lightGrayColor] set]; [[NSRectFill]]([[NSMakeRect]](0, 0, 18.0f, 18.0f));
    [[[[NSColor]] blackColor] set];
    float triPoints[4][6] = {   {8.0f, 1.0f, 11.0f, 4.0f, 5.0f, 4.0f},
                                {1.0f, 8.0f, 4.0f, 11.0f, 4.0f, 5.0f},
                                {15.0f, 8.0f, 12.0f, 11.0f, 12.0f, 5.0f},
                                {8.0f, 15.0f, 5.0f, 12.0f, 11.0f, 12.0f} };
    int i; for(i = 0; i < 4; i++) {
        [[NSBezierPath]] ''bp = [[[NSBezierPath]] bezierPath];
        [bp moveToPoint:[[NSMakePoint]](triPoints[i][0], triPoints[i][1])];
        int ii; for(ii = 1; ii < 3; ii++) {
            [bp lineToPoint:[[NSMakePoint]](triPoints[i][ii '' 2], triPoints[i][ii '' 2 + 1])];
        }
        [bp fill];
    }
    [[NSRectFill]]([[NSMakeRect]](7.0f, 3.0f, 2.0f, 12.0f));
    [[NSRectFill]]([[NSMakeRect]](3.0f, 7.0f, 12.0f, 2.0f));
    [imageBuffer unlockFocus];
    [[ResizeIcon]] = [[imageBuffer representations] objectAtIndex:0];

}

- (id)initWithFrame:([[NSRect]])frame {
    self = [super initWithFrame:frame];
    if (self) {
        chalkboard = [[[[NSMutableDictionary]] dictionary] retain];
        registeredCells = [[[NSMutableArray]] array];
        [chalkboard setObject:registeredCells forKey:@"registeredCells"];
        if (![[TableViewResourceNib]]) [self instantiateTVMatrixResources];
        minCellWidth = 100.0f; minCellHeight = 100.0f;

    }
    return self;
}
- (void)setMinCellWidth:(float)value {minCellWidth = value;}
- (void)setMinCellHeight:(float)value {minCellHeight = value;}
- (float)minCellWidth {return minCellWidth;}
- (float)minCellHeight {return minCellHeight;}
- (void)setCellSize:([[NSSize]])size {
    if (size.width < minCellWidth) size.width = minCellWidth;
    if (size.height < minCellHeight) size.height= minCellHeight;
    [super setCellSize:size];
}
- (void)sizeToCells {
    [[NSSize]] size = [self cellSize];
    [[NSEnumerator]] ''cellEnum = [[self cells] objectEnumerator]; id cell;
    [[NSSize]] intercellSpacing = [self intercellSpacing];
    while (cell = [cellEnum nextObject]) {
        int r, c;
        [self getRow:&r column:&c ofCell:cell];
        [[NSScrollView]] ''scrollView = [cell scrollView];
        [[NSRect]] frame = [[NSMakeRect]](c '' size.width + c '' intercellSpacing.width,
                                r '' size.height + r '' intercellSpacing.height, 
                                size.width, size.height);
        [scrollView setFrame:frame]; [scrollView setNeedsDisplay:YES];
    }
    [super sizeToCells];
}
- (void)dealloc {
    [chalkboard autorelease];
    [super dealloc];
} 

@end

@implementation [[TVScrollView]]
- (void)scrollWheel:([[NSEvent]] '')theEvent {
    if ([theEvent modifierFlags] & [[NSCommandKeyMask]]) [super scrollWheel:theEvent];
    else [tvMatrix scrollWheel:theEvent]; 
}
- (void)setTVMatrix:([[TVMatrix]] '')matrix {tvMatrix = matrix;}
- (void)setTVCell:([[TVCell]] '')cell {tvCell = cell;}
- (void)mouseUp:([[NSEvent]] '')theEvent {
    [timer invalidate]; [timer autorelease]; timer = nil;
}
- (void)timerAction:(id)sender {
    int r, c; [tvMatrix getRow:&r column:&c ofCell:tvCell];
    [[NSPoint]] loc = [[self window] mouseLocationOutsideOfEventStream];
    [[NSSize]] newSize = [[NSMakeSize]](mouseDownCellSize.width + (loc.x - mouseDownPoint.x) / (c + 1), 
                                mouseDownCellSize.height + (mouseDownPoint.y - loc.y) / (r + 1));
    [tvMatrix setCellSize:newSize];
    [tvMatrix sizeToCells];
    [tvMatrix setNeedsDisplay:YES];
}
- (void)mouseDown:([[NSEvent]] '')theEvent {
    [[NSSize]] size = [self frame].size;
    [[NSRect]] bottomRightCorner = [[NSMakeRect]](size.width - 16.0f, size.height - 16.0f, 16.0f, 16.0f);
    mouseDownPoint = [[self window] mouseLocationOutsideOfEventStream];
    [[NSPoint]] loc = [self convertPoint:mouseDownPoint fromView:nil];
    if ([[NSPointInRect]](loc, bottomRightCorner)) {
        mouseDownCellSize = [tvMatrix cellSize];
        [timer invalidate]; [timer release];
        timer = [[[[NSTimer]] scheduledTimerWithTimeInterval:.1
                                                target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                repeats:YES] retain];
    }
}
- (void)drawRect:([[NSRect]])rect {
    [super drawRect:rect];
    [[NSSize]] size = [self frame].size;
    [[NSRect]] bottomRightCorner = [[NSMakeRect]](size.width - 16.0f, size.height - 16.0f, 16.0f, 16.0f);
    if ([[NSIntersectsRect]](bottomRightCorner, rect)) [[[ResizeIcon]] drawAtPoint:bottomRightCorner.origin];
}
@end


@implementation [[TVTableView]]

- (void)scrollWheel:([[NSEvent]] '')theEvent {
    if ([theEvent modifierFlags] & [[NSCommandKeyMask]]) [super scrollWheel:theEvent];
    else [tvMatrix scrollWheel:theEvent]; 
}
- (void)setTVMatrix:([[TVMatrix]] '')matrix {tvMatrix = matrix;}
@end


@implementation [[TVCell]] 
- (id)init {
    self = [super init];
    if (self) {
        [[[TableViewResourceNib]] instantiateNibWithOwner:self topLevelObjects:&nibObjects];
        [nibObjects retain];
        tableView = [scrollView documentView];
        [tableView setDelegate:self];
        [[[[NSNotificationCenter]] defaultCenter] addObserver:self
                                                selector:@selector(clipViewBoundsDidChange:)
                                                name:[[NSViewBoundsDidChangeNotification]]
                                                object:[tableView superview]];
        [[tableView superview] setPostsBoundsChangedNotifications:YES];
        [scrollView setTVCell:self];
        tableData = [[[[NSMutableArray]] alloc] init];
    }
    return self;
}   
- (void)setTVMatrix:([[TVMatrix]] '')matrix {
    tvMatrix = matrix; 
    [scrollView setTVMatrix:matrix]; [tableView setTVMatrix:matrix];
}
- ([[NSTableView]] '')tableView {return tableView;}
- ([[NSScrollView]] '')scrollView {return scrollView;}
- ([[NSMutableArray]] '')tableData {return tableData;}
- (void)dealloc {
    [scrollView removeFromSuperview];
    [nibObjects makeObjectsPerformSelector:@selector(release)];
    [nibObjects release];
    [tableData release];
    [super dealloc];
}

- (void)clipViewBoundsDidChange:([[NSNotification]] '')note {
    [tableView setNeedsDisplay:YES];
    [[tableView headerView] setNeedsDisplay:YES];
}

- (void)configureCellForView:([[NSView]] '')view frame:([[NSRect]])frame {
    [view addSubview:scrollView];
    scrollFrame = frame;
    [scrollView setFrame:frame]; [scrollView setNeedsDisplay:YES];
    isTableConfigured = YES;
}

- (void)drawWithFrame:([[NSRect]])frame inView:([[NSView]] '')view {
    if (!isTableConfigured) [self configureCellForView:view frame:frame];
}

@end
</code>


*Create a new Objective-C subclass named "[[TableViewMatrixController]]" (File -> New File -> Objective-C [[NSView]] subclass)
*Open "[[TableViewMatrixController]].h" in an editor, delete everything and paste the following code into this header


''' [[TableViewMatrixController]].h'''
<code>
#import <Cocoa/Cocoa.h>
@class [[TVMatrix]];

@interface [[TableViewMatrixController]] : [[NSObject]]
{
    [[TVMatrix]] ''tvMatrix;
    [[IBOutlet]] id mainScrollView;

}
@end
</code>


*Open "[[TableViewMatrixController]].m" in an editor, delete everything and paste the following code


'''[[TableViewMatrixController]].m'''
<code>
#import "[[TableViewMatrixController]].h"
#import "[[TableViewMatrix]].h"

@implementation [[TableViewMatrixController]]

- (void)setup {
    tvMatrix = [mainScrollView documentView];
    [tvMatrix setCellClass:[[[TVCell]] class]];
    int r, c;
    for (r = 0; r < 4; r++) [tvMatrix addRow];
    for (c = 0; c < 4; c++) [tvMatrix addColumn];
    [tvMatrix setIntercellSpacing:[[NSMakeSize]](1, 1)];
    [tvMatrix setCellSize:[[NSMakeSize]](300, 300)];
    [tvMatrix sizeToCells];

    [[NSArray]] ''cells = [tvMatrix cells];
    [[NSEnumerator]] ''cellEnum = [cells objectEnumerator]; 
    [[TVCell]] ''cell;
    int i, idCount = 0;
    while (cell = [cellEnum nextObject]) {
        [cell setTVMatrix:tvMatrix];
        [[NSTableView]] ''tableView = [cell tableView];
        [tableView setDataSource:self];
        [tvMatrix getRow:&r column:&c ofCell:cell];
        for (i = 0; i < 100; i++) {
            [[NSMutableDictionary]] ''entry = [[[NSMutableDictionary]] dictionary];
            [entry setObject:[[[NSNumber]] numberWithInt:idCount++] forKey:@"id"];
            [[NSString]] ''name = [[[NSString]] stringWithFormat:@"tv[%i, %i]   item[%i]", r, c, i];
            [entry setObject:name forKey:@"name"];
            [[cell tableData] addObject:entry];
        }
        [tableView reloadData];
    }
    
}

- (void)awakeFromNib {
    if (!tvMatrix) [self setup];
}

- (void)tableView:([[NSTableView]] '')aTableView sortDescriptorsDidChange:([[NSArray]] '')oldDescriptors {
    [[TVCell]] ''cell = ([[TVCell]] '')[aTableView delegate];
    [[NSMutableArray]] ''tableData = [cell tableData];
    [tableData sortUsingDescriptors:[aTableView sortDescriptors]];
    [aTableView reloadData];
}

-(BOOL)tableView:(id)aTableView shouldSelectRow:(int)rowIndex {
    [[TVCell]] ''cell = ([[TVCell]] '')[aTableView delegate];
    [[NSMutableArray]] ''tableData = [cell tableData];
    if (rowIndex < [tableData count]) {
        /''
            do somthing here
        ''/
    }
    return YES;
}

- (void)tableView:([[NSTableView]] '')aTableView
    setObjectValue:anObject
    forTableColumn:([[NSTableColumn]] '')aTableColumn
    row:(int)rowIndex 
{
    [[TVCell]] ''cell = ([[TVCell]] '')[aTableView delegate];
    id theRecord = [[cell tableData] objectAtIndex:rowIndex];
    if (anObject) {
        [theRecord setObject:anObject forKey:[aTableColumn identifier]];
    }

}

- (id)tableView:([[NSTableView]] '')aTableView
    objectValueForTableColumn:([[NSTableColumn]] '')aTableColumn
    row:(int)rowIndex
{
    [[TVCell]] ''cell = ([[TVCell]] '')[aTableView delegate];
    id theRecord, theValue;
    theRecord = [[cell tableData] objectAtIndex:rowIndex];
    theValue = [theRecord objectForKey:[aTableColumn identifier]];
    return theValue;
}

- (int)numberOfRowsInTableView:([[NSTableView]] '')aTableView
{
    [[TVCell]] ''cell = ([[TVCell]] '')[aTableView delegate];
    return [[cell tableData] count];
}

@end
</code>


*Build the project
*Now open the [[MainMenu]].nib file (Double click on the [[MainMenu]].nib icon located in the Resources group in the Group&Files outline view)
*[[InterfaceBuilder]] should launch and open the nib file. The contents of the nib file are displayed in a window with a tab view that has tabs named Instances, Classes, Images, Sounds and Nib. This tab view will be refered to as the nib's tab view. 
*Click on the nib's tab view to make this nib active in [[InterfaceBuilder]]
*Now read in the two header files you created in [[XCode]] ([[TableViewMatrix]].h and [[TableViewMatrixController]].h)

*To read in header files select the menu item (Classes -> Read Files...)

*After the files have been successfully parsed, click on the Classes tab in the [[MainMenu]].nib tab view. 
*Scroll to the far left of the class browser and select [[NSObject]]
*Scroll through [[NSObject]]'s subclasses until you see [[TableViewMatrixController]]
*Select [[TableViewMatrixController]] (make sure [[TableViewMatrixController]] is highlighted blue) and instantiate this subclass (Classes -> Instantiate [[TableViewMatrixController]]). Notice that the Classes menu was dynamically updated to show that [[TableViewMatrixController]] is selected in the class browser.
*If [[TableViewMatrixController]] was successfully instantiated, the [[MainMenu]].nib tab view should have changed tabs so that a newly instantiated "[[TableViewMatrixController]] object" is now visible in the "Instances" tab.
*In the "Instances" tab double click on the "Window" icon. This action should make the main window key.
*Drag and drop a "Custom View" object onto the main window (The "Custom View" object is located in the Interface Builder palettes window under Cocoa-Containers)
*Resize the custom view so that it fills the window.
*Select the custom view by clicking on it.
*Hit Command + "3" to configure the autoresizing mode of the custom view. 
*Command + "3" brings up the inspector window. This window has eight different modes for inspecting the active object. The first five are described below. Notice that the inspector window's title tells you the class of the active object. 

*Command + "1" allows you to configure attributes
*Command + "2" allows you to configure connections
*Command + "3" allows you to configure autoresizing settings
*Command + "4" allows you to configure bindings
*Command + "5" allows you to configure a custom class for the active object

*Select the inner springs (both vertical and horizontal) in the autoresizing view (the inner springs are the springs inside the box).
*With the custom view still selected Hit Command + "5" to set the class for the custom view.
*You should see a class named [[MainScrollView]] in the "Custom Class" list. Select [[MainScrollView]] as the custom class for the custom view.
*Drag a connection from the "[[TableViewMatrixController]] object" (in the "Instance" tab of the [[MainMenu]].nib tab view) to the "[[MainScrollView]]" custom view that you dropped onto the main window. See file:///Developer/Documentation/[[DeveloperTools]]/Conceptual/[[IBTips]]/Articles/[[MakingConnections]].html for info on making connections.
*Select the outlet named "mainScrollView" for this connection.
*Save [[MainMenu]].nib (File -> Save)
*Close the [[MainMenu]].nib window (the window with the [[MainMenu]].nib tab view).
*Create a new empty Cocoa nib file (File -> New -> Cocoa - Empty)
*Make sure you save this file into the folder of the project under the name "[[TableViewMatrix]]"
*Save this nib as "[[TableViewMatrix]]" (File -> Save).
*While you are saving the nib you will be asked which targets in the project you would like the nib file to be associated with. [[TableViewMatrix]] should be checked, but if it isn't check this target and add the nib to the project.
*Select the Classes tab in the nib's tab view.
*Now read in "[[TableViewMatrix]].h" (Classes -> Read Files...)
*Select the Instances tab in the nib's tab view.
*Select the "File's Owner" object in the nib's tab view.
*With the "File's Owner" object selected, Hit Command + "5" and set the class for the nib file's owner to "[[TVCell]]"
*Now drag a "Custom View" onto the nib's tab view.
*You should now see an instance of a custom view in the "Instances" tab.
*Double click on the "View" instance
*Enlarge the view to a workable size and drop a table view from the Cocoa-Data pallet onto the view.
*Enlarge the table view to a workable size and select the first table column
*Hit Command + "1" to configure the selected table column.
*Set the title of the first column to "ID", set the identifier to "id" and set the sort key to "id".
*Select the second column of the table view.
*Set the title of the first column to "Name", set the identifier to "name" and set the sort key to "name".
*Now you need to configure the class of the table view and the scroll view.
*First deselect everything in the "Custom View" (i.e. if the table view, one of the table headers or if the scroll view is selected). To deselect the "Custom View's" contents simply click on the "Custom View" without touching the table view. Nothing should be highlighted or banded with resizing marks.
*Click ONE TIME on the table view. This action should create a banding with resizing marks around the table view. The inspector window's title should be "[[NSScrollView]] Info".
*Hit Command + "5" to set the custom class of the scroll view to [[TVScrollView]]
*The inspector window's title should now read "[[TVScrollView]] Info".
*Now double click on the table view. This action should highlight the content space of the table view. The inspector window's title should read "[[NSTableView]] Info"
*Hit Command + "5" to set the custom class of the table view to [[TVTableView]]
*The inspector window's title should now read "[[TVTableView]] Info".
*Drag a connection from the "File's Owner" instance object to the table view's scroll view 

*This operation is kind of tricky because there are five views that can be connected (the main parent "Custom View", the table view, two table columns and the scroll view that holds the table view). While you are dragging a connection line from the "File's Owner" instance object toward the custom view, you will be able to dynamically see where the connection line is terminating by watching each view's outline highlight as the mouse is dragged over each element. When the table view is terminating the connection, the table view's inner content space will be highlighted. When table columns are terminating the connection, each individual column header will highlight. When the scroll view that contains the table view is terminating the connection, the entire table view's outline (including the table column headers and the scrollers) will be highlighted. When the "Custom View" is terminating the connection the outline of the entire parent view (the "Custom View") will be highlighted. You want to drag a connection line from the "File's Owner" instance object to the scroll view that contains the table view. The easiest way to do this is to drag a connection line so that it terminates on one of the scrollers of the scroll view. 

*Select "scrollView" as the outlet for this connection
*resave the nib (File -> Save)


At this point you should be ready to launch this application. Go back to [[XCode]] and build and run [[TableViewMatrix]] (Build -> Build and Run).