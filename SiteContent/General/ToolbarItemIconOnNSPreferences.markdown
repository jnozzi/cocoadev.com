

Hi folks,
I've successfully created a Preferences Pane for my Mac Address Book Plugin (files available at the bottom of this post).
Now I want to define the Icon show on the AB Preferences for my plugin, but I don't know how to do it (currently the AB icon is displayed). Can anyone point out how to do it?

The following code was based on http://www.cocoadev.com/index.pl?[[NSPreferences]]

[[NSPreferences]].h

<code>
#import <Cocoa/Cocoa.h>

// Taken from /System/Library/Frameworks/[[AppKit]].framework/[[AppKit]]

/''
 '' Preferences are read from mainBundle's [[PreferencePanels]].plist file:
 '' Keys are
 ''  [[ContentSize]] (string representation of a [[NSSize]]),
 ''  [[UsesButtons]] (string with 0 or 1)
 ''  [[PreferencePanels]] (array of dictionaries):
 ''   Class (string)
 ''   Identifier (string)
 ''/

#ifdef TIGER

@protocol [[NSPreferencesModule]]
- (id)viewForPreferenceNamed:(id)fp8;
- (id)imageForPreferenceNamed:(id)fp8;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
@end

@interface [[NSPreferences]] : [[NSObject]]
{
    [[NSWindow]] ''_preferencesPanel;
    [[NSBox]] ''_preferenceBox;
    [[NSMatrix]] ''_moduleMatrix;
    [[NSButtonCell]] ''_okButton;
    [[NSButtonCell]] ''_cancelButton;
    [[NSButtonCell]] ''_applyButton;
    [[NSMutableArray]] ''_preferenceTitles;
    [[NSMutableArray]] ''_preferenceModules;
    [[NSMutableDictionary]] ''_masterPreferenceViews;
    [[NSMutableDictionary]] ''_currentSessionPreferenceViews;
    [[NSBox]] ''_originalContentView;
    BOOL _isModal;
    float _constrainedWidth;
    id _currentModule;
    void ''_reserved;
}

+ (id)sharedPreferences;
+ (void)setDefaultPreferencesClass:(Class)fp8;
+ (Class)defaultPreferencesClass;
- (id)init;
- (void)dealloc;
- (void)addPreferenceNamed:(id)fp8 owner:(id)fp12;
- (void)_setupToolbar;
- (void)_setupUI;
- (struct _NSSize)preferencesContentSize;
- (void)showPreferencesPanel;
- (void)showPreferencesPanelForOwner:(id)fp8;
- (int)showModalPreferencesPanelForOwner:(id)fp8;
- (int)showModalPreferencesPanel;
- (void)ok:(id)fp8;
- (void)cancel:(id)fp8;
- (void)apply:(id)fp8;
- (void)_selectModuleOwner:(id)fp8;
- (id)windowTitle;
- (void)confirmCloseSheetIsDone:(id)fp8 returnCode:(int)fp12 contextInfo:(void '')fp16;
- (BOOL)windowShouldClose:(id)fp8;
- (void)windowDidResize:(id)fp8;
- (struct _NSSize)windowWillResize:(id)fp8 toSize:(struct _NSSize)fp12;
- (BOOL)usesButtons;
- (id)_itemIdentifierForModule:(id)fp8;
- (void)toolbarItemClicked:(id)fp8;
- (id)toolbar:(id)fp8 itemForItemIdentifier:(id)fp12 willBeInsertedIntoToolbar:(BOOL)fp16;
- (id)toolbarDefaultItemIdentifiers:(id)fp8;
- (id)toolbarAllowedItemIdentifiers:(id)fp8;
- (id)toolbarSelectableItemIdentifiers:(id)fp8;

@end

@interface [[NSPreferencesModule]] : [[NSObject]] <[[NSPreferencesModule]]>
{
    [[NSBox]] ''_preferencesView;
    struct _NSSize _minSize;
    BOOL _hasChanges;
    void ''_reserved;
}

