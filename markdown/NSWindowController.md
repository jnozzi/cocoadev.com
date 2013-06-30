General/NSWindowController is used to simplify the task of coordinating documents with complex view requirements by allowing each document to manage its own set of views.

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSWindowController_Class/Reference/Reference.html

http://developer.apple.com/documentation/Cocoa/Conceptual/General/WinPanel/Concepts/General/UsingWindowController.html

General/NSWindowController is usually used in conjunction with the documents in General/NSDocument-based apps. However, General/NSWindowController is convenient when creating other forms of window controllers, such as preference panels, custom about panels, and other windows. In particular, General/NSWindowController abstracts away all of the details when keeping track of windows and their delegates: making sure objects are disposed at the right time, lazily loading nib files, etc.

**See Also**

General/NSDocument and General/NSDocumentController

General/HowToReferToTheWindow

General/WhenDoISubclassNSWindowController