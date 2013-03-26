I need to use pmset in my app, but when I use the 'schedule' argument, it just says "Badly formatted date". However, if I use 'repeat', it works fine. Here's my code:

<code>
[[NSTask]] ''task = [[[NSTask]] launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:[[[NSArray]] arrayWithObjects:@"pmset", @"schedule", @"wake", @"'03/18/07 15:00:00'", nil]];
</code>
I know that's not the best way to use sudo, but it works fine for testing. :) I just have to make sure sudo is "unlocked" before using it.


Anyway, it seems like the problem might be that there's a space in between the date and the time, so it thinks it's two arguments. Does anyone have suggestions? Thanks in advance.

----
Remove the single quotes from your date. You are confusing shell argument escaping with direct UNIX arguments which require no such quoting.

See [[NSTaskArguments]].

----
Cool, it works! Thank you.