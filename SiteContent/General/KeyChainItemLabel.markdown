I want to use the keychain to store and retrieve internet passwords. This is not the big problem, i.e. I use: http://goo.gl/General/OeSCu
    
#include <Security/General/SecKeychain.h>

   // store a password in the keychain
   General/OSStatus status = General/SecKeychainAddInternetPassword(
      NULL,                            // General/SecKeychainRef keychain, 
      strlen(server),                  // UInt32 serverNameLength, 
      server,                          // const char *serverName, 
      0,                               // UInt32 securityDomainLength, 
      NULL,                            // const char *securityDomain, 
      strlen(account),                 // UInt32 accountNameLength, 
      account,                         // const char *accountName, 
      strlen(path),                    // UInt32 pathLength, 
      path,                            // const char *path, 
      port,                            // UInt16 port, 
      kSecProtocolTypeFTP,             // General/SecProtocolType protocol, 
      kSecAuthenticationTypeDefault,   // General/SecAuthType authType, 
      strlen(password),                // UInt32 passwordLength, 
      password,                        // const void *passwordData, 
      &item                            // General/SecKeychainItemRef *itemRef
   );

   // retrieve a password from the keychain
   General/OSStatus status = General/SecKeychainFindInternetPassword(
      NULL,                            // General/CFTypeRef keychainOrArray, 
      strlen(server),                  // UInt32 serverNameLength, 
      server,                          // const char *serverName, 
      0,                               // UInt32 securityDomainLength, 
      NULL,                            // const char *securityDomain, 
      strlen(account),                 // UInt32 accountNameLength, 
      account,                         // const char *accountName, 
      strlen(path),                    // UInt32 pathLength, 
      path,                            // const char *path, 
      port,                            // UInt16 port, 
      kSecProtocolTypeFTP,             // General/SecProtocolType protocol, 
      kSecAuthenticationTypeDefault,   // General/SecAuthType authType, 
      &passwordLength,                 // UInt32 *passwordLength, 
      &passwordBuf,                    // void **passwordData, 
      &item                            // General/SecKeychainItemRef *itemRef
   );


The problem is, that in the keychain the entry is shown as the account name -- and likewise, when my application request the password, the system tells me that my app wish to access <account>, which is quite ambiguous.

I did find kSecLabelItemAttr in the "documentation", which I assume can be used to set the label differently. But for General/SecKeychainItemModifyAttributesAndData() to work (which I assume is what I want, or perhaps General/SecKeychainItemModifyContent()) I need to set up attribute lists and such which I don't really understand. Can anyone clarify the meaning of:


* General/SecKeychainAttribute -- what is the type?
* General/SecKeychainAttributeList -- am I to set this up manually (with count and attr pointer)?
* General/SecKeychainAttributeInfo -- and what the h... is this?
* 'data' and 'length' -- given to many functions, but how does one data/length pair relate to a list of attributes?


For the records, I do know the concept of attributes (and associated values), it is just the way they are used in the security framework which confuses me.

On a related note, both the Add and Find functions return a reference to a keychain item -- is it my responsibility to release this somehow? and if not, for how long is the reference valid?

Also, what is the recommended behaviour if e.g. I request a password, am denied access, the user enters it (in my program): should I store this new password, cause then there will be two entries for the same server?

----

You might find the Carbon Keychain API is better for you, I don't really know. I wonder if Apple will ever open up their Cocoa API (General/SecurityHICocoa.framework). -- General/FinlayDobbie

----

I thought the above *was* the Carbon API?!?

----

**Updated:** With the release of Panther, there finally is some actual documentation on the concepts of the General/KeyChain: http://developer.apple.com/documentation/Security/Conceptual/keychainServConcepts/01introduction/index.html

This includes an example of how to construct a 'custom' entry, which is actually just a normal internet password, but with an extra attribute (being the label, which is what I wanted above), and there is also an example of how these attribute lists are constructed.

Also with Panther, it no longer uses 'account' as the name of the General/KeyChainItem, but for internet passwords it uses the server part of the URL (which makes more sense).

----

I think the above link is now: http://developer.apple.com/documentation/Security/Reference/keychainservices/

----

On the little example page is says:

    status = General/SecKeychainItemModifyAttributesAndData (
     itemRef,            // the item reference
     &attributes,        // no change to attributes
     passwordLength,     // length of password
     password            // pointer to password data
     );


this is the problem I'm having, the attributes are not getting changed.  The password changes fine, but I want to change the account info as well.  I have almost copied the code from there verbatim so I know the attribute list is getting created correctly.  I just can't figure out how to get the attributes to change.  I know Obj-C pretty well but am still a bit shaky on C so my problem may be there.  Any ideas?

----

I can not give you any advice on the attributes, but when I call:

    err = General/SecKeychainItemModifyAttributesAndData(item, nil, strlen(passwordUTF8), &passwordUTF8);

the password is garbled afterwards. Any idea why that happens?

Thanks,

Alex

----

Alex, try dropping the & from passwordUTF8 - it looks like you're passing a pointer to the c-string, instead of the c-string itself.

----

General/SecKeychainItemModifyAttributesAndData should be General/SecKeychainItemModifyContent

Cheers,
Brian Amerige.

----

It's better to use General/SecKeychainItemModifyAttributesAndData as it's the newer function and hadles more attributes. Not a problem for modifing the data but might as well stick to the lastest General/APIs.

----

If you need to use attributes from the keychain, read "Re:Creating a General/SecKeychainAttributeList" at lists.apple.com (apple-cdsa) post by General/AaronHillegass. It seems a lot easier to use the function to create "all" attributes for the class rather than try to create a specific Info struct manually.