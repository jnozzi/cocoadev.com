In the application I'm writing, I need to check the mouse coordinates to insure they are within the bounds of a custom view before an action can be taken.  Yet, when compiling the code there is an error that says the custom view might not respond to "frame".

    
if (!General/NSPointInRect(dragStartLocation, General/[CustomTitleArea frame])) {
            return;
        }


Do I have to specifically define the location of the custom view called "General/CustomTitleArea" or am I simply missing something?

----

What is "General/CustomTitleArea"? Is it a class or is it an instance of General/NSView or General/NSView subclass?

----

"General/CustomTitleArea" is a sublcass of General/NSView.

----

General/NSView doesn't respond to the message     +General/[NSView frame], so unless you have defined a     frame class method for General/CustomTitleArea it won't work.

---- 
Is that the only problem?  I just need to write the files for it (or let IB make them for me and finish the frame code)?  I thought I was missing something subtle.  Thanks for the help. 

*Actually, what I meant was that it sounds like you are messaging the class object (e.g. General/NSArray, General/CustomTitleArea) rather than an instance of the class (e.g. General/NSArray *myArray, General/CustomTitleArea *myPlace).*

I had another thought.  What if I decided to simply use an General/NSImageView?
----
Hmm, It may be subtle, is     General/CustomTitleArea a class name or an instance name? General/NSView instances do respond to      - frame , but you need to call it on a class instance, not a class name. If you designated the custom class in IB, yes you will need to generate the files for General/CustomTitleArea. You will also need a connected outlet to get to the instance in your window.

----
I probably just don't know what I'm doing all the way around.  Let's assume I drag-and-drop an General/NSImageView onto a window, what would I have to do to turn that into General/CustomTitleArea?  If that makes any sense at all.  Should I subclass it?  Instantiate it?  I don't know.  This might explain it better.  I want to be able to drag a window that is borderless, only when the mouse is within a specific area of the window, say on a .tiff image of a clown being displayed by the General/NSImageView.  Everything else is working just fine, and I can "hack" a workable method together for moving the window when the mouse is in a specific area.  However, I don't want to have to resort to some hack.  I hope that clears up some confusion. 
----
(Edited: General/RoundTransparentWindow reference removed because it lacks a solution to the specific problem.  Everything else concerning the interface is working perfectly well.  I simply am unable to figure out, for whatever reason, how to get General/NSImageView to respond to "frame" in the code above.  I have hacked together a version that will do this, but again I would prefer not to use a hack job.)
----
Define an General/NSImageView outlet in your window delegate (or any other appropriate place of your choice that makes sense in the context of the windows/views lifetime) and connect it. This will give you an instance variable on which you can call      - frame /     - setFrame:  from code. You could also derive General/CustomTitleArea from General/NSImageView. The General/RoundTransparentWindow sample shows one solution for dragging a window from an area other than the title bar. Another solution would be to catch the drag (     - mouseDragged: ) from your custom view and move your parent window by the events     - deltaX/    - deltaY.