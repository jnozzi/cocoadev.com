

The General/FoundationKit is a set of classes first developed by General/NextComputer, and now by General/AppleComputer, for core application services.

It provides things like collections (such as Arrays and Dictionaries), strings and string formatting, and other miscellaneous primitive (but essential) support classes. 

----

**Note:** Please don't go to the trouble of copying Apple's complete docs for each and every class - that's more than we need. :)

You might want to link to the corresponding page on the General/AppleComputer developer site and add some sample code and gotchas that can't be found there. (Plus: Fill in that "Description forthcoming." :) )

----
**Note:** Cocoa is available to both Objective-C and Java. Documentation for classes is available for each language except where noted by a (Java) or (General/ObjC).

General/NSMutableArray is General/ObjC only?! I don't believe that! -- General/KritTer [ why not? Java's got the Java libraries already... why wouldn't you just use com.whatever.array? ] Because according to Apple's docs, only General/NSEnumeratedSet is General/ObjC only. And because General/NSArray is in Java. Have they lied to us? They even have documentation for General/NSMutableArray in Java on their site! http://developer.apple.com/techpubs/macosx/Cocoa/Reference/Foundation/Java/Classes/NSMutableArray.html -- General/KritTer

----
What are you guys talking about? The (objc) means that the page doesn't have anything about java, it doesn't mean it's obj-c only. You are right, General/NSEnumeratedSet is the only Obj-C only thing.

*So, if I understand you correctly, all the (General/ObjC) notes below should be removed except for General/NSEnumeratedSet? And any General/ObjC-only classes added since then?*
----


== FoundationKit Overviews ==
    
 General/FoundationCollections (Arbitrary storage classes)


