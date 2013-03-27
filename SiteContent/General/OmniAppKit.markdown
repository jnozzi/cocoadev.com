

General/OmniAppKit is General/TheOmniGroup's set of extensions to Apple's General/AppKit.framework, full of cool stuff to make Mac OS X application development even easier. Some highlights:


*  General/AppleScript - General/OAOSAScript makes it super-easy to run General/AppleScripts from within a Cocoa app, and companion classes introduce features such as automatically populated script menus, scripts on toolbars, and extensions to the Text suite allowing scripters to manipulate rich text.
*  General/OAPreferences (See General/OmniAppKitPreferences) - An architecture for building multi-pane Preferences windows. All you need to do is write the individual preference panes (which is quite easy) and General/OAPreferences will automatically generate an appropriate Preferences window ? one like System Prefrences if you have lots of panes, or one like Mail's Preferences window if you only have a few.
*  General/OAFindPanel - Apple has a standardized architecture for Find in applications, but they leave implementing it entirely up to developers. General/OmniAppKit provides a powerful Find & Replace panel and a protocol for easily making widgets and documents in your app searchable.
* General/OAInspector & General/OAInspectorGroup - These classes help you write 'inspector' pallettes. See General/OmniGraffle for an excellent example of General/OAInspectorGroup. It does a really cool animated 'ping' between the pallettes when you drag them close to each other.


General/OmniAppKit also includes lots of extensions to Apple's classes to make creating rich user interfaces much easier.

Here is a list of the extensions and subclasses that have documentation so far on General/CocoaDev. (In no particular order, feel free to organize!)


*General/OAShrinkyTextField
*General/OASplitView
*General/OAConfigurableColumnTableView
*General/OAThreadCheckingView
*General/OATypeAheadSelectionHelper
*General/OAFontCache
*General/OAContextButton
*General/OAGradientTableView
*General/NSWorkspaceOAExtensions
*General/NSWindowOAExtensions


If you are thinking about using the General/OmniFrameworks you should also look at them and see how much of the classes you are going to use General/OmniBase and General/OmniFoundation weigh in at around 650K together (yes that is stripped if I am wrong please tell me), i would say General/OmniAppKit will be around the same. So either be prepared to take a hit in application size or spend quite some time slimming things down in project builder.