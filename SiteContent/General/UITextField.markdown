

Part of the iPhone [[UIKit]] framework. Subclass of [[UIControl]], implements [[UITextTraitsClient]].

%%BEGINCODESTYLE%%- (id)initWithFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

Designated initializer!

%%BEGINCODESTYLE%%- (void)setFont:([[GSFont]]'')font;%%ENDCODESTYLE%%

Here's more info on [[GSFont]].

%%BEGINCODESTYLE%%- (void)setLabel:(id)arg;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setText:(id)arg;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setTextColor:([[CGColorRef]])color;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setBorderStyle:(int)fp8;%%ENDCODESTYLE%%
enum values for [[BorderStyle]]:
<code>
0,4+ = no border
1 = fine outline
2 = recessed rectangle
3 = rounded, recessed rectangle
</code>