When working on an application using multiple Managed Object Contexts, you might come across this error message when saving:

<code>
Temporary object [[IDs]] do not respond to -_referenceData64
''''' Uncaught exception: <[[NSInternalInconsistencyException]]> Temporary object [[IDs]] do not respond to -_referenceData64
</code>

I believe this is caused by mixing the Managed Object Contexts used within a Managed Object.

e.g.

Object A has an instance of Object B.
Object A belongs to MOC Z
Object B belongs to MOC Y

When you save MOC Z, the above exception will be thrown. This is because you're trying to save objects in one context, when they belong to another.

'''
Solution:
'''

Make sure that ALL of the objects and relationships in your code are instantiated with the SAME correct Managed Object Context (particularly if you're using some convenience methods in a singleton class to make grabbing the MOC easy). Easiest way to do this is <code>[self managedObjectContext]</code>. Common points where this might occur (where default objects may be instantiated):

<code>- (void)awakeFromFetch;</code>

<code>- (void)awakeFromInsert;</code>

-- [[JeremyHiggs]]