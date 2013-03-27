

The General/RunTime is an important part of General/ObjC. It is the underlying system that implements passing messages and determining object types while your application is running.  It is more or less invisibly linked to your application code.  

It is used internally for General/MultipleDispatch, and also allows you to query General/AnObject to ask if can perform a method.

The General/RunTime is implemented using C functions and used by the framework classes and classes you create. See General/InstanceMethod and General/ClassMethod.

The General/RunTime also lets you modify class hierarchies and method dispatch on the fly with techniques such as General/ClassPosing and General/MethodSwizzling.

You can use the open source software General/RuntimeBrowser [http://code.google.com/p/runtimebrowser/] to browse Objective-C runtime.