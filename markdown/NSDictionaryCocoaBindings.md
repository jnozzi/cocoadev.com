I am trying to to use an General/NSDictionary as a data source to display values in text fields using Cocoa Bindings.

Basically, I have a model object containing an General/NSMutableDictionary with the key 'dictionary'.  This dictionary contains three General/NSStrings that are accessible via three keys that are also General/NSStrings.  In the awakeFromNib method I create the dictionary and  add the General/NSStrings to the dictionary, each associated with a specific key.  The keys are static strings with pointers named General/JHDHone, General/JHDHtwo, General/JHDHthree.  I know the awakeFromNib method is getting called because I have an General/NSBeep() at the beginning of the method.

I have created an General/NSObjectController to control the model object, and an General/NSTextField that tries to access the string stored in the dictionary using the following binding.  In the General/NSTextField binding pane, I bind displayValuePattern1 to the General/NSObjectController with controller key "selection" and model key path "dictionary.General/JHDHone".  I use the following display pattern: %{value1}@ Test.  With these settings, only " Test" gets displayed in the General/NSTextField.  The string I have stored inthe dictionary is not displayed (should see "string Test".

EDIT:  I figured it out.  Must configure the dictionary in the init not awakeFromNib method.

----

The UI (for my document-based app) contains two table views. One table displays a single column listing the members of an array-of-arrays. The arrays in the array-of-arrays contain dictionary objects whose values are displayed in the main table view (which has several columns). The dictionary objects have keys for each of those columns, plus another key whose corresponding value is a string displayed in a text view. Sound familiar? This is more or less the interface for the Mail program, except that I don't need to use a hierarchical list in the array-of-arrays part of the interface (corresponding to the Mailboxes drawer in the Mail program).

I have wired up this interface to a pair of General/NSArrayController objects, one to manage the array of arrays, and the other to manage the array in the main table view (the one that would correspond to the message list for a particular mailbox). The nested model objects are set up KVC-compliant and General/NSCoding-compliant, and so far I am able to archive the data in the two tables and restore it using the normal General/NSDocument machinery.

The hang-up is with the data in the text view, which is not consistently getting picked up automatically in the archiving process. I can use the notifications sent by the text view to capture its contents any time it changes, but I haven't quite decided how to force the data into my model on a timely basis. I have made life easier by making sure that multiple rows cannot be selected in either of the table views (as such a state makes no sense for working with the data in the text view). Obviously, the array controller is going to be fussy about letting me access its data directly, and I have the master array-of-arrays in my window controller to work with. Even more obviously, I want to identify selected objects from the main table view, and manipulate them. Table views and array controllers know about their selected objects, but how should I manipulate the data for the selected dictionary object - that is, the selected table row (in the window controller) to set the data from the text view when it changes?

----

[ New ideas ] One can, of course, solve this problem simply by making some other part of the interface key after having focus on the text view. An "update" button, or maybe a key-combination, for example, could send a message to the table view that takes the focus away from the text view and thereby updates the model. But it would be interesting to use     textDidChange to update the model "live" as data is being entered in the text view, which would save the user from having to remember to click somewhere or enter a key combo just to make sure the model is updated correctly. I guess this has more to do with the behavior of General/NSTextView than it does with that of General/NSDictionary or General/NSController.

----

I'm currently writing a dictionary for Arabists but the new Bindings feature troubles me a bit:

The dictionary should be stored in an General/NSMutableDictionary which is accessed by a search field (or a plain General/NSTextField). The entered root is the key and the output translation the value. So in case the key exists the translation is shown, if the key doesn't exist, a new value can be entered and will be saved together with the key. If the key is new but the user does not enter a value, the key is not saved either.

http://cocoa.sprachwerker.de/fa.alaDict/eingabeFenster.jpg 

So how do I put this into Bindings? I have the feeling it would save me a lot of time to have it like that. So if anybody's got a good idea feel free to mail me and I'll send you the source or you tell me what to do.

Thank you, General/BBernd

----

I highly recommend reading all of Apple's documentation first before you start using them. You could start with this intro:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/CurrencyConverterBindings/index.html

If you want to write custom bindings (i.e. not use General/NSArrayController), you should read these three sections closely.


*http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaBindings/index.html
*http://developer.apple.com/documentation/Cocoa/Conceptual/General/KeyValueCoding/index.html
*http://developer.apple.com/documentation/Cocoa/Conceptual/General/KeyValueObserving/index.html


There is a lot to digest, but once you get the hang of it, notifications and delegation start to feel less important.  

----

I've been reading these documents over and over again. Thing is, most examples are for tables and the like. Non General/NSApplicationKit objects are not really covered. I have trouble setting up methods that handle the actions once the Bindings get into play. Thanks for the hint anyway. I should have mentioned that before :-)

General/BBernd

----

I subclassed General/NSArrayController in order to implement a search function (see below for code) then I wrote an Object class for my entries (just a bunch of General/NSString objects). An General/NSMutableArray was the array for my controller (I had to shelve my General/NSMutableDictionary plans for now) and that I bound in IB. One thing I added to my Entry class was a checksum function in order to see if any changes occurred. Therefore I calculate with [aString hash] an int and add all my strings together to get a "checksum". So whenever my search function does not find a key, a new one is created. Since I have that General/SearchField function enabled that it searches incrementally a lot of new keys are created that need to be checked if they were meant for real entry business. To find out I compare the last object with a new one and if it's got the same checksum I get rid of it again.

It would be really nice if I knew how to use an General/NSMutableDictionary because the search function would be quicker and less error prone (in terms of double entries of the same key and so on) but on the other hand, a tree structure would not be bad either in order to implement an autocomplete function.

Now the code for my subclassed General/NSArrayController:
    
- (void)search:(id)sender
{
    id temporaryObject = [self newObject];
    General/NSLog(@"selection checksum: %i",General/[self selection] valueForKeyPath:@"checksum"]intValue]);
    [[NSLog(@"temporaryObject checksum: %i",General/temporaryObject valueForKeyPath:@"checksum"]intValue]);
    if ([[[self selection] valueForKeyPath:@"checksum"] isEqualToNumber:[temporaryObject valueForKeyPath:@"checksum")
    {
        [self removeObjectAtArrangedObjectIndex:[self selectionIndex]];
        General/NSLog(@"temporaryObject removed");
    }
    
    [self setSearchString:[sender stringValue]];
    
    General/NSString *lowerSearch = [searchString lowercaseString];
    
    General/NSEnumerator *oEnum = General/self arrangedObjects]objectEnumerator];
    id item;
    int selection;
    selection = -1;
    
    while (item = [oEnum nextObject])
    {
        [[NSString *lowerName = General/item valueForKeyPath:@"uniqueID"] lowercaseString];
        [[NSLog(@"uniqueID = %@",[item valueForKeyPath:@"uniqueID"]);
        if ([lowerName isEqualToString:lowerSearch])
        {
            selection = General/self arrangedObjects] indexOfObject:item];
            [self setSelectionIndex:selection];
            [[NSLog(@"searchString found");
            General/NSLog(@"General/self arrangedObjects] indexOfObject:item] = %i",[[self arrangedObjects] indexOfObject:item]);
            break;
        }
    }
    
    if (selection == -1)
    {   
        [temporaryObject setValue:[sender stringValue] forKey:@"uniqueID"];
        
        [self addObject:temporaryObject];
        [self setSelectionIndex:[[self arrangedObjects] indexOfObject:temporaryObject;
        General/NSLog(@"temporaryObject added");

    }
    [sender selectText: 0];
    General/[sender window] fieldEditor:YES forObject: sender]setSelectedRange: [[NSMakeRange(General/sender stringValue]length], 0)];
    
}

- (id)newObject
{
    newObj = [super newObject];
    [newObj setValue:@"" forKey:@"uniqueID"];
    [newObj setValue:@"" forKey:@"verbTrans"];
    return newObj;
}


//  - dealloc:
- (void)dealloc
{
    [self setSearchString: nil];    
    [super dealloc];
}


// - searchString:
- ([[NSString *)searchString
{
	return searchString;
}
// - setSearchString:
- (void)setSearchString:(General/NSString *)newSearchString
{
    if (searchString != newSearchString)
	{
        [searchString autorelease];
        searchString = [newSearchString copy];
    }
}


General/BBernd