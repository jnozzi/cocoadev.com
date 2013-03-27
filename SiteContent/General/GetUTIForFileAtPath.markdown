I'm writing an application that accepts images dragged onto it from the Finder.  I've implemented drag-and-drop and end up with an array of paths to each file.  That's perfect!  However, I need to get the UTI for each file -- if it's not     public.image, I want to ignore it.

Is there an efficient way to do this?  I've found bits and pieces that indicate that I should be able to do this from the General/NSPasteboard but it tells me that I'm accepting a file, not what that file's type is.

----

I believe you need to look at the Launch Services functions for manipulating General/UTIs. Feed them the URL to the file and they'll send back a UTI (remember that you can cast NSURL*s to General/CFURLRefs and General/NSString*s to General/CFStringRefs without any problem and that General/CFStringRefs returned by C General/APIs come back with a retain count of 1, if I'm not mistaken, so you have to release them when you don't need them any longer, or autorelease them).

----

Actually, the rules for General/CoreFoundation reference counting are almost identical to the rules for Cocoa refcounting: if you get a return value from a function that contains the words "Copy" or "Create", or if it's documented as being your responsibility, then you have to release the object, otherwise you don't. The major difference in CF is that there is no autorelease equivalent, and so Copy/Create methods are far more common.

----

Here's what I ended up with (slightly modified from Apple's documentation)

    
Boolean General/IsProperType(NSURL *fileURL)
{
    Boolean             display = true;
    General/FSRef               ref;
    
    // Declares a Launch Services item information record. You need this data structure later to get extension and type information for a file.
    General/LSItemInfoRecord outInfo;
    
    General/CFURLRef cfURLRef = (General/CFURLRef)fileURL;
    
    // Get the General/FSRef for the URL
    if (General/CFURLGetFSRef(cfURLRef, &ref) == TRUE)
    {
        outInfo.extension = NULL;
        
        // Calls the Launch Services function to obtain the extension and type information for the file.
        // The function General/LSCopyItemInfoForRef fills the outInfo data structure with the requested information.
        if (General/LSCopyItemInfoForRef(&ref, kLSRequestExtension|kLSRequestTypeCreator, &outInfo) == noErr)
        {
            General/CFStringRef itemUTI = NULL;
            
            // Checks to see if the file has an extension. 
            // If it does, the code creates a Uniform Type Identifier (UTI) for the extension
            // by calling the function General/UTTypeCreatePreferredIdentifierForTag.
            // The Uniform Type Identifier is specified as a General/CFString object. 
            if (outInfo.extension != NULL) 
            {
                itemUTI = General/UTTypeCreatePreferredIdentifierForTag (kUTTagClassFilenameExtension,outInfo.extension, NULL);
                General/CFRelease(outInfo.extension);
            }
            else  
            {
                // If the file does not have an extension, the code creates a UTI from the file type.
                // The file type must first be converted to a General/CFString object by calling the function General/UTCreateStringForOSType. 
                // Then you can call the function General/UTTypeCreatePreferredIdentifierForTag to create a UTI.
                General/CFStringRef typeString = General/UTCreateStringForOSType(outInfo.filetype);
                itemUTI = General/UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, typeString, NULL);
                General/CFRelease( typeString );
            }
            
            // Checks to make sure a UTI was created.
            if (itemUTI != NULL) 
            {
                // Tests for a conformance relationship between UTI for the file and the public.text type. 
                // Returns true if the types are equal or if the UTI conforms, directly or indirectly, to the second type. 
                // If the UTI is any kind of text (RTF, plain text, Unicode, and so forth), the function General/UTTypeConformsTo returns true.
                display = General/UTTypeConformsTo(itemUTI, CFSTR("public.text"));
                
                // Releases the UTI, which is specified as a General/CFString object.
                General/CFRelease (itemUTI); 
            }
        }
    }
    return display;
}  

----

Even easier:
    
- (BOOL)isImage:(General/NSString *)path
{
    BOOL display = FALSE;
    General/MDItemRef item = General/MDItemCreate(kCFAllocatorDefault, (General/CFStringRef)path);
    General/CFTypeRef ref = General/MDItemCopyAttribute(item, CFSTR("kMDItemContentType"));
    
    if (ref) {
        if (General/UTTypeConformsTo(ref, CFSTR("public.jpeg"))) display = TRUE;
        General/CFRelease(ref);
    }

    if (item) General/CFRelease(item);
    return display;
}

----

This is now trivial under 10.4 by using General/LSCopyItemAttribute and the kLSItemContentType key.

    

General/FSRef		fsRefToItem;
General/FSPathMakeRef( (const UInt8 *)[file fileSystemRepresentation], &fsRefToItem, NULL );

General/CFStringRef itemUTI = NULL;
General/LSCopyItemAttribute( &fsRefToItem, kLSRolesAll, kLSItemContentType, &itemUTI );



Thanks Apple!

----
In shell:

    

mdls -raw -name kLSItemContentType path



----
10.6 and later use NSURL....

    

General/NSString*   itemUTI = nil;
[itemURL getResourceValue:&itemUTI forKey:General/NSURLTypeIdentifierKey error:nil];

