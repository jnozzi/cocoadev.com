

I've made a command line tool, that i'll launch with General/NSTask like this:

    

General/NSTask * server = General/[[NSTask alloc] init];
General/NSMutableArray *args = General/[NSMutableArray array];
[args addObject:@"Server"];
[args addObject:path];
[server setCurrentDirectoryPath:path];
[server setLaunchPath:[path stringByAppendingPathComponent:@"Server"]];
[server setArguments:args];
[server launch];



so far so good.when the user quit the application, i do not send [server terminate] because it's suppose run in background. My problem is when the user open the application (not the server), and want to terminate the server, how do i do that. My guess is i have to find the process and put it into a General/NSTask and send [task terminate]. But i dont know how to do that.Tnx

----

If you name the server's executable something unique you can launch a task to kill all tasks running under that unique name. 

    

- (General/IBAction)killServer:(id)sender {
     General/[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:General/[NSArray arrayWithObjects:@"General/AUniqueServerName", nil]];
}

*

note: killall will only kill tasks that are owned by the user*!

----

Killing all tasks with the same name seems overly crude. I suggest that you use General/AGProcess to find the task. Since it lets you read the task's environment variables, you can tag it at launch and then be sure that you've found your process by looking for a certain environment variable like this:

    

General/NSString * const General/ServerBinaryName = @"Server";
General/NSString * const General/ServerIdentifierTagEnvironmentKey = @"2334rqfa";

- (void)launchServer {
    General/NSTask *server = General/[[NSTask alloc] init];

    General/NSArray *arguments = General/[NSArray arrayWithObjects:General/ServerBinaryName, path, nil];
    [server setArguments:args];

    [server setCurrentDirectoryPath:path];
    [server setLaunchPath:[path stringByAppendingPathComponent:General/ServerBinaryName]];

    General/NSMutableDictionary *environment = General/[NSMutableDictionary dictionaryWithDictionary:[server environment]];
    [environment setObject:@"" forKey:General/ServerIdentifierTagEnvironmentKey];
    [server setEnvironment:environment];
    
    [server launch];
}

- (void)killServer {
    General/NSEnumerator *processEnumerator = General/[[AGProcess userProcesses] objectEnumerator];
    General/AGProcess *process = nil;
    
    while (process = [processEnumerator nextObject]) {
        if (General/[ServerBinaryName isEqualToString:[process command]]) {
            General/NSDictionary *environment = [process environment];
            
            if ([environment valueForKey:General/ServerIdentifierTagEnvironmentKey]) {
                General/NSLog(@"Killing server with pid %i.", [process processIdentifier]);

                if ([process terminate]) {
                    General/NSLog(@"Killed server.");
                }
                else {
                     General/NSLog(@"Failed to kill server.");
                }
            }
        }
    }
    
    General/NSLog(@"Did not find a running server.");
}

*

/Mr. Fisk

See General/QuitApplicationUsingAppleEvent for faster quit code.