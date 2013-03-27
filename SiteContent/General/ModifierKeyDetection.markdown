Hey

Was wondering if there is a way to determine if a key , based on its virtual key code is a modifier key. E.g. I have the virtual key code for shift, I put it through General/UCKeyTranslate and I get back the wrong character. I understand that I need to map these myself, but is there a quick way to determine which keys are modifier keys without simply making a large switch case statement?

Thanks

----

That's a Carbon question, not a Cocoa question. However, if all you need to do is tell if a modifier key is currently being pressed, you can try -General/[NSEvent modifierFlags]. If you need to use Carbon specifically, try General/GetCurrentKeyModifiers() or General/GetCurrentEventKeyModifiers().