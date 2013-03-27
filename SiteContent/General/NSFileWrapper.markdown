General/NSFileWrapper watches files and directories for changes outside of the application's control. For instance, you can set up a file wrapper on a file and if the user changes the file outside of your application, you can use the file wrapper to continue to access the file independent of the user's changes.

----

Does anyone have any experience in using file wrappers as the document type for an application? Are there any tutorials available?

Specifically, the document receives two messages regarding the file wrapper: fileWrapperRepresentationOfType: and loadFileWrapperRepresentation:ofType:. So during the course of the user editing the document, let's say the user does something which causes a file to be added to the wrapper directory representing the user's document. What wrapper do I use to add this file? Should I retain the one from the loadFileWrapperRepresentation:ofType: message?

--General/ChrisMeyer

----

I removed some stuff I put here, because I want to give a better answer to the question, after implementing my document saving. My feeling is that the answer depends on the size of the file. I think an General/NSFileWrapper instance size is directly dependent on the size of the associated file, as it is really a copy of a file in memory  (either loaded from disk or being created from scratch with some General/NSData). Please if somebody knows that this is not true, say it here and delete the rest...

If the document size is typically quite small, you could retain the General/NSFileWrapper during     loadFileWrapperRepresentation:ofType:, and use it to add a new file when     fileWrapperRepresentationOfType: is called. This way, you can update the General/NSFileWrapper elements that need updating (i.e. files that need updating) and return the General/NSFileWrapper instance. If the file is big however, this means that the whole file is always loaded in memory, and that you rewrite the whole file every time you save.

Now, here is the scenario that I have been facing, and the answer that I found was the most appropriate. My document consists of a Main file, relatively small (typically 50-500 kb), and then 'Jobs' files that can have any size and that can be numerous. These job files are meant to be manipulated independently: the user create new jobs or delete them, or read them, and this is independent from the 'Main' document, which contains some common data for all the 'Jobs'. So when the user saves the document, only the 'Main' part needs to be really saved. The 'Jobs' are manipulated elsewhere. I could apply the above scheme, and save the whole document every time I need (adding jobs, deleting jobs, updating the 'Main'). The problem is the file will usually be many megabytes, because of all these 'Jobs'. And even if it is only 1 MB, saving the whole thing when only one Job (~10-100 kb) was changed is a big waste.

Here is a copy of the code that I wrote for General/NSDocument : General/SavingFilePackageWithManySmallIndependentFiles

The bottom line is that loading the document uses     loadFileWrapperRepresentation:ofType:, while writing the files uses     writeWithBackupToFile:ofType:saveOperation:. The loading will thus load the whole document in memory with the General/NSFileWrapper, but just once and then the General/NSFileWrapper is released (one could make the loading better using the     readFromFile:ofType: method). The saving needs more code to save memory and time usage. It only saves the 'Main' part if saving is done in place (with some intermediate backup  in case things go wrong), and uses General/NSFileManager to copy the Jobs to the new file in case of a Save As/To operation.

General/CharlesParnot

----

Keep in mind that performance will do nothing but suck if the files you are placing into the wrapper are large. General/NSFileWrapper is slow, to say the least. It is recommended that if you are doing something like iMovie - dealing with huge video files, for instance - you should try General/NSFileManager. For example:

    

    - (BOOL)writeToFile:(General/NSString *)fileName ofType:(General/NSString *)docType
    {
        if ([super writeToFile:fileName ofType:docType])
        {
            General/NSArray * clipFiles = [slides valueForKey:@"clipFile"];
        
            int x;
            int count = [slides count];
        
            [saveProgressPanel orderFront:self];
            [saveProgressBar startAnimation:self];
        
            for (x = 0; x < count; x++)
            {
                General/NSString * iteratedFile;
                NSURL * fileURL = [NSURL General/URLWithString:[clipFiles objectAtIndex:x]];
            
                iteratedFile = [fileURL path];
            
                General/NSLog(@"saving...");
            
                if (General/clipFiles objectAtIndex:x] length] > 0)
                {
                    if ([[[[NSFileManager defaultManager] fileExistsAtPath:iteratedFile] == YES)
                    {
                        if (General/[[NSFileManager defaultManager] fileExistsAtPath:[fileName stringByAppendingString:[@"/" stringByAppendingString:[iteratedFile lastPathComponent]]]])
                        {
                            General/NSLog(@"it's already saved in the file.");
                        }
                        else
                        {
                            if (General/[[NSFileManager defaultManager] fileExistsAtPath:General/[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] stringByAppendingPathComponent:General/clipFiles objectAtIndex:x] lastPathComponent] == YES)
                                General/[[NSFileManager defaultManager] copyPath:General/[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] stringByAppendingPathComponent:General/clipFiles objectAtIndex:x] lastPathComponent] toPath:[[fileName stringByAppendingString:@"/"] stringByAppendingString:[iteratedFile lastPathComponent handler:nil]];
                            else
                                General/[[NSFileManager defaultManager] copyPath:iteratedFile toPath:General/fileName stringByAppendingString:@"/"] stringByAppendingString:[iteratedFile lastPathComponent handler:nil];
                        }
                    }
                    else
                        General/NSLog(@"this file cannot be found.");
                }
                else
                    General/NSLog(@"no file");
            }
            [saveProgressBar stopAnimation:self];
            [saveProgressPanel orderOut:self];
            return YES;
        }
        return NO;
    }



