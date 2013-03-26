

Part of the iPhone [[UIKit]] framework. Subclass of [[UIView]].

%%BEGINCODESTYLE%%- (id)initWithContentRect:([[CGRect]])rect;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)orderFront:(id)sender;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)makeKey:(id)sender;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)_setHidden:(BOOL)flag;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setContentView:([[UIView]]'')view;%%ENDCODESTYLE%%

// setting the backlight level

%%BEGINCODESTYLE%%- (void)setLevel:(float)level;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (float)level;%%ENDCODESTYLE%%

// handling interface events - ??

%%BEGINCODESTYLE%%- (BOOL)shouldRespondToStatusBarHeightChange;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)handleStatusBarHeightChange;%%ENDCODESTYLE%%