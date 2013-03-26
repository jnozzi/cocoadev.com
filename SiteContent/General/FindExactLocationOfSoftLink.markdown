How do I find the location of the file a soft link links to by code, made with:

<code>
ln -s /folder /target
</code>

----

[[NSFileManager]] is a way to go: <code>[[[[NSFileManager]] defaultManager] pathContentOfSymbolicLinkAtPath:@"/path/to/link"]</code>

-- [[DenisGryzlov]]