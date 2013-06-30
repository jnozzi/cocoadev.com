

General/NSPreferences is a class the provides a pseudo-standard look-and-feel for editing application preferences. It is used in both Safari and Mail.  It basically controls a tabbed view with a toolbar-style series of icons.  IMHO, it is much more efficient for small sets of preferences than the General/PreferencesPane interface seen in System Preferences.

This falls under the General/UndocumentedGoodness category.  There are a few minor hiccups, but after that, it's smooth sailing. http://goo.gl/General/OeSCu

Due to something funky in the General/NSPreferences init method, I've found that you have to do this override to avoid a segfault.  I'm kind of interested in figuring out why this is, but for the time being, it was easier to hack around.

    
@interface General/MSPreferences : General/NSPreferences
{
}

@end


@implementation General/MSPreferences

- init
{
	_preferenceTitles = General/[[NSMutableArray alloc] init];
	_preferenceModules = General/[[NSMutableArray alloc] init];
	_masterPreferenceViews = General/[[NSMutableDictionary alloc] init];
	_currentSessionPreferenceViews = General/[[NSMutableDictionary alloc] init];
	return self;
}

@end


What you mostly need to do is extend the General/NSPreferencesModule and flesh it out with all the gory details of your interface.

    
@interface General/NSPreferencesModule:General/NSObject <General/NSPreferencesModule>
{
    General/NSBox *_preferencesView;	// 4 = 0x4
    struct _NSSize _minSize;	// 8 = 0x8
    char _hasChanges;	// 16 = 0x10
    void *_reserved;	// 20 = 0x14
}

+ sharedInstance;
- (void)dealloc;
- init;
- preferencesNibName;
- (void)setPreferencesView:fp8;
- viewForPreferenceNamed:fp8;
- imageForPreferenceNamed:fp8;
- titleForIdentifier:fp8;
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

@interface General/SamplePreferencesModule : General/NSPreferencesModule
{
}
@end

@implementation General/SamplePreferencesModule

/**
 * Image to display in the preferences toolbar
 */
- (General/NSImage *) imageForPreferenceNamed:(General/NSString *)_name

/**
 * Override to return the name of the relevant nib
 */
- (General/NSString *) preferencesNibName

- (void) didChange

- (General/NSView*) viewForPreferenceNamed:(General/NSString *)aName;

/**
* Called when switching preference panels.
 */
- (void) willBeDisplayed

/**
 * Called when window closes or "save" button is clicked.
 */
- (void) saveChanges

/**
* Not sure how useful this is, so far always seems to return YES.
 */
- (BOOL) hasChangesPending

/**
* Called when we relinquish ownership of the preferences panel.
 */
- (void)moduleWillBeRemoved

/**
* Called after willBeDisplayed, once we "own" the preferences panel.
 */
- (void)moduleWasInstalled

@end


You'll need to define a nib file (and specify it's name in the module class.  You probably want to create an General/NSPreferencesModule class in General/InterfaceBuilder and make sure it has an outlet for General/NSBox* _preferencesView.  Once you have that taken care of, you just need the following lines in you application:

    
	General/[NSPreferences setDefaultPreferencesClass:General/[MSPreferences class]];
	General/NSPreferences* prefs = General/[NSPreferences sharedPreferences];
	[prefs addPreferenceNamed:@"General/SamplePreferencesModule" owner:General/[SamplePreferencesModule sharedInstance]];


Obviously, I've left out a few things from my actual implementation, but hopefully this can get you started.  If you are having trouble, please drop me a note and I'll try update these notes to help you solve your problem.  --General/MikeSolomon

----

A more complete header for General/NSPreferences (and friends) that has 10.2 and 10.3 differences broken out.

    
#import <Foundation/General/NSObject.h>
#import <Foundation/General/NSGeometry.h>
#import <General/AppKit/General/NSNibDeclarations.h>

// Private classes from the General/AppKit framework; used by Safari and Mail.

@class General/NSWindow;
@class General/NSMatrix;
@class General/NSBox;
@class General/NSButtonCell;
@class General/NSImage;
@class General/NSView;
@class General/NSMutableArray;
@class General/NSMutableDictionary;

@protocol General/NSPreferencesModule
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
- (BOOL) preferencesWindowShouldClose;
- (BOOL) moduleCanBeRemoved;
- (void) moduleWasInstalled;
- (void) moduleWillBeRemoved;
#endif
- (void) didChange;
- (void) initializeFromDefaults;
- (void) willBeDisplayed;
- (void) saveChanges;
- (BOOL) hasChangesPending;
- (General/NSImage *) imageForPreferenceNamed:(General/NSString *) name;
- (General/NSView *) viewForPreferenceNamed:(General/NSString *) name;
@end

