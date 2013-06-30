

Code for using custom types with the General/NSUserDefaults class.

Modified from the General/NSColor sample code on Apple's developer web site

**Source for General/NSUserDefaults+General/CocoaDevUsersAdditions.h :**
    
 #import <Foundation/Foundation.h>
 
 @interface NSUserDefaults(CocoaDevUsersAdditions)
 - (void)encodeObject:(id <NSCoding>)anObject forKey:(NSString*)aKey;
 - (id)decodeObjectForKey:(NSString*)aKey;
 @end

 
**Source for General/NSUserDefaults+General/CocoaDevUsersAdditions.m :**
    
 #import "NSUserDefaults+CocoaDevUsersAdditions.h"
 
 @implementation NSUserDefaults(CocoaDevUsersAdditions)
 
 - (void)encodeObject:(id <NSCoding>)anObject forKey:(NSString*)aKey
 {
 	// Requires 10.2 or later for keyed archiving
 	NSData* theData = [NSKeyedArchiver archivedDataWithRootObject:anObject];
 	[self setObject:theData forKey:aKey];
 }
 
 - (id)decodeObjectForKey:(NSString*)aKey
 {
 	// Requires 10.2 or later for keyed archiving
 	NSData* theData = [self dataForKey:aKey];
 	return (theData != nil) ? [NSKeyedUnarchiver unarchiveObjectWithData:theData] : nil;
 }
 @end



General/Category:CocoaDevUsersAdditions