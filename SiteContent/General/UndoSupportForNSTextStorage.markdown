The [[AppKit]] comes with undo support in the text system, but unfortunatly this support is provided by the [[NSTextView]] class, not the [[NSTextStorage]] class. Adding undo support to [[NSTextStorage]] would make it easier to support text undo in a number of cases... problem is the implementation.

Here is what I have so far. Seems to work for me on paper, but I'm doing something wrong and corupting the undo stack. The basic idea here is to commit partial edits (ones that might be merged with later edits) to a separate [[HBTextStorageEdit]] object. This is done so that I have a "handle" on these edits and can remove them from the undo stack when they need to be merged with later edits. When a situation arrises where the edits cannot be merged they are commited to the undo stack. By this "commit" I mean that the edits are placed on the undo stack with the [[NSTextStorage]] as the target, they won't be removed or merged with other edits after this commit.

So what do I need to do to get this thing working?

<code>

@interface [[HBTextStorage]] : [[NSTextStorage]] {
    [[NSMutableAttributedString]] ''_textContents;
    [[HBTextStorageEdit]] ''_editInProgress;
}

@end

@implementation [[HBTextStorage]]

- ([[NSString]] '')string {
    return [_textContents string];
}

- (void)addAttribute:([[NSString]] '')name value:(id)value range:([[NSRange]])aRange {
    [_textContents addAttribute:name value:value range:aRange]; // cover bug listed on cocoadev
}

- ([[NSDictionary]] '')attributesAtIndex:(unsigned)index effectiveRange:([[NSRangePointer]])aRange {
    return [_textContents attributesAtIndex:index effectiveRange:aRange];
}

- (void)setAttributes:([[NSDictionary]] '')attributes range:([[NSRange]])aRange {
    [[self textContents] setAttributes:attributes range:aRange];
    [self edited:[[NSTextStorageEditedAttributes]] range:aRange changeInLength:0];
}

- (void)replaceCharactersInRange:([[NSRange]])aRange withString:([[NSString]] '')aString {
    [[NSUndoManager]] ''undoManager = [self undoManager];
    [[NSRange]] insertedRange = [[NSMakeRange]](aRange.location, [aString length]);
    int origLen = [self length];
    BOOL commitThisChangeToUndoStack = NO;

    if ([undoManager isUndoing] || [undoManager isRedoing]) {
        [_editInProgress release];
        _editInProgress = nil;
        commitThisChangeToUndoStack = YES;
    } else {
        [undoManager removeAllActionsWithTarget:_editInProgress];

        // 1. try to merge changes with edit in progress
        if (![_editInProgress merge:aString range:aRange]) {

            // 2. commit current edit if can't merge
            [_editInProgress commitEditToUndoStack];
            [_editInProgress release];
            _editInProgress = nil;
            
            BOOL singleInsert = [[[HBTextStorageEdit]] isSingleCharInsert:aString range:aRange];
            BOOL singleDelete = [[[HBTextStorageEdit]] isSingleCharDelete:aString range:aRange];

            // 3. start new edit in progress
            if (singleInsert || singleDelete) {
                _editInProgress = [[[[HBTextStorageEdit]] alloc] 
                    initWithString:aString range:aRange target:self];
                [[undoManager prepareWithInvocationTarget:_editInProgress] undoEdit];

            // 4. commit edit
            } else {
                commitThisChangeToUndoStack = YES;
            }
        }

        if (_editInProgress) {
            [[undoManager prepareWithInvocationTarget:_editInProgress] undoEdit];
            [undoManager setActionName:[[NSLocalizedString]](@"Typing", @"")];
        }
    }

    if (commitThisChangeToUndoStack) {
        [[NSString]] ''replacedString = [[self string] substringWithRange:aRange];
        [[undoManager prepareWithInvocationTarget:self] 
            replaceCharactersInRange:insertedRange withString:replacedString];
        [undoManager setActionName:[[NSLocalizedString]](@"Typing", @"")];
    }
    
    [[self textContents] replaceCharactersInRange:aRange withString:aString];
    [self edited:[[NSTextStorageEditedCharacters]] range:aRange 
        changeInLength:[self length] - origLen];
}