== FoundationKit Classes ==
    
 General/NSAffineTransform (10.4)
 General/NSAppleEventDescriptor (General/ObjC)
 General/NSAppleEventManager (General/ObjC)
 General/NSAppleScript
 General/NSArchiver
 General/NSArray
 General/NSAssertionHandler (General/ObjC)
 General/NSAttributedString
 General/NSAutoreleasePool
 General/NSBundle
 General/NSCachedURLResponse (10.4)
 General/NSCalendar (10.4)
 General/NSCalendarDate (General/ObjC)
 General/NSCharacterSet
 General/NSClassDescription
 General/NSCloneCommand (General/ObjC)
 General/NSCloseCommand (General/ObjC)
 General/NSCoder
 General/NSComparisonPredicate (10.4)
 General/NSCompoundPredicate (10.4)
 General/NSConditionLock (General/ObjC)
 General/NSConnection (General/ObjC)
 General/NSCountCommand (General/ObjC)
 General/NSCountedSet (General/ObjC)
 General/NSCreateCommand (General/ObjC)
 General/NSData
 General/NSDate
 General/NSDateComponents (10.4)
 General/NSDateFormatter (General/ObjC)
 General/NSDecimalMappingBehavior (Java)
 General/NSDecimalNumber (General/ObjC)
 General/NSDecimalNumberHandler (General/ObjC)
 General/NSDeleteCommand (General/ObjC)
 General/NSDeserializer (General/ObjC)
 General/NSDictionary
 General/NSDirectoryEnumerator (General/ObjC)
 General/NSDistantObject (General/ObjC)
 General/NSDistantObjectRequest (General/ObjC)
 General/NSDistributedLock (General/ObjC)
 General/NSDistributedNotificationCenter
 General/NSEnumerator
 General/NSError (10.3)
 General/NSException
 General/NSExistsCommand (General/ObjC)
 General/NSExpression (10.4)
 General/NSFileHandle (General/ObjC)
 General/NSFileManager (General/ObjC)
 General/NSFormatter
 General/NSFormatter.General/FormattingException (Java)
 General/NSFormatter.General/ParsingException (Java)
 General/NSGetCommand (General/ObjC)
 General/NSGregorianDate (Java)
 General/NSGregorianDate.General/IntRef (Java)
 General/NSGregorianDateFormatter (Java)
 General/NSHost (General/ObjC)
 General/NSHTTPCookie (10.4)
 General/NSHTTPCookieStorage (10.4)
 General/NSHTTPURLResponse (10.4)
 General/NSIndexPath (10.4)
 General/NSIndexSet (10.3)
 General/NSIndexSpecifier (General/ObjC)
 General/NSInputStream (10.3)
 General/NSInvocation (General/ObjC)
 General/NSKeyedArchiver (10.2)
 General/NSKeyedUnarchiver (10.2)
 General/NSLocale (10.4)
 General/NSLock (General/ObjC)
 General/NSLogicalTest (General/ObjC)
 General/NSMachBootstrapServer (General/ObjC)
 General/NSMachPort (General/ObjC)
 General/NSMessagePort (General/ObjC)
 General/NSMessagePortNameServer (General/ObjC)
 General/NSMetadataItem (10.4)
 General/NSMetadataQuery (10.4)
 General/NSMetadataQueryAttributeValueTuple (10.4)
 General/NSMetadataQueryResultGroup (10.4)
 General/NSMethodSignature (General/ObjC)
 General/NSMiddleSpecifier (General/ObjC)
 General/NSMoveCommand (General/ObjC)
 General/NSMutableArray (General/ObjC)
 General/NSMutableAttributedString
 General/NSMutableCharacterSet
 General/NSMutableData
 General/NSMutableDictionary
 General/NSMutableIndexSet (10.3)
 General/NSMutablePoint (Java)
 General/NSMutableRange (Java)
 General/NSMutableRect (Java)
 General/NSMutableSet
 General/NSMutableSize (Java)
 General/NSMutableString (General/ObjC)
 General/NSMutableStringReference (Java)
 General/NSMutableURLRequest (10.2.7)
 General/NSNamedValueSequence (Java)
 General/NSNameSpecifier (10.2)
 General/NSNetService (General/ObjC - 10.2)
 General/NSNetServiceBrowser (General/ObjC - 10.2)
 General/NSNotification
 General/NSNotificationCenter
 General/NSNotificationQueue
 General/NSNull
 General/NSNumber (General/ObjC)
 General/NSNumberFormatter
 General/NSObject
 General/NSOutputStream (10.3)
 General/NSPathUtilities (Java)
 General/NSPipe (General/ObjC)
 General/NSPoint (Java)
 General/NSPort
 General/NSPortCoder (General/ObjC)
 General/NSPortMessage (General/ObjC)
 General/NSPortNameServer (General/ObjC)
 General/NSPositionalSpecifier (General/ObjC)
 General/NSPredicate (10.4)
 General/NSProcessInfo (General/ObjC)
 General/NSPropertyListSerialization (Java)
 General/NSPropertySpecifier (General/ObjC)
 General/NSProtocolChecker (General/ObjC)
 General/NSProxy (General/ObjC)
 General/NSQuitCommand (General/ObjC)
 General/NSRandomSpecifier (General/ObjC)
 General/NSRange (Java)
 General/NSRangeSpecifier (General/ObjC)
 General/NSRect (Java)
 General/NSRecursiveLock (General/ObjC)
 General/NSRelativeSpecifier (General/ObjC)
 General/NSRunLoop
 General/NSRuntime (Java)
 General/NSScanner (General/ObjC)
 General/NSScriptClassDescription (General/ObjC)
 General/NSScriptCoercionHandler (General/ObjC)
 General/NSScriptCommand (General/ObjC)
 General/NSScriptCommandDescription (General/ObjC)
 General/NSScriptExecutionContext (General/ObjC)
 General/NSScriptObjectSpecifier (General/ObjC)
 General/NSScriptSuiteRegistry (General/ObjC)
 General/NSScriptWhoseTest (General/ObjC)
 General/NSSelector (Java)
 General/NSSerializer (General/ObjC)
 General/NSSet
 General/NSSetCommand (General/ObjC)
 General/NSSize (Java)
 General/NSSocketPort (General/ObjC)
 General/NSSocketPortNameServer (General/ObjC)
 General/NSSortDescriptor (10.3)
 General/NSSpecifierTest (General/ObjC)
 General/NSSpellServer
 General/NSStream (10.3)
 General/NSString (General/ObjC)
 General/NSStringReference (Java)
 General/NSSystem (Java)
 General/NSTask (General/ObjC)
 General/NSThread (General/ObjC)
 General/NSTimer
 General/NSTimeZone
 General/NSUnarchiver
 General/NSUndoManager
 General/NSUniqueIDSpecifier (10.2)
 General/NSURL (General/ObjC)
 General/NSURLAuthenticationChallenge (10.2.7)
 General/NSURLCache (10.2.7)
 General/NSURLConnection (10.2.7)
 General/NSURLCredential (10.2.7)
 General/NSURLCredentialStorage (10.2.7)
 General/NSURLDownload (10.2.7)
 General/NSURLHandle (10.3)
 General/NSURLProtectionSpace (10.2.7)
 General/NSURLProtocol (10.2.7)
 General/NSURLRequest (10.2.7)
 General/NSURLResponse (10.2.7)
 General/NSUserDefaults
 General/NSValue (General/ObjC)
 General/NSValueTransformer
 General/NSWhoseSpecifier (General/ObjC)
 General/NSXMLDocument (10.4)
 General/NSXMLDTD (10.4) General/NSXmlDtd
 General/NSXMLDTDNode (10.4)
 General/NSXMLElement (10.4)
 General/NSXMLNode (10.4)
 General/NSXMLParser (10.3)
 

