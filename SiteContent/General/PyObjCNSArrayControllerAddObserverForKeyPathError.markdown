

I am developing in General/PyObjC, but the mailing list for is kind of sleeping. Because this is a Cocoa-related issue I thougt why not try it here...

I have got a list with objects:

p = [<Person 1 lastname=u'Koen' firstname=u'Harry'>, <Person 2 lastname=u'Hei' firstname=u'Yvin'>, <Person 3 lastname=u'Stoop' firstname=u'Dirk'>, <Person 4 lastname=u'Dooijes' firstname=u'Ciaran'>, <Person 5 lastname=u'Ensink' firstname=u'Anneke'>]

I am feeding this list to an General/NSArrayController, and displaying it in an General/NSTableView. It works, but for each key I get such an error in the console:

2005-09-05 12:14:07.657 Etalage[317] *** Ignoring *** addObserver:forKeyPath:options:context: for 'lastname' (of <General/NSArrayController: 0x119daa0>[object class: General/NSMutableDictionary, number of selected objects: 1] with 0 in 0x0).

So I guess I have to subclass an General/NSArrayController and redefine the method where it does the General/AddObserverForKeyPath function, right?