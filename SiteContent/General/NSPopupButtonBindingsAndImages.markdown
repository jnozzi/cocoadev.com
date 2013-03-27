I'd like to use cocoa bindings but to have nice icons in my General/NSPopupButtons. Is it possible?

Currently, i think the better option is to sublass General/NSPopupButton and to override 
- (void)bind:(General/NSString *)bindingName	toObject:(id)observableObject withKeyPath:(General/NSString *)observableKeyPath options:(General/NSDictionary *)options

But there is maybe a better solution.

KDM