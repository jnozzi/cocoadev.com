It's like an General/NSArray, but crunchier. You have to type a lot more to use one.

 http://developer.apple.com/documentation/General/CoreFoundation/Reference/General/CFArrayRef/

It can hold arbitary data, including raw numbers and structs, and includes a binary search function. In other ways, General/NSArray and General/NSMutableArray are comparable or better.

Actually, General/NSArray and General/NSMutableArray are not better or worse; they're all the same. General/TollFreeBridging means that any General/CFArray is an General/NSArray and vice versa, even the ones you make yourself via subclassing.

Simple examples of calling General/CFArray functions can be found at
http://www.carbondev.com/site/?page=General/CFArray

Notably, calling CFA<nowiki/>rrayCreate with NULL for the callbacks parameter creates an General/NSArray that uses pointer equality and doesn't retain its members.