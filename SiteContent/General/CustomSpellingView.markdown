This article describes how to support spell checking and grammer checking in a custom view. This view supports checking spelling using the Spelling pane and the Edit menu.

There aren't a lot of examples of how to do this. The best one I could find was General/WebKit:
http://trac.webkit.org/browser/trunk/General/WebKit/mac/General/WebCoreSupport/General/WebEditorClient.mm

 --General/SaileshAgrawal

----

    
#import <Cocoa/Cocoa.h>

@interface General/MyView : General/NSView
{
  General/NSString *document;
  General/NSRange selection;
  General/NSInteger documentTag;
  General/NSArray *cachedSpellCheckResults;
  General/NSInteger misspellingIndex;
  General/NSInteger misspellingCount;
}
@end



    
#import "General/MyView.h"


static BOOL sContinuousSpellCheckingEnabled = YES;
static BOOL sGrammarCheckingEnabled = YES;


@interface General/MyView ()

@property (retain) General/NSString *document;
@property (retain) General/NSArray *cachedSpellCheckResults;

@end


@implementation General/MyView

@synthesize document;
@synthesize cachedSpellCheckResults;

- (void)dealloc
{
  [self setDocument:nil];
  [self setCachedSpellCheckResults:nil];
  [super dealloc];
}

- (void)setDocument:(General/NSString *)newDocument
{
  [newDocument retain];
  [document release];
  document = newDocument;
  [self setCachedSpellCheckResults:nil];
}

- (General/NSArray *)spellCheckResults
{
  if (!cachedSpellCheckResults) {
    General/NSTextCheckingType types = 0;
    if (sContinuousSpellCheckingEnabled)
      types |= General/NSTextCheckingTypeSpelling;
    if (sGrammarCheckingEnabled)
      types |= General/NSTextCheckingTypeGrammar;
    [self setCachedSpellCheckResults:General/[[NSSpellChecker sharedSpellChecker]
                   checkString:document
                         range:General/NSMakeRange(0, [document length])
                         types:types
                       options:nil
        inSpellDocumentWithTag:documentTag
                   orthography:NULL
                     wordCount:NULL]];
  }
  return cachedSpellCheckResults;
}

- (void)awakeFromNib
{
  [self setDocument:General/[NSMutableString stringWithString:
      @"I is a goode reader.\nHelllo worrld this is someething else."]];
  documentTag = General/[NSSpellChecker uniqueSpellDocumentTag];
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)becomeFirstResponder
{
  [self setNeedsDisplay:YES];
  return YES;
}

- (BOOL)resignFirstResponder
{
  [self setNeedsDisplay:YES];
  return YES;
}

- (void)drawRect: (General/NSRect)rect
{
  General/NSRect bounds = [self bounds];
  General/[[NSColor lightGrayColor] set];
  General/NSRectFill(bounds);

  if (General/[self window] firstResponder] isEqual:self]) {
    [[[[NSColor blueColor] set];
    General/NSFrameRectWithWidth(bounds, 4);
  }

  General/NSDictionary *attributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
      General/[NSFont systemFontOfSize:20], General/NSFontAttributeName,
      nil];
  General/NSDictionary *spellingAttributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
      General/[NSNumber numberWithInt:General/NSUnderlineStyleSingle | General/NSUnderlinePatternDot], General/NSUnderlineStyleAttributeName,
      General/[NSColor redColor], General/NSUnderlineColorAttributeName,
      nil];
  General/NSDictionary *grammarAttributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
      General/[NSNumber numberWithInt:General/NSUnderlineStyleSingle | General/NSUnderlinePatternDot], General/NSUnderlineStyleAttributeName,
      General/[NSColor greenColor], General/NSUnderlineColorAttributeName,
      nil];

  General/NSMutableAttributedString *text = General/[[[NSMutableAttributedString alloc]
      initWithString:document
          attributes:attributes] autorelease];

  for (General/NSTextCheckingResult *result in [self spellCheckResults]) {
    if ([result resultType] & General/NSTextCheckingTypeSpelling) {
      [text addAttributes:spellingAttributes range:[result range]];
    }
    if ([result resultType] & General/NSTextCheckingTypeGrammar) {
      for (General/NSDictionary *details in [result grammarDetails]) {
        General/NSRange range = General/details objectForKey:[[NSGrammarRange] rangeValue];
        range.location += [result range].location;
        [text addAttributes:grammarAttributes range:range];
      }
    }
  }

  if (selection.length > 0) {
    General/NSDictionary *selAttributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
        General/[NSColor selectedTextBackgroundColor], General/NSBackgroundColorAttributeName,
        nil];
    [text addAttributes:selAttributes
                  range:selection];
  }

  General/NSRect textFrame;
  textFrame.size = [text size];
  textFrame.origin.x = roundf((bounds.size.width - textFrame.size.width) / 2.0);
  textFrame.origin.y = roundf((bounds.size.height - textFrame.size.height) / 2.0);
  [text drawInRect:textFrame];
}