@end

@interface [[HBTextStorageEdit]] : [[NSObject]] {
    [[HBTextStorage]] ''_target;
    [[NSRange]] _editRange;
    [[NSString]] ''_replacedString;
}

+ (BOOL)isSingleCharInsert:([[NSString]] '')edit range:([[NSRange]])range;
+ (BOOL)isSingleCharDelete:([[NSString]] '')edit range:([[NSRange]])range;

- (id)initWithString:([[NSString]] '')string range:([[NSRange]])range target:([[HBTextStorage]] '')target;
- (void)undoEdit;
- (void)commitEditToUndoStack;
- (BOOL)merge:([[NSString]] '')edit range:([[NSRange]])range;

@end

@implementation [[HBTextStorageEdit]]

+ (BOOL)isSingleCharInsert:([[NSString]] '')edit range:([[NSRange]])range {
    return range.length == 0 && [edit length] == 1;
}

+ (BOOL)isSingleCharDelete:([[NSString]] '')edit range:([[NSRange]])range {
    return range.length == 1 && [edit length] == 0;
}

- (id)initWithString:([[NSString]] '')string range:([[NSRange]])range target:([[HBTextStorage]] '')target {
    if (self = [super init]) {
        _target = target;
        _editRange.location = range.location;
    
        if (range.length == 0) {
            _editRange.length = 1;
            _replacedString = @"";
        } else {
            _editRange.length = 0;
            _replacedString = [[[target string] substringWithRange:range] retain];
        }
    }

    return self;
}

- (void)dealloc {
    [_replacedString release];
    [super dealloc];
}

- (void)undoEdit {
    [[_target undoManager] removeAllActionsWithTarget:self];
    [_target replaceCharactersInRange:_editRange withString:_replacedString];
}

- (void)commitEditToUndoStack {
    [[NSUndoManager]] ''undoManager = [_target undoManager];
    [[_target undoManager] removeAllActionsWithTarget:self];
    [[undoManager prepareWithInvocationTarget:_target] 
        replaceCharactersInRange:_editRange withString:_replacedString];
    [undoManager setActionName:[[NSLocalizedString]](@"Typing", @"")];
}

- (BOOL)merge:([[NSString]] '')edit range:([[NSRange]])range {
    int currentCursor = _editRange.location + _editRange.length;
    BOOL singleInsert = range.location == currentCursor 
                        && [[[HBTextStorageEdit]] isSingleCharInsert:edit range:range];
    BOOL singleDelete = range.location == currentCursor - 1 
                        && [[[HBTextStorageEdit]] isSingleCharDelete:edit range:range];

    if (singleInsert) {
        _editRange.length++;
        return YES;
    } else if (singleDelete) {
        if (_editRange.length > 0) {
            _editRange.length--;
        } else {
            [[NSString]] ''temp = [[_target string] substringWithRange:range];            
            [_replacedString autorelease];
            _replacedString = [[temp stringByAppendingString:_replacedString] retain];
            _editRange.location--;
        }
        return YES;        
    }

    return NO;
}

@end
(wrapped the code so that it won't force hugely wide paragraphs on this page)

</code>

[[JesseGrosjean]]
software(at)hogbay(dot)com

------

You want to be looking into 
http://developer.apple.com/techpubs/macosx/Cocoa/[[TasksAndConcepts]]/[[ProgrammingTopics]]/[[UndoArchitecture]]/index.html

There look for [[UndoGroups]] and be happy. :-)

I would (rather that looking at the previous event on the stack) determine which operations should start a new [[UndoGroup]] and then appropriately end the current [[UndoGroup]].

Just a thought,

[[KayRoepke]]

That's definitely the way to do it. -- [[KritTer]]

-------

If using the [[UndoGroup]] approach would I need to turn of setGroupsByEvent:? I would be a little worried about this approach (if i understand it correctly) since every char insert/delete would need to be placed on the undo stack. I'd like to have infinite undo and if you type for a few hours this could get expensive??? Hit me over the head with the don't optimize it stupid until you know its slow if appropriate.

