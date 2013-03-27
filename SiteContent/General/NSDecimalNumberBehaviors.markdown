**Protocol Description**

The General/NSDecimalNumberBehaviors protocol declares three methods that control the discretionary aspects of working with General/NSDecimalNumber(s). The     scale and     roundingMode methods determine the precision of General/NSDecimalNumber�s return values and the way in which those values should be rounded to fit that precision. The     exceptionDuringOperation:error:leftOperand:rightOperand: method determines the way in which an General/NSDecimalNumber should handle different calculation errors.


For an example of a class that adopts the General/NSDecimalNumberBehaviors protocol, see the specification for General/NSDecimalNumberHandler.
 ----
**Apple Documentation**

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSDecimalNumberBehaviors_Protocol/

----
**See Also**

*General/NSDecimalNumber
*General/NSDecimalNumberHandler