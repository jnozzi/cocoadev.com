I am trying to dupicate the behavior seen in iTunes's source list, where when you click on a certain row (i.e. the Music Store), it changes the view from an [[NSTableView]] to a [[WebView]] (probably in an [[NSTabView]]). What I want to know is how to get it to send the method to the tabview to change its current tab when a row is clicked in the tableview. I understand [[NSTableView]] uses its delegate methods to send notifications about changes in selection, and that I can use the -clickedRow method to know which one, but what I need to know is where and how can I implement this? Do I do it in a subclass of the tableview? Or do I do it in another subclass altogether? I've seen this behavior in a lot of good apps and little or no documentation on how to do it exactly. --[[LoganCollins]]

----

You need to implement tableViewSelectionDidChange: on the table view's delegate. Rather than using a tab view, however, it might make more sense to just have the big view you want to switch between [[NSTableView]] and [[WebView]] be a generic [[NSView]]. Then programmatically point it to whichever view is appropriate. Alternately, add the appropriate view as a subview. It seems like using a tab view here would be... not the intended use for a tab view. -- [[AndyMatuschak]]

''Another possibility is to assign your table column's cell an action, which will be sent when the user clicks on it. Also, you should use <code>[tableView selectedRow]</code> (which is probably more reliable than <code>clickedRow</code> anyway). --[[JediKnil]]''

I see nothing wrong with using a (tabless) tab view here. --[[RyanStevens]]

<pedantic>Since iTunes is Carbon, it's using neither an [[NSTableView]] nor a [[WebView]].</pedantic>

<pedantic times two>[[WebView]] is available to Carbon apps, so iTunes ''could'' use it. It doesn't, though.</pedantic>