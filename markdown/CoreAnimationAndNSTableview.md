

Hi,

I was trying to get a General/NSTableView to animate like iChat with the help of General/CoreAnimation, but it seems impossible!
Since all the items in a Tableview is General/NSCells, General/CoreAnimation wont help at all...

Anyone got any input on how to do this??

----

Use an General/NSCollectionView instead?

----
Look at the code of Adium - they use animated table view, though it's not General/CoreAnimation. This should help you, too: http://www.mactech.com/articles/mactech/Vol.18/18.11/1811TableTechniques/index.html

Just try replacing [table ...] with [[table animator] ...].