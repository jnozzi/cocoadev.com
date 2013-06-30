    
#!/usr/local/bin/ioDesktop

General/ObjcBridge autoLookupClassNamesOn

array := (General/NSMutableArray array) 

array addObject:(General/NSNumber numberWithInt:(0))
array addObject:("Test")

writeln (array count)
writeln (array description)

