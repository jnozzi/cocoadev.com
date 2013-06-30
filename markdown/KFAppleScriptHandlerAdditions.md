General/KFAppleScriptHandlerAdditions
Makes it easy to call subroutines (with arguments) of compiled General/AppleScript scripts. Certain simple argument types and returns are translated. Here's an (artificial) example:
    
General/NSArray *numberObjects;
numberObjects = [iTunesControllerScpt executeHandler:@"num_albums_by_artists"
                                      withParameters:@"Artist1", @"Artist2", nil];


http://homepage.mac.com/kenferry/software.html#General/KFAppleScript