I am attempting  to forward the message drawRect: on an General/NSView subclass to another selector on the same object, but my implementation is not working.  Apparently the drawRect: message is being called in some special way.  If I call it myself I get the forwarding I expect.  But if It gets called by the application it's in. (to actually draw) the forwarding is not invoked and I end up with an General/NSView drawRect:..  (I don't see "my drawrect" get logged)  here's an example:

I have confirmed by category on General/NSObject that instanceMethodForSelector: and methodForSelector: are not being used to retrieve drawRect:
So, there must be some other way that Cocoa is looking up drawRect on my General/NSView subclass and ignoring my forwarding...
any ideas?

----

I'll give you odds that it's calling it on General/NSView rather than your subclass. You won't receive -forwardInvocation: messages when a superclass implements the message. It makes -forwardInvocation: a little weak to rely on since any old category on General/NSObject can add methods...

----

    

- (void)__ac_hiding_drawRect:(General/NSRect)rect {
    General/NSLog(@"my drawrect");
    [super drawRect: rect];
}

-(General/NSMethodSignature*) methodSignatureForSelector: (SEL) aSelector {
    General/NSLog(@"method sig %s", aSelector);
    //newSig = aSelector prepended with __ac_hiding_
    SEL newSig = sel_registerName(
        General/[[NSString stringWithFormat: @"__ac_hiding_%s", aSelector] cString]);
    //see if there is a hidding method with this selector
    if ([self respondsToSelector: newSig]){
        //return the signature of the hiding method
	return [super methodSignatureForSelector: newSig];
    }else{
	return [super methodSignatureForSelector: aSelector];
    }
}

-(void) forwardInvocation: (General/NSInvocation *) anInvocation{
    General/NSLog(@"forwarding");
    SEL oldInvoke = [anInvocation selector];
    //newInvoke = oldInvoke prepended with __ac_hiding_
    SEL newInvoke = sel_registerName(
        General/[[NSString stringWithFormat: @"__ac_hiding_%s", oldInvoke] cString]);
    //see if there is a hidding method with this selector
    //if so, perform advice
    if ([self respondsToSelector: newInvoke]){
        [anInvocation setSelector: newInvoke];
	General/NSLog(@"before %s",newInvoke);
	[anInvocation invoke];
	General/NSLog(@"after %s",newInvoke);
    }else{
	[super forwardInvocation: anInvocation];
    }
}

