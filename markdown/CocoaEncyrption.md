General/NSWorkspaceCompressOperation	Compress file. Currently unavailable.
General/NSWorkspaceDecompressOperation	Decompress file. Currently unavailable.
General/NSWorkspaceEncryptOperation	Encrypt file. Currently unavailable.
General/NSWorkspaceDecryptOperation	Decrypt file. Currently unavailable.


Mostly I want the encryption features...anyone know how I can implement them in a equally simple manner? Im guessing they are unavailable  because os x finder can not do it yet....like it could in nine. Which then made me think hmm maybe I can just use a carbon call, but I could not find anything. I think I just wasn't looking in the right place.

--General/GormanChristian

I think they are available. SNAX uses them, I believe.

-- General/DavidRemahl

Well I just tried them....maybe I did it wrong.

    
General/NSFileManager *fileManager;
General/NSArray *simple;

fileManager = General/[[NSFileManager alloc] init];
fileManager = General/[NSFileManager defaultManager];

simple = General/[[NSArray alloc] initWithObjects:(General/NSString *)
                          @"ducktape2 copy.jpg",nil ];
General/NSLog(@"%d", [fileManager fileExistsAtPath:
                       @"/hello/ducktape2 copy.jpg"]);
 
General/NSLog(@"%d",General/[[NSWorkspace sharedWorkspace]
                  performFileOperation:General/NSWorkspaceEncryptOperation
                                source:@"/hello"
                           destination:@""
                                 files: simple
                                   tag: nil]);


Output:

1 (File does exist)

0 (No, I won't encrypt your file foo!)

When I throw in another operation, like say General/NSWorkspaceDestroyOperation, it works fine. And of course I didn't backup that picture. Oh well.

--General/GormanChristian

----

No, I'm pretty sure these operations (Compress/Decompress/Encrypt/Decrypt) really don't do anything. That's what "unavailable" means. So 0 means "I don't understand your request ..."

-- General/MikeTrent