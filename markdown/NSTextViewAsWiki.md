Seeking a bit of advice: I'm just diving into the General/NSTextView and I'd like to write a small wiki type system (very similar to General/VoodooPad actually but with a few twists).  I believe I get how I'd actually convert all Wiki Names to links, but I'm not real sure where in the pipeline to place this code.  I'm assuming for efficiency this should really by done by watching text as it's typed and adding the link attributes as needed.  Which delegate would be appropriate for basically watching the text as it is typed?  Or, is there a better way?

Thanks,

General/EricFreeman

----

I'll let the code speak for itself... (PS General/WikiController is the delegate of it's wikiTextView and wikiWindow, also the data source of it's wikiLocation combo box)

    
/* General/WikiController */

#import <Cocoa/Cocoa.h>
#import "General/WikiManager.h"

@interface General/WikiController : General/NSObject
{
    General/IBOutlet General/WikiManager *wikiManager;
    General/IBOutlet General/NSWindow *wikiWindow;
	General/IBOutlet General/NSComboBox* wikiLocation;
	General/IBOutlet General/NSTextView *wikiTextView;
}
- (General/IBAction)changeWikiLocation:(id)sender;
- (General/IBAction)removeCurrentNode:(id)sender;
-(void)scanForWikiWords;
@end

@interface General/WikiController (General/NSTextViewDelegate)
-(void)textDidChange:(General/NSNotification*)aNotification;
- (BOOL)textView:(General/NSTextView *)aTextView 
    clickedOnLink:(id)link 
    atIndex:(unsigned)charIndex;
@end

@interface General/WikiController (General/NSComboBoxDataSource)
-(int)numberOfItemsInComboBox:(General/NSComboBox*)aComboBox;
-(id)comboBox:(General/NSComboBox*)aComboBox 
    objectValueForItemAtIndex:(int)index;
@end

@interface General/WikiController (General/NSWindowDelegate)
-(void)windowWillClose:(General/NSNotification *)aNotification;
@end

//General/WikiController.m
#import "General/WikiController.h"

@implementation General/WikiController

- (General/IBAction)changeWikiLocation:(id)sender
{
	General/NSString* wikiKey  = [wikiLocation stringValue]; 
	General/NSString* wikiText = nil;
	
	if([wikiManager isValidWikiKey:wikiKey]) {
		wikiText = [wikiManager wikiTextForWikiKey:wikiKey];
		wikiText ? 
                    [wikiTextView setString:wikiText] 
                    : [wikiTextView setString:@""];
		[self scanForWikiWords];
	} else {
		[wikiTextView setString:@"Invalid Key"];
	}
}

- (General/IBAction)removeCurrentNode:(id)sender
{
	General/NSString* wikiKey  = [wikiLocation stringValue];
	
	[wikiLocation setStringValue:@"General/SandBox"];
	[self changeWikiLocation:self];
	[wikiManager removeWikiKey:wikiKey];
	[wikiLocation noteNumberOfItemsChanged];
	
}

-(void)scanForWikiWords
{
	General/NSString*  wikiText = [wikiTextView string];
	General/NSScanner* wikiScan = General/[[NSScanner alloc] initWithString:wikiText];
	General/NSString*  currentWord = nil;
	General/NSRange    currentRange;
	General/NSTextStorage* wikiStorage = [wikiTextView textStorage];
	
	[wikiStorage removeAttribute:General/NSLinkAttributeName 
                             range:General/NSMakeRange(0,[wikiText length])];
	
	General/NSCharacterSet* alphaChars = General/[NSCharacterSet alphanumericCharacterSet];
	
	[wikiScan scanUpToCharactersFromSet:alphaChars intoString:nil];
	while(![wikiScan isAtEnd]) {
		[wikiScan scanCharactersFromSet:alphaChars intoString:&currentWord];
		
		if([wikiManager isValidWikiKey:currentWord]) {
			currentRange.location = [wikiScan scanLocation] - [currentWord length];
			currentRange.length   = [currentWord length];

			[wikiStorage setAttributes: // on link clicked pass the General/WikiWord
                              General/[NSDictionary dictionaryWithObject:currentWord forKey:General/NSLinkAttributeName] 
                        range:currentRange];
			
		}
		[wikiScan scanUpToCharactersFromSet:alphaChars intoString:nil];
	}
	return;
}
@end

@implementation General/WikiController (General/NSTextViewDelegate)
-(void)textDidChange:(General/NSNotification*)aNotification
{
	//optimize by only checking the words at the index of the change
	
	[self scanForWikiWords];
	General/NSString* wikiKey = [wikiLocation stringValue];
	General/NSString* wikiText = [wikiTextView string];
	
	[wikiManager setWikiText:wikiText forWikiKey:wikiKey];
	[wikiLocation noteNumberOfItemsChanged];
}
- (BOOL)textView:(General/NSTextView *)aTextView clickedOnLink:(id)link atIndex:(unsigned)charIndex
{
	[wikiLocation setStringValue:link];
	[self changeWikiLocation:self];
	return YES;
}
@end

@implementation General/WikiController (General/NSComboBoxDataSource)
-(int)numberOfItemsInComboBox:(General/NSComboBox*)aComboBox
{
	General/NSArray* wikiKeys = [wikiManager wikiKeys];
	return [wikiKeys count];
}

