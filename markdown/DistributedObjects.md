

General/DistributedObjects (aka DO) refers to General/FoundationKit's Object Oriented General/RemoteProcedureCall (RPC) mechanism. It allows objects in one process on one machine to talk to objects in other processes on other machines. For more information on using this powerful system, see the General/FoundationKit's General/NSConnection object.

General/NSConnection used to use General/MachMessages to communicate with other machines. Now General/NSConnection uses TCP/IP to communicate with other machines, but continues to use (by default?) General/MachMessages when communicating with processes on one machine.

There are some DO examples on the system here:

/Developer/Examples/Foundation

Also the General/NSConnection documentation outlines several examples of how and when to use DO.

See also: General/DistributedObjectsSampleCode, General/DistributedObjectsForInterThreadCommunication