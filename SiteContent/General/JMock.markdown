Unit Test : �Unit Test is a procedure used to validate that individual units of functional code are working properly. �

� General/JUnit is very much about testing state and behaviour of individual methods. How about the interaction between classes?
� One way is to use mock objects (jMock, www.jmock.org) Mock means something made as an imitation
� A mock object of a class C has all the methods of class C but instead of executing them, it records the calls to the 
  methods of C, which can then be tested.
� Mock Objects are stubs that mimic the behavior of real objects in controlled ways.
� Mock Objects will enable your unit test to mimic behavior and verify expectations on
  dependent components.

Use Mock Objects when testing dependent components, for example:
Object Graph, Circular Dependency, your Coworker Component, a Third Party Component, a Very Slow Component, a
Component with Complex Set up, a Component with Exceptional Behavior, a Remote Component, a DB Component