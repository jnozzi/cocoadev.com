

See also General/SocketClasses.

General/CoreFoundation 's Networking classes built on top of the General/RunLoop. 


*General/CFSocket
*General/CFStream
*General/CFHost


----
You may see General/CFNetwork appear in webserver logs or website statistics applications from programs using these classes.
----

We have a socket class now available on the code section of our website that simplifies asynchronous networking using General/CFSocket. General/NetSocket should fit well into any networked application that has a runloop.

http://www.blackholemedia.com/code (Site moved, somebody knows where?)

-- General/DustinMierau

----

I have also written a socket class, General/AsyncSocket, that probably fills the same niche as General/NetSocket. -- General/DustinVoss