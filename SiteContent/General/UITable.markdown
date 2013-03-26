

Part of the iPhone [[UIKit]] framework. Subclass of [[UIScroller]].

See also: [[UIPreferencesTable]] and [[UISectionList]].

'''Methods'''

%%BEGINCODESTYLE%%- (id)initWithFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)addTableColumn:([[UITableColumn]]'')column;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setDataSource:(id)dataSource;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setDelegate:(id)delegate;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setSeparatorStyle:(int)style%%ENDCODESTYLE%%

[[SeparatorStyles]] are: 1 for a 1px grey line, 2 for a 2px grey line, 3 (default) for no separator lines.

%%BEGINCODESTYLE%%- (void)reloadData;%%ENDCODESTYLE%%

you can deselect the select row by calling the following at the end of the tableRowSelected callback:

	%%BEGINCODESTYLE%%[[[notification object]cellAtRow:[[notification object]selectedRow]column:0] setSelected:FALSE withFade:TRUE];%%ENDCODESTYLE%%

[[EcumeDesJours]]

Unlike in [[AppKit]], you must call reloadData for the table rows to appear.

----

'''
Data source methods
'''

%%BEGINCODESTYLE%%- (int)numberOfRowsInTable:([[UITable]]'')table;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[UITableCell]]'')table:([[UITable]]'')table cellForRow:(int)row column:([[UITableColumn]] '')column;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[UITableCell]]'')table:([[UITable]]'')table cellForRow:(int)row column:([[UITableColumn]] '')column reusing:(BOOL)flag;%%ENDCODESTYLE%%

----

'''
Delegate methods
'''

%%BEGINCODESTYLE%%- (BOOL)table:([[UITable]] '')table showDisclosureForRow:(int)row %%ENDCODESTYLE%%

Returns YES if a row shows the disclosure arrow, NO if not.

%%BEGINCODESTYLE%%- (BOOL)table:([[UITable]] '')table disclosureClickableForRow:(int)row %%ENDCODESTYLE%%

If YES, table row will be selected if user clicks on disclosure arrow. If NO, selection won't change ("dead spot" on arrow). If not implemented, defaults to YES.

%%BEGINCODESTYLE%%- (BOOL)table:([[UITable]]'')table canSelectRow:(int)row;%%ENDCODESTYLE%%

Return value indicates whether the row can be selected. Defaults to YES.

%%BEGINCODESTYLE%%- (void)tableRowSelected:([[NSNotification]]'')notification;%%ENDCODESTYLE%%

A [[UITableSelectionNotification]] notification. The notification's object is the [[UITable]]. Called when a row is clicked, even if it was already selected.

%%BEGINCODESTYLE%%- (void)tableSelectionDidChange:([[NSNotification]]'')notification;%%ENDCODESTYLE%%

A [[UITableSelectionDidChangeNotification]] notification. The notification's object is the [[UITable]].

----

'''
Misc. delegate methods
'''


*scrollerDidScroll:
*scroller:adjustSmoothScrollEnd:velocity:
*scroller:shouldAdjustSmoothScrollEndForVelocity:
*table:willSwipeToDeleteRow:
*tableWillLoadVisibleCells:
*table:heightForRow:
*table:setObjectValue:forTableColumn:row:
*table:willDisplayRowsInRange:
*table:canDeleteRow:
*table:confirmDeleteRow:
*table:canInsertAtRow:


----

(moved [[UISectionList]] sample code to a new [[UISectionList]] page..)