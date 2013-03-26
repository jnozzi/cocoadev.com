[[ObjectLibrary]]

"A wrapper class around the <code>kqueue(2)</code> file change notification mechanism.

Simply create a [[UKKQueue]], add a few paths to it and listen to the change notifications via [[NSWorkspace]]'s notification center."

http://www.zathras.de/programming/sourcecode.htm#[[UKKQueue]]

See also: [[FileSystemNotifications]]

----

How can I subscribe a directory situated in a removable media?

----
The file system has to support the change notifications.  Things like NFS and FAT32 don't have the necessary support to do that (as far as I know)

----
If the file system does not support kqueues, you can use the traditional [[NSWorkspace]] notifyFileSystemChanged and corresponding notifications to make things work more or less right. You can also do polling if needed. -- [[EmanueleVulcano]] aka l0ne

----

[[UKKQueue]] works quietly, politely, and as advertised. I used it in a recent project and was very pleased to have done so! -- [[RobRix]]

----
I'm trying to use this, but don't seem to be getting any notifications. Could anyone help?

I'm setting up the [[UKKQueue]] as follows.
<code>
[[UKKQueue]]'' kqueue = [[[UKKQueue]] sharedFileWatcher];
    [[NSLog]](@"adding dir=%@", [Preferences tvShowDirectory]);
    [kqueue addPathToQueue:[Preferences tvShowDirectory]];
    [[NSWorkspace]]'' workspace = [[[NSWorkspace]] sharedWorkspace];
    [[NSNotificationCenter]]'' notificationCenter = [workspace notificationCenter];
    [[NSArray]]'' notifications = [[[NSArray]] arrayWithObjects:
        [[NSWorkspaceDidPerformFileOperationNotification]],
        [[NSWorkspaceMoveOperation]],
        [[NSWorkspaceCopyOperation]],
        [[NSWorkspaceLinkOperation]],
        [[NSWorkspaceCompressOperation]],
        [[NSWorkspaceDecompressOperation]],
        [[NSWorkspaceEncryptOperation]],
        [[NSWorkspaceDecryptOperation]],
        [[NSWorkspaceDestroyOperation]],
        [[NSWorkspaceRecycleOperation]],
        [[NSWorkspaceDuplicateOperation]],
        nil];
    
    int i;
    for (i=0; i<[notifications count]; i++) {
        [[NSLog]](@"Adding notification=%@", [notifications objectAtIndex:i]);
        [notificationCenter addObserver:self selector:@selector(fsHandler:) name:[notifications objectAtIndex:i] object:nil];
    }
</code>

[[FsHandler]] never gets called when I create/touch/delete files within the added file structure.  Any suggestions?  Thanks!


----

[[UKFileWatcher]]/[[UKKQueue]] doesn't use those constants as its notification names. See http://www.zathras.de/programming/cocoa/[[UKKQueue]].zip/[[UKKQueue]]/[[UKFileWatcher]].h for appropriate notification names.

----

Yes it always helps to subscribe to the proper notifications. ;)
Thanks! Worked like a charm.

----

[[UKKQueue]] was written in 2003 and is a bit long in the tooth. There is now a modern, faster, more efficient class that you might consider: [[VDKQueue]]. You can find it here: http://github.com/bdkjones/[[VDKQueue]]