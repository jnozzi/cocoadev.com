

[[TemplateMethod]] is a [[DesignPattern]] which defines the steps of an algorithm and allows another class to provide the implementation for one or more steps.  This is typically implemented by using an [[AbstractSuperclass]] which calls abstract methods from its template methods, effectively deferring steps in an algorithm to its subclasses.

[[TemplateMethod]] is useful for:


* Adding hooks into an algorithm for notification purposes, similar to [[DelegateObject]]<nowiki/>s.
* Keeping the steps of an algorithm intact while hiding the implementation details of the rest of the algorithm from the object that implements some of those steps.


----
'''Using abstract classes for [[TemplateMethod]]'''

Cocoa does not have an explicit way to declare an [[AbstractSuperclass]] or abstract methods, but these can be simulated by throwing exceptions in the "abstract" methods and throwing an exception in the default initializer if the class being initialized is the "abstract" class (instead of a subclass).  

See [[HowToDeclareAbstractClasses]] and [[WhyDeclareClassAsAbstract]].

----
'''Using a [[DelegateObject]] to mimic [[TemplateMethod]]'''

Delegation in Cocoa is similar to [[TemplateMethod]], but in most cases delegates are optional, and the result of the delegate call is not crucial to the proper functioning of the algorithm. However, use of the [[TemplateMethod]] often involves cases where the algorithm cannot function properly unless the abstract method is implemented (or the delegate responds to the method).

The best way to mimic [[TemplateMethod]] with delegates is to force delegates to implement a [[FormalProtocol]] for non-hook delegate methods and require the delegate as an initializer parameter. 

This approach is very similar to the Strategy [[DesignPattern]].

----
'''Discussion:'''