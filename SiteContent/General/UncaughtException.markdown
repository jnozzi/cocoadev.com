This is my first Cocoa application:
It is an [[AppleScript]] application

On build and run, the build is Successful and no errors or warning, but on run I get this error on te Run: page

<code>
2003-06-16 12:15:31.076 [[GalleryBuilder]][523] An uncaught exception was raised
2003-06-16 12:15:31.103 [[GalleryBuilder]][523] ''''' class error for '[[ASKNibObjectInfo]]': class not loaded
2003-06-16 12:15:31.119 [[GalleryBuilder]][523] ''''' Uncaught exception: <[[NSArchiverArchiveInconsistency]]> ''''' class error for '[[ASKNibObjectInfo]]': class not loaded

[[GalleryBuilder]] has exited due to signal 5 (SIGTRAP).
</code>

I do not understand this and need some help please. 
Thanks,
Steven King
( mailto:steven.king@washingtonpost.com )

----
At a guess, I'd say you need to include the [[AppleScriptKit]] framework. You'll find it in /System/Library/Frameworks

----
Thanks, it worked, I thing when I started it was a Cocoa application instead of an Applescript Studio app, thanks again