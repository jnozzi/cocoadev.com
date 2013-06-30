

Events are occurrences that the system recognizes: things such as mouse clicks, key hits, and the like.

When General/AnEvent is received by General/AnApplication, the General/FirstResponder in the General/ResponderChain is given the chance to deal with it. If it doesn't know what to do with it, it passes it on up the General/ResponderChain. If nothing deals with it, it is ignored.