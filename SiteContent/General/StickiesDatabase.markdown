Does anybody know how to open up the ~/Library/[[StickiesDatabase]] file and work with it? I tried [[NSUnarchiver]], couldn't get that to work. Anybody have an idea? It looks like sometype of [[NSArray]] is in there but I don't know how to get it out.

----

It sure looks like an [[NSArchiver]] file; the only hold-up is that it seems to use a class named Document (no relation to [[NSDocument]]), so you'll need to either provide a Document class or use decodeClassName:asClassName: to substitute yours in.  It appears to have only a single encoded object within the Document class, an [[NSData]] object that seems to hold a serialized [[NSFileWrapper]] (probably using it's serializedRepresentation and initWithSerializedRepresentation: methods).  Once you get the [[NSFileWrapper]], you can use its -writeToFile:atomically: method to write it out as a directory and see what's in it.  -- Bo

PS A super quick Document class to illustrate what you need.  Not tested in the slightest, caveat emptor, etc.:
<code>
@interface Document : [[NSObject]] <[[NSCoding]]>
{
	[[NSFileWrapper]]'' fw;
}
@end

@implementation Document
- (void)encodeWithCoder:([[NSCoder]]'')inCoder
{
	[inCoder encodeObject:[fw serializedRepresentation]];
}
- (id)initWithCoder:([[NSCoder]]'')inCoder
{
	if (self = [super init]) {
		[[NSData]]'' dat = [inCoder decodeObject];
		fw = [[[[NSFileWrapper]] alloc] initWithSerializedRepresentation:dat];
	}
	return self;
}
@end
</code>

----

Ok thanks. I also just parsed through it as a string using some delimiters. Pretty cheap, but it worked :)

----

It appears that it has changed on OS X 10.3. It no longer uses an [[NSFileWrapper]] but 

<code>
typedef enum {
	[[YellowStickie]]=0,
	[[BlueStickie]],
	[[GreenSticke]],
	[[PinkSticke]],
	[[PurpleSticke]],
	[[GreySticke]]
} [[StickieColor]];

@interface Document: [[NSObject]] <[[NSCoding]]>
{
	[[NSMutableData]] ''rtf; // RTF file
	[[NSRect]] location;	// screen location
	int flag;			// ??
	[[NSDate]] ''created;	// created
	[[NSDate]] ''changed;	// last change
	[[StickieColor]] color; // color code
}
</code>

-- hns http://www.dsitri.de

----

could the <code>flag</code> var be for the collapsed/expanded state of the stickie?

----

I'm very interested in making a full [[StickiesDatabase]] parser. Here's what [[ClassDump]] outputs for Stickies 4.2:

<code>
@interface Document : [[NSObject]] <[[NSCoding]]>
{
    int mWindowColor;
    int mWindowFlags;
    struct _NSRect mWindowFrame;
    [[NSData]] ''mRTFDData;
    [[NSDate]] ''mCreationDate;
    [[NSDate]] ''mModificationDate;
}

- (id)init;
- (void)dealloc;
- (id)initWithCoder:(id)fp8;
- (id)initWithData:(id)fp8;
- (void)encodeWithCoder:(id)fp8;
- (id)creationDate;
- (void)setCreationDate:(id)fp8;
- (id)modificationDate;
- (void)setModificationDate:(id)fp8;
- (id)[[RTFDData]];
- (void)setRTFDData:(id)fp8;
- (int)windowColor;
- (void)setWindowColor:(int)fp8;
- (int)windowFlags;
- (void)setWindowFlags:(int)fp8;
- (struct _NSRect)windowFrame;
- (void)setWindowFrame:(struct _NSRect)fp8;
@end
</code>

So would I just have to create this document header and implementation file and then use [[NSUnarchiver]] to process it?? Don't tell me it's that easy... :)

''I don't know, you tell us ;) I doubt it's '''that''' complex... It's only Stickies, after all...''

----

This article over at [[MacDevCenter]].com shows how to reverse engineer the [[StickiesDatabase]] file http://www.macdevcenter.com/pub/a/mac/2005/03/18/cocoa.html