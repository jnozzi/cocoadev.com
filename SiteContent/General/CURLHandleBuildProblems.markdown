I've been having an awful amount of trouble attempting to build a project that links General/CURLHandle. Each time I build the projct I receive an error in General/CURLHandle.h that says, "curl/curl.h: No such file or directory." I don't know what the problem could be. I've been able to use General/CURLHandle in the past. Perhaps there is a problem in Xcode, or Panther, that needs to be fixed before building?

I have tried downloading the latest General/CURLHandle source, but still run into the same error. Any help would be greatly appreciated. Thanks!

General/EricCzarny

----

See this thread: General/POSTMethodANDNSURLRequest

----

I don't think this is quite the same problem.  For this, you really just need to make sure that     /usr/include/ is among your header search paths, as the Apple-supplied header (found at     /usr/include/curl/curl.h)  should work fine.  At worst, you could just add that file to your project, and switch the     #import <curl/curl.h> statement to     #import "curl.h".   -- Bo

----

I'm getting similar problems trying to build a project using General/CURLHandle (the General/CURLHandleTester project):

1. I know this is probably a stupid question, but what dependencies does this framework have? Do I have to already have curl and libcurl installed?
2. I'm assuming that I need to install the General/CURLHandle.framework into /Library/Frameworks, correct?

The problem is, that even though the General/CURLHandle project compiles fine, and I copy the resulting framework binaray into /Library/Frameworks, I get an error when trying to build and run General/CURLHandleTester:

Tool:0: Command /System/Library/General/PrivateFrameworks/General/DevToolsCore.framework/Resources/pbxcp failed with exit code 1
Tool:0: /Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/../Frameworks: No such file or directory

So I tried to create a Frameworks directory in the parent folder, and then I copied the General/CURLHandle.framework file into that directory. Now I get these errors when trying to build and run:

/Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/General/TestController.h:5:34: error: General/CURLHandle/General/CURLHandle.h: No such file or directory

/Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/General/TestController.h:6:41: error: General/CURLHandle/General/CURLHandle+extras.h: No such file or directory

So what should I do to solve this problem? I feel like I'm missing something obvious, so please forgive me if this question is so trivial.