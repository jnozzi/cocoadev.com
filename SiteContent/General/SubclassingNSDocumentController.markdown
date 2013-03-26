I'm trying to subclass [[NSDocumentController]]. Apple's docs at

    [http://developer.apple.com/documentation/Cocoa/Conceptual/Documents/Tasks/[[SubclassController]].html] say

''The application will not ask for its shared document controller until after the applicationWillFinishLaunching: message is sent to its delegate. Therefore, you can create an instance of your sub-class of [[NSDocumentController]] in your application delegate�s applicationWillFinishLaunching: method and that instance will be set as the shared document controller.''

But with the following in my app delegate

<code>

- (void)applicationWillFinishLaunching:([[NSNotification]]'')notification 
{
    documentController = [[[[MyDocumentController]] alloc] init];
}

</code>

my app still uses the regular [[NSDocumentController]]. Creating the [[MyDocumentController]] instance in my app controller's <code>-(id)init</code> method causes my document controller to be used (i.e. it works.)

Can anyone confirm that <code>applicationWillFinishLaunching:</code> is still too late to create a [[NSDocumentController]] subclass, or am I doing something wrong?

----

Ah... nevermind. Some other code in my app delegate's init was instantiating another controller which called <code>[[[NSDocumentController]] sharedDocumentController]</code> which was creating the instance. I just happened to insert the <code>[[[[MyDocumentController]] alloc] init]</code> line before that code.