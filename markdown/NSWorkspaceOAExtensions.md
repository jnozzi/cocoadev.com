

A category on General/NSWorkspace that adds one very handy method:

    - (General/NSString *)fullPathForApplicationWithIdentifier:(General/NSString *)bundleIdentifier;

This lets you search by identifier for an app, which means the user can rename or move the app and you'll still find it. It uses General/LaunchServices.