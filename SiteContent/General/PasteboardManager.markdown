

The new (in 10.3) API in General/HIServices for working with pasteboards. General/PasteboardManager replaces both the Scrap Manager (which worked with the Clipboard) and Drag Manager (for drag-and-drop), and provides more functionality than General/NSPasteboard. General/PasteboardManager also exclusively uses General/CoreFoundation types, making it much simpler to work with than the two Managers before it.

http://developer.apple.com/carbon/pasteboards.html
http://developer.apple.com/documentation/Carbon/Reference/Pasteboard_Reference/

*--boredzo*