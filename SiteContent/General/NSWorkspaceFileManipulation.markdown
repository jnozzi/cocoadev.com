

I was looking through documentation on General/NSWorkspace, and I came across this:
    
int tag;
BOOL succeeded;
General/NSString *source, *destination, *fullPath;    // Assume these exist
General/NSWorkspace *workspace = General/[NSWorkspace sharedWorkspace];
General/NSArray *files = General/[NSArray arrayWithObject:fullPath];
succeeded = [workspace performFileOperation:General/NSWorkspaceCopyOperation source:source destination:destination files:files tag:&tag];

I understood most of it, but I was confused by fullPath.
Can anyone fill me in?

--General/JoshaChapmanDodson
----
You know, at first glance, I thought you must be joking. It's a full path, right? How hard can it be?     **/**path/to/wherever

But then I realized that it's also a copy operation. And the usual way to do copies is to find a list of filenames *relative* to     source and move them to     destination. In fact (AFAIK), *all* of the General/NSWorkspace file operations work this way. So why use a full path? Well, there's certainly no harm in it...but now I agree - there is no need for it. So what's up with Apple? --General/JediKnil

----
Is there an easier way to copy files?

----

Theres     - (BOOL)copyPath:(General/NSString *)source toPath:(General/NSString *)destination handler:(id)handler from General/NSFileManager

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSFileManager.html#//apple_ref/doc/uid/20000305-CHDBEDCJ