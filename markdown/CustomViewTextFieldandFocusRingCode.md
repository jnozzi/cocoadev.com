
     
#import "General/KeyView.h"

@implementation General/KeyView

- (id)initWithFrame:(General/NSRect)frameRect
{
        [super initWithFrame:frameRect];
	return self;
}


-(void)dealloc {
	[nonVisibleDict release];
	[self release];
}

-(void)awakeFromNib {

	General/NSArray *keys=General/[NSArray arrayWithObjects:@"76",@"36",@"122",@"120",@"99",@"118",
@"96",@"97",@"98",@"100",@"101",@"109",@"103",@"111",
@"124",@"123",@"125",@"126",@"51",@"53",@"49",@"48",nil];
        General/NSArray *objects=General/[NSArray arrayWithObjects:@"Enter",@"Return",@"F1",@"F2",@"F3"
,@"F4",@"F5",@"F6",@"F7",@"F8",
@"F9",@"F10",@"F11",@"F12",@"Right Arrow",@"Left Arrow",@"Down Arrow",
@"Up Arrow",@"Delete",@"Escape",@"Space",@"Tab",nil];
        
        nonVisibleDict=General/[[[NSDictionary alloc] initWithObjects:objects forKeys:keys] retain];
}

- (BOOL) becomeFirstResponder
{
        isSelected=YES;
        [self setNeedsDisplay:YES];
        return YES;
   
}

- (BOOL)resignFirstResponder {
    isSelected=NO;
    [self setNeedsDisplay:YES];
    return YES;
}


- (void)drawRect:(General/NSRect)rect
{

        General/NSBezierPath *myPath=General/[NSBezierPath bezierPathWithRect:rect];
        General/[[NSColor whiteColor] set];
        [myPath fill];
    
       if ([viewString isEqualToString:@""] !=YES) {
            General/[[NSColor blackColor] set];
            [viewString drawAtPoint:General/NSMakePoint(7,General/NSMidY(rect)-8) withAttributes:nil];
        }	

        if (isSelected==YES && [myWindow isKeyWindow]) {
            General/NSSetFocusRingStyle(General/NSFocusRingOnly); 
            General/NSRectFill(rect);
            [self setKeyboardFocusRingNeedsDisplayInRect: rect];
        } else {
            myPath=General/[NSBezierPath bezierPathWithRect:rect];
            General/[[NSColor grayColor] set];
            [myPath stroke]; 
        }
    
}

- (BOOL)acceptsFirstResponder { 
    return YES;
} 

- (void)mouseDown:(General/NSEvent *)theEvent {
    isSelected=YES;
    [self setNeedsDisplay:YES];
}



- (void)keyDown:(General/NSEvent *)theEvent {
  if (isSelected=YES) {
        unichar myKeystroke = General/[[[NSApp currentEvent] charactersIgnoringModifiers]
characterAtIndex:0]; 
        myKeyCode = General/[[NSApp currentEvent] keyCode];
    
        [viewString release];
        
        if ([nonVisibleDict objectForKey:General/[[NSNumber numberWithInt:myKeyCode]
stringValue]] != nil) {
            viewString=General/[[NSString stringWithString:
[nonVisibleDict objectForKey:General/[[NSNumber numberWithInt:myKeyCode] stringValue]]] retain];
        } else {
            viewString=General/[[NSString stringWithFormat:@"%C",myKeystroke] retain];
        }
      
        
        [self setNeedsDisplay:YES]; 
     }

}

@end
 