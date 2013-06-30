

[Topic]

----

To do a "Reveal in Finder" type command, you just need the (full) path, and then write something like the following call:
    
 (General/IBAction)revealLocal:(id)sender{
        General/NSWorkspace *sw = General/[NSWorkspace sharedWorkspace];

	 // probably going to use your own path, this is just to remind you to expand '~'.
	General/NSString *path = [@"~/Desktop/General/MyFile.pdf" stringByExpandingTildeInPath]; 

 	[sw selectFile:path inFileViewerRootedAtPath:nil];
}



----

I'm having trouble with this method.  Even though the docs are very specific:

<code>
If a path is specified by rootFullPath, a new file viewer is opened. If rootFullPath is an empty string (@""), the file is selected in the main viewer.
</code>

I'm getting a new file viewer created each time I call this even though I'm passing @"" for rootFullPath. Anyone else have this problem or know what's up?

UPDATE: This only happens if I call the method with a path to a folder.  Works as advertised for files.

-General/KenAspeslagh

----

Did you try passing 'nil' as the path? *Sorry, brain-dead question. Never mind I asked. ;-)*

----

What if you specify the parent folder as the rootFullPath? 
----
works great for me!  General/EcumeDesJours