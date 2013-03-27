There is General/NSCarriageReturnCharacter, there is General/NSUpArrowFunctionKey but you won't find an according key for the Escape key on your keyboard.

But after some searching on Google I found out that it's 27. So if you want to catch the escape key being pressed in your view, do this:

    
- (void)keyDown:(General/NSEvent *)theEvent
{
    unichar key = General/theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == 27)
    {
        [[NSLog(@"Escape Key Pressed");
    }
}


Hope this helps. Tested it on my PPC and it worked like expected.

Regards,

--General/MatthiasGansrigler

----

Or you can just use '\e'.

----
D'oh!

----
Depending why you are trying to detect the escape key, you are probably better off using General/NSResponder's cancelOperation: method
----
What would be the appropriate key for the Del key (Note: not the backspace key, but the del key) on the keyboard? General/NSDeleteCharacter doesn't work for me...

----

Try General/NSDeleteFunctionKey.