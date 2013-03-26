, 

You can spin off threads using <code>+[[[NSThread]] detachNewThreadSelector:toTarget:withObject:]</code>. You probably want to create a [[WorkerThread]]--see that page for a thorough discussion. And don't forget about [[ThreadSafety]].