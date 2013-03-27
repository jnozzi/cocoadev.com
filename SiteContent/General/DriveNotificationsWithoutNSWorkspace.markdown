I currently use General/NSWorkspace's notification center to get notified when an iPod is connected or disconnected. This works for General/FireWire and USB iPods. However, this method gets called other times too when the iPod/disk isn't actually getting disconnected or connected (just mounted/unmounted). Is there another way (General/IOKit?) to get drive notifications? Thanks.

----

General/DiskArbitration. *--boredzo*