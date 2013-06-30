I have a single tablecolumn. Each row of the table column should have a General/NSRelevance type level indicator and its height should be lesser than the row height. Can anyone help me out.

----

Don't really parse your statement "Each row [height] of the table column should ... be lesser than the row height"...but General/NSTableView has the following method:

- (void)setRowHeight:(float)rowHeight

If you mean the General/NSLevelIndicator, then this is derived from General/NSCell in a table column so have a look at the documentation for that class.

----
General/HowToAskQuestions General/MailingListMode