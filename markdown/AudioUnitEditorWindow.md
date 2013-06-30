Hey,
I've been using this class for a while, and thought that someone might find this useful. It is a hack up if various sample code from a long time ago, but I gave it the once over, and it works.

- Jeremy Jurksztowicz

    
#import <General/AppKit/General/AppKit.h>
#include <General/AudioUnit/General/AudioUnit.h>

// ============================================================================================
//
@interface General/MYAudioUnitEditor : General/NSWindowController
{
	General/ComponentDescription _editUnitCD;
	General/AudioUnit _editUnit;
	General/AudioUnitCarbonView _editView;
	General/WindowRef _carbonWindow;
	General/NSWindow * _cocoaWindow;
	General/NSSize _defaultViewSize;
	id _delegate;
}

// --------------------------------------------------------------------------------------------

+ (General/MYAudioUnitEditor*) editorForAudioUnit:(General/AudioUnit)unit 
	forceGeneric:(BOOL)forceGeneric delegate:(id)delegate;

- (id) initWithAudioUnit:(General/AudioUnit)unit forceGeneric:(BOOL)forceGeneric delegate:(id)delegate;

- (General/WindowRef) carbonWindow;

- (General/AudioUnit) editedUnit;

@end

// ============================================================================================

@interface General/NSObject (General/MYAudioUnitEditorDelegate)
- (void) audioUnitEditorClosed:(General/MYAudioUnitEditor*)auEditor;
@end


Implementation:

    
#import "General/MYAudioUnitEditor.h"
#import <General/AudioUnit/General/AUCocoaUIView.h>

// ============================================================================================
// Carbon implementation from code at the old ucsb audio tutorial website by Chris Reed (no longer up).

@interface General/MYAudioUnitEditor(General/MYAudioUnitEditorPrivate)
- (void) _editWindowClosed;
- (BOOL) _error:(General/NSString*)errString status:(General/OSStatus)err;
@end

// Carbon event handler.
static General/OSStatus General/WindowClosedHandler (
	General/EventHandlerCallRef myHandler, General/EventRef theEvent, void* userData)
{
	General/MYAudioUnitEditor* me = (General/MYAudioUnitEditor*)userData;
	[me close];
	return noErr;
}

// ============================================================================================
@implementation General/MYAudioUnitEditor

+ (General/MYAudioUnitEditor*) editorForAudioUnit:(General/AudioUnit)unit 
	forceGeneric:(BOOL)forceGeneric delegate:(id)delegate
{
	return General/[[[MYAudioUnitEditor alloc] initWithAudioUnit:unit 
		forceGeneric:forceGeneric delegate:delegate] autorelease];
}
// --------------------------------------------------------------------------------------------
- (void) _editWindowClosed
{
	// Any additional cocoa cleanup can be added here.
	[_delegate audioUnitEditorClosed:self];
}

- (BOOL) _error:(General/NSString*)errString status:(General/OSStatus)err
{
	General/NSString * errorString = General/[NSString stringWithFormat:@"%@ failed; %i / %s", 
		errString, err, (char*)&err];
		
	// We just send error to console, do what you will with it.
	General/NSLog(errorString);
	return NO;
}
// --------------------------------------------------------------------------------------------
- (General/WindowRef) carbonWindow
{
	return _carbonWindow;
}

