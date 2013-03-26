http://www.diggory.net/grazing/[[SystemPrefsIcon]].jpg

http://developer.apple.com/documentation/[[UserExperience]]/Conceptual/[[PreferencePanes]]/index.html
----

[[SystemPreferences]] is an Application built-in to Mac OS X which allows the user to alter system-wide preferences - i.e. preferences that will affect the whole OS and not just one application.

The application basically allows selection of different preferencePanes (commonly called prefpanes)

It is a Cocoa application and these panes are bundles that are loaded dynamically.

This means you can write your own prefpanes by subclassing [[NSPreferencePane]]

See also [[NSUserDefaults]] and [[CFPreferences]].

----

[[NSUserDefaults]] seems to allow only storing data under the com.apple.systempreferences domain, not under your own domain. For that, you must use [[CFPreferences]], either directly or by subclassing [[NSUserDefaults]].

You may also use apple private methods of [[NSUserDefaults]]�:

<code>
@interface [[NSUserDefaults]] ([[ApplePrivate]])
- (id) objectForKey:([[NSString]]'')key inDomain:([[NSString]]'')domain;
- (void) removeObjectForKey:([[NSString]]'')key inDomain:([[NSString]]'')domain;
- (void) setObject:(id)object forKey:([[NSString]]'')key inDomain:([[NSString]]'')domain;
@end
</code>