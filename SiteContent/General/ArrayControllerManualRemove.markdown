I have an General/NSArrayController bound to an array "values" in my model object.  There is, in turn, an General/NSTableView bound to said General/NSArrayController.

My problem is that there are a few times when I need to remove an item from the array in code.  I do: (and if anyone can format this to make it look like code, it'd be much appreciated)

    
[self      willChange:General/NSKeyValueChangeRemoval
      valuesAtIndexes:General/[NSIndexSet indexSetWithIndex:i]       
               forKey:@"values"];

[_values removeObjectAtIndex:i];

[self       didChange:General/NSKeyValueChangeRemoval
      valuesAtIndexes:General/[NSIndexSet indexSetWithIndex:i]
               forKey:@"values"];


(i is the index of the item I want to remove).

Now, if there is only one item in the array, and it's selected in the General/TableView, this message gets spit out on the didChange event:
index (0) beyond bounds (0)

This makes sense, because I just removed that object.  However, General/NSArrayController refuses to see so, even when I provide the General/NSKeyValueChangeRemoval value.  Any ideas on how to fix?

----

I seem to recall reading about a bug with the array controller and having the last item removed when it was selected. Does it work for the other cases?

*Yes, everything but when the last index is selected.  Does anyone know of a good workaround for this problem when the action requires a selection?  For instance a delete.  Obviously, a row must be selected.  I've tried [tableView selectRow:byExtendingSelection:], but it still doesn't seem to cure the array controller.*