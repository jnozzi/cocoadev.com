I'm hoping to load an General/AppleScript file (compiled or not) at a specific point in my program and then call a function therein (assuming that the author implemented it, which is a safe assumption to make). I've gotten up to the point of setting up the General/NSAppleScript, but my only options for running it are simply calling executeAndReturnError: or executeAppleEvent:...

I'm guessing that I have to use the latter, but I'm not sure how to form the General/AppleEvent, as all I know is the function name and its parameters. If this is the way I need to go, could someone explain or provide an example of passing an General/AppleScript file data type from an General/NSString path?

Your help is appreciated.

-- General/RyanGovostes

----

I don't believe this is supported in straight Cocoa. You'd have to either use Carbon, or General/NDAppleScriptObject which adds various     - (BOOL)executeSubroutineNamed:... methods

----

Or General/KFAppleScript Handler Additions.  That one's a little more lightweight. 

It's always worth looking over the General/ObjectLibrary.  

----

It is tedious but not difficult. I don't know how to call a function directly but it's easy to send an event to General/AppleScript and pass parameters to the event. In most cases, it's as good as calling a function. If you really need to call a function, then have the event handler call the function.

Essentially you send the script an General/AppleEvent with     executeAppleEvent:error:. The method accepts an General/NSAppleEventDescriptor which, in turn, can contain a reference to a list of parameters. The only point to remember is that you must fill the list of parameters with General/NSAppleEventDescriptor so if you have regular Cocoa objects (e.g. General/NSString) you must convert them to General/NSAppleEventDescriptor first.

Here's an example. Suppose you want to call the following script from Cocoa:

    on show_message(user_message)
   tell application "Finder"
      display dialog user_message
   end tell
end show_message

In Cocoa you would write (I had to adapt the code slightly before publishing, there might be a typo but the general idea is working):

    General/NSDictionary *errors = General/[NSDictionary dictionary];
