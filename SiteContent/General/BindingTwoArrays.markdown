I'm creating a Core Data app and I successfully managed to get part of the interface working. I have 2 classes: Person and Address. The classes were defined on Xcode so that one person can have multiple addresses (one-to-many). When designing the GUI, I dragged two array controllers, one for the person list (will populate a General/NSTableView) and the other one for the address list (another General/TableView). This second tableView, along with some other controls (like General/NSTextFields) are all linked to the selection on the first General/NSTableView.

The problem that I get is that the second General/NSTableView (addresses) never works; everything else works fine.

This is how the array controllers and tableViews were configured:

General/PersonController: Parameters: bound to File's Owner - managedObjectContext, Mode: Entity (Person)
General/AddressController: Parameters  bound to File's Owner - managedObjectContext, General/ContentArray: bound to General/PersonController (selection.properties)

Person tableColumn 1: value bound to General/PersonController (arrangedObjects.name)
Address tableColumn 1: value bound to General/AddressController (arrangedObjects.address)

Buttons are all connected to the respective add/remove methods on the arrayControllers

What am I doing wrong?


http://developer.apple.com/documentation/Cocoa/Conceptual/General/CoreData/Articles/cdTroubleshooting.html#//apple_ref/doc/uid/TP40002320-DontLinkElementID_59  ?