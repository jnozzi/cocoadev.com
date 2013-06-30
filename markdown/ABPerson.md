

General/ABPerson Inherits from General/ABRecord
----

<code>- (General/NSArray *)parentGroups;</code>

    * Returns an array of General/ABGroup this person belongs to.
    * Returns an empty array if this person doesn't belong to any group



*// This section deals with adding/removing properties on people*


<code>+ (int)addPropertiesAndTypes:(General/NSDictionary *)properties;</code>

    * Adds properties to **all** people records. The dictionary must be of the form:
*key: *propety name*
*value: *property type*
    * Property name must be unique
    * Returns the number of properties successfuly added



<code>+ (int)removeProperties:(General/NSArray *)properties;</code>

    * Removes properties from **all** people
    * Returns the number of properties successfuly removed



<code> + (General/NSArray *)properties;</code>

    * Returns an array of property names



<code> + (General/ABPropertyType)typeOfProperty:(General/NSString*)property;</code>

    * Returns the type of a given property.
    * Returns kABErrorInProperty if the property is not known


*// This section deals with creating search elements to search groups *



<code>+ (General/ABSearchElement *)searchElementForProperty:(General/NSString*)property 
                                        label:(General/NSString*)label 
                                        key:(General/NSString*)key 
                                        value:(id)value 
                                    comparison:(General/ABSearchComparison)comparison; </code>

    * Returns a search element that will search on groups
    *	property: the name of the property to search on (cannot be null)
    * label: for multi-value properties an optional label    * key: for dictionary values an optional key
    * value: value to match (cannot be NULL)
    * comparison: the type of search (see General/ABTypedefs.h)


*// This section deals with vCards *


<code>- (id)initWithVCardRepresentation:(General/NSData*)vCardData;</code>

    * Create a person from a vCard
    * Returns nil if vCardData is nil or not a valid vCard



<code>- (General/NSData *)vCardRepresentation;</code>

    *     Returns the vCard representation of a person


----
There seems to be a little confusion on what to use for the value in the General/NSDictionary, every explanation on the web shows:
    
[newProperties setObject:@"kABStringProperty" forKey:@"com.xyz.propertyName"];

This does not work. You must create an General/NSNumber with one of the Constants in General/ABRecord.

*Here is an example using addPropertiesAndTypes:*

    
General/NSMutableDictionary* petProperties = General/[NSMutableDictionary dictionary];
[petProperties setObject:General/[NSNumber numberWithInt:kABArrayProperty] 
                                                        forKey:@"com.yourcompany.pet"];
int num = General/[ABPerson addPropertiesAndTypes:petProperties];
General/NSLog(@"addPropertiesAndTypes returned %d", num);
