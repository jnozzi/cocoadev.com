SCTSearchManager is a class in Apple's Shortcut.framework. It's used to control the Help menu introduced in Mac OS 10.5.

For more info see ProgramaticallyShowMenuInMenuBar. --SaileshAgrawal

----

    
/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSResponder.h"

@class NSButton, NSConditionLock, NSImageView, NSMutableArray, NSMutableSet, NSSearchField, NSStatusItem, NSString, NSTableView, NSTextField, NSTimer, NSView, NSWindow, SCTGRL, SCTGRLIndex, SCTMenuView;

@interface SCTSearchManager : NSResponder
{
    SCTMenuView *mSearchView;
    NSTextField *mSearchTitle;
    NSStatusItem *mStatusItem;
    NSButton *mSCTIconView;
    NSTableView *mResultsTable;
    NSSearchField *mSearchField;
    NSView *mSearchFieldView;
    NSImageView *mBackgroundView;
    SCTGRLIndex *mGRLIndex;
    NSMutableSet *mSearchDataSources;
    NSMutableArray *mGRLSearchResults;
    NSMutableArray *mCustomSearchResults;
    NSMutableArray *mHelpSearchResults;
    int mSelectedResult;
    BOOL mSelectionInProgress;
    BOOL mIgnoreMenuClosedEvents;
    BOOL mHelpMenuIsInSearchMode;
    SCTGRL *mGRLToBeShown;
    SCTGRL *mShownGRL;
    SCTGRL *mPrevShownGRL;
    NSWindow *mSavedKeyWindow;
    NSTimer *mClearSearchTimer;
    unsigned int mLastNavigationDirection;
    struct OpaqueEventHandlerRef *mCloseMenuHandler;
    BOOL mDebugMode;
    float mSearchFrameWidth;
    int mThreadCount;
    NSConditionLock *mSearchThreadLock;
    BOOL mResetSearch;
    NSString *mSearchString;
    BOOL mTerminateSearchThread;
    unsigned int mGRLResultSequenceNumber;
    unsigned int mHelpResultSequenceNumber;
    unsigned int mQuerySequenceNumber;
    double mSearchTimeInterval;
    NSTimer *mDelayedShowcaseTimer;
    SEL mMoveUpSelector;
    SEL mMoveDownSelector;
    SEL mMoveLeftSelector;
    SEL mMoveRightSelector;
    SEL mCarriageReturnSelector;
    SEL mNewLineSelector;
    SEL mEnterSelector;
    struct OpaqueMenuRef *mPreviousHelpMenu;
    struct OpaqueEventHandlerRef *mInstallWhenTrackingHandlerRef;
}

+ (id)initShortCut;
+ (id)sharedSearchManager;
- (id)init;
- (void)loadNib;
- (void)finishAwakeFromNib:(id)fp8;
- (void)awakeFromNib;
- (void)setupSearchResults;
- (void)resetSearchResults;
- (id)searchString;
- (int)searchResultCount;
- (void)convertIndex:(int)fp8 toResults:(id *)fp12 andOffset:(int *)fp16;
- (id)searchResultAtIndex:(int)fp8;
- (id)searchTypeLabelAtIndex:(int)fp8;
- (void)stopClearSearchTimer;
- (void)startClearSearchTimer;
- (void)stopShowcase:(id)fp8;
- (void)clearSelection;
- (void)clearSearch;
- (void)updateGRLIndex;
- (void)searchCustomSearchDataSources:(id)fp8;
- (void)performSearch;
- (void)dealloc;
- (void)doSendAppleEventOfKind:(unsigned long)fp8;
- (void)sendAppleEventSetup:(id)fp8;
- (void)sendAppleEventCompleted;
- (void)applicationWillTerminate:(id)fp8;
- (void)installCarbonEventHandler;
- (long)installShortcutMenuHandlers:(struct OpaqueMenuRef *)fp8;
- (long)installShortcutView;
- (id)setupTableView:(struct _NSRect)fp8;
- (void)updateHelpResults:(id)fp8;
- (void)updateGRLResults:(id)fp8;
- (void)updateSearchView;
- (BOOL)updateSearchViewWithWidth:(float *)fp8;
- (void)setupSearchView;
- (struct _NSRect)searchFrameInScreenCoordinates;
- (void)helpMenuOpening;
- (void)helpMenuClosed;
- (void)toggleSearchMenu:(id)fp8;
- (void)hideSearchWindow;
- (void)setIgnoreMenuClosedEvents:(BOOL)fp8;
- (void)handleMenuClosed:(id)fp8;
- (BOOL)shouldTakeFocus;
- (void)makeSearchFieldKey;
- (void)selectRowAfterTargetingItem:(unsigned short)fp8 withMenu:(struct OpaqueMenuRef *)fp12;
- (void)setLastNavigationDirection:(unsigned int)fp8;
- (void)keyDown:(id)fp8;
- (void)mouseDown:(id)fp8;
- (BOOL)selectUp;
- (BOOL)selectDown;
- (void)selectResult:(int)fp8;
- (id)resultsTable;
- (BOOL)hasNoResults;
- (BOOL)searchIsInProgress;
- (int)numberOfRowsInTableView:(id)fp8;
- (id)tableView:(id)fp8 objectValueForTableColumn:(id)fp12 row:(int)fp16;
- (void)tableView:(id)fp8 willDisplayCell:(id)fp12 forTableColumn:(id)fp16 row:(int)fp20;
- (float)tableView:(id)fp8 heightOfRow:(int)fp12;
- (BOOL)tableView:(id)fp8 shouldSelectRow:(int)fp12;
- (void)controlTextDidChange:(id)fp8;
- (void)setupEditFieldKeyBindings;
- (BOOL)control:(id)fp8 textView:(id)fp12 doCommandBySelector:(SEL)fp16;
- (id)control:(id)fp8 textView:(id)fp12 completions:(id)fp16 forPartialWordRange:(struct _NSRange)fp20 indexOfSelectedItem:(int *)fp28;
- (void)doShowResource:(id)fp8;
- (void)doPerformResource:(id)fp8;
- (id)selectedGRL;
- (void)selectSearchResult:(id)fp8;
- (void)analyzeAndIndexApp:(id)fp8;
- (void)setPrevShownGRL:(id)fp8;
- (id)prevShownGRL;
- (BOOL)shouldShopShowcaseForTransitionToGRL:(id)fp8;
- (void)showcaseSelectedResult:(id)fp8;
- (void)delayedShowcaseSelectedResult:(id)fp8;
- (void)stopDelayedShowcase;
- (BOOL)selectionInProgress;
- (void)setSelectedResult:(int)fp8;
- (BOOL)handleKeyEventWhileInOtherUI:(unsigned long)fp8;
- (void)analyzeAndIndexAppDidComplete:(id)fp8;
- (id)grlIndex;
- (void)registerSearchDataSource:(id)fp8;
- (void)unregisterSearchDataSource:(id)fp8;
- (void)restoreKeyboardFocus:(id)fp8;
- (void)handleWindowDidBecomeKey:(id)fp8;
- (void)showInspectorWindow;
- (void)setDebugMode:(BOOL)fp8;
- (BOOL)debugMode;
- (BOOL)shortcutIsVisible;

@end