+ (id)sharedInstance;
- (void)dealloc;
- (void)finalize;
- (id)init;
- (id)preferencesNibName;
- (void)setPreferencesView:(id)fp8;
- (id)viewForPreferenceNamed:(id)fp8;
- (id)imageForPreferenceNamed:(id)fp8;
- (id)titleForIdentifier:(id)fp8;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (struct _NSSize)minSize;
- (void)setMinSize:(struct _NSSize)fp8;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
- (BOOL)isResizable;

@end

#else

@protocol [[NSPreferencesModule]]
- (char)preferencesWindowShouldClose;
- (char)moduleCanBeRemoved;
- (void)moduleWasInstalled;
- (void)moduleWillBeRemoved;
- (void)didChange;
- (void)initializeFromDefaults;
- (void)willBeDisplayed;
- (void)saveChanges;
- (char)hasChangesPending;
- imageForPreferenceNamed:fp8;
- viewForPreferenceNamed:fp8;
@end

@interface [[NSPreferences]]:[[NSObject]]
{
    [[NSWindow]] ''_preferencesPanel;	// 4 = 0x4
    [[NSBox]] ''_preferenceBox;	// 8 = 0x8
    [[NSMatrix]] ''_moduleMatrix;	// 12 = 0xc
    [[NSButtonCell]] ''_okButton;	// 16 = 0x10
    [[NSButtonCell]] ''_cancelButton;	// 20 = 0x14
    [[NSButtonCell]] ''_applyButton;	// 24 = 0x18
    [[NSMutableArray]] ''_preferenceTitles;	// 28 = 0x1c
    [[NSMutableArray]] ''_preferenceModules;	// 32 = 0x20
    [[NSMutableDictionary]] ''_masterPreferenceViews;	// 36 = 0x24
    [[NSMutableDictionary]] ''_currentSessionPreferenceViews;	// 40 = 0x28
    [[NSBox]] ''_originalContentView;	// 44 = 0x2c
    char _isModal;	// 48 = 0x30
    float _constrainedWidth;	// 52 = 0x34
    id _currentModule;	// 56 = 0x38
    void ''_reserved;	// 60 = 0x3c
}

+ sharedPreferences;
+ (void)setDefaultPreferencesClass:(Class)fp8;
+ (Class)defaultPreferencesClass;
- init;
- (void)dealloc;
- (void)addPreferenceNamed:fp8 owner:fp12;
- (void)_setupToolbar;
- (void)_setupUI;
- (struct _NSSize)preferencesContentSize;
- (void)showPreferencesPanel;
- (void)showPreferencesPanelForOwner:fp8;
- (int)showModalPreferencesPanelForOwner:fp8;
- (int)showModalPreferencesPanel;
- (void)ok:fp8;
- (void)cancel:fp8;
- (void)apply:fp8;
- (void)_selectModuleOwner:fp8;
- windowTitle;
- (void)confirmCloseSheetIsDone:fp8 returnCode:(int)fp12 contextInfo:(void '')fp16;
- (char)windowShouldClose:fp8;
- (void)windowDidResize:fp8;
- (struct _NSSize)windowWillResize:fp8 toSize:(struct _NSSize)fp12;
- (char)usesButtons;
- _itemIdentifierForModule:fp8;
- (void)toolbarItemClicked:fp8;
- toolbar:fp8 itemForItemIdentifier:fp12 willBeInsertedIntoToolbar:(BOOL)fp16;
- toolbarDefaultItemIdentifiers:fp8;
- toolbarAllowedItemIdentifiers:fp8;
- toolbarSelectableItemIdentifiers:fp8;

@end

@interface [[NSPreferencesModule]]:[[NSObject]] <[[NSPreferencesModule]]>
{
    [[NSBox]] ''_preferencesView;	// 4 = 0x4
    struct _NSSize _minSize;	// 8 = 0x8
    char _hasChanges;	// 16 = 0x10
    void ''_reserved;	// 20 = 0x14
}

