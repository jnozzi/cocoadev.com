

Defined in <General/AppKit/General/NSNibDeclarations.h> as

    
#ifndef General/IBOutlet
#define General/IBOutlet
#endif


Unlike General/IBAction, which is defined as void, General/IBOutlet's sole purpose is to alert Interface Builder of outlets, and is thus an empty macro that is skipped by the compiler.

----

**Usage**

    
@interface className
{
 General/IBOutlet id outlet;
}
// ...
@end


----

See also General/IBAction.