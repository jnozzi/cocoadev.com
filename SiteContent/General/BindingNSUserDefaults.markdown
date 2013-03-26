I would like to bind an instance of [[NSUserDefaultsController]] to manage/store the widths of table columns.  Rather than have each table column bind to a key that's stored in the defaults property file, I'd like to bind to a key in a dictionary that's stored in the property file.  So rather than having:

<code>
TableColumn1Width: 2.0
TableColumn2Width: 3.0
</code>

You would have:

<code>
[[TableColumnWidths]]:
   TableColumn1Width: 2.0
   TableColumn2Width: 3.0
</code>

I'm trying to specify this in the model key path for the binding by doing the following:  "[[TableColumnWidths]].Table1Width" 
Rather than creating/indexing into a dictionary, I get entries in the property file that look like that string.  Is there a way to specify this?  Do I need a special value transformer?

Thanks.