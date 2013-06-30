An General/NSURLConnection object provides support to perform the loading of a URL request. The interface for General/NSURLConnection is sparse, providing only the controls to start and cancel asynchronous loads of a URL request.

General/NSURLConnection�s delegate methods allow an object to receive informational callbacks about the asynchronous load of a URL request. Other delegate methods provide facilities that allow the delegate to customize the process of performing an asynchronous URL load.

Note that these delegate methods will be called on the thread that started the asynchronous load operation for the associated General/NSURLConnection object.

 General/NSURLConnection also has a convenience class method, sendSynchronousRequest:returningResponse:error:, to load a URL request synchronously.

http://developer.apple.com/documentation/Cocoa/Conceptual/General/URLLoadingSystem/index.html?http://developer.apple.com/documentation/Cocoa/Conceptual/General/URLLoadingSystem/Tasks/General/UsingNSURLConnection.html

----

I have a General/NSView that when resized beyond a certain size creates an object that initiates a General/NSURLConnection.  The connection is initiated but it does not trigger any of its delegates (didReceiveResponse etc) until after the viewDidEndLiveResize. I want to download data continously while I'm resizing the view but as it is now the download doesn't start until after I've stopped resizing it. Does anyone know what the cause of this behaviour could be and how to fix it? --General/ErikS 

----

To quote the docs: "For the connection to work correctly the calling thread�s run loop must be operating in the default run loop mode." If you're resizing the window, then you're probably in the event tracking run loop mode. I see no way to influence what modes General/NSURLConnection will run in, so you'll probably have to spin off a secondary thread and have it call back to the main thread using performSelectorInMainThread:, which does have a modes: parameter you can use to make it work in whatever mode you want.

----



That is definitely the problem. Does this mean that everytime an event such as a view resize is triggered General/NSURLConnections spawned on the same thread as the view halts? This seems a bit inefficient. 

Anyway, performSelectorOnMainThread: modes: only determine which modes the selector will be performed under. It doesn't set the mode it is performed in. Which would bee what I want. Or am I misunderstanding something? I guess I need to make sure that the code with the General/NSURLconnection runs in default mode and not event mode (which is the case now). How do I do this? Do I really neeed to create a second thread? And if so how do I make sure that the new thread is running in default mode? It seems like a thread runs in event mode if it is spawned in event mode. I'm not sure of this though since General/[[NSRunLoop currentRunLoop] currentMode] seems to return nil all the time. 

I found a solution to a similar discussion here, but it doesn't help me General/NSTimerDoesntRunWhenMenuClicked . Any ideas?

----
Create a second thread. Then avoid issues of runloops altogether by doing a General/NSURLConnection sendSynchronousRequest:returningResponse:error, then call back to the main thread via performSelectorInMainThread: with the result.

----
Your distinction between "performed under" and "performed in" does not make sense. The modes argument determines which runloop modes can be running when the selector is invoked.

Your statement that "a thread runs in event mode if it is spawned in event mode" does not make sense. An General/NSRunLoop will run in whatever mode you tell it to run in.

    General/[[NSRunLoop currentRunLoop] currentMode] is probably returning nil because you're calling it from a place where the current mode is not a concept that makes sense, for example from outside an event handler or other callback.