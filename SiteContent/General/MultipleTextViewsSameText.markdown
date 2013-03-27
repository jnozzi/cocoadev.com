

Displaying the same text in multiple text views is as easy as replacing the text storage object of a text view with a shared     General/NSTextStorage object.

    
@interface General/MyDocument : General/NSDocument {
    General/IBOutlet General/NSTextView *topTextView, *bottomTextView;
}
@end


in your document implementation...

    
- (id)init {

    if (self = [super init]) {
        storage = General/[[NSTextStorage alloc] init];
    }
    return self;

}

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType {

    General/NSString *string = General/[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (string) {
        [storage setAttributedString:General/[[[NSAttributedString alloc] initWithString:string] autorelease]];
        return YES;
    }
    return NO;

}

- (void)windowControllerDidLoadNib:(General/NSWindowController *)aController {

    [super windowControllerDidLoadNib:aController];
    if (storage) {
        [[[topTextView textContainer] layoutManager] replaceTextStorage:storage];
        [[[bottomTextView textContainer] layoutManager] replaceTextStorage:storage];
    }

}

- (void)dealloc {

    [storage release];
    [super dealloc];

}


The nice thing about this is the undo manager will share the same target for edits performed in either view (don't forget to check "Undo Allowed" in IB for     topTextView and     bottomTextView). --zootbobbalu