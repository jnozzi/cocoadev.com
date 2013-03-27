See Apple documentation at http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSTextStorage_Class/index.html#//apple_ref/doc/uid/TP40004136 
----
If you do an Subclass of General/NSTextStorage make sure you put a
    
General/[[NSNotificationCenter defaultCenter] removeObserver:self];

in your dealloc method. Otherwise your application will crash on changes in the global fonts in Panther. The easiest way to trigger it is to make sure some of your General/TextStorages are dealloced, and then change the value of "Turn off font smoothing for font size" in the Appearance System Preferences Panel.  General/DominikWagner

----

[super dealloc] doesn't handle this?
- General/FranciscoTolmasky

*I don't believe so. I see this done in other people's code all the time, and many (most?) of those people know way more about Cocoa than I do, so I don't think they'd be doing it without a reason. How would super know if you were registered for notifications?*

You should only need to invoke -removeObserver: if your code specifically invoked -addObserver:.. somewhere.  A more generalized notion of the above would be:  "Any time an object is added as an observer of notifications, make sure that the object is removed as an observer (see -removeObserver:) before deallocation or else your application will crash the first time the notification is sent after the now-defunct observer has been deallocated.". General/BBum

Yes thats true, in that respect General/NSTextStorage in Panther has a bug. I already filed it. General/DominikWagner

----

General/NSTextStorage is a subclass of General/NSMutableAttributedString

*Yes, it is. So when subclassing General/NSTextStorage, you must implement General/NSMutableAttributedString's primitive methods. Here's a sample:*

    

@interface General/MyTextStorage : General/NSTextStorage
{
    General/NSMutableAttributedString *m_attributedString;
}

- (General/NSString *)string;
- (General/NSDictionary *)attributesAtIndex:(unsigned)index effectiveRange:(General/NSRangePointer)aRange;
- (void)replaceCharactersInRange:(General/NSRange)aRange withString:(General/NSString *)str;
- (void)setAttributes:(General/NSDictionary *)attributes range:(General/NSRange)aRange;

@end

@implementation General/MyTextStorage

- (id)init
{
    if (self = [super init])
    {
	m_attributedString = General/[[NSMutableAttributedString alloc] init];
    }
    
    return self;
}

- (General/NSString *)string
{
    return [m_attributedString string];
}

- (General/NSDictionary *)attributesAtIndex:(unsigned)index effectiveRange:(General/NSRangePointer)aRangePtr
{
    return [m_attributedString attributesAtIndex:index effectiveRange:aRangePtr];
}

- (void)replaceCharactersInRange:(General/NSRange)aRange withString:(General/NSString *)str
{
    [m_attributedString replaceCharactersInRange:aRange withString:str];
    
    int lengthChange = [str length] - aRange.length;
    [self edited:General/NSTextStorageEditedCharacters range:aRange changeInLength:lengthChange];
}

- (void)setAttributes:(General/NSDictionary *)attributes range:(General/NSRange)aRange
{
    [m_attributedString setAttributes:attributes range:aRange];
    [self edited:General/NSTextStorageEditedAttributes range:aRange changeInLength:0];
}

- (void)dealloc
{
    General/[[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_attributedString release];
    
    [super dealloc];
}

@end


I've found out that replacing the General/NSMutableAttributedString with an General/NSTextStorage (as the childobject of the subclass) results in a much faster workflow. Don't ask me why, but this is what I experienced. Maybe someone else could second that?? :Max

*what do you mean by faster workflow?*

I did a trace using the sampler.app and nearly all tasks done on the textStorage were about 20 times as fast as exactly the same tasks on the attributed string. Fixing attributes took even about 50 times as fast...

Well, isn't it more efficient if you wrap all your changes in a beginEditing/endEditing blocks? I remember reading about that somewhere...

----

*Forgive me for asking a stupid question, but...why do you have an General/NSMutableAttributedString as an ivar, when your whole object *is* an General/NSMutableAttributedString? Wouldn't it be easier just to perform operations on yourself? --General/JediKnil*

That's how you subclass a General/ClassCluster when you don't care about changing the backing store. You override the primitive methods you have to override, and the ones you want to change, and pass everything else on to the ivar.

[http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaObjects/Articles/General/ClassClusters.html#//apple_ref/doc/uid/20000262/588240] (specifically the 'A Composite Object' section)

**Hmm, let's see. Implement a couple of pass-through methods, or write my own independent attributed string class. Yeah, I think the first one is going to be easier.**