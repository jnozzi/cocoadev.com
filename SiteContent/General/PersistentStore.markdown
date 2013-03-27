A data storage location used by the General/CoreData framework's General/PersistentStoreCoordinator. The General/PersistentStoreCoordinator can add and remove General/PersistentStore instances on the fly, giving the appearance of a single storage location.

There is no official public General/PersistentStore class in General/CoreData 1.0, so the General/PersistentStoreCoordinator uses the id type to represent it.

Each General/PersistentStore has a store type, such as General/NSXMLStoreType (the default), General/NSSQLiteStoreType, General/NSBinaryStoryType or General/NSInMemoryStoreType. The initial release of General/CoreData does not support custom store types. The General/NSSQLiteStoreType has some scalability advantages over the other types, since it supports faulting and incremental writes. By contrast, the XML and Binary stores types read and write the entire object graph at each load or save event.

More information can be found here:
http://cocoadevcentral.com/articles/000086.php#10