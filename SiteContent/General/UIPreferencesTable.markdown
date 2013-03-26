

Subclass of [[UITable]].

'''[[UIPreferencesTable]] delegate methods'''

%%BEGINCODESTYLE%%- (int)numberOfGroupsInPreferencesTable:([[UIPreferencesTable]]'')aTable;

%%BEGINCODESTYLE%%- (int)preferencesTable:([[UIPreferencesTable]]'')aTable numberOfRowsInGroup:(int)group;

%%BEGINCODESTYLE%%- ([[UIPreferencesTableCell]]'')preferencesTable:([[UIPreferencesTable]]'')aTable cellForGroup:(int)group;

%%BEGINCODESTYLE%%- (float)preferencesTable:([[UIPreferencesTable]]'')aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed;

%%BEGINCODESTYLE%%- (BOOL)preferencesTable:([[UIPreferencesTable]]'')aTable isLabelGroup:(int)group;

%%BEGINCODESTYLE%%- ([[UIPreferencesTableCell]]'')preferencesTable:([[UIPreferencesTable]]'')aTable cellForRow:(int)row inGroup:(int)group;