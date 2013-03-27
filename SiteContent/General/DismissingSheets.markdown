When I saw the following     General/[NSApp beginSheet:mySheet modalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil]; My sheet pops right up.  But when I click my button on the sheet, which is wired up to a dimiss method, nothing I seem to do makes the sheet go away.  Does anyone know how to dismiss sheets? (I tried, General/[NSApp endSheet:mySheet] but that doesn't seem to help)

----

Did you try 
    
General/[NSApp endSheet:mySheet];
[mySheet orderOut:nil]