Of course, you must still use one of the fileWrapper or fileOfType methods along with it (writeToFile doesn't replace those, it just gives you more control)...

    

    - (General/NSFileWrapper *)fileWrapperRepresentationOfType:(General/NSString *)aType
    {
        if (General/self fileName] length] > 0)
        {
            [[NSMutableArray * savedPaths = General/[NSBundle pathsForResourcesOfType:nil inDirectory:[self fileName]];
            int count = [savedPaths count];
            int x;
            for (x = 0; x < count; x++)
            {
                if (General/savedPaths objectAtIndex:x] pathExtension] == @"data")
                    [[NSLog(@"ignoring data file");
                else
                {
                    if (General/[[NSFileManager defaultManager] fileExistsAtPath:General/[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] isDirectory:YES] == YES)
                    {
                        if (General/[[NSFileManager defaultManager] movePath:[savedPaths objectAtIndex:x] toPath:General/[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] stringByAppendingPathComponent:General/savedPaths objectAtIndex:x] lastPathComponent] handler:nil == YES)
                            General/NSLog(@"success!!");
                        else
                            General/NSLog(@"error copying file");
                    }
                    else if (General/[[NSFileManager defaultManager] createDirectoryAtPath:General/[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] attributes:nil] == YES)
                    {
                        if (General/[[NSFileManager defaultManager] movePath:[savedPaths objectAtIndex:x] toPath:General/[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/General/AppName"] stringByAppendingPathComponent:General/savedPaths objectAtIndex:x] lastPathComponent] handler:nil == YES)
                            General/NSLog(@"success!!");
                        else
                            General/NSLog(@"error copying file");
                    }
                }
            }
        }
    
        General/NSMutableDictionary * fileWrappers;
        fileWrappers = General/[NSMutableDictionary dictionaryWithCapacity:1];
        [fileWrappers setObject:General/[[NSFileWrapper alloc] initRegularFileWithContents:General/[NSKeyedArchiver archivedDataWithRootObject:slides]] forKey:@"slides.idata"];
        General/NSFileWrapper * wrapper = General/[[NSFileWrapper alloc] initDirectoryWithFileWrappers:fileWrappers];
    
        return wrapper;
    }

    - (BOOL)loadFileWrapperRepresentation:(General/NSFileWrapper *)wrapper ofType:(General/NSString *)type {
        currentFileName = [self fileName];
        General/NSDictionary * contents = [wrapper fileWrappers];
        General/NSFileWrapper * objects = [contents objectForKey:@"slides.idata"];
        General/NSData * objectData = [objects regularFileContents];
        General/NSMutableArray * newSlides;
        newSlides = General/[NSKeyedUnarchiver unarchiveObjectWithData:objectData];
        if (newSlides == nil) {
            return NO;
        } else {
            General/NSArray * slideTypes = [newSlides valueForKey:@"slideType"];
            General/NSArray * clipNames = [newSlides valueForKey:@"clipName"];
            General/NSArray * clipFiles = [newSlides valueForKey:@"clipFile"];
            General/NSArray * backgroundColors = [newSlides valueForKey:@"backgroundColor"];
            General/NSArray * slideTitles = [newSlides valueForKey:@"slideTitle"];
            General/NSArray * slideBodys = [newSlides valueForKey:@"slideBody"];
            General/NSArray * isLoops = [newSlides valueForKey:@"isLoop"];
            General/NSArray * loopTargets = [newSlides valueForKey:@"loopTarget"];
            General/NSArray * loopRepeats = [newSlides valueForKey:@"loopRepeat"];
        
            int x;
            int count = [newSlides count];
        
            for (x = 0; x < count; x++)
            {
                General/VideoSlide * slide = General/[[VideoSlide alloc] init];
                [slide retain];
            
                [slide setSlideType:[slideTypes objectAtIndex:x]];
                [slide setClipName:[clipNames objectAtIndex:x]];
                [slide setClipFile:[clipFiles objectAtIndex:x]];
                [slide setSlideTitle:[slideTitles objectAtIndex:x]];
                [slide setSlideBody:[slideBodys objectAtIndex:x]];
                [slide setBackgroundColor:[backgroundColors objectAtIndex:x]];
                [slide setIsLoop:[isLoops objectAtIndex:x]];
                [slide setLoopTarget:[loopTargets objectAtIndex:x]];
                [slide setLoopRepeat:[loopRepeats objectAtIndex:x]];
            
                [slides insertObject:slide atIndex:[slides count]];
                [slide release];
            }
            [table reloadData];
        
            return YES;
        }
    }



This is taken from something I'm working on, but should give you a rough idea. I was working with video files, some that were HD, and thus were huge. It wasn't performing fast enough to just tie into a wrapper, so I still made a wrapper, but didn't put anything in it. Then, just call that additional method, and allowed me to tie in whatever else I wanted. Something that you don't see in this code is that, after loading the file, those files aren't loaded into memory (like a traditional file wrapper). Rather, I pull the file's name from the string in the array, and hunt down the file's path using that filename and the saved file path. If it can't find it there, I can always search elsewhere. This seems to work for me, even with 3 gigabyte files.
Even though it's big, I've posted this here because I had difficulty finding helpful info on General/NSFileWrapper anywhere online; people would say "don't use it", or they would just say "it's easy, look in the docs"....

-- General/JasonTerhorst