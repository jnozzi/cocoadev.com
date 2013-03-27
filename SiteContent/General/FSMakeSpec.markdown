I'm writing a General/QuickTime tool in Cocoa, and I'm going crazy trying to figure out why I'm getting an General/OSErr=-37 when I try to General/FSMakeFSSpec an General/FSSpec for a simple full path. The error code descriptions are at the link below:

http://developer.apple.com/documentation/Carbon/Reference/File_Manager/file_manager/General/ResultCodes.html

Basically General/OSErr=-37 is a bad filename or volume name (bdNamErr). When a full pathname is only four levels deep, everything works fine, but when a full pathname is more than four levels deep I get this error. 

    

*extern General/OSErr General/FSMakeFSSpec( short vRefNum, long dirID, ConstStr255Param fileName, General/FSSpec *spec)
        
struct General/FSSpec {
    short              vRefNum;           //  Volume reference number.
    long               dirID;                  //  Directory ID of parent directory.
    General/StrFileName    name;                 //  Filename or directory name; a Str63 string on the Mac OS
};
    


The full pathnames do not have spaces in them or any other funky characters for that matter. All of the path components are less than 10 characters each, so I don't think this is being caused by any limits to the length of the pascal string passed to this function. I'm not an experienced classic Mac programmer, so any help from one would be nice --zootbobbalu

A solution to this problem is available here: General/FSMakeFSSpec