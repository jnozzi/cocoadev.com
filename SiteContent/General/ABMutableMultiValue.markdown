

ABMutableMultiValue Inherits from ABMultiValue, NSObject
----


<code>- (NSString *)addValue:(id)value withLabel:(NSString *)label;</code>

 *Adds a value with its label
 *Returns the identifier if successful. nil otherwise
 *Raises if value or label are nil
 *Note: No type checking is made when adding a value. But trying to set a multivalue property with a multivalue that doesn't have all its values of the same type will return an error.


<code>- (NSString *)insertValue:(id)value withLabel:(NSString *)label atIndex:(int)index;</code>

 *Insert a value/label pair at a given index
 *Returns the identifier if successful. nil otherwise
 *Raises if value or label are nil or the index is out of bounds.
 *Note: No type checking is made when adding a value. But trying to set a multivalue property with a multivalue that doesn't have all its values of the same type will return an error

    
 
<code>- (BOOL)removeValueAndLabelAtIndex:(int)index;</code>

 *Removes a value/label pari at a given index
 *Raises if the index is out of bounds

        

<code>- (BOOL)replaceValueAtIndex:(int)index withValue:(id)value;</code>

 *Replaces a value at a given index
 *Raises if the index is out of bounds or the value is nil

        


<code>- (BOOL)replaceLabelAtIndex:(int)index withLabel:(NSString*)label;</code>

 *Replaces a label at a given index
 *Raises if the index is out of bounds or the label is nil

        


<code>- (BOOL)setPrimaryIdentifier:(NSString *)identifier;</code>

 *Sets the primary value given its identifier.
 *Raises if identifier is nil
 *Returns YES if successful


[[Category:PointlessInformation]]