

For all General/AspectCocoa related purposes, an General/ACInvocation is the same thing as an General/NSInvocation except that it is not actually an General/NSInvocation (not a subclass of General/NSInvocation).  Otherwise it has nearly the same interface.

    

 /*
     Returns the NSMethodSignature object describing the method to be invoked.
 */
 - (NSMethodSignature *)methodSignature;
 
 /*
     set/get the selector to be invoked on the target
 */
 - (void)setSelector:(SEL)sel;
 - (SEL)selector;
 
 /*
     set/get the target of the invocation
 */
 - (id)target;
 - (void)setTarget:(id)obj;
 
 /*
     returns the class containg the method for which this invocation was created
     note that this may or may not the same class as General/invocation target] class];
     (which will always return the lowest level class of the object.)
 */
 - (Class)getClass;
 
 /*
     set/get the target of the invocation
 */
 - (void)invoke;
 - (void)invokeWithTarget:(id)target;
 
 /*
     set/get the return value or argument values of the invocation
     same usage as on NSInvocation
 */
 - (void)getReturnValue:(void *)retLoc;
 - (void)setReturnValue:(void *)retLoc;
 - (void)getArgument:(void *)argumentLocation atIndex:(int)index;
 - (void)setArgument:(void *)argumentLocation atIndex:(int)index;
 




[[Category:PointlessInformation