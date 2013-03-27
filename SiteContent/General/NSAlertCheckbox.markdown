I got annoyed that General/NSAlert doesn't have any SIMPLE way to add a checkbox to it, so I wrote this custom subclass to add it in, enjoy:

General/NSAlertCheckbox.h:
    
#import <Cocoa/Cocoa.h>

// private methods
@interface General/NSAlert (General/CheckboxAdditions)
- (void)prepare;
- (id)buildAlertStyle:(int)fp8 title:(id)fp12 formattedMsg:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32;
- (id)buildAlertStyle:(int)fp8 title:(id)fp12 message:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32 args:(char *)fp36;
@end

@interface General/NSAlertCheckbox : General/NSAlert {
	General/NSButton *_checkbox;
}

+ (General/NSAlertCheckbox *)alertWithMessageText:(General/NSString *)message defaultButton:(General/NSString *)defaultButton alternateButton:(General/NSString *)alternateButton otherButton:(General/NSString *)otherButton informativeText:(General/NSString *)format;

- (BOOL)showsCheckbox;
- (void)setShowsCheckbox:(BOOL)showsCheckbox;

- (General/NSString *)checkboxText;
- (void)setCheckboxText:(General/NSString *)text;

- (int)checkboxState;
- (void)setCheckboxState:(int)state;
@end


General/NSAlertCheckbox.m:
    
#import "General/NSAlertCheckbox.h"

@interface General/NSAlertCheckbox (Private)
- (void)_addCheckboxToWindow;
@end

@implementation General/NSAlertCheckbox
- (id)init {
	if (self = [super init]) {
		_checkbox = nil;
	}
	
	return self;
}

- (void)dealloc {
	[_checkbox release];
	
	[super dealloc];
}

+ (General/NSAlertCheckbox *)alertWithMessageText:(General/NSString *)message defaultButton:(General/NSString *)defaultButton alternateButton:(General/NSString *)alternateButton otherButton:(General/NSString *)otherButton informativeText:(General/NSString *)format {
	General/NSAlert *alert = [super alertWithMessageText:message
								   defaultButton:defaultButton
								 alternateButton:alternateButton
									 otherButton:otherButton
					   informativeTextWithFormat:format];
	
	return (General/NSAlertCheckbox *)alert;
}

#pragma mark -

- (BOOL)showsCheckbox {
	return (_checkbox != nil);
}

- (void)setShowsCheckbox:(BOOL)showsCheckbox {
	if (showsCheckbox && !_checkbox) {
		_checkbox = General/[[NSButton alloc] initWithFrame:General/NSZeroRect];
		[_checkbox setButtonType:General/NSSwitchButton];
	} else if (!showsCheckbox && _checkbox) {
		if ([_checkbox superview]) {
			[_checkbox removeFromSuperview];
		}
		[_checkbox release];
		_checkbox = nil;
	}
}

- (General/NSString *)checkboxText {
	General/NSString *text = nil;
	
	if ([self showsCheckbox]) {
		text = [_checkbox title];
	}
	
	return text;
}

- (void)setCheckboxText:(General/NSString *)text {
	if ([self showsCheckbox]) {
		[_checkbox setTitle:text];
	}
}

- (int)checkboxState {
	int state = -1;
	
	if ([self showsCheckbox]) {
		state = [_checkbox state];
	}
	
	return state;
}

- (void)setCheckboxState:(int)state {
	if ([self showsCheckbox]) {
		[_checkbox setState:state];
	}
}

#pragma mark -

- (id)buildAlertStyle:(int)fp8 title:(id)fp12 formattedMsg:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32 {
	id retVal = [super buildAlertStyle:fp8 title:fp12 formattedMsg:fp16 first:fp20 second:fp24 third:fp28 oldStyle:fp32];
	[self _addCheckboxToWindow];
	
	return retVal;
}

- (id)buildAlertStyle:(int)fp8 title:(id)fp12 message:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32 args:(char *)fp36 {
	id retVal = [super buildAlertStyle:fp8 title:fp12 message:fp16 first:fp20 second:fp24 third:fp28 oldStyle:fp32 args:fp36];
	[self _addCheckboxToWindow];
	
	return retVal;
}
@end

@implementation General/NSAlertCheckbox (Private)
- (void)_addCheckboxToWindow {
	float checkboxPadding = 14.0f; // according to the apple HIG
	
	if ([self showsCheckbox]) {
		General/NSWindow *window = [self window];
		General/NSView *content = [window contentView];
		
		// find the position of the main text field
		General/NSArray *subviews = [content subviews];
		General/NSEnumerator *en = [subviews objectEnumerator];
		General/NSView *subview = nil;
		General/NSTextField *messageText = nil;
		int count = 0;
		
		while (subview = [en nextObject]) {
			if ([subview isKindOfClass:General/[NSTextField class]]) {
				count++;
				
				if (count == 2) {
					messageText = (General/NSTextField *)subview;
				}
			}
		}
		
		if (messageText) {
			[content addSubview:_checkbox];
			
			// make the checkbox font match the text area above it
			[_checkbox setFont:[messageText font]];
			[_checkbox sizeToFit];
			
			// expand the window
			General/NSRect windowFrame = [window frame];
			General/NSRect checkboxFrame = [_checkbox frame];
			windowFrame.size.height += checkboxFrame.size.height + checkboxPadding;
			[window setFrame:windowFrame display:YES];
			
			checkboxFrame.origin.y = [messageText frame].origin.y - checkboxFrame.size.height - checkboxPadding;
			checkboxFrame.origin.x = [messageText frame].origin.x;
			
			[_checkbox setFrame:checkboxFrame];
			[window makeFirstResponder:General/self buttons] objectAtIndex:0;
		}
	}
}
@end


Here's some example code using it:
    
// prompt the user
General/NSAlertCheckbox *alert = General/[NSAlertCheckbox alertWithMessageText:@"Install Flash"
								 defaultButton:@"Download"
							   alternateButton:@"No Thanks"
								   otherButton:nil
							   informativeText:@"The current verson of flash is out of date, do you wish to download the latest?"];
		
[alert setShowsCheckbox:YES];
[alert setCheckboxText:@"Don't ask me again."];
[alert setCheckboxState:General/NSOnState];

if ([alert runModal] == General/NSAlertDefaultReturn) {
	// go download flash
}

if ([alert checkboxState] == General/NSOnState) {
	// go set a pref somewhere
}


-- General/TristanOTierney

----

I've got some similar code that will use the private checkbox methods built into General/NSAlert, if they're available, or fallback to a regular checkbox if the code appears to be missing. The advantage to this code is that there is less direct manipulation of the alert's window and controls--i.e. it's a higher-level implementation. If people would like, I can clean it up and post it as a download. - General/JonathanGrynspan

----
General/TristanOTierney thanks and General/JonathanGrynspan, please do. 

----
Looks like Leopard allows you not only to set an accessory view to the General/NSAlert but to set a "suppression checkbox". - General/DanGrover