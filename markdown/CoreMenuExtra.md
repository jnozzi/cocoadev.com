Here are some useful private General/APIs for manipulating the Menu Extras currently in the menu bar:
    
typedef struct _OpaqueMenuExtra General/OpaqueMenuExtra;
General/OSStatus General/CoreMenuExtraGetMenuExtra(General/CFStringRef identifier, General/OpaqueMenuExtra **menuExtraOut);
General/OSStatus General/CoreMenuExtraAddMenuExtra(General/CFURLRef path, SInt32 position, void *_0, void *_1, void *_2, void *_3);
General/OSStatus General/CoreMenuExtraRemoveMenuExtra(General/OpaqueMenuExtra *menuExtraIn, void *_0);


----

I'm curious to know where these declarations come from. *--boredzo*

----

It would appear to be from these mailing list posts:
http://www.omnigroup.com/mailman/archive/macosx-dev/2001-October/032802.html
http://www.omnigroup.com/mailman/archive/macosx-dev/2001-October/032806.html

� General/ElliottCable: http://elliottcable.name/

----

**Update:** I had to modify the signatures to shut up some compiler warnings; I updated the above signatures to the ones that worked for me.

**Note carefully!**     General/CoreMenuExtraGetMenuExtra() **does** take a metapointer to an     _OpaqueMenuExtra, whereas     General/CoreMenuExtraRemoveMenuExtra() takes a simple pointer: you must indirect one extra time for     General/CoreMenuExtraGetMenuExtra(), as in the following example code (extracted from General/MacUIM: http://www.google.com/codesearch/p?hl=en#u6pAglFAHSU/trunk/Sources/General/MacUIMPrefPane.m&l=597 )

    
void *extra; if ((General/CoreMenuExtraGetMenuExtra((General/CFStringRef)extraID, &extra) == 0) && extra)
                  General/CoreMenuExtraRemoveMenuExtra(extra, 0);