== FoundationKit Protocols (General/ObjC) ==
    
 General/NSCoding
 General/NSComparisonMethods
 General/NSCopying
 General/NSDecimalNumberBehaviors
 General/NSKeyValueBindingCreation
 General/NSKeyValueCoding
 General/NSLocking
 General/NSMutableCopying
 General/NSObjCTypeSerializationCallBack
 General/NSObject
 General/NSScriptKeyValueCoding
 General/NSScriptObjectSpecifiers
 General/NSScriptingComparisonMethods
 General/NSURLHandleClient


== FoundationKit Interfaces (Java) ==
    
 General/NSComparisonMethods
 General/NSKeyValueCoding 
 General/NSScriptingComparisonMethods
 General/NSScriptingKeyValueCoding


== FoundationKit Functions (General/ObjC) ==
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Functions/FoundationFunctions.html

=== Assertions ===
    
 General/NSAssert
 NSAssert1
 NSAssert2
 NSAssert3
 NSAssert4
 NSAssert5
 General/NSCAssert
 NSCAssert1
 NSCAssert2
 NSCAssert3
 NSCAssert4
 NSCAssert5
 General/NSCParameterAssert
 General/NSParameterAssert


=== Bundles ===
    
 General/NSLocalizedString
 General/NSLocalizedStringFromTable
 General/NSLocalizedStringFromTableInBundle
 General/NSLocalizedStringWithDefaultValue


=== Byte Ordering ===
    
 General/NSConvertHostDoubleToSwapped
 General/NSConvertHostFloatToSwapped
 General/NSConvertSwappedDoubleToHost
 General/NSConvertSwappedFloatToHost
 General/NSHostByteOrder
 General/NSSwapBigDoubleToHost
 General/NSSwapBigFloatToHost
 General/NSSwapBigIntToHost
 General/NSSwapBigLongLongToHost
 General/NSSwapBigLongToHost
 General/NSSwapBigShortToHost
 General/NSSwapDouble
 General/NSSwapFloat
 General/NSSwapHostDoubleToBig
 General/NSSwapHostDoubleToLittle
 General/NSSwapHostFloatToBig
 General/NSSwapHostFloatToLittle
 General/NSSwapHostIntToBig
 General/NSSwapHostIntToLittle
 General/NSSwapHostLongLongToBig
 General/NSSwapHostLongLongToLittle
 General/NSSwapHostLongToBig
 General/NSSwapHostLongToLittle
 General/NSSwapHostShortToBig
 General/NSSwapHostShortToLittle
 General/NSSwapInt
 General/NSSwapLittleDoubleToHost
 General/NSSwapLittleFloatToHost
 General/NSSwapLittleIntToHost
 General/NSSwapLittleLongLongToHost
 General/NSSwapLittleLongToHost
 General/NSSwapLittleShortToHost
 General/NSSwapLong
 General/NSSwapLongLong
 General/NSSwapShort


=== Decimals ===
    
 General/NSDecimalAdd
 General/NSDecimalCompact
 General/NSDecimalCompare
 General/NSDecimalCopy
 General/NSDecimalDivide
 General/NSDecimalIsNotANumber
 General/NSDecimalMultiply
 NSDecimalMultiplyByPowerOf10
 General/NSDecimalNormalize
 General/NSDecimalPower
 General/NSDecimalRound
 General/NSDecimalString
 General/NSDecimalSubtract


=== Java Setup ===
    
 General/NSJavaBundleCleanup
 General/NSJavaBundleSetup
 General/NSJavaClassesForBundle
 General/NSJavaClassesFromPath
 General/NSJavaNeedsToLoadClasses
 General/NSJavaNeedsVirtualMachine
 General/NSJavaObjectNamedInPath
 General/NSJavaProvidesClasses
 General/NSJavaSetup
 General/NSJavaSetupVirtualMachine


