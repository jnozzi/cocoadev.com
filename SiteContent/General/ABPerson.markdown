

[[ABPerson]] Inherits from [[ABRecord]]
----

%%BEGINCODESTYLE%%- ([[NSArray]] '')parentGroups;%%ENDCODESTYLE%%

    * Returns an array of [[ABGroup]] this person belongs to.
    * Returns an empty array if this person doesn't belong to any group



''// This section deals with adding/removing properties on people''


%%BEGINCODESTYLE%%+ (int)addPropertiesAndTypes:([[NSDictionary]] '')properties;%%ENDCODESTYLE%%

    * Adds properties to '''all''' people records. The dictionary must be of the form:
*key: ''propety name''
*value: ''property type''
    * Property name must be unique
    * Returns the number of properties successfuly added



%%BEGINCODESTYLE%%+ (int)removeProperties:([[NSArray]] '')properties;%%ENDCODESTYLE%%

    * Removes properties from '''all''' people
    * Returns the number of properties successfuly removed



%%BEGINCODESTYLE%% + ([[NSArray]] '')properties;%%ENDCODESTYLE%%

    * Returns an array of property names



%%BEGINCODESTYLE%% + ([[ABPropertyType]])typeOfProperty:([[NSString]]'')property;%%ENDCODESTYLE%%

    * Returns the type of a given property.
    * Returns kABErrorInProperty if the property is not known


''// This section deals with creating search elements to search groups ''



%%BEGINCODESTYLE%%+ ([[ABSearchElement]] '')searchElementForProperty:([[NSString]]'')property 
                                        label:([[NSString]]'')label 
                                        key:([[NSString]]'')key 
                                        value:(id)value 
                                    comparison:([[ABSearchComparison]])comparison; %%ENDCODESTYLE%%

    * Returns a search element that will search on groups
    *	property: the name of the property to search on (cannot be null)
    * label: for multi-value properties an optional label    * key: for dictionary values an optional key
    * value: value to match (cannot be NULL)
    * comparison: the type of search (see [[ABTypedefs]].h)


''// This section deals with vCards ''


%%BEGINCODESTYLE%%- (id)initWithVCardRepresentation:([[NSData]]'')vCardData;%%ENDCODESTYLE%%

    * Create a person from a vCard
    * Returns nil if vCardData is nil or not a valid vCard



%%BEGINCODESTYLE%%- ([[NSData]] '')vCardRepresentation;%%ENDCODESTYLE%%

    *     Returns the vCard representation of a person


----
There seems to be a little confusion on what to use for the value in the [[NSDictionary]], every explanation on the web shows:
<code>
[newProperties setObject:@"kABStringProperty" forKey:@"com.xyz.propertyName"];
</code>
This does not work. You must create an [[NSNumber]] with one of the Constants in [[ABRecord]].

''Here is an example using addPropertiesAndTypes:''

<code>
[[NSMutableDictionary]]'' petProperties = [[[NSMutableDictionary]] dictionary];
[petProperties setObject:[[[NSNumber]] numberWithInt:kABArrayProperty] 
                                                        forKey:@"com.yourcompany.pet"];
int num = [[[ABPerson]] addPropertiesAndTypes:petProperties];
[[NSLog]](@"addPropertiesAndTypes returned %d", num);
</code>