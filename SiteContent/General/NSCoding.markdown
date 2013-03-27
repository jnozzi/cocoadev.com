<General/NSCoding> is a protocol. http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/

Apple's docs on archiving and serialization are here: http://developer.apple.com/documentation/Cocoa/Conceptual/Archiving/

----

If a class conforms to <General/NSCoding> then it can can be archived. (see General/UsingArchiversAndUnarchivers)

If a class conforms to <General/NSCoding> it implements these required methods (i.e. responds to these messages:)

    
-(id)initWithCoder:(General/NSCoder*)coder;
-(void)encodeWithCoder:(General/NSCoder*)coder;



What these two methods are expected to do:
  
*  initWithCoder: initialises an instance of the Class from an General/NSCoder object.
*  encodeWithCoder: writes an existing instance of the Class out to an General/NSCoder object.


Most of the foundation classes conform to <General/NSCoding>. For more information on how your class can conform to <General/NSCoding> see the page on General/NSCoder.

----

I put together a tutorial on General/NSKeyedArchiver/General/NSKeyedUnarchiver and General/NSCoding:

http://cocoadevcentral.com/articles/000084.php  -- General/ScottStevenson