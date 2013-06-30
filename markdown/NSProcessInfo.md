[http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSProcessInfo.html]

A General/FoundationKit class containing various low-level information about your process and the system it's executing on, such as environment variables, arguments, OS type, host name and so on. You access your process' shared instance of General/NSProcessInfo with     General/[NSProcessInfo processInfo].

It can also be used to generate strings guaranteed to be unique on your network with     General/[[NSProcessInfo processInfo] globallyUniqueString]  <- also see General/IDentifiers