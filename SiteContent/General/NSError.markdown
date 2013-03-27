General/NSError and related methods provide standard ways of passing error codes and explanatory text, and handling display functionality.

Conceptual overview � http://developer.apple.com/documentation/Cocoa/Conceptual/General/ErrorHandlingCocoa/index.html

API reference � http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSError_Class/Reference/Reference.html

See also General/ErrorCodes.

----

Cocoa General/NSError support includes an error responder chain, that works something like the event responder chain.

A useful idiom for your own methods which may need to return an error:     -(BOOL)doSomething:(id)anArgument error:(General/NSError **)anErr;  On failure, instantiate an General/NSError (unless you already got one returned to you by Cocoa) and pass it back in the argument reference, and return NO. This can be passed up through classes in the chain. 

To display the error to the user (and optionally offer recovery procedures), you can pass it to     -presentError:, which puts it into the error responder chain. 

To display an error in a sheet, use     -[presentError:modalForWindow:delegate:didPresentSelector:contextInfo:]. Implement delegate methods to handle the users response.

To customize how General/NSApplication presents your error, provide     -application:willPresentError: in your delegate.