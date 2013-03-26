
Hello,
I'm not sure if this is the right place to post but here goes(if it doesn't belong here I can delete the page). 
I have the headers(using class-dump)  of Mail.App 3.0 - i intend to write a plugin.
I managed one plugin, however while trying to write another imported this file "[[MessageContentController]].h" which has the following lines
<code>
#import "[[DocumentEditorManagingProtocol]].h"

@class [[ActivityMonitor]], [[AttachmentsView]], [[EmbeddedNoteDocumentEditor]], [[InvocationQueue]], Message, [[MessageHeaderDisplay]], [[MessageViewingState]], [[NSArray]], [[NSBox]], [[NSButton]], [[NSDictionary]], [[NSImageView]], [[NSLock]], [[NSMutableDictionary]], [[NSString]], [[NSTextField]], [[NSTimer]], [[NSView]], [[ObjectCache]], [[TextMessageDisplay]];

@interface [[MessageContentController]] : [[NSResponder]] <[[DocumentEditorManaging]]>
{
    Message ''_message;
    [[ActivityMonitor]] ''_documentMonitor;
    [[ActivityMonitor]] ''_urlificationMonitor;
    id <[[MessageContentDisplay]]> _currentDisplay;
    id <[[MessageContentDisplay]]> _threadDisplay;

</code>

Now, I don't have access to [[DocumentEditorManagingProtocol]].h nor the header declaring protocol [[MessageContentDisplay]] and [[XCode]] refuses to build (even when i removed the #import line)

Q: Is there a way to tell [[XCode]] to ignore the need for the protocol declaration (something like -undefined dynamic_lookup in linker flags, which I already have switched on)

Regards
Sapsi

Aah, include this line
@protocol [[DocumentEditorManaging]],[[MessageContentDisplay]];
Rgds
Sapsi