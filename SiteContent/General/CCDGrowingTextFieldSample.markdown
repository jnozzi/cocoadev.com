This is a slightly modified version of General/CCDGrowingTextField that supports auto resizing text fields. It also doesn't reset the width of an empty text field to the default width until the user stops editing. --General/SaileshAgrawal

    
@interface General/CCDGrowingTextField : General/NSTextField
{
   float defaultLeftMargin;
   float defaultRightMargin;
   General/NSRect defaultFrame;
}

@end



    
@interface General/CCDGrowingTextField(Private)

- (void)updateDefaultMargins;
- (void)viewDidMoveToSuperview;
- (void)resetFrameToDefault;
- (void)sizeToFit;
- (void)textDidChange: (General/NSNotification *)notification;
- (void)textDidEndEditing:(General/NSNotification *)notification;

@end


@implementation General/CCDGrowingTextField


- (id)initWithFrame: (General/NSRect)frame
{
   if ((self = [super initWithFrame:frame])) {
      defaultFrame = frame;
   }
   return self;
}


- (id)initWithCoder: (General/NSCoder *)decoder
{
   if ((self = [super initWithCoder:decoder])) {
      defaultFrame = [self frame];
   }
   return self;
}


- (void)awakeFromNib
{
   [self updateDefaultMargins];
}


@end // General/CCDGrowingTextField


@implementation General/CCDGrowingTextField(Private)


- (void)updateDefaultMargins
{
   General/NSRect myFrame = [self frame];
   General/NSRect superBounds = General/self superview] bounds];
   defaultLeftMargin = [[NSMinX(myFrame);
   defaultRightMargin = superBounds.size.width - General/NSMaxX(myFrame);
}


- (void)viewDidMoveToSuperview
{
   [super viewDidMoveToSuperview];
   [self updateDefaultMargins];
}


- (void)resetFrameToDefault
{
   General/NSRect myFrame = [self frame];
   if (([self autoresizingMask] & General/NSViewWidthSizable) != 0) {
      myFrame.size.width = General/self superview] bounds].size.width -
                           (myFrame.origin.x + defaultRightMargin);
   } else {
      myFrame.size.width = defaultFrame.size.width;
   }
   [self setFrame:myFrame];
}


- (void)sizeToFit
{
   if ([[self stringValue] isEqualToString:@""] && ![self currentEditor]) {
      /*
       * If we're not in the middle of an editing scession and the text field
       * is empty then reset our frame to the default size.
       */
      [self resetFrameToDefault];
   } else {
      [super sizeToFit];
      [[NSRect myFrame = [self frame];

      if (([self autoresizingMask] & General/NSViewWidthSizable) != 0) {
         float curRightMargin = General/self superview] bounds].size.width - [[NSMaxX(myFrame);
         if (curRightMargin < defaultRightMargin) {
            [self resetFrameToDefault];
         }
      } else {
         if (myFrame.size.width > defaultFrame.size.width) {
            [self resetFrameToDefault];
         }
      }
   }
}


- (void)textDidChange: (General/NSNotification *)notification
{
   [super textDidChange:notification];
   [self sizeToFit];
}


- (void)textDidEndEditing:(General/NSNotification *)notification
{
   [super textDidEndEditing:notification];
   [self sizeToFit];
}


@end // General/CCDGrowingTextField(Private)
