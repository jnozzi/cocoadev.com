Here's some simple code to save and restore the position of an General/NSSplitView (which unfortunately don't save their position). You can call these from your window controller's awakeFromNib/windowDidLoad and termination code.

    @interface General/NSSplitView (Defaults)
    
    - (void) saveLayoutWithName: (General/NSString *) defaultName;
    - (void) loadLayoutWithName: (General/NSString *) defaultName;
    
    @end
    
    @implementation NSSplitView (Defaults)
    
    - (void) saveLayoutWithName: (General/NSString *) defaultName
    {
        General/NSMutableArray *rectstrs = General/[NSMutableArray array];
        for (General/NSView *view in self.subviews)
            [rectstrs addObject: General/NSStringFromRect(view.frame)];
        General/[[NSUserDefaults standardUserDefaults] setObject: rectstrs forKey: defaultName];
    }
    
    - (void) loadLayoutWithName: (General/NSString *) defaultName
    {
        General/NSMutableArray *rectstrs = General/[[NSUserDefaults standardUserDefaults] objectForKey: defaultName];
        if (rectstrs == nil) return;
    
        for (General/NSView *view in self.subviews) {
            view.frame = General/NSRectFromString([rectstrs objectAtIndex:0]);
            [rectstrs removeObjectAtIndex:0];
        }
        
        [self adjustSubviews];
    }
    
    @end

----

Too much work to change, easier to rewrite. This also handles collapsed views:

*This only sort of handles collapsed views.  "Collapsed" state is different from just zero height (or width).  In a freshly loaded layout with this code, no subview will report YES for -[splitView isSubviewCollapsed:subview].*

    @interface General/NSSplitView (General/CCDLayoutAdditions)
    
    - (void)storeLayoutWithName: (General/NSString*)name;
    - (void)loadLayoutWithName: (General/NSString*)name;
    
    @end    
    
    @implementation General/NSSplitView (General/CCDLayoutAdditions)
    
    - (General/NSString*)ccd__keyForLayoutName: (General/NSString*)name
    {
    	return General/[NSString stringWithFormat: @"General/CCDNSSplitView Layout %@", name];
    }
    
    - (void)storeLayoutWithName: (General/NSString*)name
    {
    	General/NSString*		key = [self ccd__keyForLayoutName: name];
    	General/NSMutableArray*	viewRects = General/[NSMutableArray array];
    	General/NSEnumerator*	viewEnum = General/self subviews] objectEnumerator];
    	[[NSView*			view;
    	General/NSRect			frame;
    	
    	while( (view = [viewEnum nextObject]) != nil )
    	{
    		if( [self isSubviewCollapsed: view] )
    			frame = General/NSZeroRect;
    		else
    			frame = [view frame];
    			
    		[viewRects addObject: General/NSStringFromRect( frame )];
    	}
    	
    	General/[[NSUserDefaults standardUserDefaults] setObject: viewRects forKey: key];
    }
    
    - (void)loadLayoutWithName: (General/NSString*)name
    {
    	General/NSString*		key = [self ccd__keyForLayoutName: name];
    	General/NSMutableArray*	viewRects = General/[[NSUserDefaults standardUserDefaults] objectForKey: key];
    	General/NSArray*		views = [self subviews];
    	int				i, count;
    	General/NSRect			frame;
    		
    	count = MIN( [viewRects count], [views count] );
    	
    	for( i = 0; i < count; i++ )
    	{
    		frame = General/NSRectFromString( [viewRects objectAtIndex: i] );
    		if( General/NSIsEmptyRect( frame ) )
    		{
    			frame = General/views objectAtIndex: i] frame];
    			if( [self isVertical] )
    				frame.size.width = 0;
    			else
    				frame.size.height = 0;
    		}
    			
    		[[views objectAtIndex: i] setFrame: frame];
    	}
    }
    
    @end

----

I've got code similar to ones above that set the position of a split view. Now this works fine for a normal split view, but for a split view inside another split view, this doesn't work. Can anyone see why it might not work? I've tried using     setNeedsDisplay: and     adjustSubviews but neither worked. Thanks.

    - (void)setPositionUsingAutosaveName:([[NSString *)name
    {
    	General/NSArray *s = General/[[NSUserDefaults standardUserDefaults] objectForKey:name];;
    	if (s == nil || [s isKindOfClass:General/[NSArray class]] == NO)
    		return;
    	
    	General/NSArray *subviews = [self subviews];
    	int i;
    	for (i=0; i<[subviews count] && i<[s count]; i++)
    	{
    		General/NSRect newRect = General/NSRectFromString([s objectAtIndex:i]);
    		[[subviews objectAtIndex:i] setFrame:newRect];
    	}
    }