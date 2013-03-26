

Part of the iPhone [[UIKit]] framework. Defined in <[[UIKit]]/[[UIPickerView]].h>

<code>
- (id) initWithFrame: (struct [[CGRect]])rect
{
     [[UIPickerView]] ''refreshPicker = [[[[UIPickerView]] alloc] initWithFrame: [[CGRectMake]](0.0f, rect.size.height - 200.0f, 320.0f, 200.0f)];
     [refreshPicker setDelegate: self];
     [refreshPicker setSoundsEnabled: TRUE];

     [[UIPickerTable]] ''_table = [refreshPicker createTableWithFrame: [[CGRectMake]](0.0f, 0.0f, 320.0f, 200.0f)];
     [_table setAllowsMultipleSelection: FALSE];

     [[UITableColumn]] ''_pickerCol = [[[[UITableColumn]] alloc] initWithTitle: @"Refresh" identifier:@"refresh" width: rect.size.width];

     [refreshPicker columnForTable: _pickerCol];
}

- (int) numberOfColumnsInPickerView:([[UIPickerView]]'')picker
{
     // Number of columns you want (1 column is like in when clicking an <select /> in Safari, multi columns like a date selector)
     return 1;
}

- (int) pickerView:([[UIPickerView]]'')picker numberOfRowsInColumn:(int)col
{
     // Rows of selection for each row (use a switch for multi cols)
     return 2;
}

- ([[UIPickerTableCell]]'') pickerView:([[UIPickerView]]'')picker tableCellForRow:(int)row inColumn:(int)col
{
     [[UIPickerTableCell]] ''cell = [[[[UIPickerTableCell]] alloc] initWithFrame: [[CGRectMake]](0.0f, 0.0f, 320.0f, 32.0f)];

     switch (row)
     {
          case 0:
		[cell setTitle: @"Manually"];
	  break;
	  case 1:
		[cell setTitle: @"5 min"];
	  break;
     }

     return cell;
}
</code>

How can I set the row that should be selected as default?