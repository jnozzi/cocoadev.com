I'm working on a [[ScreenSaver]] and I have a few [[NSImage]]<nowiki/>s that are allocated in the initialization. I need them in every [[AnimateOneFrame]] method, so is there a method I can use to release it when the screensaver stops?

----

How about your dealloc method?

----

Never mind, it goes in the [[StopAnimation]] method.

''No matter what class you're in, <code>dealloc</code> is the preferred location for releasing your class variables. You should get in a habit of using it.''

'''Shouldn't the <code>init...</code> method be paired with <code>dealloc</code> and <code>startAnimation</code> with <code>stopAnimation</code>? If the screen saver stops and restarts, won't it crash? --[[JediKnil]]'''