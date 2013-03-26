

Defined in <[[AppKit]]/[[NSNibDeclarations]].h> as

<code>
#ifndef [[IBOutlet]]
#define [[IBOutlet]]
#endif
</code>

Unlike [[IBAction]], which is defined as void, [[IBOutlet]]'s sole purpose is to alert Interface Builder of outlets, and is thus an empty macro that is skipped by the compiler.

----

'''Usage'''

<code>
@interface className
{
 [[IBOutlet]] id outlet;
}
// ...
@end
</code>

----

See also [[IBAction]].