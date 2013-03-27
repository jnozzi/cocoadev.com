General/PosingClasses is where you take one class and have it used in place of another class throughout your program. You do this by sending the +poseAsClass: message to the class you want to pose.

If you think General/PosingClasses might be useful in your program, consider first whether or not you could achieve what you want with General/ClassCategories, as General/PosingClasses is a bit more in-depth.

One caveat is that it requires both classes to be the same size, which effectively means that posing classes can't define any new General/InstanceVariables. Doing so will result in an error, failure of the posing operation, and (most likely) a crash.

Another caveat is that posing does not change any instances of the posed class to be instances of the new class, although it will change instances of subclasses. For example, if you use posing to replace General/NSView, all General/NSView instances that exist at the time you pose will *not* be changed to the new class. Instances of General/NSControl, General/NSMovieView, etc. will be changed. This isn't important for classes like General/NSObject where nobody ever allocates instances of them, but for other classes, you need to make sure that your posing happens as early as possible, before any instances are created.

One use of General/PosingClasses is General/WeakReferencingObject; General/WeakReferencingObject poses as General/NSObject in order to provide everything with weak referencing methods. This couldn't have been done with General/ClassCategories, however, because General/WeakReferencingObject had to override methods in General/NSObject, and then call them within those methods (in order to extend them).

See also General/ClassPosing.