@interface General/NSPreferences : General/NSObject {
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_2
	id preferencesPanel;
	General/NSBox *preferenceBox;
	id moduleMatrix;
	id okButton;
	id cancelButton;
	id applyButton;
#else
	General/NSWindow *_preferencesPanel;
	General/NSBox *_preferenceBox;
	General/NSMatrix *_moduleMatrix;
	General/NSButtonCell *_okButton;
	General/NSButtonCell *_cancelButton;
	General/NSButtonCell *_applyButton;
#endif
	General/NSMutableArray *_preferenceTitles;
	General/NSMutableArray *_preferenceModules;
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_2
	General/NSMutableDictionary *_preferenceViews;
#else
	General/NSMutableDictionary *_masterPreferenceViews;
	General/NSMutableDictionary *_currentSessionPreferenceViews;
#endif
	General/NSBox *_originalContentView;
	BOOL _isModal;
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
	float _constrainedWidth;
	id _currentModule;
	void *_reserved;
#endif
}
+ (id) sharedPreferences;
+ (void) setDefaultPreferencesClass:(Class) class;
+ (Class) defaultPreferencesClass;

- (id) init;
- (void) dealloc;
- (void) addPreferenceNamed:(General/NSString *) name owner:(id) owner;

- (General/NSSize) preferencesContentSize;

- (void) showPreferencesPanel;
- (void) showPreferencesPanelForOwner:(id) owner;
- (int) showModalPreferencesPanelForOwner:(id) owner;
- (int) showModalPreferencesPanel;

- (void) ok:(id) sender;
- (void) cancel:(id) sender;
- (void) apply:(id) sender;

- (General/NSString *) windowTitle;
- (BOOL) usesButtons;

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_2
- (void) selectModule:(id) sender;
#endif
@end

@interface General/NSPreferencesModule : General/NSObject <General/NSPreferencesModule> {
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_2
	General/IBOutlet General/NSBox *preferencesView;
	BOOL hasChanges;
#else
	General/IBOutlet General/NSBox *_preferencesView;
	General/NSSize _minSize;
	BOOL _hasChanges;
	void *_reserved;
#endif
}
+ (id) sharedInstance;
- (id) init;
- (General/NSString *) preferencesNibName;
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
- (void) setPreferencesView:(General/NSView *) view;
#endif
- (General/NSView *) viewForPreferenceNamed:(General/NSString *) name;
- (General/NSImage *) imageForPreferenceNamed:(General/NSString *) name;
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
- (General/NSString *) titleForIdentifier:(General/NSString *) identifier;
#endif
- (BOOL) hasChangesPending;
- (void) saveChanges;
- (void) willBeDisplayed;
- (void) initializeFromDefaults;
- (void) didChange;
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
- (General/NSSize) minSize;
- (void) setMinSize:(General/NSSize) size;
- (void) moduleWillBeRemoved;
- (void) moduleWasInstalled;
- (BOOL) moduleCanBeRemoved;
- (BOOL) preferencesWindowShouldClose;
- (BOOL) isResizable;
#endif
@end


Also since _currentSessionPreferenceViews and _masterPreferenceViews were added in 10.3, leaving those allocs out in your custom override init method will allow your code to work in 10.2 and 10.3. General/NSPreferences seems to allocate these lazily. --General/TimothyHatcher

----

If you want to avoid stuff that isn't officially allowed for use by Apple (it looks like General/NSPreferences is private), you can also use my General/UKPrefsPanel class, which does something similar when combined with General/NSUserDefaults. Not quite as advanced, but similar enough. It's at http://www.zathras.de/programming/sourcecode.htm#General/UKPrefsPanel -- General/UliKusterer


----

Could someone post an example? I'm completely lost :(  



-General/JohnWells

----
I'm guessing there's a reason why sending init doesn't work.  You probably have to call something like initWithWindow: or something like that... for debugging purposes someone probably threw in an assertation or something like it into the init method which is why you see your program exit.

----

I'm using this to add a preferences module to Safaris preferences, for my plug-in. The only problem I've encountered, is that I have to click "Preferences..." from the Safari menu TWO times, before it show up. Every time. 
Do anyone know why this happens? And any idea how to fix it...?

UPDATE: Safari saves the last preference module that was open. If my module was not the last, it has to be clicked on in the preferences toolbar twice. If it was the last, it is as described above. It seems like it has to be activated one time first to "activate" it, and then another time to really open.

UPDATE2: It is fixed! I had connected the preferencesView-outlet to a General/NSView, but it needed to be a General/NSBox. The naming confused me. (and maybe others, so I don't delete this comment.)

-General/HannesPetrihttp://jamtangankanan.blogspot.com/
http://www.souvenirnikahku.com/
http://xamthonecentral.com/
http://www.jualsextoys.com
http://cupu.web.id
http://seoweblog.net
http://corsva.com
http://yudinet.com/
http://seo.corsva.com
http://seojek.edublogs.org/
http://tasgrosir-brandedmurah.com/
http://upin.blogetery.com/
http://www.symbian-kreatif.co.cc/
http://upin.blog.com/
http://release.pressku.com/
http://cupu.web.id/tablet-android-honeycomb-terbaik-murah/
http://cupu.web.id/hotel-murah-di-yogyakarta-klikhotel-com/
http://www.seoweblog.net/hotel-murah-di-semarang-klikhotel-com/