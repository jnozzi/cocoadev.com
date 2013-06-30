Hi,
I have an application where i am creating a General/NSMatrix of General/NSImageCells to display thumbnail images. In this matrix i am trying to support Drag and Drop.
If i create the General/NSMatrix in Interface builder, drag and drop is working fine. But for the same code, if i create the General/NSMatrix dynamically, i am getting only mouseDragged, mouseDown and mouseUp events. I am not getting draggingUpdated, draggingEntered, draggingExited, performDragOperation events.
Because of this i am able to just drag the image and i am not able to do drop...

I am creating the General/NSMatrix dynamically like this:

pThumbnailMatrix = General/[[DragMatrix alloc] initWithFrame:frame
                                                           mode:General/NSListModeMatrix
                                                           prototype:General/NSImageCell
                                                           numberOfRows:2
                                                           numberOfColumns:5];

[pThumbnailMatrix setCellSize:General/NSMakeSize(100.0f,100.0f)];
[pThumbnailMatrix setIntercellSpacing:General/NSMakeSize(10.0f,10.0f)];

Here i have subclassed General/NSMatrix to General/DragMatrix to perform Drag and Drop.

Can anyone please help me why i am not getting drag and drop related events only if i create matrix dynamically during run tyme? Am i missing anything here?
----You'll need to post more of your code for us to see why drag and drop isn't working. You've posted nothing that tells us this.