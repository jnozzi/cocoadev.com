

I have an instance General/NSView subclass that has many various subviews within it. I'd like that instance to receive all mouse left-click events first, so I tried the following code:

    - (BOOL)acceptsFirstMouse:(General/NSEvent *)theEvent {
   return YES;
}

- (void)mouseDown:(General/NSEvent *)theEvent {
   General/NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
   if([theEvent type] == General/NSLeftMouseUp) {
      General/NSLog(@"Click message");
   } else {
      General/NSLog(@"Other message");
   }
}

However, I only get an "Other message" when I click in a General/NSTextField subview. Am I missing a step here?

-- General/RyanGovostes

----

*I do believe there is a special event for right mouse down.*

I was looking for the left mouse button, though.

----

If your subviews implement mouseDown:, they will intercept the event and you will never see it.

I'm not sure of what a good way to do this would be. Perhaps override -hitTest: to return self, and then implement all mouse events to do your interception, then use     [super hitTest:] and pass the event on.

----

 In your subviews, implement General/self superview] mouseDown:event];

----

Also, the event passed into     mouseDown: will not have a type of     [[NSLeftMouseUp. It will probably have a type of     General/NSLeftMouseDown.

----

Oops, thanks for the catch. I would implement the     General/self superview] mouseDown:event]; for each subview, but I'd have to do a lot of subclassing of those, too. What about putting a see-through [[NSView subclass instance on the top and ordering everything below it, and then using this topmost view for click stuff?