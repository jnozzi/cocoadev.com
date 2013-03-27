Im trying to figure out what may be going here, basically I am working on a Core Data Document based app. When I begin to load a view in an external nib into the app I create and initialize a General/NSNib instance then load the view as the content view in a General/NSBox on the window belonging to General/MyDocument. The View loads fine but if I try to create a General/NSManagedObjectContext method in the controller class of the view that was just loaded using the following code

    
- (General/NSManagedObjectContext *)managedObjectContext
{
	return General/[[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
}


it spits out the error "*** General/NSRunLoop ignoring exception 'Cannot perform operation without a managed object context' that raised during posting of delayed perform with target 3bf160 and selector 'invokeWithTarget"

but if I do 

- (General/NSManagedObjectContext *)managedObjectContext
{
	return General/[[[[NSDocumentController sharedDocumentController] documents] objectAtIndex:0] managedObjectContext];
}

it works fine. Can anybody help me understand why the current document method fails but the object at index method works fine? The object at index method is just asking for trouble later on.

----
    -currentDocument is documented as returning nil in various circumstances, so it's probably not the best idea to use it.