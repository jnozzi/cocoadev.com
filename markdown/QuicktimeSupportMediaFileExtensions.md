

Hello,

Is there any way to get all supported Quicktime media extensions like .mov .mp3 and so on?

Thank you

----

Yep. I don't have sample code right now, but maybe you can find some on http://developer.apple.com/ . The idea is to enumerate the list of open General/QuickTime components and ask for their supported file types and/or extensions. Something like this:

    
Component component = NULL;
General/ComponentDescription looking;
General/NSCharacterSet *spaceSet = General/[NSCharacterSet characterSetWithCharactersInString:@" "];

looking.componentType = General/MovieImportType;
looking.componentSubType = 0; // Any subtype is OK
looking.componentManufacturer = 0; // Any manufacturer is OK
looking.componentFlags = movieImportSubTypeIsFileExtension;
looking.componentFlagsMask = movieImportSubTypeIsFileExtension;

while (component = General/FindNextComponent(component, &looking)) {
    General/ComponentDescription description;
    
    if (General/GetComponentInfo(component, &description, NULL, NULL, NULL) == noErr) {
        // the extension is present in the description.componentSubType field, which really holds
        // a 32-bit number. you need to convert that to a string, and trim off any trailing spaces.
        // here's a quickie...
        char ext[5] = {0};
        General/NSString *extension;

        bcopy(&description.componentSubType, ext, 4);

        extension = General/[[NSString stringWithCString:ext] stringByTrimmingCharactersInSet:spaceSet];

        // do something with extension here ...    
    }
}


If you get this working, please post better sample code. Thanks!

-- General/MikeTrent
----

Thanks Mike,

It really works!