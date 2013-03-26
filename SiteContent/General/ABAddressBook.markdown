<code>+ (ABAddressBook *)sharedAddressBook;</code>

 *Returns the unique shared instance of ABAddressBook
 *The addressbook returned will be for the effective user ID at the time of the call. setuid calls can be used to change the current user if you are trying to look through addressbooks.


<code>- (NSArray *)recordsMatchingSearchElement:(ABSearchElement *)search;</code>

 *Returns an array of record matching the given search element
  *Raises if search is nil
  *Returns an empty array if no matches


<code>- (BOOL)save;</code>


  *Saves changes made since the last save
  *Return YES if successful (or there was no change)


<code>- (BOOL)hasUnsavedChanges;</code>


   *Returns YES if they are unsaved changes
   *The unsaved changes flag is automatically set when changes are made


<code>- (ABPerson *)me;</code>


   *Returns the person that represents the user
   *Returns nil if "me" was never set


<code>- (void)setMe:(ABPerson *)moi;</code>


   *Sets "Me" to moi.
   *Pass nil to clear "Me"


<code>- (ABRecord *)recordForUniqueId:(NSString *)uniqueId;</code>


   *Returns a record (ABPerson or ABGroup) matching a given unique ID
   *Raises if uniqueId is nil
   *Returns nil if the record could not be found


<code>- (BOOL)addRecord:(ABRecord *)record;</code>


   *Adds a record (ABPerson or ABGroup) to the AddressBook Database
   *Raises if record is nil
   *Returns YES if the addition was successful


<code>- (BOOL)removeRecord:(ABRecord *)record;</code>


   *Removes a record (ABPerson or ABGroup) from the AddressBook Database
   *Raises if record is nil
   *Returns YES if the removal was successful


<code>- (NSArray *)people;</code>


   *Returns an array of all the people in the AddressBook database
   *Returns an empty array in case the DB doesn't contain any body


<code>- (NSArray *)groups;</code>


   *Returns an array of all the groups in the AddressBook database
   *Returns an empty array in case the DB doesn't contain any groups



[[Category:PointlessInformation]]