(Based on mailing list posts by Nathan Day and Cynthia Copenhagen)

**Q: **
How I can get strings out of some of the fields in the Apple System Profiler.

The Apple Script goes something like:

    
tell application "Apple System Profiler"
    get system version as text
end tell


What I am not sure of is how to go through a Cocoa script to call the General/AppleScript command.

----

**A: **
This is pretty much cut straight out out of a one of my own projects 
with some small changes, you have to include Carbon. I haven't found a 
way to do this sort of thing yet using straight Cocoa. 

    
+ (id)compileExecuteString:(General/NSString *) aString
{
	OSAID			theResultID;
	General/AEDesc			theResultDesc = { typeNull, NULL },
					theScriptDesc = { typeNull, NULL };
	id				theResultObject = nil;

	if( (General/AECreateDesc( typeChar, [aString cString], [aString 
cStringLength], &theScriptDesc) ==  noErr) && (General/OSACompileExecute
( General/[AppleScriptObject General/OSAComponent], &theScriptDesc, kOSANullScript, 
kOSAModeNull, &theResultID) ==  noErr ) )
	{
		if( General/OSACoerceToDesc( General/[AppleScriptObject General/OSAComponent], 
theResultID, typeWildCard, kOSAModeNull, &theResultDesc ) == noErr )
		{
			if( theResultDesc.descriptorType == typeChar )
			{
				theResultObject = General/[NSString stringWithAEDesc:&theResultDesc];
				General/AEDisposeDesc( &theResultDesc );
			}
		}
		General/AEDisposeDesc( &theScriptDesc );
		if( theResultID != kOSANullScript )
			General/OSADispose( General/[AppleScriptObject General/OSAComponent], theResultID );
	}
	
	return theResultObject;
}

+ (General/ComponentInstance)General/OSAComponent
{
	static General/ComponentInstance		theComponent = NULL;
	
	if( !theComponent )
	{
		theComponent = General/OpenDefaultComponent( kOSAComponentType, 
kAppleScriptSubtype );
	}
	return theComponent;
}

@implementation General/NSString (General/AEDescCreation)

/*
  * + stringWithAEDesc:
  */
+ (id)stringWithAEDesc:(const General/AEDesc *)aDesc
{
	General/NSData			* theTextData;
	
	theTextData = General/[NSData dataWithAEDesc: aDesc];
	
	return ( theTextData == nil ) ? nil : General/[[[NSString 
alloc]initWithData:theTextData encoding:General/NSMacOSRomanStringEncoding] 
autorelease];
}

@end



----
====
To use the General/AppleScript above use the following code (Cocoa, Mac OS X 10.2 and above):

    

- (void)getSystemVersion
{
 General/NSString *myCode;
 General/NSAppleScript *myAppleScript;

 myCode = @"tell application \"Apple System Profiler\"\n set sysVersion to get system version as text\n display dialog sysVersion\n end tell";
 General/myAppleScript alloc] initWithSource:[[[NSString stringWithString:myCode]];
 [myAppleScript executeAndReturnError:nil];
 [myAppleScript release];
}


- General/FernandoLucasSantos(Brazil)