I am designing an application which may load files from ftp sites. I figured that I then better stick to exclusively using NSURL for file names throughout my program.

It turns out that NSURL suck in that I always have to do [NSURL fileURLWithPath:<nsstring>] because General/NSStrings are used so many places... and worse, 1) the General/NSApplication delegate methods all use General/NSStrings for opening files and 2) even though the General/NSDocumentController has a noteNewRecentDocumentURL (which take an NSURL) then it will choke on non-file General/URLs... so basically General/NSURLs are incompatible with the core system services I would need...

So should I just use normal General/NSStrings and handle ftp opens specially (i.e. not tell the document controller about it on so)?