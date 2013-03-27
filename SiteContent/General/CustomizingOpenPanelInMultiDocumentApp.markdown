I thought I wanted to do a simple thing: Customize the General/OpenPanel, so that I can give the option to open other document types than in my info.plist.
Is it really the case that subclassing the General/NSDocumentController (namely the openDocument: method) is what I have to do?

Any other info on the matter would be greatly appreciated!

Alex

----

On casual inspection, I'd say: looks like. I expect it's not a "standard" operation. Is that a problem, particularly?

You might want to override -runModalOpenPanel:forTypes: also, and have it do the work of making an unusual open panel.

-- General/KritTer

----

Thanks for the info.

The ideal hint for me would be source code for the General/TextEdit Open Panel, which does pretty much all the things I would like to do. Is something like that around, somewhere?

Alex

----

You could look at the source code for General/TextEdit in /Developer/Examples/General/AppKit/General/TextEdit to see how General/TextEdit accomplishes this.

-- General/KentSutherland

----

Thanks! Great!