=== Hash Tables ===
    
 General/NSAllHashTableObjects
 General/NSCompareHashTables
 General/NSCopyHashTableWithZone
 General/NSCountHashTable
 General/NSCreateHashTable
 General/NSCreateHashTableWithZone
 General/NSEndHashTableEnumeration
 General/NSEnumerateHashTable
 General/NSFreeHashTable
 General/NSHashGet
 General/NSHashInsert
 General/NSHashInsertIfAbsent
 General/NSHashInsertKnownAbsent
 General/NSHashRemove
 General/NSNextHashEnumeratorItem
 General/NSResetHashTable
 General/NSStringFromHashTable


=== HFS File Types ===
    
 General/NSFileTypeForHFSTypeCode
 General/NSHFSTypeCodeFromFileType
 General/NSHFSTypeOfFile


=== Map Tables ===
    
 General/NSAllMapTableKeys
 General/NSAllMapTableValues
 General/NSCompareMapTables
 General/NSCopyMapTableWithZone
 General/NSCountMapTable
 General/NSCreateMapTable
 General/NSCreateMapTableWithZone
 General/NSEndMapTableEnumeration
 General/NSEnumerateMapTable
 General/NSFreeMapTable
 General/NSMapGet
 General/NSMapInsert
 General/NSMapInsertIfAbsent
 General/NSMapInsertKnownAbsent
 General/NSMapMember
 General/NSMapRemove
 General/NSNextMapEnumeratorPair
 General/NSResetMapTable
 General/NSStringFromMapTable


=== Object Allocation/Deallocation ===
    
 General/NSAllocateObject
 General/NSCopyObject
 General/NSDeallocateObject
 General/NSDecrementExtraRefCountWasZero
 General/NSExtraRefCount
 General/NSIncrementExtraRefCount
 General/NSShouldRetainWithZone


=== Objective-C Runtime ===
    
 General/NSClassFromString
 General/NSGetSizeAndAlignment
 General/NSLog
 General/NSLogv
 General/NSSelectorFromString
 General/NSStringFromClass
 General/NSStringFromSelector


=== Path Utilities ===
    
 General/NSFullUserName
 General/NSHomeDirectory
 General/NSHomeDirectoryForUser
 General/NSOpenStepRootDirectory
 General/NSSearchPathForDirectoriesInDomains
 General/NSTemporaryDirectory
 General/NSUserName


=== Points ===
    
 General/NSEqualPoints
 General/NSMakePoint
 General/NSPointFromString
 General/NSStringFromPoint


=== Ranges ===
    
 General/NSEqualRanges
 General/NSIntersectionRange
 General/NSLocationInRange
 General/NSMakeRange
 General/NSMaxRange
 General/NSRangeFromString
 General/NSStringFromRange
 General/NSUnionRange


=== Rects ===
    
 General/NSContainsRect
 General/NSDivideRect
 General/NSEqualRects
 General/NSIsEmptyRect
 General/NSHeight
 General/NSInsetRect
 General/NSIntegralRect
 General/NSIntersectionRect
 General/NSIntersectsRect
 General/NSMakeRect
 General/NSMaxX
 General/NSMaxY
 General/NSMidX
 General/NSMidY
 General/NSMinX
 General/NSMinY
 General/NSMouseInRect
 General/NSOffsetRect
 General/NSPointInRect
 General/NSRectFromString
 General/NSStringFromRect
 General/NSUnionRect
 General/NSWidth


=== Sizes ===
    
 General/NSEqualSizes
 General/NSMakeSize
 General/NSSizeFromString
 General/NSStringFromSize


=== Uncaught Exception Handlers ===
    
 General/NSGetUncaughtExceptionHandler
 General/NSSetUncaughtExceptionHandler


=== Zones ===
    
 General/NSAllocateMemoryPages
 General/NSCopyMemoryPages
 General/NSCreateZone
 General/NSDeallocateMemoryPages
 General/NSDefaultMallocZone
 General/NSLogPageSize
 General/NSPageSize
 General/NSRealMemoryAvailable
 General/NSRecycleZone
 General/NSRoundDownToMultipleOfPageSize
 General/NSRoundUpToMultipleOfPageSize
 General/NSSetZoneName
 General/NSZoneCalloc
 General/NSZoneFree
 General/NSZoneFromPointer
 General/NSZoneMalloc
 General/NSZoneName
 General/NSZoneRealloc

== FoundationKit structs ==
(**Note:** These are C structs, not classes.)
    
 General/NSPoint
 General/NSRange
 General/NSRect
 General/NSSize
