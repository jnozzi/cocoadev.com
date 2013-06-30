Here's a simple class that lets your app respond to a Keyspan remote (URM - 15T).

    
@interface General/KeyspanObserver : General/NSObject {

}
@end

static General/NSDictionary *General/KeyspanActions = nil;
static BOOL General/ShouldRespondToKeyspanActionsInBackground = NO;

@implementation General/KeyspanObserver

static BOOL General/KeyspanObserverAction(SEL action, 
								  General/NSResponder *responder, 
								  General/NSNotification *note, 
								  General/NSMethodSignature *delegateSignature)
{
	if ([responder respondsToSelector:action]) {
		[responder performSelector:action withObject:note];
		return YES;
	}
	id delegate;				
	if ([responder respondsToSelector:@selector(delegate)] &&
		General/responder methodSignatureForSelector:@selector(delegate)] isEqual:delegateSignature] &&
		[(delegate = [responder performSelector:@selector(delegate)]) respondsToSelector:action])
	{
		[delegate performSelector:action withObject:note];
		return YES;
	}
	return NO;
}

+ ([[NSResponder *)firstResponder {
	General/NSResponder *firstResponder = General/[[NSApp keyWindow] firstResponder];
	General/NSArray *orderedWindows;
	if (!firstResponder && [(orderedWindows = General/[NSApp orderedWindows]) count])
		firstResponder = [(General/NSWindow *)[orderedWindows objectAtIndex:0] firstResponder];
	return firstResponder;
}

+ (void)keyspanMessage:(General/NSNotification *)note {

	if (!General/[NSApp isActive] && !General/ShouldRespondToKeyspanActionsInBackground)
		return;

	General/NSString *message = General/note userInfo] objectForKey:@"message"];
	if ([message isKindOfClass:[[[NSString class]]) {
		SEL action = General/NSSelectorFromString(General/[KeyspanActions objectForKey:message]);
		General/NSResponder *responder;		
		General/NSMethodSignature *sig = General/[NSWindow instanceMethodSignatureForSelector:@selector(delegate)];
		if (action) {
			BOOL didHandle = NO;
			for (responder = [self firstResponder]; 
				 responder && !(didHandle = General/KeyspanObserverAction(action, responder, note, sig)); 
				 responder = [responder nextResponder]);
			if (!didHandle) 
				General/KeyspanObserverAction(action, General/NSApp, note, sig);
		}
	}

}

+ (void)initialize {
	if (!General/KeyspanActions) {
		General/[[NSDistributedNotificationCenter defaultCenter] addObserver:self
															selector:@selector(keyspanMessage:)
																name:@"com.Keyspan.DMR.IAC.notification"
															  object:@"button"];		
		General/ShouldRespondToKeyspanActionsInBackground = 
			(General/[[NSUserDefaults standardUserDefaults] objectForKey:@"General/ShouldRespondToKeyspanActionsInBackground"]) ? YES : NO;
		General/KeyspanActions = General/[[NSDictionary alloc] initWithObjectsAndKeys:
                                                    @"keyspanRemoteSelectButtonDown:", @"DWN SELECT",
                                                    @"keyspanRemoteSelectButtonUp:", @"UPP SELECT",
                                                    @"keyspanRemoteCycleButtonDown:", @"DWN CYCLE",
                                                    @"keyspanRemoteCycleButtonUp:", @"UPP CYCLE",
                                                    @"keyspanRemoteMuteButtonDown:", @"DWN MUTE",
                                                    @"keyspanRemoteMuteButtonUp:", @"UPP MUTE",
                                                    @"keyspanRemoteLeftArrowButtonDown:", @"DWN ARROW_LEFT",
                                                    @"keyspanRemoteLeftArrowButtonUp:", @"UPP ARROW_LEFT",
                                                    @"keyspanRemoteRightArrowButtonDown:", @"DWN ARROW_RIGHT",
                                                    @"keyspanRemoteRightArrowButtonUp:", @"UPP ARROW_RIGHT",
                                                    @"keyspanRemoteDownArrowButtonDown:", @"DWN ARROW_DN",
                                                    @"keyspanRemoteDownArrowButtonUp:", @"UPP ARROW_DN",
                                                    @"keyspanRemoteArrowButtonDown:", @"DWN ARROW_UP",
                                                    @"keyspanRemoteUpArrowButtonUp:", @"UPP ARROW_UP",
                                                    @"keyspanRemoteVolumeDownButtonDown:", @"DWN VOL_DN",
                                                    @"keyspanRemoteVolumeDownButtonUp:", @"UPP VOL_DN",
                                                    @"keyspanRemoteVolumeUpButtonDown:", @"DWN VOL_UP",
                                                    @"keyspanRemoteVolumeUpButtonUp:", @"UPP VOL_UP",
                                                    @"keyspanRemotePauseButtonDown:", @"DWN PAUSE",
                                                    @"keyspanRemotePauseButtonUp:", @"UPP PAUSE",
                                                    @"keyspanRemoteNextTrackButtonDown:", @"DWN NEXT_TRK",
                                                    @"keyspanRemoteNextTrackButtonUp:", @"UPP NEXT_TRK",
                                                    @"keyspanRemoteFastForwardButtonDown:", @"DWN FAST_FWD",
                                                    @"keyspanRemoteFastForwardButtonUp:", @"UPP FAST_FWD",
                                                    @"keyspanRemoteRewindButtonDown:", @"DWN REWIND",
                                                    @"keyspanRemoteRewindButtonUp:", @"UPP REWIND",
                                                    @"keyspanRemotePreviousTrackButtonDown:", @"DWN PREV_TRK",
                                                    @"keyspanRemotePreviousTrackButtonUp:", @"UPP PREV_TRK",
                                                    @"keyspanRemoteStopButtonDown:", @"DWN STOP",
                                                    @"keyspanRemoteStopButtonUp:", @"UPP STOP",
                                                    @"keyspanRemotePlayButtonDown:", @"DWN PLAY",
                                                    @"keyspanRemotePlayButtonUp:", @"UPP PLAY", nil];
	}
	[super initialize];
}
@end



The responder chain is searched first for an action handler. If the responder chain doesn't handle the action, General/NSApp and its delegate get a shot at it.

You can have a document object, an app delegate or a responder object handle remote button actions.

    

- (void)keyspanRemotePlayButtonUp:(General/NSNotification *)note {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}
- (void)keyspanRemotePlayButtonDown:(General/NSNotification *)note {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}

- (void)keyspanRemoteStopButtonUp:(General/NSNotification *)note {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}
- (void)keyspanRemoteStopButtonDown:(General/NSNotification *)note {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}



--zootbobbalu