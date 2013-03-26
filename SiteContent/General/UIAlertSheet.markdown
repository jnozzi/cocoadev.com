

<code>
// Alert sheet attached to bootom of Screen.
[[UIAlertSheet]] ''alertSheet = [[[[UIAlertSheet]] alloc] initWithFrame:[[CGRectMake]](0, 240, 320, 240)];
[alertSheet setTitle:@"Alert Title"];
[alertSheet setBodyText:@"This is an alert."];
[alertSheet addButtonWithTitle:@"Yes"];
[alertSheet addButtonWithTitle:@"No"];
[alertSheet setDelegate:self];
[alertSheet presentSheetFromAboveView:self];
</code>

<code>
// Allert sheet displayed at centre of screen.
[[NSArray]] ''buttons = [[[NSArray]] arrayWithObjects:@"OK", @"Cancel", nil];
[[UIAlertSheet]] ''alertSheet = [[[[UIAlertSheet]] alloc] initWithTitle:@"An Alert" buttons:buttons defaultButtonIndex:1 delegate:self context:self];
[alertSheet setBodyText:@"Do something?"];
[alertSheet popupAlertAnimated:YES];
</code>


%%BEGINCODESTYLE%%- (void)setTitle:([[NSString]]'')title;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setBodyText:([[NSString]]'')text;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)addButtonWithTitle:([[NSString]]'')title;%%ENDCODESTYLE%%

Numbered, starting with one. Number is returned in delegate callback.

%%BEGINCODESTYLE%%- (void)setDelegate:(id)delegate;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)presentSheetFromAboveView:([[UIView]]'')view;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)popupAlertAnimated:(BOOL)animated;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)popupAlertAnimated:(BOOL)animated: atOffsett:(float)offset;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)dismiss;%%ENDCODESTYLE%%

Same as dismissAnimated:YES, I think.

%%BEGINCODESTYLE%%- (void)dismissAnimated:(BOOL)animated;%%ENDCODESTYLE%%

'''[[UIAlertSheet]] delegate methods'''

%%BEGINCODESTYLE%%- (void)alertSheet:([[UIAlertSheet]]'')sheet buttonClicked:(int)button;%%ENDCODESTYLE%%

<code>
- (void)alertSheet:([[UIAlertSheet]]'')sheet buttonClicked:(int)button
{
  if ( button == 1 )
    [[NSLog]](@"Yes");
  else if ( button == 2 )
    [[NSLog]](@"No");

  [sheet dismiss];
}