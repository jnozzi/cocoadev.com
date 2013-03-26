I'm working on [[VocableTrainerX]] (http://www.sourceforge.net/projects/vocx), an easy to use Open Source Flash Card program.

A user sent me a cool suggestion: he wants the textfields in the software to have a "[[StickyKeyboardLayout]]".

The idea works like this:
1) When the user first enters a chinese word, he manually sets his Keyboard Layout to chinese
2) Now he enter his chinese word and leaves this text field again, now automatically the Keyboard Layout is changed back to English
3) The next time he enters a text field supposed to be for chinese input, it automatically changes again to Chinese

That feature would be generally a huge time saver for people entering words in non-latin alphabets like Greek, Korean or Japanese!

I already fabricated a prototype, a subclass of [[NSTextField]] (see below). It uses the functions explained in http://developer.apple.com/documentation/Carbon/Reference/[[KeyboardLayoutServices]]/[[KeyboardLayoutReference]].pdf. Unfortunately it still shows some random behaviour, for example the picture in the menu bar doesn't get changed automatically...

Has anyone else already implemented the same functionality somewhere? Any ideas for improvements?

Thank you very much, 
Michael


<code>
'''[[MMKeyboardLayoutAwareTextField]].h'''

/'' [[MMKeyboardLayoutAwareTextField]].h ''/

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface [[MMKeyboardLayoutAwareTextField]] : [[NSTextField]]
{
    [[KeyboardLayoutRef]] myLayout;
    [[KeyboardLayoutRef]] systemLayout;
}

-([[NSString]] '')nameOfLayout:([[KeyboardLayoutRef]])layoutRef;
@end
</code>


<code>
'''[[MMKeyboardLayoutAwareTextField]].m'''

#import "[[MMKeyboardLayoutAwareTextField]].h"

#define MM_NO_KEYBOARDLAYOUT_SET 0

@implementation [[MMKeyboardLayoutAwareTextField]]

- (id)init
{
    if (self = [super init]) {
	[[KLGetCurrentKeyboardLayout]](&myLayout);
	[[KLGetCurrentKeyboardLayout]](&systemLayout);
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    if (systemLayout == MM_NO_KEYBOARDLAYOUT_SET) {
	[[KLGetCurrentKeyboardLayout]](&systemLayout);	
    }	
        
    [[KLSetCurrentKeyboardLayout]](myLayout); 
    
    return [super becomeFirstResponder];
}

- (void)textDidEndEditing:([[NSNotification]] '')aNotification {
    [[KLGetCurrentKeyboardLayout]](&myLayout);
    [[KLSetCurrentKeyboardLayout]](systemLayout);
        
    [super textDidEndEditing:aNotification];
}


-([[NSString]] '')nameOfLayout:([[KeyboardLayoutRef]])layoutRef {
    [[NSString]] ''result;
    if (layoutRef==MM_NO_KEYBOARDLAYOUT_SET) {
	return @"Not yet specified";
    }
    [[KLGetKeyboardLayoutProperty]](layoutRef,kKLLocalizedName,&result); 
    return result;
}

@end
</code>