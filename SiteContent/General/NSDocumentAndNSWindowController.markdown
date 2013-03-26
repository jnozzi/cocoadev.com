I have a document-based app that is not using [[NSDocument]] subclasses (basically writing all the MDI support myself).

I got bitten because I added a document getter to my window controller. Apparently the window calls something like

<code>[[[self windowController] document] isDocumentEdited]</code>

although the <code>document</code> message in the window controller class is said only to return <code>id</code>. The result is used for handling the responder chain (i.e. sending a message to nil will reach the document of the current window, if no-one else responds to the message. This should ''not'' require that the instance be (a subclass of) [[NSDocument]]).

Can anyone give more details about what is really required by the document returned? I would prefer to use the name of <code>document</code> for my getter, and I could just implement <code>isDocumentEdited</code> This seems quite risky, since others might perhaps also make unjustified assumptions about the type of the result.