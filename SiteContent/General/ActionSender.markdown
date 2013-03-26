How do I use a [[IBAction]] without mouse and keyboard?

''If you mean "How do I send an [[IBAction]] programatically" it's just another method call.'' <code>[self doAction: nil]</code> You can pass anything of type id for sender if you like.