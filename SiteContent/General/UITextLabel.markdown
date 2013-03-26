

Subclass of [[UIView]]. Displays static, uneditable text, with optional shadow, center alignment, wrapping, ellipsis-izing, and so on.

%%BEGINCODESTYLE%%+ ([[GSFont]]'')defaultFont;

- (void)setText:([[NSString]] '')text;

- (void)setFont:([[GSFont]]'')font;

- (void)setColor:([[CGColorRef]])color;

- (void)setBackgroundColor:([[CGColorRef]])color;

- (void)setCentersHorizontally:(BOOL)center;

- (void)setWrapsText:(BOOL)wrap;

- (void)setShadowColor:([[CGColorRef]])color;

- (void)setShadowOffset:([[CGSize]])offset;%%ENDCODESTYLE%%