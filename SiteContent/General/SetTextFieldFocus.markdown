

Hi,

I have bound an General/IBAction method to check if the value inside a General/NSTextField is "valid" (as in if it's unique). If it's not unique a General/NSAlert is sent and then I would like to set the focus back to the original textfield.

I've searched and found that the proper way is to go General/self window] makeFirstResponder: txtMarkerName]; and this works as long as you press "enter" to validate (meaning focus is returned to the desired textfield) but if you press the tab key then focus is moved to the next text field (even though the value was invalid). So how do I actually force it to go to a certain textfield regardless of if I press enter or tab before?

    
- ([[IBAction) SMTag_EndEditing: (id) poSender {
    if (![_oController tagIsUnique: [_oMarker sTag]]) { 
        //Non Unique Tag
        General/NSAlert *loAlert = General/[[[NSAlert alloc] init] autorelease];
        [loAlert setAlertStyle: General/NSCriticalAlertStyle];
        [loAlert setMessageText: @"Names must be unique"];
        [loAlert setInformativeText: @"Sorry, there already is another marker with the same name. Please choose another name."];
        [loAlert runModal];
        
        General/self window] makeKeyAndOrderFront: nil];

        if([[self window] makeFirstResponder: [[SMTag]) {
            General/NSLog(@"Set focus to tag field"); //This always gets called even when we press the tab key but with the tab key it skips to the next field.
        } else {
            General/NSLog(@"Can't set focus");
        }

        General/[SMTag selectText: poSender ]; //Select the text to highlight what needs to be changed.
    }    
}


Any suggestions as to what I might be able to do?