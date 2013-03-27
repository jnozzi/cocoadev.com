

An General/InstanceMethod is a function that General/AnObject can perform, commonly on or with a General/DataMember.

An General/InstanceMethod must be invoked on an actual instance of the receiving class.  This is what distinguishes it from a General/ClassMethod.

A method is similar to a C function, except that it can only be performed by sending an General/ObjectMessage to an object that implements it, which is central to the modularization that General/ObjectOrientedDesign provides.