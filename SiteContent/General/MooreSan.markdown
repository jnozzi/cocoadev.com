General/MooreSan 

I like the General/EiffelProgrammingLanguage for General/ProgrammingByContract and clean General/MultipleInheritance.  I like General/AppleScript for General/ConversationalProgramming.  I like General/JavaScript for runtime fun with closures, everything being an object (including functions) and runtime overridable inheritance ^_^.  I like General/CPlusPlus for introducing me to templates (General/STLGoodness).  I like General/LangPerl because it's like awk but better!  I like General/LangBasic because I started programming on an General/AppleII (and General/QBasic for F5.. did I mention I made use of mouse, images, and sound in my General/QBasic programs...).  I like Cocoa, because of the General/DevelopmentEnvironment (General/XCode, General/InterfaceBuilder) and the clean division between General/OOCode and C.  (At first I thought it was silly to have the [reciever message] syntax as being inconsistant with the C underpinnings.  Now I think that because it's seperate it makes it very clear when you are working on an object, versus touching member variables etc.)

I'm a Canadian in Japan, teaching English in Elementary Schools.  I have a Bachelors of Biblical Counseling.  I write programs for making programs (General/ScriptingLanguages, General/MacroLanguages, etc.), programs for making teaching resources (handouts, gameboards, card sets, etc.), and programs for recreation (tetris General/AIs, General/UnixLikeOperatingSystems in General/ECMAScript for portability between flash and web browsers etc.)

----

Some things I am using/working on in my current projects: General/InvarianceCheckingWithAspectCocoa, General/ACCurrentMethod (now considered uneccesary), General/PluginArchitecture, General/WebKit, General/DragAndDropTables, General/NSTextViewAsWiki, General/FSObject, General/DOScriptingArchitecture (see General/DOStrategy).

there's more but I'll add them later.

----

Current Cocoa design pattern thoughts:

Model Manager (Vender) Controller View.  I only code the middle three.  Model is completely Foundation classes (General/NSUserDefaults/General/NSDictionary/General/NSString... sometimes I add categories to them so that relevant code stays on that layer). Manager only talks to the Model and contains all the application logic for manipulating the data (if it's of a more general nature I put it in the affore mentioned category on the class itself). Vender is an object implementing a General/DOScriptingArchitecture protocol and registers itself on launch on a port with the bundle id of the application (usually I vend methods that give access to data without manipulating it).  Controller is a delegate/datasource/target for General/AppKit classes, and that's all... (it has a reference to a Manager object which it asks about data state, or tells to manipulate the data... but the controller really only responds to and sends messages to General/ApplicationKit and other General/NSView sub-classes).  View is General/AppKit.

I like General/NSUserDefaults; I don't like General/TooMuchXML...I like General/CoProcessing; I don't like threads.... I like categories and General/ObjC's orthogonality to C; I don't like General/CPlusPlus or Java because they're not General/ObjC (no categories, not orthogonal)... I like UNIX; I don't like Microsoft... I like General/FScript and General/JavaScript; I don't like macros...  I like General/DistributedObjects; I don't like SQL...I like Interface Builder; I wish IB did more... I like cheese...