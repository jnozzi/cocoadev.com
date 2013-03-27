How would one go about hiding the General/InstanceVariables in the header for a class like Apple does with many core Cocoa classes?  

For example, if you look at General/NSArray.h, there are no General/InstanceVariable declarations visible, only methods. How would I do the same in my classes?

-- General/BrianMoore

General/NSArray is a class cluster; the arrays you actually use are a subclass of General/NSArray. Hence why General/NSArray itself has no instance variables. Check out the General/ClassClusters tutorial for how to roll your own. -- General/KritTer

Ah... I see. Thanks!

-- General/BrianMoore