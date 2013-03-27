I'm working on a General/ScreenSaver and I have a few General/NSImage<nowiki/>s that are allocated in the initialization. I need them in every General/AnimateOneFrame method, so is there a method I can use to release it when the screensaver stops?

----

How about your dealloc method?

----

Never mind, it goes in the General/StopAnimation method.

*No matter what class you're in,     dealloc is the preferred location for releasing your class variables. You should get in a habit of using it.*

**Shouldn't the     init... method be paired with     dealloc and     startAnimation with     stopAnimation? If the screen saver stops and restarts, won't it crash? --General/JediKnil**