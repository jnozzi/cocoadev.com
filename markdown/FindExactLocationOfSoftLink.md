How do I find the location of the file a soft link links to by code, made with:

    
ln -s /folder /target


----

General/NSFileManager is a way to go:     General/[[NSFileManager defaultManager] pathContentOfSymbolicLinkAtPath:@"/path/to/link"]

-- General/DenisGryzlov