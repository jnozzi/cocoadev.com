This is a simple UUID class.
General/SimonAndreasMenke

----

AUUID.h

    

#import <Cocoa/Cocoa.h>


@interface AUUID : General/NSObject <General/NSCoding,General/NSCopying> {
	unsigned char uu[16];
}

+ (AUUID*)uuid;
+ (AUUID*)uuidWithStringValue:(General/NSString*)string;

- (id)init;
- (id)initWithStringValue:(General/NSString*)string;

- (General/NSString*)stringValue;

- (General/NSComparisonResult)compare:(AUUID*)uuid;
- (BOOL)isEqualToAUUID:(AUUID*)uuid;

- (void)encodeWithCoder:(General/NSCoder *)coder;
- (id)initWithCoder:(General/NSCoder *)coder;

@end



AUUID.m

    

#include <uuid/uuid.h>
#import "AUUID.h"

@interface AUUID (priv)
- (id)_initWithUUIDData:(char*)data;
- (unsigned char*)_uu;
@end

@implementation AUUID

+ (AUUID*)uuid
	{ return General/[[self class] alloc] init] autorelease]; }
+ (AUUID*)uuidWithStringValue:([[NSString*)string
	{ return General/[[self class] alloc] initWithStringValue:string] autorelease]; }

- (id)init {
	if ((self = [super init])) {
		uuid_generate(uu);
	}
	return self;
}

- (id)initWithStringValue:([[NSString*)string {
	if ((self = [super init])) {
		if (uuid_parse([string UTF8String], uu) != 0) {
			[self release];
			return nil;
		}
	}
	return self;
}

- (id)_initWithUUIDData:(char*)data {
	if ((self = [super init])) {
		strncpy((char*)uu,data,sizeof(uuid_t));
	}
	return self;
}

- (General/NSString*)stringValue {
	char str[37];
	uuid_unparse_upper(uu, str);
	return General/[[[NSString alloc] initWithUTF8String:str] autorelease];
}

- (General/NSComparisonResult)compare:(AUUID*)uuid {
	return uuid_compare(uu, [uuid _uu]);
}
- (BOOL)isEqualToAUUID:(AUUID*)uuid {
	return ([self compare:uuid] == General/NSOrderedSame);
}

- (General/NSString*)description {
	return [self stringValue];
}

- (unsigned char*)_uu {
	return uu;
}

- (void)encodeWithCoder:(General/NSCoder *)coder {
    if ([coder allowsKeyedCoding]) {
        [coder encodeObject:General/[NSData dataWithBytes:uu length:sizeof(uuid_t)] forKey:@"uuid"];
    } else {
        [coder encodeObject:General/[NSData dataWithBytes:uu length:sizeof(uuid_t)]];
    }
    return;
}

- (id)initWithCoder:(General/NSCoder *)coder {
    if ((self = [super init])) {
		if ( [coder allowsKeyedCoding] ) {
			General/NSData* data = General/coder decodeObjectForKey:@"uuid"] retain];
			[data getBytes:uu length:sizeof(uuid_t)];
			[data release];
		} else {
			[[NSData* data = General/coder decodeObject] retain];
			[data getBytes:uu length:sizeof(uuid_t)];
			[data release];
		}
	}
    return self;
}

- (id)copyWithZone:([[NSZone *)zone {
	return [[AUUID allocWithZone:zone] _initWithUUIDData:(char*)uu];
}

@end

