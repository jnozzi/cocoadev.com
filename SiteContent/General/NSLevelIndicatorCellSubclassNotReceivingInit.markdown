I have a subclass on General/NSLevelIndicatorCell called General/FTPSessionTransferStatusCell which I am using inside an General/NSTableView.  I dragged an General/NSLevelIndicatorCell into the column, then on the Custom Class pane of the IB Inspector changed it to an General/FTPSessionTransferStatusCell.  My subclass of General/NSLevelIndicatorCell is not receiving -init or -initWithLevelIndicatorStyle, but it's being created somehow.  http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaFundamentals/General/AddingBehaviortoaCocoaProgram/chapter_4_section_5.html#//apple_ref/doc/uid/TP40002974-CH5-DontLinkElementID_11 says that I should implement -init, but that's not working.  As a result, my ivars aren't getting allocated and my custom cell is useless.

Can anyone help?

----

If it's coming from a nib, it's initialized with -initWithCoder:.    

http://developer.apple.com/documentation/Cocoa/Conceptual/General/LoadingResources/Concepts/General/NibFileLoaded.html

----

Thanks a lot!