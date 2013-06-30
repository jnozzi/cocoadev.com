

I managed to find a pre-compiled version of General/CURLHandle for both intels and ppcs, and I installed the framework into my /Library/Frameworks folder. I found the framework at this address:

http://www.bleepsoft.com/developers

1. I know this is probably a stupid question, but what dependencies does this framework have? Do I have to already have curl and libcurl installed?

2. I'm assuming that I need to install the General/CURLHandle.framework into /Library/Frameworks, correct?

The problem is, that even though the General/CURLHandle project compiles fine, and I copy the resulting framework binaray into /Library/Frameworks, I get an error when trying to build and run General/CURLHandleTester:

Tool:0: Command /System/Library/General/PrivateFrameworks/General/DevToolsCore.framework/Resources/pbxcp failed with exit code 1

Tool:0: /Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/../Frameworks: No such file or directory

So I tried to create a Frameworks directory in the parent folder, and then I copied the General/CURLHandle.framework file into that directory. Now I get these errors when trying to build and run:

/Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/General/TestController.h:5:34: error: General/CURLHandle/General/CURLHandle.h: No such file or directory


/Users/General/DeadJB/Desktop/General/CURLHandle (All Sources)/General/CURLHandleTester/General/TestController.h:6:41: error: General/CURLHandle/General/CURLHandle+extras.h: No such file or directory

So what should I do to solve this problem? I feel like I'm missing something obvious, so please forgive me if this question is so trivial. I just want to be able to get General/CURLHandleTester working so that I can know how to use General/CURLHandle in my own project, since I need the extra features it provides over General/NSURLConnectiton.


----

libcurl is there on os x 10.4.

The framework above makes use of it:
    
cristi:~/Desktop/General/CURLHandle.framework diciu$ nm General/CURLHandle | grep curl
00001b20 t +General/[CURLHandle curlAcceptURL:]
00001cb8 t +General/[CURLHandle curlFlushEntireCache]
00001aa4 t +General/[CURLHandle curlGoodbye]
00001b34 t +General/[CURLHandle curlHelloSignature:acceptAll:]
00002008 t +General/[CURLHandle curlVersion]
000032ec t -General/[CURLHandle curlError]
00002eb8 t -General/[CURLHandle curlThreadBackgroundLoad:]
00002fdc t -General/[CURLHandle curlWritePtr:size:number:message:]
00001d1c t -General/[CURLHandle curl]
00001a34 T _curlBodyFunction
00001a6c T _curlHeaderFunction
         U _curl_easy_cleanup
         U _curl_easy_getinfo
         U _curl_easy_init
         U _curl_easy_perform
         U _curl_easy_setopt
         U _curl_formadd
         U _curl_global_cleanup
         U _curl_global_init
         U _curl_slist_append
         U _curl_slist_free_all
         U _curl_version


I'd say you need to add the curl system library to your frameworks (see man page for curl_easy_cleanup).
On my system it's located under:

/Developer/General/SDKs/MacOSX10.4u.sdk/usr/lib/libcurl.dylib