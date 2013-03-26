This is a code provide by apple...in loading filepath of  type jpg from the resource direcoty into an Array.
<code>
 NSArray *imageBundlePathArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
</code>
With this solution, it is inflexible as the files need to be added into the resource directory before compiling in Xcode.

What i require is able to load file path of type jpg from a folder at run-time.  Any ideas?

----

Off the top of my head:
<code>
 NSString *dirPath = // path to directory
 NSArray *dirFiles = [[NSFileManager defaultManager] directoryContentsAtPath:dirPath];
 int i;
 for (i=0; i<[dirFiles count]; i++)
 {
 	NSString *dirFile = [dirFiles objectAtIndex:i];
 	if ([[dirFile pathExtension] isEqualToString:@"jpg"])
 	{
 		// process file
 	}
 }
</code>

----

Thanks but I stil have problems.

<code>
 NSString dirPath = @"images/";
 NSArray *dirFiles = [[NSFileManager defaultManager] directoryContentsAtPath:dirPath];
</code>

Basically i need dirFiles Array to include the relative path as well as the file name.  For example.  
Index 1 contain "image/image1.jpg"
Index 2 contain 'image/image2.jpg"

any ideas?

----

Read the name of every function on http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSString.html .   That will answer your question and many future questions.

''specifically, you're looking for''  [http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSString.html#//apple_ref/doc/uid/20000154/stringByStandardizingPath]

er, <code>-[NSString stringsByAppendingPaths:]</code> actually.  Standardizing "image1.jpg" is not going to yield "image/image1.jpg".