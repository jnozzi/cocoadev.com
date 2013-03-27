{{#Del:}}




General/NSSplitView has been improved with Leopard 10.5. To implement a resize control (like the one at the bottom of the General/MailStyleNSSplitview page), you'll need to set the delegate for the General/NSSplitView and then implement the following method in your delegate:

    

-(General/NSView* )resizeView {
  // TODO: return the view which contains the resize control
}

-(General/NSView* )splitView {
  // TODO: return the split view
}

-(void)awakeFromNib {
  General/self splitView] setDelegate:self];
}

-([[NSRect)splitView:(General/NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(General/NSInteger)dividerIndex {
  return General/self resizeView] convertRect:[[self resizeView] bounds] toView:splitView]; 
}



- [[DavidThorpe