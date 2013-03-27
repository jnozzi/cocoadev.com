**Problem:** I've included <General/AddressBook/General/AddressBook.h> but when I try     General/NSArray *people = [book people];, the array is empty.

**Solution:** Remember to add the General/AddressBook.framework to your project. Including is not enough.

----