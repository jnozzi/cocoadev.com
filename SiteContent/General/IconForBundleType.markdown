It's easy enough to get the icon for a particular file type using:
    
General/NSString *type = @"html";
General/NSImage *icon = General/[[NSWorkspace sharedWorkspace] iconForFileType:type];


But, this technique doesn't seem to work for bundle types (i.e. app,prefpane,plugin...), I don't want to have to write code as follows  with a case for every known bundle type:
    
General/NSString *type = ...
if([type isEqual:@"app"]) 
    type = General/NSFileTypeForHFSTypeCode('APPL');
else ... //other cases	
    type = General/NSFileTypeForHFSTypeCode('fldr');	
General/NSImage *icon = General/[[NSWorkspace sharedWorkspace] iconForFileType:type];


Can someone suggest an alternative? Note: the file doesn't necessary exist, so the normal General/NSWorkspace General/IconForFile: won't help.