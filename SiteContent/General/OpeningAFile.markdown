I have an application (not document-based) which allows you to open a certain file type in it, but when I drag the file into the app's icon, it logs     *** +[Controller readableTypes]: selector not recognized, even though everything works fine. Should I igonore this, or is there something I'm missing?

See General/DebuggingTechniques, particularly the section on debugging uncaught exceptions.

----

OK, thanks.

----

There is already a page General/[DebugUnrecognizedSelector] that topically addresses this problem by title.

General/OpenFileInNonDocumentApplication deals with the specific subject of General/OpeningAFile in a non-document application

General/HowToOpen deals with opening a file using the C standard library