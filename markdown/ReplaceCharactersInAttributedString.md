What I need to do is take an General/NSAttributedString, search it for a specific set of characters, say an @ symbol, and then replace that symbol with something else. I looked into General/NSScanner, but it doesn't seem to work with General/NSAttributedString. Does anyone have a good idea? This is probably really easy and I'm just overlooking something. Thanks.

*General/NSMutableAttributedString*

Sorry, that's what I am using, but I need an idea of how to actually search it and replace the characters.

**Pull out its string using the     -string method. I don't really blame you for missing this; it seems like an attributed string should just work like a string sometimes. General/NSMutableAttributedString also has a method     -mutableString, which returns an General/NSMutableString that tracks the changes to the attributed string. --General/JediKnil**