+ sharedInstance;
- (void)dealloc;
- init;
- preferencesNibName;
- (void)setPreferencesView:fp8;
- viewForPreferenceNamed:fp8;
- imageForPreferenceNamed:fp8;
- titleForIdentifier:fp8;
- (char)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (struct _NSSize)minSize;
- (void)setMinSize:(struct _NSSize)fp8;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (char)moduleCanBeRemoved;
- (char)preferencesWindowShouldClose;
- (char)isResizable;

@end

#endif
</code>

NSPreferences_AKAConnect.h

<code>
#import <[[NSPreferences]].h>


@interface NSPreferences_AKAConnect : [[NSPreferences]] {

}

@end
</code>

NSPreferences_AKAConnect.m

<code>
#import "NSPreferences_AKAConnect.h"
#import "[[AKAConnectPreferences]].h"

@implementation NSPreferences_AKAConnect

+ (void) load
{
    [NSPreferences_AKAConnect poseAsClass:[[[NSPreferences]] class]];
}

+ sharedPreferences
{
    static BOOL	added = NO;
    id			preferences = [super sharedPreferences];

    if(preferences != nil && !added){
		[[NSLog]](@"... adding AKA Connect Prefs now...");
        added = YES;
        [preferences addPreferenceNamed:@"AKA Connect" owner:[[[AKAConnectPreferences]] sharedInstance]];
    }
    
    return preferences;
}

@end
</code>

[[AKAConnectPreferences]].h

<code>
/'' [[AKAConnectPreferences]] ''/
#import <[[NSPreferences]].h>

#import <[[AppKit]]/[[AppKit]].h>

#import <Cocoa/Cocoa.h>

@interface [[AKAConnectPreferences]] : [[NSPreferencesModule]]
{
    [[IBOutlet]] [[NSTextField]] ''akaUserName;
    [[IBOutlet]] [[NSSecureTextField]] ''akaUserPass;
	[[IBOutlet]] [[NSButton]] ''akaUserForce;
	[[IBOutlet]] [[NSComboBox]] ''akaUserConnMode;
}
//- ([[IBAction]])savePreferences:(id)sender;
@end
</code>

[[AKAConnectPreferences]].m

<code>
#import "[[AKAConnectPreferences]].h"

@implementation [[AKAConnectPreferences]]

- (id)preferencesNibName {
	return @"[[AKAPreferences]]";
}

- (void)loadUserSettings {
	[[NSUserDefaults]] ''us = [[[NSUserDefaults]] standardUserDefaults];
	
	[[NSLog]](@"loadUserSettings was called...");
	
	if ([us valueForKey:@"[[AKAUserName]]"] != nil ) {
		[akaUserName setStringValue:[us valueForKey:@"[[AKAUserName]]"]];
	}
	if ([us valueForKey:@"[[AKAUserPass]]"] != nil) {
		[akaUserPass setStringValue:[us valueForKey:@"[[AKAUserPass]]"]];
	}
	if ([us valueForKey:@"[[AKAUserForce]]"] != nil) {
		[akaUserForce setStringValue:[us valueForKey:@"[[AKAUserForce]]"]];
	}
	if ([us valueForKey:@"[[AKAConnMode]]"] != nil) {
		[akaUserConnMode setStringValue:[us valueForKey:@"[[AKAConnMode]]"]];
	}
}

- (void)willBeDisplayed {

	[self loadUserSettings];

}

- (void)initializeFromDefaults {

	[self loadUserSettings];

}

-(void) saveChanges {
	[[NSLog]](@"Save changes was called...");
	
	[[NSUserDefaults]] ''us = [[[NSUserDefaults]] standardUserDefaults];
	
	[us setValue:[akaUserName stringValue] forKey:@"[[AKAUserName]]"];
	[us setValue:[akaUserPass stringValue] forKey:@"[[AKAUserPass]]"];
	[us setValue:[akaUserConnMode stringValue] forKey:@"[[AKAConnMode]]"];
	[us setValue:[akaUserForce stringValue] forKey:@"[[AKAUserForce]]"];
}

@end
</code>

----
I've never written one of these, but it looks to me like [[NSPreferencesModule]]'s -imageForPreferenceNamed: would be a good place to start. Did you try that? -CS