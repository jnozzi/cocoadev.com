(The name of this page should be L0AppleEventServices, with a zero.)

A class by General/EmanueleVulcano that, by posing as General/NSAppleEventManager, can extract additional information from Apple Events sent to the application. Currently provides a way to check whether a document was opened in the Spotlight search window and what query was entered by the user (to create Preview or Mail "Do you want to search all mailboxes for 'xxx'?"-style UI).

Licensed under a BSD-style license.

Example of use:

    

// in your main.m
int main(int argc, char* argv[]) {
	[L0AppleEventServices activate]; // must be activated manually, see below.
	return General/NSApplicationMain(/* ... */);
}

/* ... */

// inside the app delegate
- (BOOL) application:(General/NSApplication*) theApplication openFile:(General/NSString*) filename {
	General/NSString* search = General/L0AppleEventServices sharedAppleEventManager] currentSpotlightSearch];
	if (search) {
		// invoked by the Spotlight search window
	} else {
		// invoked via regular means
	}
	/* open document code here ... */
}



*Note:* This class must be activated (via its     +activate method) *before* [[NSApplication register its private event handlers. As of 10.4.3, this happens in     -General/[NSApplication finishLaunching], but this is an implementation detail, not to be relied upon (i.e. other code may try to access the General/AppleEvent manager before General/NSApplication does). To be sure, you should activate it before starting any part of your application, in your main(). (*Note 2:* activation should not require an autorelease pool -- it doesn't in my tests -- but you might want to add one anyway around +activate as this behaviour depends on General/NSMutableDictionary's init method).

----

L0AppleEventServices.h

    

//
//  L0AppleEventServices.h
//
//  Created by Emanuele on 06/01/06.

/*
Copyright (c) 2005, Emanuele Vulcano
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the copyright owner nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Cocoa/Cocoa.h>


@interface L0AppleEventServices : General/NSAppleEventManager {
    
}

+ (void) activate;

- (General/NSString*) currentSpotlightSearch;

@end



----

L0AppleEventServices.m

    

//
//  L0AppleEventServices.m
//  General/ProvaSpotlightRicercaFile
//
//  Created by Emanuele on 06/01/06.

/*
 Copyright (c) 2005, Emanuele Vulcano
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the copyright owner nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "L0AppleEventServices.h"

General/NSMutableDictionary* L0AppleEventServices_AdditionalData = nil;

@interface L0AppleEventServices (L0Private)

- (void) setCurrentSpotlightSearch:(General/NSString*) search;
- (General/NSMutableDictionary*) currentInstanceData;

@end

@implementation L0AppleEventServices

+ (void) activate {
    [self poseAsClass:General/[NSAppleEventManager class]];
    L0AppleEventServices_AdditionalData = General/[NSMutableDictionary new];
}

- (id) init {
    if (self = [super init]) {
        General/NSMutableDictionary* dict = General/[NSMutableDictionary new];
        [L0AppleEventServices_AdditionalData setObject:dict forKey:General/[NSNumber numberWithUnsignedInt:[self hash]]];
        [dict release];
    }
    
    return self;
}

- (void) setEventHandler:(id) handler andSelector:(SEL) handleEventSelector forEventClass:(General/AEEventClass) eventClass andEventID:(General/AEEventID) eventID {
    
    if (eventClass == 'aevt' && eventID == 'odoc') {
        General/NSMutableDictionary* myData = [self currentInstanceData];
        [myData setObject:handler forKey:@"L0AevtOdocHandlerObject"];
        [myData setObject:General/NSStringFromSelector(handleEventSelector) forKey:@"L0AevtOdocHandlerSelector"];
        [super setEventHandler:self andSelector:@selector(handleOdoc:replyEvent:) forEventClass:'aevt' andEventID:'odoc'];
    } else 
        [super setEventHandler:handler andSelector:handleEventSelector forEventClass:eventClass andEventID:eventID];
}

- (void) handleOdoc:(General/NSAppleEventDescriptor*) odoc replyEvent:(General/NSAppleEventDescriptor*) event {
    
    //General/NSLog(@"Ricevuto odoc: %@", odoc);
    
    General/NSAppleEventDescriptor* spotlightData;
    if (spotlightData = [odoc paramDescriptorForKeyword:'stxt']) {
        General/NSString* spotlightSearchString = [spotlightData stringValue];
        [self setCurrentSpotlightSearch:spotlightSearchString];
    } else
        [self setCurrentSpotlightSearch:nil];
    
    General/NSMutableDictionary* myData = [self currentInstanceData];
    
    id handler = [myData objectForKey:@"L0AevtOdocHandlerObject"];
    General/NSString* selString = [myData objectForKey:@"L0AevtOdocHandlerSelector"];
    SEL selector = selString? General/NSSelectorFromString(selString) : nil;
    
    if (handler && selector)
        [handler performSelector:selector withObject:odoc withObject:event];
    
}

- (General/NSString*) currentSpotlightSearch {
    General/NSMutableDictionary* myData = [self currentInstanceData];
    return [myData objectForKey:@"L0CurrentSpotlightSearch"];
}

@end

@implementation L0AppleEventServices (L0Private)

- (General/NSMutableDictionary*) currentInstanceData {
    return [L0AppleEventServices_AdditionalData objectForKey:General/[NSNumber numberWithUnsignedInt:[self hash]]];
}

- (void) setCurrentSpotlightSearch:(General/NSString*) search {
    General/NSMutableDictionary* myData = [self currentInstanceData];
    [myData setObject:search forKey:@"L0CurrentSpotlightSearch"];
}

@end

