

General/ProcessManager is the Carbon API for, well, process management, though the most common use is merely to retrieve information about processes for other uses. Since 10.2 it has been part of the General/HIServices framework under General/ApplicationServices; before that you actually had to link to Carbon to use it.

Most of General/ProcessManager's API depends on being able to retrieve the "process serial number" of the process you're looking for. The best way of doing this uses General/ProcessManager's own     General/GetNextProcess(), which cycles through all of the current user's processes. Start at the beginning by passing in     {0, kNoProcess} as the current process serial number. Each call to     General/GetNextProcess() replaces the contents of its argument with the next process's serial number. When the function reaches the end of the list, it returns     procNotFound and puts     {0, kNoProcess} back into your serial number variable.

<pre>
NSDictionary *info;
BOOL foundApp = NO;
OSErr err;
ProcessSerialNumber psn = {0, kNoProcess};

while (!foundApp)
{	
    err = GetNextProcess(&psn);

    if (!err)
    {
        info = (NSDictionary *)ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
        foundApp = [@"com.apple.dock" isEqual:[info objectForKey:(NSString *)kCFBundleIdentifierKey]];
        [info release];
    }
    else
    {
        break; // either a problem or the end of the list
    }
}
</pre>

General/NSWorkspace offers     -launchedApplications as a little sliver of General/ProcessManager functionality; the same information (and more) can be obtained by stepping through all of the processes using     General/GetNextProcess() and examining info with     General/ProcessInformationCopyDictionary() as shown above.     -launchedApplications also only lists applications, not other processes or UI elements (see General/LSUIElement). Both     -launchedApplications and     General/GetNextProcess() only return information for the current user's processes.

----

When you receive application-related General/NSWorkspace notifications, they contain the application's process serial number within the notification's user info dictionary. You can convert it to a     General/ProcessSerialNumber struct using the following code:

<pre>
// Assuming the dictionary is called userInfo:
ProcessSerialNumber psn;
psn.lowLongOfPSN = [[userInfo objectForKey:@"NSApplicationProcessSerialNumberLow"] unsignedLongValue];
psn.highLongOfPSN = [[userInfo objectForKey:@"NSApplicationProcessSerialNumberHigh"] unsignedLongValue];
</pre>