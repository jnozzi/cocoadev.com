I have two nib files, and from one of them I call the other. But when the other gets loaded, the first's awakeFromNib executes. How can I avoid this ?
I reckon it has something to do with the owner in loadNibNamed - can it be nil ?

----
Making the owner nil will break any outlets you have connected to File's Owner, so you probably don't want to do that. The simplest way to avoid this is to add a flag to your ivars:
    
BOOL didAwakeFromNib;

Then code your     -awakeFromNib like this:
    
- (void)awakeFromNib {
   if(!didAwakeFromNib) {
      didAwakeFromNib = YES;
      ...initialization here...
   }
}


----
With the disclaimer that I'm still not a Cocoa expert, this seems to me like the same class is instantiated twice, one from each nib file. If this is the case, then everything works correctly, and if someone finds that to be a problem then there is probably something wrong with the design of the application. Object instances should be self-contained, and calling a method on one should not affect the other instances.

-- General/EliasMartenson

----
Actually this is what's going on:     -awakeFromNib is sent to every object in a nib after that nib is loaded. This includes File's Owner (see General/FilesOwner). So in the scenario described, you have two nibs. Nib1 instantiates an object of class General/SomeClass, and then sends it     -awakeFromNib. Later on, this instance of General/SomeClass loads Nib2 with     self as File's Owner; Nib2 then sends     -awakeFromNib *again*, causing a probably-unwanted double invocation.

----
In fact, the documentation (http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSBundleAdditions.html) states:

*This method calls awakeFromNib: on owner.*

in the entry for     loadNibNamed:owner:. Clearly then, this is deliberate behaviour. There must be a design change that avoids the satisfactory, but hacky workaround with     didAwakeFromNib above. Surely this sort of code is common:

    
General/IBOutlet General/OtherWindowController *fOtherWindowController;

if(fOtherWindowController==nil)
{
  if(!General/[NSBundle loadNibNamed:@"General/OtherWindow.nib" owner:self])
  {
    General/NSLog(@"Load of Registration.nib failed");
    return;
  }
}
[fOtherWindowController showWindow:self];


where the File Owner of O<nowiki/>therWindow.nib is the same type as this class, and the     fOtherWindowController outlet of File Owner in O<nowiki/>therWindow.nib is connected to an instance of O<nowiki/>therWindowController. That way,     fOtherWindowController is automatically assigned when the nib is loaded, thus giving easy access to the objects in O<nowiki/>therWindow.nib. This is the way I learnt to add nib files, so why is Cocoa trying to destroy me by calling     awakeFromNib on     owner again? If     owner exists, then surely it has already awokenFromNib.

-- General/HeathRaftery

----
*If owner exists, then surely it has already awokenFromNib.*

That's true when an object in one nib loads another nib. But nibs are very often loaded by objects which are not themselves part of a nib, e.g. General/NSWindowController. Even though such objects exist before the nib is loaded, they still need an opportunity to do some work after the nib is loaded and all connections are made, and that's what     awakeFromNib is for. If you have initialization code which should only run once, then you need either to protect it using a flag as described above or else put the code somewhere else, such as your     init method. I'd be extra careful about loading another nib from inside     awakeFromNib.-CS