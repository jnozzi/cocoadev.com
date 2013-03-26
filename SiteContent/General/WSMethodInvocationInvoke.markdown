Greetings:
   I'm taking baby steps here.  All I want to do is to call [[WSMethodInvocationInvoke]]() without parameters and get any response.

Here's what I have:
<code>
@try { 
        // I. Define the location of the SOAP service and method. 
           // Create a method invocation. Parameters:
           // (1) URL to the SOAP service; 
           // (2) the name of the SOAP method to call; 
           // (3) a constant to specify the SOAP2001 protocol; 
        soapCall = [[WSMethodInvocationCreate]](([[CFURLRef]])soapURL,         // (1)
                                            ([[CFStringRef]])theAction,    // (2)
                                            kWSSOAP2001Protocol);      // (3)
        
       
         
        // II. Set up the parameters to be passed to the SOAP method.
        
        // III. Make the call and parse the results.
        
        theResultDict = ([[NSDictionary]]'')[[WSMethodInvocationInvoke]](soapCall); 

        // If the results are a fault, display an error to the user with the fault 
        // code and descriptive string 
        if ([[WSMethodResultIsFault]](([[CFDictionaryRef]])theResultDict)) { 
            [[NSRunAlertPanel]]([[[NSString]] stringWithFormat:@"Error %@", 
                             [theResultDict objectForKey: ([[NSString]]'')kWSFaultCode]], 
                            [theResultDict objectForKey: ([[NSString]]'')kWSFaultString], @"OK", @"", @""); 
        } else { 
            // Otherwise, pull the results from the dictionary, 
            // held as another dictionary named "soapVal" 
            [[NSDictionary]] ''dictionary = [theResultDict objectForKey:([[NSString]]'')kWSMethodInvocationResult]; 
            
         } // end if().
</code>

This is merely a shell.
I've launched this in Xcode 3.1 (beta) using Leopard OS 10.5.2.

The code HANGS at [[WSMethodInvocationInvoke]]().

I was expecting an error or a nil reply or something.

Any ideas?

Ric.