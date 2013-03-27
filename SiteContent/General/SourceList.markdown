General/SourceList is an open-source iLife '08 based General/NSView subclass hosted at http://code.google.com/p/sourcelist. Let me know here if you use it and I can link you from my site at http://www.33software.com.

General/SourceList is really easy to use, it exposes three content bindings and one for selection:

* General/NSContentBinding, this should be bound to the -arrangedObjects property of an General/NSTreeController or other compatible controller.
* General/NSContentValuesBinding, these are the item titles and should be set to the appropriate controller collection subpath.
* General/KDContentImagesBinding, should also be set to the appropriate subpath.
* General/KDSelectionIndexPathBinding, which unlike General/NSSelectionIndexPathsBinding only supports a single selection, will typically be bound to the -selectionIndexPath property of the content controller.


General/SourceList is dependent on another one of my projects Amber.framework which is available at http://code.google.com/p/amber-framework.

http://33software.com/images/components/General/SourceList.jpg

The screenshot was taken of the included example application which parses the 'iTunes Music Library.xml' file, I'm moving towards using an SAX based parser to improve performance.