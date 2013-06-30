http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSNetServiceBrowser.html

Used for Browsing (i.e. discovering General/RendezVous network services)

(General/ObjC only and 10.2 and later only.)

The example application that apple provides (General/PictureSharing and General/PictureBrowserSharing) are good starts. Here is another useful example to read through:

http://macdevcenter.com/pub/a/mac/2003/05/13/cocoa.html

----

Has anyone else noticed that General/NSNetServiceBrowser is GOD AWFUL at resolving services found? Almost half the time I search for something, the delegate tries to resolve the service, but it never completes. Anybody else had this trouble?

-- General/KentSutherland

Have not had that issue at all. Do you have some serious network issues? -- General/MatPeterson

Here neither, in the development General/SubEthaEdit we almost never got netService:didNotResolve:. Note that the actual resolving does the General/NSNetService, and you have to register as delegate for that to recieve the netServiceDidResolveAddress: method. Also note that you should send the General/NSNetService a stop message after you have sufficiently resolved your stuff, otherwise you cause much unneccesary traffic, which Panther will comment with some General/NSLog messages to the console. -- General/DominikWagner