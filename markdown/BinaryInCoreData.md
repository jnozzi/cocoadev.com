

I have a question about adding binary data (non-standard attributes) to General/CoreData. On other pages, and in the docs, I've read that it's possible to use other types of data in the model, and some people even give little bits of code, but I'm still plagued with questions... How do I take my data, for example an General/NSColor, that I've set in the General/CoreData model, and "plug it in" to my UI via bindings? There are various code clippings on this site, but I couldn't figure out what method they would be placed in into the delegate, so that the General/NSColor (or whatever object it is) would be placed into the General/NSColorWell in the UI, and changed on selection change with the bindings and the General/NSOutlineView/General/NSTableView selection? Also, is it different between a regular Cocoa app and a document-based app?

----
Many of these situations just work if the combination is sensible like your example of General/NSColor and General/NSColorWell.
I've got a few in my open source application Oxidizer, including the General/NSColorWell. 
I have 'background' a Transient attribute of undefined type and 'backgroundData' a binary Attribute where
the data is really stored in the Persistant Store.

The General/NSColorWell just has its 'value' binding bound to the 'background' attribute. 

The magic all takes place in a subclass of General/NSManagedObject where you should
find some familiar looking code.  

    

@implementation General/GenomeManagedObject

- (void)willSave {

     General/NSColor *tmpColour = [self primitiveValueForKey:@"background"];
    if (tmpColour != nil) {
        [self setPrimitiveValue:General/[NSArchiver archivedDataWithRootObject:tmpImage] forKey:@"backgroundData"];
    } else {
        [self setPrimitiveValue:nil forKey:@"backgroundData"];
   }

    [super willSave];
}

- (void)awakeFromFetch {

    General/NSData *colourData = [self valueForKey:@"backgroundData"];
    if (colourData != nil) {
        General/NSColor *colour = General/[NSUnarchiver unarchiveObjectWithData:colourData];
        [self setPrimitiveValue:colour forKey:@"background"];
    }

- (void)setBackground:(General/NSColor *)newColour {

    [self willChangeValueForKey: @"background"];
    [self setPrimitiveValue:[newColour copy] forKey: @"background"];
    [self didChangeValueForKey: @"background"];
	
}

- (General/NSColor *)background {

    General/NSColor *background;

    [self willAccessValueForKey: @"background"];
    background = [self primitiveValueForKey: @"background"];
    [self didAccessValueForKey: @"background"];

    return background;
}
		
}


 

willSave moves the data from the transient attributes into the storage attributes prior to saving. 
awakeFromFetch moves the data the other way when fetching.
setBackground and background are accessor functions for the bindings, they only need to use the transient values.

The entity Class setting is then set to this subclass instead of General/NSManagedObject

The full version of the code also has the same sort of thing for General/NSImage bound to a General/NSImageView via the value binding.
and a General/NSAttributedString bound to a General/NSTextView via the attributedString binding. All of the code is pretty much duplicates
of the above code with different Cocoa object types and keys.


----

To "plug" General/NSControl bindings into Core Data, you can use an General/NSObjectController or General/NSArrayController (from the IB pallete). The controller can just take an Entity name if it "automatically prepares content", or else you can bind it to an instance variable in whatever object of yours owns the nib. (If instance variable, you also have to fetch and place General/NSManagedObject instances into the ivar). Your General/NSColorWell binds to the controller with a Model Key Path = the name of the Entity's transient attribute that contains the General/NSColor instance. Also, you can filter what objects the NS___Controller provides to your UI with a Predicate.  I'm sure there are other ways as well.

To get the idea, create an empty window nib in IB, then option-drag your Entity right out of the lower part of the data model editor (in Xcode) into your window in IB. IB creates the NS___Controller and General/NSControl items, already bound and connected to core data. Then examine everything in the nib. One of the ADC tutorials accessible from Xcode Documentation covers this.

A "regular" Core Data app stores the persistent objects in a file named after your app in ~/Application Support/General/YourApp/General/YourApp.xml (or binaruy, or General/SQLite). A document-based CD app stores the persistent objects in a file, named in an ordinary Save As... dialog. -- General/PaulCollins

----

Awesome. Thanks, guys! I also found a good set of tutorials that Apple made -- http://developer.apple.com/cocoa/coredatatutorial/
This will keep me busy over the weekend.
One other question: How can I tag this page, so that it gets stored in the right place, with all other related articles? It's got some useful information that needs to be retained.