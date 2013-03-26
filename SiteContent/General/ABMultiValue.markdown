

[[ABMultiValue]] Inherits from [[NSObject]]
----

Represents values of type kABMultiXXXXProperty. All values in an [[ABMultiValue]] must be of the same type.  e.g. in a kABMultiStringProperty: all values must be strings

If you need to store away a reference to a specific value/label pair use the "identifier".

You cannot use the Index to reference because other apps can add/remove/reorder a multivalue making your index point to the wrong pair. Identifiers are unique Ids.


----

%%BEGINCODESTYLE%%- (unsigned int)count;%%ENDCODESTYLE%%

 *Returns the number of value/label pairs

    
%%BEGINCODESTYLE%%- (id)valueAtIndex:(int)index;%%ENDCODESTYLE%%

 *Returns a value at a given index
 *Raises an exception if index is out of bounds


%%BEGINCODESTYLE%%- ([[NSString]] '')labelAtIndex:(int)index;%%ENDCODESTYLE%%

 *Returns a label at a given index
 *Raises if index is out of bounds

    
%%BEGINCODESTYLE%%- ([[NSString]] '')identifierAtIndex:(int)index;%%ENDCODESTYLE%%

 *Returns a identifier at a given index
 *Raises if index is out of bounds

    
%%BEGINCODESTYLE%%- (int)indexForIdentifier:([[NSString]] '')identifier;%%ENDCODESTYLE%%

 *Returns the index of a given identifier
 *Returns [[NSNotFound]] if not found

    
 
%%BEGINCODESTYLE%%- ([[NSString]] '')primaryIdentifier;%%ENDCODESTYLE%%

 *Identifier for the primary value

    

%%BEGINCODESTYLE%%- ([[ABPropertyType]])propertyType;%%ENDCODESTYLE%%

 *Type of this multivalue (kABMultiXXXXProperty)
 *Returns kABErrorInProperty in this multi-value is empty or not all values have the same type.