-(id)comboBox:(General/NSComboBox*)aComboBox objectValueForItemAtIndex:(int)index
{
	General/NSArray* wikiKeys = [wikiManager wikiKeys];
	return [wikiKeys objectAtIndex:index];
}
@end

@implementation General/WikiController (General/NSWindowDelegate)
-(void)windowWillClose:(General/NSNotification *)aNotification
{
	General/[NSApp terminate:self];
}
@end

/* General/WikiManager.h */

#import <Cocoa/Cocoa.h>

@interface General/WikiManager : General/NSObject
{
}
-(General/NSArray*)wikiKeys;
-(General/NSString*)wikiTextForWikiKey:(General/NSString*)aWikiKey;
-(void)setWikiText:(General/NSString*) newText forWikiKey:(General/NSString*)aWikiKey;
-(BOOL)isValidWikiKey:(General/NSString*)aWikiKey;
-(void)removeWikiKey:(General/NSString*)aWikiKey;
@end

@interface General/WikiManager (General/WikiData)
-(General/NSDictionary*)wikiData;
-(void)setWikiData:(General/NSDictionary*)newWikiData;
@end

@interface General/NSString (General/McWordAtIndex)
-(General/NSString*)wordAtIndex:(int)anIndex;
@end

//General/WikiManager.m
#import "General/WikiManager.h"

@implementation General/WikiManager
-(General/NSArray*)wikiKeys
{
	General/NSDictionary * wikiData = [self wikiData];
	return [wikiData allKeys];
}

-(General/NSString*)wikiTextForWikiKey:(General/NSString*)aWikiKey
{
	General/NSDictionary * wikiData = [self wikiData];
	return [wikiData objectForKey:aWikiKey];
}

-(void)setWikiText:(General/NSString*) newText forWikiKey:(General/NSString*)aWikiKey
{
	General/NSDictionary * wikiData = [self wikiData];
	General/NSMutableDictionary* mutableWikiData = 
                 General/[NSMutableDictionary dictionaryWithDictionary:wikiData];
	[mutableWikiData setObject:newText forKey:aWikiKey];
	[self setWikiData:mutableWikiData];
	return;
}

-(BOOL)isValidWikiKey:(General/NSString*)aWikiKey
{
	if(!aWikiKey) return NO;
	if([aWikiKey length] < 2) return NO;
	//check for no illegal characters (whitespace, punctuation...) initial caps
	BOOL noIllegalChars = General/aWikiKey wordAtIndex:0] isEqual:aWikiKey];
	BOOL initialCaps = [[[[NSCharacterSet uppercaseLetterCharacterSet] 
			characterIsMember:[aWikiKey characterAtIndex:0]];
	//check for at least one more capital
	General/NSScanner* wikiScan = General/[[NSScanner alloc] initWithString:aWikiKey];
	[wikiScan setScanLocation:1];
	[wikiScan scanUpToCharactersFromSet:
                 General/[NSCharacterSet uppercaseLetterCharacterSet] 
        intoString:nil];
	BOOL secondCaps = ![wikiScan isAtEnd];
	return noIllegalChars && initialCaps && secondCaps;
}

-(void)removeWikiKey:(General/NSString*)aWikiKey
{
	General/NSDictionary* wikiData = [self wikiData];
	General/NSMutableDictionary* mutableWikiData = 
                 General/[NSMutableDictionary dictionaryWithDictionary:wikiData];
	[mutableWikiData removeObjectForKey:aWikiKey];
	[self setWikiData:mutableWikiData];
}

@end

@implementation General/WikiManager (General/WikiData)
-(General/NSDictionary*)wikiData
{
	General/NSDictionary* wikiData = 
                General/[[NSUserDefaults standardUserDefaults] 
                              objectForKey:@"General/WikiData"];
	if(!wikiData) {
		wikiData = General/[[NSDictionary alloc] init];
		[self setWikiData:wikiData];
	}
	return wikiData;
}

-(void)setWikiData:(General/NSDictionary*)newWikiData
{
	General/[[NSUserDefaults standardUserDefaults] 
                 setObject:newWikiData forKey:@"General/WikiData"];
	return;
}
@end

@implementation General/NSString (General/McWordAtIndex)
-(General/NSString*)wordAtIndex:(int)anIndex
{
	General/NSString * result = nil;
	General/NSCharacterSet* goodChars = General/[NSCharacterSet alphanumericCharacterSet];
	
	if([goodChars characterIsMember:[self characterAtIndex:anIndex]])
	{
		General/NSRange resultRange;
		resultRange.location = anIndex;
		while(
                        resultRange.location-- != 0 && 
                        [goodChars characterIsMember:
                                 [self characterAtIndex:resultRange.location]]
                );
		resultRange.location++;
		resultRange.length = anIndex;
		while(
                      (++resultRange.length) < [self length] && 
                      [goodChars characterIsMember:
                                  [self characterAtIndex:resultRange.length]]
                );
		resultRange.length -= resultRange.location;
		result = [self substringWithRange:resultRange];
	}
	
	return result;
}
@end


The end result could be much more optimized with creating the attributes... but it runs great on my G3 iBook for now (maybe when it gets to have large entries and many entries I'll need to play with things)... at any rate, I'll go with Knuth: "Premature optimization is the root of all evil"