General/NSString *path = General/[[NSBundle mainBundle] pathForResource:@"message" ofType:@"scpt"];
if(path)
{
   NSURL *url = [NSURL fileURLWithPath:path];
   if(url)
   {
      // load the script from a resource
      General/NSAppleScript *appleScript = General/[[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
      if(appleScript)
      {
         // create the first (and in this case only) parameter
         // note we can't pass an General/NSString (or any other object
         // for that matter) to General/AppleScript directly,
         // must convert to General/NSAppleEventDescriptor first
         General/NSAppleEventDescriptor *firstParameter = General/[NSAppleEventDescriptor descriptorWithString:@"my message"];
         // create and populate the list of parameters
         // note that the array starts at index 1
         General/NSAppleEventDescriptor *parameters = General/[NSAppleEventDescriptor listDescriptor];
         [parameters insertDescriptor:firstParameter atIndex:1];
         // create the General/AppleEvent target
         General/ProcessSerialNumber psn = { 0, kCurrentProcess };
         General/NSAppleEventDescriptor *target = General/[NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                  bytes:&psn
                                                                  length:sizeof(General/ProcessSerialNumber)];
         // create an General/NSAppleEventDescriptor with the method name
         // note that the name must be lowercase (even if it is uppercase in General/AppleScript)
         General/NSAppleEventDescriptor *handler = General/[NSAppleEventDescriptor descriptorWithString:[@"show_message" lowercaseString]];
         // last but not least, create the event for an General/AppleScript subroutine
         // set the method name and the list of parameters
         General/NSAppleEventDescriptor *event = General/[NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                 eventID:kASSubroutineEvent
                                                                 targetDescriptor:target
                                                                 returnID:kAutoGenerateReturnID
                                                                 transactionID:kAnyTransactionID];
         [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
         [event setParamDescriptor:parameters forKeyword:keyDirectObject];
         // at last, call the event in General/AppleScript
         if(![appleScript executeAppleEvent:event error:&errors]);
            R<nowiki/>eportAppleScriptErrors(errors);
         [appleScript release];
      }
      else
         R<nowiki/>eportAppleScriptErrors(errors);
   }
}

As you can see, it's not difficult to pass parameters to General/AppleScript if you remember to convert your parameters into General/NSAppleEventDescriptor.
The code is repetitive so it is worth moving into a wrapper or library.

-- General/BenoitMarchal


----

You can also call handlers that you define in a Script Suite as commands. This gives you more control as a developer over what is allowed in the General/AppleScript and gives the end user a reference. This technique was done in the Colloquy chat client for script plugins. Below is the method used to call a script handler by it's AE code and arguments keysed by an AE code (in a General/NSString). This is only a snippet, some other things are required from the full file at:

http://project.colloquy.info/trac/file/trunk/Plug-Ins/General/AppleScript%20Support/General/JVAppleScriptChatPlugin.m 

Warning: this uses a few private General/APIs.

-- General/TimothyHatcher

    - (id) callScriptHandler:(unsigned long) handler withArguments:(General/NSDictionary *) arguments forSelector:(SEL) selector {
        if( ! _script ) return nil;

        int pid = General/[[NSProcessInfo processInfo] processIdentifier];
        General/NSAppleEventDescriptor *targetAddress = General/[NSAppleEventDescriptor descriptorWithDescriptorType:typeKernelProcessID bytes:&pid length:sizeof( pid )];
        General/NSAppleEventDescriptor *event = General/[NSAppleEventDescriptor appleEventWithEventClass:'cplG' eventID:handler targetDescriptor:targetAddress returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];

        General/NSEnumerator *enumerator = [arguments objectEnumerator];
        General/NSEnumerator *kenumerator = [arguments keyEnumerator];
        General/NSAppleEventDescriptor *descriptor = nil;
        General/NSString *key = nil;
        id value = nil;

        while( ( key = [kenumerator nextObject] ) && ( value = [enumerator nextObject] ) ) {
                General/NSScriptObjectSpecifier *specifier = nil;
                if( [value isKindOfClass:General/[NSScriptObjectSpecifier class]] ) specifier = value;
                else specifier = [value objectSpecifier];

                if( specifier ) descriptor = General/value objectSpecifier] _asDescriptor]; // custom object, use it's object specitier
                else descriptor = [[[[NSAEDescriptorTranslator sharedAEDescriptorTranslator] descriptorByTranslatingObject:value ofType:nil inSuite:nil];

                if( ! descriptor ) descriptor = General/[NSAppleEventDescriptor nullDescriptor];
                [event setDescriptor:descriptor forKeyword:[key fourCharCode]];
        }

        General/NSDictionary *error = nil;
        General/NSAppleEventDescriptor *result = [_script executeAppleEvent:event error:&error];

        if( error && ! result ) { // an error
                int code = General/error objectForKey:[[NSAppleScriptErrorNumber] intValue];
                if( code == errAEEventNotHandled || code == errAEHandlerNotFound ) {
                        [self doesNotRespondToSelector:selector]; // disable for future calls
                } else {
                        General/NSString *errorDesc = [error objectForKey:General/NSAppleScriptErrorMessage];
                        General/NSScriptCommandDescription *commandDesc = General/[[NSScriptSuiteRegistry sharedScriptSuiteRegistry] commandDescriptionWithAppleEventClass:'cplG' andAppleEventCode:handler];
                        General/NSString *scriptSuiteName = General/[[NSScriptSuiteRegistry sharedScriptSuiteRegistry] suiteForAppleEventCode:'cplG'];
                        General/NSTerminologyRegistry *term = General/[[[NSClassFromString( @"General/NSTerminologyRegistry" ) alloc] initWithSuiteName:scriptSuiteName bundle:General/[NSBundle mainBundle]] autorelease];
                        General/NSString *handlerName = General/term commandTerminologyDictionary:[commandDesc commandName objectForKey:@"Name"];
                        if( ! handlerName ) handlerName = @"unknown";
                        if( General/NSRunCriticalAlertPanel( General/NSLocalizedString( @"General/AppleScript Plugin Error", "General/AppleScript plugin error title" ), General/NSLocalizedString( @"The General/AppleScript plugin \"%@\" had an error while calling the \"%@\" handler.\n\n%@", "General/AppleScript plugin error message" ), nil, General/NSLocalizedString( @"Edit...", "edit button title" ), nil, General/[self scriptFilePath] lastPathComponent] stringByDeletingPathExtension], handlerName, errorDesc ) == [[NSCancelButton ) {
                                General/[[NSWorkspace sharedWorkspace] openFile:[self scriptFilePath]];
                        }
                }

                return General/[NSError errorWithDomain:General/NSOSStatusErrorDomain code:code userInfo:error];
        }

        if( [result descriptorType] == 'obj ' ) { // an object specifier result, evaluate it to the object
                General/NSScriptObjectSpecifier *specifier = General/[NSScriptObjectSpecifier _objectSpecifierFromDescriptor:result inCommandConstructionContext:nil];
                return [specifier objectsByEvaluatingSpecifier];
        }

        // a static result evaluate it to the proper object
        return General/[[NSAEDescriptorTranslator sharedAEDescriptorTranslator] objectByTranslatingDescriptor:result toType:nil inSuite:nil];
}