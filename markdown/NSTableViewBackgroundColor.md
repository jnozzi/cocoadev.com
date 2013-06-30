

I was looking for examples of how to set an General/NSTableView row's background color based on a value in the row. I didn't find anything but came up with a method I thought I'd share. I subclassed General/NSTableView and overrode drawBackgroundInClipRect:. It gets the background color from the delegate through a call to tableView:backgroundColorForRow:. To leave the background color at the default, the delegate simply returns nil.

Here's the header (including a protocol that the delegate can conform to):


    
@interface General/RowColorTableView : General/NSTableView {
	BOOL delegateRespondsToBackgroundColorForRow;
}

@end

@protocol General/RowColorTableViewDelegate <General/NSObject>
- (General/NSColor *)tableView:(General/RowColorTableView *)aTableView backgroundColorForRow:(General/NSInteger)rowIndex;
@end


and the implementation:

    
#import "General/RowColorTableView.h"

@implementation General/RowColorTableView

- (void)awakeFromNib {
	delegateRespondsToBackgroundColorForRow = General/self delegate] respondsToSelector:@selector(tableView:backgroundColorForRow:)];
}

- (void)drawBackgroundInClipRect:([[NSRect)clipRect {
	//First draw default background
	[super drawBackgroundInClipRect:clipRect];
	
	if (delegateRespondsToBackgroundColorForRow) {
		//Now draw custom background where necessary
		General/NSRange rowRange = [self rowsInRect:clipRect];
		for (int rowIndex=rowRange.location; rowIndex<rowRange.location + rowRange.length; rowIndex++) {
			General/NSColor *bgndColor = General/self delegate] tableView:self backgroundColorForRow:rowIndex];
			if (bgndColor) {
				[bgndColor set];
				[[[NSBezierPath fillRect:[self rectOfRow:rowIndex]];
			}
		}
	}
}

@end


-General/SteveNicholson