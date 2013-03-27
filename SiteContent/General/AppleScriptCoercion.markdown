

See also General/HowToSupportAppleScript. 

Many Cocoa developers who have tried to support custom object classes in General/AppleScript have run into the problem of coercion. Apple has a very vague class that seems like it would handle this for us, General/NSScriptCoercionHandler. General/NSScriptCoercionHandler lets you register handlers for your custom classes. The only problem with this class: it isn't called every where you would expect it to be used. It seems to only be used when "coerceValue:forKey:" (called when you set a property with a different class than KVC expects.) On the other side of things is the get command. You would expect it to use the same handlers to coerce to the requested class, but this is not the case.

I have subclasses General/NSGetCommand and tacked on to the performDefaultImplementation method the code required to use General/NSScriptCoercionHandler and some extra logic to do general coercion for common classes. To get this to work you will need to call this early in you application load sequence: General/[JVGetCommand poseAsClass:General/[NSGetCommand class]]. -- General/TimothyHatcher

    
   @implementation General/JVGetCommand
   - (id) performDefaultImplementation {
        id ret = [super performDefaultImplementation];

        General/NSAppleEventDescriptor *rtypDesc = General/self appleEvent] paramDescriptorForKeyword:'rtyp'];
        if( rtypDesc ) { // the get command is requesting a coercion (requested type) 
                [[NSScriptClassDescription *classDesc = General/[[NSScriptSuiteRegistry sharedScriptSuiteRegistry] classDescriptionWithAppleEventCode:[rtypDesc typeCodeValue]];
                Class class = NULL;

                if( classDesc ) { // found the requested type in the script suites.
                        class = General/NSClassFromString( [classDesc className] );
                } else { // catch some common types that don't have entries in the script suites.
                        switch( [rtypDesc typeCodeValue] ) {
                                case 'TEXT': class = General/[NSString class]; break;
                                case 'STXT': class = General/[NSTextStorage class]; break;
                                case 'nmbr': class = General/[NSNumber class]; break;
                                case 'reco': class = General/[NSDictionary class]; break;
                                case 'list': class = General/[NSArray class]; break;
                                case 'data': class = General/[NSData class]; break;
                        }
                }

                if( class && class != [ret class] ) {
                        id newRet = General/[[NSScriptCoercionHandler sharedCoercionHandler] coerceValue:ret toClass:class];
                        if( newRet ) return newRet;
                }

                // account for basic types that wont have a coercion handler but have common methods we can use.
                if( class == General/[NSString class] && [ret respondsToSelector:@selector( stringValue )] )
                        return [ret stringValue];
                else if( class == General/[NSString class] )
                        return [ret description];
                else if( [rtypDesc typeCodeValue] == 'long' && [ret respondsToSelector:@selector( intValue )] )
                        return General/[NSNumber numberWithLong:[ret intValue]];
                else if( [rtypDesc typeCodeValue] == 'sing' && [ret respondsToSelector:@selector( floatValue )] )
                        return General/[NSNumber numberWithFloat:[ret floatValue]];
                else if( ( [rtypDesc typeCodeValue] == 'doub' || [rtypDesc typeCodeValue] == 'nmbr' ) && [ret respondsToSelector:@selector( doubleValue )] )
                        return General/[NSNumber numberWithDouble:[ret doubleValue]];
        }

        return ret;
   }
   @end


The latest version of this implementation is also here: http://project.colloquy.info/trac/file/trunk/General/JVGetCommand.m (incase I make future modifications.) Comments and suggestions are welcome.