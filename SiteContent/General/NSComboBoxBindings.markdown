

I've been trying to get this work for several days now and it becomes an headache for me...

I've created a General/NSArrayController that is responsible for a set of General/NSManagedObjects. One of the related entity property is a 'category' relationship. Another General/CategoryArrayController is then associated to that entity.

What I want to do is to manage Categories through a General/NSComboBox box. I've set bindings to :

**content** : General/CategoryArrayController.arrangedObjects

**contentValues** : General/CategoryArrayController.arrangedObjects.category

**value** : General/TransactionArrayController.selection.category

That works fine for programmatically added category value, that is I can select them through the General/NSComboBox. However, I cannot add a new category in the user interface. When I enter it, I get a message :

*2005-11-28 11:44:10.198 test[426] *** -General/[NSCFString _isKindOfEntity:] selector not recognized [self = 0x3f7b90]*

Does anyone have a idea for that ?

----

Well, I assume that "category" is a to-one relationship to a "category" entity. contentValues (note the pluralization) should be pointing to a set (a to-many relationship) like "categories" ... further, it should be pointed to a string value (because contentValues is alist of the strings that will be displayed to the user) ... So it should be arrangedObjects.categories.categoryTitle or something similar.

... oops - let me amend my statement after looking more closely. Your General/CategoryArrayController controls your "categories" ... so, assuming your category entity has a "categoryTitle" or similar string property, contentValues should be bound to arrangedObjects.categoryTitle. Sorry for any confusion caused by my quick answer.

----

I finally managed to do it. Here is the final mail I posted to the cocoa mailing list

So I've got the following model (credits to Wain ;) :

    
< Transaction >
<    category    > <<------------> < Category >
                                                  <  category  >


The General/NSCombobox ' bindings should be set to

    
        content : General/CategoryArrayController.arrangedObjects
        contentValues : General/CategoryArrayController.arrangedObjects.category
        value : General/TransactionArrayController.selection.category.category


Indeed, value expects a General/NSString, to be printed in the text area of the General/NSCombobox.

Now, Coredata cannot automatically update the 'category' Relationship in the Transaction Entity, as the value in not a General/NSManagedObject.

So we must intercept the General/NSCombox Selection change, and code it ourselves. I did it with comboBoxSelectionDidChange: delegate method :

    
- (void)comboBoxSelectionDidChange:(General/NSNotification *)notification
{         
               // User entered a known category name

               General/NSEnumerator *e = General/categoryController arrangedObjects] objectEnumerator];
               id categoryObject;

                while ( (categoryObject = [e nextObject]) ) {                               
                    if ([[categoryObject valueForKey:@"category"] isEqualToString:[categoryComboBox objectValueOfSelectedItem)
                    {
                        unsigned int selectionIndex = [transactionArrayController selectionIndex];            

                        General/NSManagedObject *transaction =  General/transactionArrayController arrangedObjects] objectAtIndex:selectionIndex];
                        [transaction setValue:categoryObject forKey:@"category"];

                        break;
                     }
                 }
}


Ok, what about adding new category ? I had a little problem, because :

  + nor controlTextDidEndEditing: neither textDidEndEditing: [[NSComboBox delegate method were called, for a currently unknown reason
  + an "An error occurred" message modal window appeared, because a category name was expected...

I had to do something "very early", so I use the General/NSComboBox contr:isValidObject: delegate method (from General/NSControl).

    
- (BOOL)control:(General/NSControl *)control isValidObject:(id)object
{
    BOOL categoryIsOK = FALSE;
    General/NSManagedObject *category;
    General/NSString *categoryName = General/[NSString stringWithString:object];
    [categoryName retain];

    // User entered a known category name
    General/NSEnumerator *e = General/categoryController arrangedObjects] objectEnumerator];
    id categoryObject;
   
    while ( (categoryObject = [e nextObject]) ) {
        if ([[categoryObject valueForKey:@"category"] isEqualToString:categoryName])
        {
            categoryIsOK = TRUE;
            category = categoryObject;
            break;
        }
    }
   
    // Existing category not found, User is creating a new category
    if (categoryIsOK == FALSE)
    {
        [[NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

        category = General/[NSEntityDescription
            insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
   
        [category setValue:categoryName forKey:@"category"];
        [categoryController addObject:category];
        categoryIsOK = TRUE;
    }
   
    unsigned int selectionIndex = [transactionArrayController selectionIndex];
     
    General/NSManagedObject *transaction =  [[transactionArrayController arrangedObjects] objectAtIndex:selectionIndex];

    [transaction setValue:category forKey:@"category"];
   
    return TRUE;
}