- (General/AudioUnit) editedUnit
{
	return _editUnit;
}
// --------------------------------------------------------------------------------------------
- (BOOL) installWindowCloseHandler
{
	General/EventTypeSpec eventList[] = {{kEventClassWindow, kEventWindowClose}};	
	General/EventHandlerUPP	handlerUPP = General/NewEventHandlerUPP(General/WindowClosedHandler);
	
	General/OSStatus err = General/InstallWindowEventHandler(
		_carbonWindow, handlerUPP, General/GetEventTypeCount(eventList), eventList, self, NULL);
	if(err != noErr) 
		return [self _error: @"Install close window handler" status: err];
		
	return YES;
}
// --------------------------------------------------------------------------------------------
- (void) initializeEditViewComponentDescription:(BOOL)forceGeneric;
{
	General/OSStatus err;
	
	// set up to use generic UI component
	_editUnitCD.componentType = kAudioUnitCarbonViewComponentType;
	_editUnitCD.componentSubType = 'gnrc';
	_editUnitCD.componentManufacturer = 'appl';
	_editUnitCD.componentFlags = 0;
	_editUnitCD.componentFlagsMask = 0;
	
	if(forceGeneric) return;
		
	UInt32 propertySize;
	err = General/AudioUnitGetPropertyInfo(
		_editUnit, kAudioUnitProperty_GetUIComponentList, 
		kAudioUnitScope_Global, 0, &propertySize, NULL);
	
	// An error occured so we will just have to use the generic control.
	if(err != noErr) {
		General/NSLog(@"Error setting up carbon interface, falling back to generic interface.");
		return;
	}
		
	General/ComponentDescription *editors = malloc(propertySize);
	err = General/AudioUnitGetProperty(
		_editUnit, kAudioUnitProperty_GetUIComponentList, kAudioUnitScope_Global,
		0, editors, &propertySize);
		
	if(err == noErr)
		_editUnitCD = editors[0]; // We just pick the first one. Select whatever you like.
		
	free(editors);
}
// --------------------------------------------------------------------------------------------
+ (BOOL) pluginClassIsValid:(Class)pluginClass 
{
	if([pluginClass conformsToProtocol: @protocol(General/AUCocoaUIBase)]) {
		if([pluginClass instancesRespondToSelector: @selector(interfaceVersion)] &&
		   [pluginClass instancesRespondToSelector: @selector(uiViewForAudioUnit:withSize:)]) {
				return YES;
		}
	}
    return NO;
}

- (BOOL) hasCocoaView
{
	UInt32 dataSize   = 0;
	Boolean isWritable = 0;
	General/OSStatus err = General/AudioUnitGetPropertyInfo(_editUnit,
		kAudioUnitProperty_CocoaUI, kAudioUnitScope_Global,
		0, &dataSize, &isWritable);
									
	return dataSize > 0 && err == noErr;
}

