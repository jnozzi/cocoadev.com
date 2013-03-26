
I would appreciate any help with the following conundrum-

I have the following classes:

[[CustomView]]
CustomWindow1
CustomWindow2
[[DealWithData]]

here's the scenario:

[[DealWithData]] is the primary class and contains methods for setting the alpha of CustomWindow2

CustomWindow1 is an [[NSWindow]] that is connected to [[DealWithData]] by an [[IBOutlet]] - it is the original window from the original NIB created when I began this cocoa app (I suspect this is significant)

CustomWindow1 contains [[CustomView]], which is registered for drags
[[CustomView]] can reference the methods in [[DealWithData]] through a singleton instance of [[DealWithData]]

CustomWindow2 is an [[NSWindow]] that is also connected to [[DealWithData]] by its own [[IBOutlet]]
CustomWindow2 contains some textviews and other data



What I want is for the calls in [[DealWithData]] that control window opacity of CustomWindow2 to be activated by a drag event in [[CustomView]] (which is contained in CustomWindow1).  
So what I am doing is as follows: from within [[CustomView]], I get the singleton instance of [[DealWithData]], and when I get drag events I call [instanceOfDealWithData changeWindowOpacityOfWIndowTwo]

strangely, the events in [[DealWIthData]] are in fact called (because I have [[NSLogs]] that get triggered), but the opacity of CustomWindow2 is unchanged.  If I create buttons in CustomWindow1 with actions to call those very same functions that were ostensibly called by the drag event, then the opacity changes!  

So then I try adding the opacity controlling methods from [[DealWithData]] to [[MyCustomView]] (which lives in CustomWindow1) and try to directly reference CustomWindow2 through an [[IBOutlet]], to avoid [[DealWithData]] altogether.  Everything links up fine in [[InterfaceBuilder]] - but I am simply unable to affect CustomWindow2!  it seems to only respond to commands originating in [[DealWithData]]...any idea why this would be or what I could look for?  is there some property of [[NSView]] that makes it unable to control another window, however indirectly it does so?
----

sounds like this problem:

[[NSViewRedrawsOnObjCMethod]]

----

nope, it was a problem with my implementation of the Singleton.  First time singleton users: read the entire thread before using it to make sure you understand what is going on.  Don't forget to override -(init) to establish a static instance right off the bat!