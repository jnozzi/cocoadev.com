I have a document based Cocoa app created in PB and I would like to set the delegate for the shared General/NSSavePanel the entire application uses. 

I'm assuming that the General/NSSavePanel returned from:
    

General/[NSSavePanel savePanel] 


will be the shared General/NSSavePanel (the documentation says this is the case), but when I try to set the savePanel delegate to the window controller, the window controller does not receive delegate messages. 

The documentation also states that General/NSSavePanel will check to make sure that all the delegate methods are implemented before changing where the delegate instance points to, so I made sure that all methods are implemented.

    
- (General/NSComparisonResult)panel:(id)sender compareFilename:(General/NSString *)fileName1 with:(General/NSString *)fileName2 caseSensitive:(BOOL)flag {
    General/NSLog(@"fileName1: %@ fileName: %@", fileName1, fileName2);
    return [fileName1 compare:fileName2];
}
- (BOOL)panel:(id)sender isValidFilename:(General/NSString *)filename {
    General/NSLog(@"savePanel isValidFilename: filename: %@", filename);
    return YES;
}
- (BOOL)panel:(id)sender shouldShowFilename:(General/NSString *)filename {
    General/NSLog(@"savePanel shouldShowFilename: filename: %@", filename);
    return YES;
}
- (General/NSString *)panel:(id)sender userEnteredFilename:(General/NSString *)filename confirmed:(BOOL)okFlag {
    General/NSLog(@"savePanel filename: %@", filename);
    return filename;
}
- (void)panel:(id)sender willExpand:(BOOL)expanding {
}


when I build/run the app nothing gets logged by the savePanel delegate when I save a document. I set the savePanel delegate by overriding the General/NSDocument saveDocument: method. 

    
-(void)saveDocument:(id)sender {
    id savePanel=General/[NSSavePanel savePanel];
    [savePanel setDelegate:windowController];
    General/NSLog(@"saveDocument: savePanelDelegate: %@ savePanel: %@", General/savePanel delegate] description], [savePanel description]);
    [super saveDocument:sender];
}
- ([[NSData *)dataRepresentationOfType:(General/NSString *)aType {
    General/NSLog(@"dataRep: savePanelDelegate: %@", General/[[[NSSavePanel savePanel] delegate] description]);
    return docData;
}


the following gets logged when I run and save a document:

2002-12-19 09:56:54.675 General/DocApp[4901] saveDocument: savePanelDelegate: <General/MyWindowController: 0x19800c0> savePanel: <General/NSSavePanel: 0x1a14550>

2002-12-19 09:56:59.606 General/DocApp[4901] dataRep: savePanelDelegate: (null)

If you notice the savePanel delegate was successfully changed to the window controller (General/MyWindowController), but the savePanel delegate is set back to null by the time the document is asked to return the data that needs to be saved.

the application state is:

window delegate = window controller
General/NSApp delegate = document controller

any ideas what I'm doing wrong?

----

General/[NSSavePanel savePanel] sets the shared save panel to all default values every time it's called, including having no delegate.  If you want to set the delegate, you need to call setDelegate: between when  +savePanel and -runModal are called.  See the docs for + (General/NSSavePanel*)savePanel for a full listing of the default values used.

For an General/NSDocument, you should override prepareSavePanel: if you want to always have the same delegate for your save panel.  Something like this:

    
- (BOOL)prepareSavePanel:(General/NSSavePanel*)inSavePanel
{
    [inSavePanel setDelegate:windowController];
    return YES;
}


Also, you do not need to implement all the delegates, just the ones you want to do something during.  By 'checking', it means that the save panel checks if the particular delegate method exists, and if it doesn't, doesn't try to call it.