My current approach (I?ll post some code tonight, but it's not quite working) is to have a new object called [[TextEditInProgress]]. For edits to the [[NSTextStorage]] that can be merged (contiguous single char insert/delete in my implementation) the undo target is set to be this [[TextEditInProgress]] object. For each new replaceCharactersInRange I

1. Remove the current [[TextEditInProgress]] from the undo stack using removeTarget:
2. See if the new change can be merged with the current [[TextEditInProgress]]
    - if yes
        merge changes and place [[TextEditInProgress]] back on undo stack. This means that the [[NSTextStorage]] is not the target of the undo, the [[TextEditInProgress]] is.
    - if no
        commit changes in [[TextEditInProgress]] to undo stack. This means put those changes on stack with [[NSTextStorage]] as target... so [[TextEditInProgress]] is no longer on the undo stack.

3. if appropriate for the current change (if it is a single char insert/delete) then creat a new [[TextEditInProgress]] and put it on undo stack. Else commit the inverse change to the undo stack, [[NSTextStorage]] as target.

4. Apply change to the [[NSTextStorages]] backing [[NSMutableAttributedString]].

Ok, that was probably very unclear, but maybe it gives you an idea of my current approach. The big point is it should avoid putting an invocation on the undo stack for each character typed, but it's not working yet, and who knows maybe it has some fundamental flaw that someone can point out to me.

Thanks for your comments,
[[JesseGrosjean]]

----

Ignoring the undo issue for a moment, I would like to remind our readership that the custom text storage subclass listed above is an excellent starting point for more sophisticated auto-formatting / auto-completion projects that tend to come up at the same tim as syntax coloring. See also [[ImplementSyntaxHighlighting]]. -- [[MikeTrent]]

----

I've added my current code to the top of this page.

----

This may be orthogonal to your needs, but I think one reason that people want undo in [[NSTextStorage]] is because they need to programmatically insert or change text and have it be able to be undone. I was struggling with the same problem, but then I found that the easiest solution was to keep the modification in [[NSTextView]] and just notify it to record the changes. Here's my code -- I do everything with attributed strings, so I added "-insertAttributedText:" and "-insertText:withAttributes:". To change/insert text I simply set the selection and call one of these methods.

<code>
@implementation [[MyTextView]]

-(void)insertAttributedText:([[NSAttributedString]]'')astring
{
    [[NSRange]] range = [self selectedRange];
    [[NSString]] ''insertingText = [astring string];
    [[NSString]] ''selectedText = [[self string] substringWithRange:range];
    [[NSString]] ''stringForDelegate = insertingText;
    
    // If only attributes are changing, pass nil.
    if ([insertingText isEqualToString:selectedText])
        stringForDelegate = nil;
    
    // Call delegate methods to force undo recording
    if ([self shouldChangeTextInRange:range
                    replacementString:stringForDelegate])
    {
        [[self textStorage] replaceCharactersInRange:range
                                withAttributedString:astring];
        [self setSelectedRange:
            [[NSMakeRange]](range.location+[astring length], 0)];
        [self didChangeText];
    }
}

-(void)insertText:([[NSString]]'')string withAttributes:([[NSDictionary]]'')attr
{
    [[NSAttributedString]] ''astring =
        [[[[NSAttributedString]] alloc] initWithString:string
                                        attributes:attr];
    [self insertAttributedText:astring];
    [astring release];
}

@end
</code>

The calls to -shouldChangeTextInRange:replacementString: and -didChangeText are sufficient to get the [[NSTextView]] to record the undo. Like I said, this may not be what you actually wanted :-) but it solved my problem. --[[DrewThaler]]

----

Though very rare, there are cases where there is no way around a custom implementation. One example is some structure in the text that covers deeper semantics and can not be represented by a plain attributed string without loosing that information at the same time. Thanks for the headstart, Jesse. --[[MaxSeelemann]]