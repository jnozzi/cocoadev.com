How do I use a General/IBAction without mouse and keyboard?

*If you mean "How do I send an General/IBAction programatically" it's just another method call.*     [self doAction: nil] You can pass anything of type id for sender if you like.