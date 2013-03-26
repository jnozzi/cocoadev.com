

Hi all,

I'm using <code>tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:</code> in my table view. After returning an array of names I create the files at the specified location <code>[data writeToFile:path atomically:YES];</code> and <code>[data writeToURL:url atomically:YES];</code>. The problem is that when I drag files to Finder they appear not under the mouse cursor where I did drop them, but aligned to other icons (it looks like if my desktop has an option "Snap to grid" always turned on, but in fact it hasn't).
When using other types of drag and drop and writing file data directly to pasteboard, then everything works fine and resulting files appears exactly at the drop location.

I'm totally frustrated, what am I doing wrong?