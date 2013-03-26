

As i'v said, i wish to know new sizes of window ( of [[NSImageView]] element exactly ) after resizing it. I suppose i need to use windowDidResize function as an event... But i don't know how to use it. [[NSWindowController]]? Must i connect it and how? I'm just newb with Cocoa, so i have such stupid questions. You are wellcome )

Or windowWillResize ([[NSImageView]] will resize)? Have may i add class reference, what headers, etc...

----

when a window is resized, it sends a message to it's delegate 
<code>
- ([[NSSize]])windowWillResize:([[NSWindow]] '')sender toSize:([[NSSize]])frameSize
</code>

if the window has no delegate, or it does not implement this method, then nothing happens.
create a new class that extends [[NSObject]] and implements this method.  it recieves an [[NSSize]] object which is a c struct.
you can get the width and height like so:

<code>
- ([[NSSize]])windowWillResize:([[NSWindow]] '')sender toSize:([[NSSize]])frameSize
{
 float width  = frameSize.width;
 float height = frameSize.height;
}
</code>
and then do with them what you wish.  

in interface builder you need to instantiate the new class and then make it the delegate of the window (cntrl drag from 'window' to new class)

i'm pretty new to cocoa too, so i hope that helps and made sense.

----
Thanks anywhere )

Well, i thought that i had made an update of the thread... I'v already solved the problem, but have a little issue. I'm using windowDidResize funtion, but it receives message from [[NSWindow]] every time i'm resizing it (realtime resizing - sending message). I'v thought that it must run only once - when window already resized (mouse button up), but it runs every time resizing... I didn't catch out how to say it send only once...