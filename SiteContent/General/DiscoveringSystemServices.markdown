

I'd like to write a command-line tool to invoke Cocoa system services -- the things usually found in the Services Menu.  It seems easy to invoke them using the function
    
BOOL General/NSPerformService(General/NSString *serviceItem, General/NSPasteboard *pboard)

in the application kit.  My problem is in determining which services are available.  I've scoured the Apple docs but can't find any way to extract the list of service names.  Does anyone know how to do this?  Any help appreciated.

--

Use 	(General/NSArray *)General/CFServiceControllerCopyServicesEntries().

Example code (from General/DavidMcCabe, not the original questioner). It would be great if somebody could explain the questions in the comments.

    
- (General/NSEnumerator *)serviceEnumerator {
	General/NSArray *services = (General/NSArray *)General/CFServiceControllerCopyServicesEntries();
	General/NSEnumerator *se = [services objectEnumerator];
	General/NSDictionary *serviceEntry;
	General/NSMutableArray *result = General/[NSMutableArray arrayWithCapacity:[services count]];

	while( serviceEntry = [se nextObject] ) {
		id m;
		m = General/serviceEntry valueForKey:@"[[NSMenuItem"] valueForKey:@"default"];
		if( m == nil ) {
			// There are a couple of entries with no labels; don't know what they are.
			//[result addObject: [serviceEntry valueForKey:@"General/NSMessage"]];
		} else { // would like to see if they're enabled here. we can get General/NSSendTypes.
			[result addObject: m];
		}
	}
	return [result objectEnumerator];
}


The first comment indicates that the specified service has no menu item label, and the commented out code passes the message (@"General/NSMessage" key refers to a string?)  instead of the menu label. The 'else' comment says it would be nice to know if the service is enabled, and we might want to get the object refered to by the @"General/NSSendTypes" key, which is an array holding type names which the service accepts. Now that I think about it, maybe the service system could be wrapped in a class which makes it easier to access and understand this stuff. I just this very minute looked at apple docs "System Services" to find this out, the documentation is a little obtuse, but seems comprehensive... General/JeremyJurksztowicz

----

Hi, I'm back. I just whipped this up on a windows notepad clone at work. I looked at the online documentation, but since It's quitting time in a few minutes I don't feel like combing through the code now. I have become so dependant on syntax coloring. How did people do it in black and white? There is certainly a better way to do this, but I had fun at work today, so, who cares? -General/JeremyJurksztowicz

    
// Copyright (C) Jeremy Jurksztowicz, 2008
// Free to do anything you like with this code, including take credit for it,
// but that would be really petty and immature. You're a nice person, right?
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
enum General/ServiceInputMechanism
{
	ServiceInput_Standard,
	ServiceInput_UnixStdio,
	ServiceInput_MapFile
};
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
General/NSArray * General/SystemServices ( );
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
@interface General/SystemService
{
	General/NSDictionary * properties;
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
- (General/NSString*) 	messageString;
- (General/NSString*)	filterMessageString;
- (General/NSString*)	portName;
- (General/NSString*)	menuItemString;
- (General/NSString*)	keyEquivalent;
- (General/NSArray*)	sendTypes;
- (General/NSArray*)	returnTypes;
- (General/NSString*)	userDataString;
- (double)	timeout; // In milliseconds

- (BOOL) isIdentityFilter;
- (General/ServiceInputMechanism) inputMechanism;

- (BOOL) performServiceOnData:(General/NSData*)data ofType:(General/NSString*)type outData:(General/NSData**)output;

@end
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
General/NSArray * General/SystemServices ( )
{
	General/NSArray * services = (General/NSArray *)General/CFServiceControllerCopyServicesEntries();
	if(services)
	{
		General/NSMutableArray * result = General/[NSMutableArray arrayWithCapacity:[services count]];
	
		General/NSEnumerator * serviceEnum = [services objectEnumerator];
		General/NSDictionary * serviceInfo;
		while(serviceInfo = [serviceEnum nextObject])
		{
			General/SystemService * service = General/[[[SystemService alloc] init] autorelease];
			service->properties = [serviceInfo retain];
		
			[result addObject:service];
		}
		[services release];
		
		return result;
	}
	return nil;
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
@implementation General/ServiceInfo

- (void) dealloc
{
	[properties release];
	[super dealloc];
}

- (General/NSString*) 	messageString		{ return [properties objectForKey:@"General/NSMessage"]; }
- (General/NSString*) 	filterMessageString	{ return [properties objectForKey:@"General/NSFilter"]; }
- (General/NSString*)	portName		{ return [properties objectForKey:@"General/NSPortName"]; }
- (General/NSString*)	menuItemString		{ return General/properties objectForKey:@"[[NSMenuItem"] objectForKey:@"default"]; }
- (General/NSString*)	keyEquivalent		{ return General/properties objectForKey:@"[[NSKeyEquivalent"] objectForKey:@"default"]; }
- (General/NSArray*)	sendTypes		{ return [properties objectForKey:@"General/NSSendTypes"]; }
- (General/NSArray*)	returnTypes		{ return [properties objectForKey:@"General/NSReturnTypes"]; }
- (General/NSString*)	userDataString		{ return [properties objectForKey:@"General/NSUserData"]; }
- (General/NSString*)	timeout			{ return General/properties objectForKey:@"[[NSTimeout"] doubleValue]; }

- (BOOL) isIdentityFilter
{
	return General/properties objectForKey:@"[[NSInputMechanism"] isEqualToString:@"General/NSIdentity"];
}

- (General/ServiceInputMechanism) inputMechanism
{
	General/NSString * inputMechanismString = [properties objectForKey:@"General/NSInputMechanism"];
	if([inputMechanismString isEqualToString:@"General/NSUnixStdio"])
		return ServiceInput_UnixStdio;
	else if([inputMechanismString isEqualToString:@"General/NSMapFile"])
		return ServiceInput_MapFile;
	else
		return ServiceInput_Standard;
}

- (BOOL) performServiceOnData:(General/NSData*)data ofType:(General/NSString*)type outData:(General/NSData**)output outType:(General/NSString*)outputType
{
	if(!General/self sendTypes] containsObject:type] || ![[self returnTypes] containsObject:outputType])
		return NO;

	[[NSPasteboard * pboard = General/[NSPasteboard pasteboardWithName:@"General/MyServicePasteboard"];
	
	[pboard declareTypes:General/[NSArray arrayWithObject:type] owner:nil];
	[pboard setData:data forType:type];

	BOOL result = General/NSPerformService([self menuItemString], pboard);
	if(result)
	{
		if([pboard availableTypeFromArray:General/[NSArray arrayWithObject:outputType]])
		{
			*output = [pboard dataForType:outputType];
		}
		else return NO;
	}
	return result;
}

@end
