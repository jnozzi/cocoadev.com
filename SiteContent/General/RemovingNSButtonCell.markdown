I've got my table setup so one column is all [[NSButtonCells]]. However, I'd like for some of the rows to not show the cell, but just show blank. Is there an easy way to do this, or do I need to create a custom cell that internally has its own [[NSButtonCell]] and draws it only if <code>[self drawButton]</code> (or something like that) is true? I tried using <code>setType:</code> with [[NSNullCellType]] but that didn't work.

----
You could <code>return @"";</code> from <code>tableView:objectValueForTableColumn:row:</code>...?

Alternatively, you might <code>setTransparent:YES</code> from <code>tableView:willDisplayCell:forTableColumn:row:</code> and then check <code>isTransparent</code> when the action gets triggered.