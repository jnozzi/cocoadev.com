

Note: This data applies to the latest gleaned info from production OS X - 10.3.5 as of this writing.

iSync uses a closed API defined in /System/Library/General/PrivateFrameworks/General/SyncConduit.framework to define it's conduits (pieces of software that provide sync servicing for individual devices).  As this is a Private Framework, Headers are not available and were gleaned from General/ClassDump.  The tricky part of course is translating all the fun (id) defs in General/ClassDump -ed headers to real objects... and determining the whys and hows about these individual objects going in and out.

I (General/BrendanWMcAdams) have been doing some work on puzzling out General/NSSyncConduit myself over at www.twodot.org.  My coding partner and I thought it might be nice to kick back some of the info we've puzzled to General/CocoaDev, so here goes...

This is the results of my work, off of the 10.3.5 verion of General/SyncConduit...

    
/*
 * Decoded from /System/Library/General/PrivateFrameworks/General/SyncConduit.framework
 * 
 * basic structure from class-dump
 * 
 * Actual datastructures and functionality details decoded by 
 * Brendan W. General/McAdams <bmcadams@twodot.org>    
 *
 */

#import <Foundation/Foundation.h>

@interface General/NSSyncConduit : General/NSObject
{
}

/** 
 * This is a simple name describing the conduit, 
 * e.g. "General/ExchangeConduit" 
*/
+ (General/NSString*) conduitName;

/** 
 * Not sure what this is supposed to indicate...
 * May be related to whether there's a full app 
 * doing the work, with a gui, or if iSync should
 * handle display, UI, etc.
 */
+ (BOOL) isApplication;

/** 
 * This returns an General/NSArray, 
 * which contains General/NSString objects.
 * Each General/NSString indicates a class name 
 * which is an General/NSSyncDataClass.
 * [having trouble dumping the stuff for this].
 * 
 * The General/DataClasses returned are the forms of data
 * that this conduit will support syncing.
 * 
 * General/DataClasses represent types of syncing.
 * The only General/DataClasses I know about are:
 *     - General/NSSyncContactDataClass (General/AddressBook)
 *     - General/NSSyncICalendarDataClass (iCal)
 *  
 * I haven't dug deep but there are likely bookmark ones, etc.
 * for .mac and Safari
 */
+ (General/NSArray*) supportedDataClasses;

/** 
 * This returns an General/NSArray,
 * which contains General/NSConduit objects,
 * which are presumably instances of the 
 * local conduit's own subclass.
 * This is obviously most useful 
 * In the case where the conduit allows
 * you to configure multiple sync devices 
 * i.e. iMac account, iPod and phone.
 */
+ (General/NSArray*) activeConduits;

/**
 * This returns an General/NSString 
 * containing an ID for the particular 
 * instance of device (possibly, e.g. IMEI)
 * this instance is syncing.
 * Keep in mind an instance refers to a 
 * particular device, rather than type of device
 */
- (General/NSString*) deviceId;

/**
 * This returns an General/NSString 
 * containing a name or the particular 
 * instance of device (possibly, e.g. bluetooth 'short name')
 * this instance is syncing.
 * Keep in mind an instance refers to a 
 * particular device, rather than type of device
 */
- (General/NSString*) deviceName;

/**
 * This returns an General/NSString 
 * containing the fully qualified path to 
 * an icon representing the device (.tiff or .icns seem used)
 * This icon is used in the 'add device' search as well as
 * the little bar that shows devices you have setup to sync.
 * This is an instance method as it's possible for a conduit, 
 * (e.g. symbianconduit) to handle multiple 'similar devices'.
 * A great example is that my instance of symbian conduit is 
 * for my Nokia 3650, but could also do an N-Gage, etc.
 * The symbian conduit has icons for multiple devices and shows 
 * them appropriate.
 */
- (General/NSString*) iconPath;


/** 
 * This returns an General/NSArray, 
 * which contains General/NSString objects.
 * Each General/NSString indicates a class name 
 * which is an General/NSSyncDataClass.
 * [having trouble dumping the stuff for this].
 *  
 * The General/DataClasses returned are the forms of data
 * that this conduit will support syncing.
 * 
 * General/DataClasses represent types of syncing.
 * The only General/DataClasses I know about are:
 *     - General/NSSyncContactDataClass (General/AddressBook)
 *     - General/NSSyncICalendarDataClass (iCal)
 *  
 * I haven't dug deep but there are likely bookmark ones, etc.
 * for .mac and Safari
 */
- (General/NSArray*) activeDataClasses;

- (int)openSync:(id)fp12;
- (id)synchronizerForDataClass:(id)fp12;
- (void)finishedSynchronizingDataClass:(id)fp12 synchronizer:(id)fp16;

