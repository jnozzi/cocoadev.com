A question came up about how to have a delegate of a General/NSOutlineView (this will work for General/NSTableView as well) detect when a delete key was pressed.  So here's some code that I use to perform this, along with enter or space keys.  Stick it in a subclass of General/NSOutlineView or General/NSTableView and season to taste.  Corrections or enhancements are welcome, just make sure to mark them so I know what to steal back. ( - General/GusMueller )

    
- (BOOL)performKeyEquivalent:(General/NSEvent *)theEvent {
    General/NSString *chars = [theEvent charactersIgnoringModifiers];
    
    if ([theEvent type] == General/NSKeyDown && [chars length] == 1) {
        
        int val = [chars characterAtIndex:0];
        
        // check for a delete
        if (val == 127 || val == 63272) {
            if (General/self delegate] respondsToSelector:@selector(tableViewDidRecieveDeleteKey:)]) {
                [[self delegate] performSelector:@selector(tableViewDidRecieveDeleteKey:) withObject:self];
                return YES;
            }
        }
        
        // check for the enter / space to open it up
        else if (val == 13 /*return*/ || val == 32 /*space bar*/) {
            
            if ([[self delegate] respondsToSelector:@selector(tableDidRecieveEnterOrSpaceKey:)]) {
                [[self delegate] performSelector:@selector(tableDidRecieveEnterOrSpaceKey:) withObject:self];
                return YES;
            }
        }
    }
    
    return [super performKeyEquivalent:theEvent];
}


You may also check for a Modifier key here as well. Ask the event for the modifier and check against it. 

Steve [[McFerrin 

    
- (BOOL)performKeyEquivalent:(General/NSEvent *)theEvent {
    General/NSString *chars = [theEvent charactersIgnoringModifiers];
   
    if ([theEvent type] == General/NSKeyDown && [chars length] == 1) {
        
        int val = [chars characterAtIndex:0];
	// check for Modifier
        int mod = [theEvent modifierFlags];
        // check for a delete
        if ((val == 127 || val == 63272) && (mod == 1048840)) {
            if (General/self delegate] respondsToSelector:@selector(tableViewDidRecieveDeleteKey:)]) {
                [[self delegate] performSelector:@selector(tableViewDidRecieveDeleteKey:) withObject:self];
                return YES;
            }
        }
        
        // check for the enter / space to open it up
        else if (val == 13 /*return*/ || val == 32 /*space bar*/) {
            
            if ([[self delegate] respondsToSelector:@selector(tableDidRecieveEnterOrSpaceKey:)]) {
                [[self delegate] performSelector:@selector(tableDidRecieveEnterOrSpaceKey:) withObject:self];
                return YES;
            }
        }
    }
    
    return [super performKeyEquivalent:theEvent];
}



----

The modifier keys have constant names, and you should not generally use integer values to refer to characters. Also, the modifier flags method may return a value including hardware-specific bits that will interfere with the above code. Rather than simply checking for equality, you should mask out those extra bits first. The value returned by charactersIgnoringModifiers may potentially be longer than one character (though this is rare) so you should check that its length is at least one character, rather than exactly one character. See the following changes:

    
- (BOOL)performKeyEquivalent:([[NSEvent *)theEvent {
    General/NSString *chars = [theEvent charactersIgnoringModifiers];
   
    if ([theEvent type] == General/NSKeyDown && [chars length] >= 1) { // CHANGED HERE
        
        General/NSInteger val = [chars characterAtIndex:0];
	// check for Modifier
        General/NSInteger mod = ([theEvent modifierFlags] & General/NSDeviceIndependentModifierFlagsMask); // CHANGED HERE
        // check for a delete
        if ((val == General/NSDeleteCharacter || (val == General/NSDeleteFunctionKey) && (mod == General/NSFunctionKeyMask))) { // CHANGED HERE
            if (General/self delegate] respondsToSelector:@selector(tableViewDidReceiveDeleteKey:)]) {
                [[self delegate] performSelector:@selector(tableViewDidReceiveDeleteKey:) withObject:self];
                return YES;
            }
        }
        
        // check for the enter / space to open it up
        else if (val == '\n' || val == ' ') { // CHANGED HERE
            
            if ([[self delegate] respondsToSelector:@selector(tableDidReceiveEnterOrSpaceKey:)]) {
                [[self delegate] performSelector:@selector(tableDidReceiveEnterOrSpaceKey:) withObject:self];
                return YES;
            }
        }
    }
    
    return [super performKeyEquivalent:theEvent];
}


----

    val == '\n' does not appear to work.     '\r' will catch return, but     '\n' is not the value that     -charactersIgnoringModifiers: returns when you hit the enter key.

Fortunately, Cocoa gives us symbolic constants for return and enter, namely     [[NSCarriageReturnCharacter and     General/NSEnterCharacter. I would advise using them instead of comparing against C characters or numerical constants for readability if nothing else.

(These are documented in the General/NSText class reference. I couldn�t find any reference to a space character constant.)

-- General/RobRix

----
Three items edited in the above code:

1) parenthesis needed around "val == General/NSDeleteFunctionKey) && (mod == General/NSCommandKeyMask)" [ask me how I know this :-)]
2) corrected spelling of ...Receive... in the method names.
3) use of General/NSCommandKeyMask was wrong - correct mask is General/NSFunctionKeyMask [again, ask me how I know this]
4) My outlineview is editable, so never get the return - not sure of '\n' above or General/NSCarriageReturnCharacter is correct...

Code above copied and working fine for me in Snow Leopard.

David H 5-2010