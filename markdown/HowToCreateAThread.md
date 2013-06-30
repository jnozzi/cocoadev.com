, 

You can spin off threads using     +General/[NSThread detachNewThreadSelector:toTarget:withObject:]. You probably want to create a General/WorkerThread--see that page for a thorough discussion. And don't forget about General/ThreadSafety.