/**
 * Not 100% sure on the content of the dictionary; 
 * our testing hasn't finished yet.
 * However, it's likely related to changes, 
 * differences and / or conflicts.
 */
- (General/NSDictionary*) closeSync;

@end



(some return and parameter types have been edited in a best guess manner... More data is forthcoming as we hack away)

----

-- This is the original dump from this page, I believe it's from an old version of OS .. 10.2? --
Here some first learnings about General/NSSyncConduit (iSync):

iSync uses plugin bundles (suffix .conduit) stored at /System/Library/General/SyncServices. These apparently define a subclass of General/NSSyncConduit which is part of the private framework General/SyncConduit (/System/Library/General/PrivateFrameworks)

General/ClassDump of a conduit reveals (crashes on General/SyncConduit itself):

    
@interface xxConduit : General/NSSyncConduit

+ (id)iconPathForDeviceModel:(id)fp12;
+ (General/NSString *)conduitName; - human readable name of the conduit bundle
+ (General/NSArray *)supportedDataClasses; - array of data classes (e.g. General/ABPerson etc.) that are supported
+ (General/NSArray *)activeConduits; - ???
+ (BOOL)isApplication; - ???

- (General/NSString *)deviceId; - device ID (unique)
- (General/NSString *)deviceName; - device name (e.g. Cellphone name; conduit might support more than one Cellphone)
- (General/NSString *)iconPath; - path to Icon to be shown in iSync view
- (BOOL)canGenerateChanges; - ???
- (General/NSArray *)activeDataClasses; - ???
- (int)openSync:(id)fp12; - ???
- (id)synchronizerForDataClass:(Class)fp12; - ??? does this return a synchronizer object which is a subclass of General/NSSyncDBSynchronizer
- (void)_secretMethodToRemoveDeviceForever; - ???
- (void)finishedSynchronizingDataClass:(id)fp12 synchronizer:(id)fp16; - ???
- (id)closeSync; - ???
- (BOOL)canFastSync;

@end



I don't know if this might help but someOne anonymous post a code on blackberry forum:
http://www.blackberry.com/developers/forum/post.jsp?forum=1&thread=516&message=9211&reply=true&quote=true

    
#import <Foundation/Foundation.h>

@interface General/NSSyncConduitManager : General/NSObject
{
}

+ (General/NSSyncConduitManager*)conduitManager;
- (General/NSArray*)conduitClasses;

@end

@interface General/TESTSyncConduit : General/NSObject
{
}

+ (General/NSString*)conduitName;
+ (BOOL)isApplication;
+ (General/NSArray*)supportedDataClasses;
+ (General/NSArray*)activeConduits;
+ (General/NSArray*)activeDataClasses;
- (id)synchronizerForDataClass:(General/NSString*)dataClass ;

@end

@interface General/NSSyncDBSynchronizer : General/NSObject
{
}

- (General/NSDictionary*)database;

@end


int main( int argc, char** argv )
{
General/NSAutoreleasePool* pool = General/[[NSAutoreleasePool alloc] init];

General/NSSyncConduitManager* aConduitManager = General/[NSSyncConduitManager conduitManager];
if( aConduitManager != nil )
{
General/NSArray* conduitClasses = [aConduitManager conduitClasses];

int i = 0;
for( ; i < [conduitClasses count]; i++ )
{
General/TESTSyncConduit* curConduitClass = [conduitClasses objectAtIndex:i];

General/NSLog( @"CONDUIT NAMED %@", General/curConduitClass class] conduitName] );

[[NSArray* supportedDataClasses = General/curConduitClass class] supportedDataClasses];

[[NSArray* activeConduits = General/curConduitClass class] activeConduits];
if( activeConduits != nil && [activeConduits count] > 0 )
{
int j = 0;
for( ; j < [activeConduits count]; j++ )
{
[[TESTSyncConduit* aConduit =
[activeConduits objectAtIndex:j];
if( aConduit != nil && General/aConduit class]isApplication] == NO )
{
int k = 0;
for( ; k < [supportedDataClasses count]; k++ )
{
[[NSString* supportedClass = [supportedDataClasses objectAtIndex:k];
General/NSSyncDBSynchronizer* syncher = [aConduit synchronizerForDataClass:supportedClass];

General/NSLog( @"SYNCHRONIZER FOR DATA CLASS %@", supportedClass );
General/NSLog( @"NOW HERE'S WHERE IT GETS INTERESTING: DATABASE IS: %@", [[syncher database] description] );
}
}
}
}
}
}

[pool release];

return 0;
}

