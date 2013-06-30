Hi, I'm a newbie writing my second app, a HTML/General/JavaScript Editor.
I have two questions:

1) I'm looking for a simple way to add some text to a General/NSTextView and then hightlight the text I have inserted.
All I have is this...

    
- (General/IBAction)insertText:(id)sender
{
    General/NSString *myCode;
    myCode = @"some javascript code here";
    [_textView insertText:myCode];
}


... which works fine, very simple. Now I would like the text that was inserted (myCode) to be highlighted (something like a sintax coloring, but much simpler).

2) Is there some way to insert some text and then select just part of it, like General/XCode does when you choose a parameter from the Hint list? (e.g. <#(General/NSString *)format#> gets selected when you choose stringWithFormat) Can I do it with General/[NSTextView selectWord:(id)sender]; ?

Thanx in advance.

- General/FernandoLucasSantos


----

Use General/NSTextView's setSelectedRange and pass it the range of what you just inserted. Something like     [_textView setSelectedRange:General/NSMakeRange([_textView selectedRange].location, [myCode length])]

----

Also see General/HelpWithNSTextView and General/SettingInsertionPoint for why using     insertText: is probably not the best way to get text into a General/NSTextView programatically.