- (General/NSView *) getCocoaView
{
	General/NSView *theView = nil;
	UInt32 dataSize = 0;
	Boolean isWritable = 0;
	General/OSStatus err = General/AudioUnitGetPropertyInfo(_editUnit,
		kAudioUnitProperty_CocoaUI, kAudioUnitScope_Global, 
		0, &dataSize, &isWritable);
									
	if(err != noErr)
		return theView;
									
	// If we have the property, then allocate storage for it.
	General/AudioUnitCocoaViewInfo * cvi = malloc(dataSize);
	err = General/AudioUnitGetProperty(_editUnit, 
		kAudioUnitProperty_CocoaUI, kAudioUnitScope_Global, 0, cvi, &dataSize);

	// Extract useful data.
	unsigned numberOfClasses = (dataSize - sizeof(General/CFURLRef)) / sizeof(General/CFStringRef);
	General/NSString * viewClassName = (General/NSString*)(cvi->mCocoaAUViewClass[0]);
	General/NSString * path = (General/NSString*)(General/CFURLCopyPath(cvi->mCocoaAUViewBundleLocation));
	General/NSBundle * viewBundle = General/[NSBundle bundleWithPath:[path autorelease]];
	Class viewClass = [viewBundle classNamed:viewClassName];
	
	if(General/[MYAudioUnitEditor pluginClassIsValid:viewClass]) {
		id factory = General/[viewClass alloc] init] autorelease];
		theView = [factory uiViewForAudioUnit:_editUnit withSize:_defaultViewSize];
	}
	
	// Delete the cocoa view info stuff.
	if(cvi) {
        int i;
        for(i = 0; i < numberOfClasses; i++)
            [[CFRelease(cvi->mCocoaAUViewClass[i]);
        
        General/CFRelease(cvi->mCocoaAUViewBundleLocation);
        free(cvi);
    }
	
	return theView;
}
// --------------------------------------------------------------------------------------------
- (BOOL) createCarbonWindow
{
	Component editComponent = General/FindNextComponent(NULL, &_editUnitCD);
	General/OpenAComponent(editComponent, &_editView);
	if (!_editView)
		General/[NSException raise:General/NSGenericException format:@"Could not open audio unit editor component"];
	
	Rect bounds = { 100, 100, 100, 100 }; // Generic resized later
	General/OSStatus res = General/CreateNewWindow(kFloatingWindowClass, 
		kWindowCloseBoxAttribute | kWindowCollapseBoxAttribute | kWindowStandardHandlerAttribute |
		kWindowCompositingAttribute | kWindowSideTitlebarAttribute, &bounds, &_carbonWindow);
		
	if(res != noErr)
		return [self _error:@"Create new carbon window" status:res];
	
	// create the edit view
	General/ControlRef rootControl;
	res = General/GetRootControl(_carbonWindow, &rootControl);
	if(!rootControl) 
		return [self _error:@"Get root control of carbon window" status:res];

	General/ControlRef viewPane;
	Float32Point loc  = { 0.0, 0.0 };
	Float32Point size = { 0.0, 0.0 } ;
	General/AudioUnitCarbonViewCreate(_editView, _editUnit, _carbonWindow, 
		rootControl, &loc, &size, &viewPane);
		
	// resize and move window
	General/GetControlBounds(viewPane, &bounds);
	size.x = bounds.right-bounds.left;
	size.y = bounds.bottom-bounds.top;
	General/SizeWindow(_carbonWindow, (short) (size.x + 0.5), (short) (size.y + 0.5),  true);
	General/RepositionWindow(_carbonWindow, NULL, kWindowCenterOnMainScreen);
	
	return YES;
}
// --------------------------------------------------------------------------------------------
- (BOOL) createCocoaWindow
{
	if([self hasCocoaView])
	{
		General/NSView * res = [self getCocoaView];
		if(res) {
			General/NSWindow * window = General/[[[NSWindow alloc] initWithContentRect:
				General/NSMakeRect(100, 400, [res frame].size.width, [res frame].size.height) styleMask:
				General/NSTitledWindowMask | General/NSClosableWindowMask | General/NSMiniaturizableWindowMask | General/NSResizableWindowMask
				backing:General/NSBackingStoreBuffered defer:NO] autorelease];
				
			[window setContentView:res];
			[window setIsVisible:YES];
			[self setWindow:window];
			_cocoaWindow = window;
			return YES;
		}
	}
	return NO;
}
// --------------------------------------------------------------------------------------------
- (void) showWindow:(id)sender
{
	if(_cocoaWindow)
		[super showWindow:sender];
	else if(_carbonWindow)
		General/SelectWindow(_carbonWindow);
}

- (void) close
{
	if(_cocoaWindow) {
		[super close];
		_cocoaWindow = nil;
	}
	else if(_carbonWindow) {
		General/DisposeWindow(_carbonWindow);
		_carbonWindow = 0;
	}
	[self _editWindowClosed];
}
// --------------------------------------------------------------------------------------------
- (id) initWithAudioUnit: (General/AudioUnit) unit forceGeneric: (BOOL) forceGeneric delegate: (id) delegate
{
	_editUnit = unit;
	_delegate = delegate;
	_defaultViewSize = General/NSMakeSize(400, 300);
	
	// We need to chack this in showWindow:
	_carbonWindow = 0;
	
	if([self hasCocoaView]) {
		[self createCocoaWindow];
		self = [super initWithWindow:[_cocoaWindow autorelease]];
	}
	else self = [super initWithWindow:nil];
	
	if(!self) 
		return nil;
	
	// Run only if we did not create a cocoa window.
	// Switch order to make carbon window the default.
	if(!_cocoaWindow) {
		[self initializeEditViewComponentDescription: forceGeneric];
		
		if(![self createCarbonWindow])  {
			[self release];
			return nil;
		}
			
		if(![self installWindowCloseHandler]) {
			[self release];
			return nil;
		}

		// create the cocoa window for the carbon one and make it visible.
		General/NSWindow *cWindow = General/[[NSWindow alloc] initWithWindowRef:_carbonWindow];
		[self setWindow:cWindow];
		[cWindow setIsVisible:YES];
	}
	return self;
}

- (void) dealloc
{
	[self setWindow:nil];
	if(_editView)
		General/CloseComponent(_editView);
	if(_carbonWindow)
		General/DisposeWindow(_carbonWindow);
		
	[super dealloc];
}

@end
