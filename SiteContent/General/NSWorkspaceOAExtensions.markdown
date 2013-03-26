

A category on [[NSWorkspace]] that adds one very handy method:

<code>- ([[NSString]] '')fullPathForApplicationWithIdentifier:([[NSString]] '')bundleIdentifier;</code>

This lets you search by identifier for an app, which means the user can rename or move the app and you'll still find it. It uses [[LaunchServices]].