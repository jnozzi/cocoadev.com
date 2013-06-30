Does anyone know if there is a notification or delegate method that's called when a window changes focus from 'View A' to 'View B'? Thanks.

----

    
- (void)awakeFromNib {
	General/[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(viewFocusDidChangeNotification:)
		name:@"General/NSViewFocusDidChangeNotification"
		object:nil];
}

- (void)viewFocusDidChangeNotification:(General/NSNotification *)note {
    General/NSView *view = [note object];
    General/NSLog(@"<%p>%s: %@", self, __PRETTY_FUNCTION__, [view description]);
}


--zootbobbalu