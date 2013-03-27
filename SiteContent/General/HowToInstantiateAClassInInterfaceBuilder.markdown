

If the class in question already has an General/IBPalette, you can create the instance the same way you would a button. See General/HowToCreateAButton.

If your class is a subclass of General/NSView, you can created an instance of the superclass (General/NSView or any subclass with an General/IBPalette) and then change it's class to your subclass. For example, if you want to instantiate a M<nowiki/>yButton, you would create an General/NSButton and change its class to M<nowiki/>yButton.

If you want the object to be at the top level of the Nib, select the class you want to instantiate and choose Classes > Instantiate M<nowiki/>yClass.

General/HowToProgramInOSX