is it possible to have a tableview row formatted to a certain font? 

also, how can i make it so the tableview items are not editable?

thx

----

Returning an General/NSAttributedString as the object value for a cell allows you to specify a font. See the Apple documentation on this class for more.

For the second part, look at - (BOOL)tableView:(General/NSTableView *)tableView shouldEditTableColumn:(General/NSTableColumn *)tableColumn row:(int)row. This message is sent to the General/NSTableView delegate (either set up in General/InterfaceBuilder or with the setDelegate: message). Again, the Apple documentation describes this in more detail.

General/SamTaylor

----

thank you. will give it a shot.

Tommy

----

ok, here is my tableview method:

- (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex {
   
     General/NSString *dafont=[ fontarray objectAtIndex:rowIndex];

fontsetup= General/[NSDictionary dictionaryWithObject:General/[NSFont fontWithName: dafont size: 12.0] forKey:@"General/NSFontAttributeName"];
 
  [data initWithString: dafont attributes:fontsetup];
  
   return data;
 

}


any values that are not declared are declared in the header file. fontarray is an aray contining system fonts. data is an General/NSAttributedString, fontsetup a dictonary. this enters all the rows into the tableview but they are all blank. any advice?

thx

----

Something is wrong with the line: [data initWithString:dafont attributes:fontsetup]. You say data is an General/NSAttributedString, but do not say where it is alloced. Normally the alloc and init statements are kept together in Cocoa, so the line would be: data=General/[[[NSAttributedString alloc] initWithString:dafont attributes:fontsetup] autorelease]. See General/MemoryManagement for why you use an autorelease. It might also help to look at General/InstanceObject. The variable data should be probably be local to the method (it doesn't have to be, but there is no reason for it not to be).

Just to check, are you also implementing - (int)numberOfRowsInTableView:(General/NSTableView *)aTableView?

General/SamTaylor

----

i'm implementing the numberOfRowsInTableView method. with that data=General/[[[NSAttributedString alloc] initWithString:dafont attributes:fontsetup] autorelease]; line it now displays the font in the tableview but the tablerow is in the default font rather than the font specified in the method.

Tommy

[edit: making data a local variable to the method did not change anything.]

----

OK, the problem is with using @"General/NSFontAttributeName" as the key value in the dictionary. You should actually just use General/NSFontAttributeName, which is defined in the headers. The code definitely works after that (I just compiled it...)

As for the local/global variable thing, yes it will work as either, but it is probably good practice to use a local (to the method) variable. I don't see any situation where data could be used outside this method, as its value is unpredictable. Make it local to remove the temptation of using it elsewhere...

----

thanks everyone! i dont know where i would be concerning cocoa/objective c if it weren't for people willing to answer a questino or two.