

An General/NSMovie is a wrapper for a General/QuickTime Movie, providing a simple interface for loading a movie into memory. The movie data can come from a URL or a pasteboard, including the drag-and-drop and cut-and-paste pasteboards. The data can be of any type recognized by General/QuickTime, including nonvideo data such as pure audio or even still images. Once loaded, you can obtain a pointer to the movie data and use the extensive General/QuickTime General/APIs to manipulate the data.

**Important**: General/NSMovie is obsolete and should not be used for new development. If you are developing for 10.4+, or 10.3 with General/QuickTime 7 installed, use General/QTMovie.