- (void)setSelection: (General/NSRange)range
{
  selection = range;
  [self setNeedsDisplay:YES];
}

- (BOOL)advanceToNextMisspelling: (General/NSTextCheckingResult **)outResult
                         details: (General/NSDictionary **)outDetails
                           range: (General/NSRange *)outRange
{
  General/NSUInteger findLocation = selection.location + selection.length;
  for (General/NSTextCheckingResult *result in [self spellCheckResults]) {
    if ([result resultType] & General/NSTextCheckingTypeSpelling) {
      if ([result range].location >= findLocation) {
        *outResult = result;
        *outDetails = nil;
        *outRange = [result range];
        return YES;
      }
    }
    if ([result resultType] & General/NSTextCheckingTypeGrammar) {
      for (General/NSDictionary *details in [result grammarDetails]) {
        General/NSRange range = General/details objectForKey:[[NSGrammarRange] rangeValue];
        range.location += [result range].location;
        if (range.location >= findLocation) {
          *outResult = result;
          *outDetails = details;
          *outRange = range;
          return YES;
        }
      }
    }
  }

  return NO;
}

- (General/IBAction)checkSpelling:(id)sender
{
  General/NSTextCheckingResult *result = nil;
  General/NSDictionary *details = nil;
  General/NSRange range;
  if ([self advanceToNextMisspelling:&result
                             details:&details
                               range:&range]) {
    if ([result resultType] & General/NSTextCheckingTypeSpelling) {
      General/[[NSSpellChecker sharedSpellChecker]
          updateSpellingPanelWithMisspelledWord:[document substringWithRange:range]];
    } else if ([result resultType] & General/NSTextCheckingTypeGrammar) {
        General/[[NSSpellChecker sharedSpellChecker]
            updateSpellingPanelWithGrammarString:[document substringWithRange:range]
                                          detail:details];
    }
    [self setSelection:range];
  } else {
    General/[[NSSpellChecker sharedSpellChecker]
        updateSpellingPanelWithMisspelledWord:@""];
    [self setSelection:General/NSMakeRange(0,0)];
  }
}

- (General/IBAction)changeSpelling:(id)sender
{
  General/NSString* newWord = General/sender selectedCell] stringValue];
  if (newWord != nil) {
    [self setDocument:
      [document stringByReplacingCharactersInRange:selection
                                        withString:newWord;
    General/NSRange range;
    range.location = selection.location + [newWord length];
    range.length = 0;
    [self setSelection:range];
  }
}

- (General/IBAction)ignoreSpelling:(id)sender
{
  General/NSString* wordToIgnore = [sender stringValue];
  if (wordToIgnore != nil) {
    // TODO This doesn't ignore grammar mistakes.
    General/[[NSSpellChecker sharedSpellChecker]
                    ignoreWord:wordToIgnore
        inSpellDocumentWithTag:documentTag];
    General/NSRange range;
    range.location = selection.location + [wordToIgnore length];
    range.length = 0;
    [self setSelection:range];
    [self setCachedSpellCheckResults:nil];
  }
}

- (General/IBAction)showGuessPanel:(id)sender
{
  if (YES) {
    General/[[[NSSpellChecker sharedSpellChecker] spellingPanel]
        performSelectorOnMainThread:@selector(makeKeyAndOrderFront:)
                         withObject:nil
                      waitUntilDone:YES];
    [self checkSpelling:nil];
  } else {
    General/[[[NSSpellChecker sharedSpellChecker] spellingPanel]
        performSelectorOnMainThread:@selector(close)
                         withObject:nil
                      waitUntilDone:YES];
  }
}

- (General/IBAction)toggleContinuousSpellChecking:(id)sender
{
  sContinuousSpellCheckingEnabled = !sContinuousSpellCheckingEnabled;
  [self setNeedsDisplay:YES];
}

- (General/IBAction)toggleGrammarChecking:(id)sender
{
  sGrammarCheckingEnabled = !sGrammarCheckingEnabled;
  [self setNeedsDisplay:YES];
}

@end
