I am trying to subclass [[NSData]] or [[NSMutableData]].

#import <Cocoa/Cocoa.h>

@interface [[MyData]] : [[NSData]] {

	int aValue;
}
@end

Everything compiles fine but when I allocate and initialize using

	myData = [[[[MyData]] alloc] initWithContentsOfFile: myFilepath];

I get the following message

''''' initialization method -initWithBytes:length:copy:freeWhenDone:bytesAreVM: cannot be sent to an abstract object of class [[MyData]]: Create a concrete instance!
 
It seems that the subclass is no a real instance. I can't find any info subclassing [[NSData]] on the Apple site or any info on which methods must be overridden!

Any Ideas? 

---- 

[[NSData]] is most likely a Class Cluster.  Check out [[ClassClusters]] on what they are and how they work.


Michael Gyngell