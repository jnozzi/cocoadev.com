This is more of a unix question, but anyway...

From a Cocoa app I am launching a process using <code>fork()</code>/<code>system()</code> (yes, I also tried [[NSTask]], but with the same problem).  The problem is, that the process I launch will also launch a process, and so, when I kill the process I launched, the child of it will stay around.

This was initially why I switched from [[NSTask]] to <code>fork()</code>/<code>system()</code>, cause then I could use <code>setpgrp()</code> for the new process and use <code>killpg()</code> to kill the process group, but it gave the same result (and anyway, the child of the new process had the process group ID to be the process ID of the process, not the group ID.

I also tried <code>kill(-getpid(), SIGTERM)</code> but w/o luck.  The only thing which works is <code>kill(0, SIGTERM)</code>, but unfortunately that will also kill my own task.

So my question is, how to kill a process with all its children?
<code>
- (void)awakeFromNib
{
   setpgrp(0, getpid());

   int parentID = getpid();
   if(fork() == 0) // child
   {
      setpgrp(0, parentID);
      system(cmd); // cmd will spawn a new process and wait for ctrl-c
   }
}

- (void)applicationWillTerminate:([[NSNotification]]'')aNotification
{
   kill(0, SIGTERM);
}
</code>

----

I looked in the documentation for [[NSTask]].

Is <code>- (void) terminate </code> the magic bullet for this one?