Basically I have [[NSTableView]] with custom dataCell set via <code>[[[tableView tableColumns] objectAtIndex:0] setDataCell:customCell]</code>. For some calculations I need to know the <code>rectOfRow</code> and tableView returns correct value, but just while there're some rows. When I delete the last row, tableView starts to return 0 for nonexistent rows. <code>rowHeight</code> (even summed with <code>intercellSpacing</code>) and <code>[customCell cellSize].height</code> return smaller values.

But there should be somewhere the correct value, since empty table continues to draw alternate rows at correct size. The question is where can I get the same value for empty table that rectOfRow will return when the table is filled with data?

-- Solved

----

Hello, Mr. Lazy Mess-Maker, do you think you could actually post what the solution is, rather than leave the page incomplete and put a half-hearted attempt at a [[DeleteMe]] tag on it?

----

This is really disappointing. All the newbies who come along make a '''mess''' and don't bother cleaning it up. If you create a question page and find an answer yourself, '''POST THE ''#@&$ ANSWER!'''

----

^^ Perfect example of an appropriate response vs inappropriate response.