I set up an [[NSMenu]] as a contextual menu for a [[NSTextView]] and fill it with items from a [[NSDictionary]]. If the items in the dictionary change I need to update/refresh the menu. Somehow I can't seem to remove all items from the menu before adding them again. Is there a way to 'release' the menu and call setMenu for the textView again? 

Elwin