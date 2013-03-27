In order to receive Key and Mouse events  an object must implement the following methods:

    

- (BOOL)acceptsFirstResponder
{
General/NSLog(@"Accepts First Responder");

return YES;

}

- (BOOL)becomeFirstResponder
{
General/NSLog(@"Become First Responder");

return YES;

}
- (BOOL)resignFirstResponder
{
General/NSLog(@"Resigns First Responder");
return YES;
}


By overriding     acceptsFirstResponder, you are telling other objects that your General/NSView subclass can handle key events and action messages. This same method returns NO inside the General/NSResponder class. That is why you need to override it to return YES. In object-oriented programming, a subclass inherits all methods in its superclass. The General/NSView class is a subclass of General/NSResponder so it inherits the "acceptsFirstResponder" method that returns NO. Your subclass would also inherits this method, but because you specified the "acceptsFirstResponder" method in your own class, it will use your method instead of inheriting it from General/NSView.

-- General/RyanBates