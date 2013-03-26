

Hi folks,

I'm having trouble with the Sync Services.  I've looked at the docs:

http://developer.apple.com/documentation/Cocoa/Conceptual/[[SyncServices]]/index.html

and

http://developer.apple.com/documentation/[[AppleApplications]]/Reference/[[SyncServicesSchemaRef]]/index.html#//apple_ref/doc/uid/TP40001543

for the correct client property list description format, and I can get it to work for the com.apple.contacts.Contact  but if I add the com.apple.contacts.IM into the Entities list, it fails to registery my client.   Here is the error from [[XCode]]:

'''
failed to register to sync these required properties of entity named com.apple.contacts.IM: {contact} 
'''

Here is my property list for the client:  
<code>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/[[DTDs]]/[[PropertyList]]-1.0.dtd">
<plist version="1.0">
<dict>
	<key>[[DisplayName]]</key>
	<string>testd</string>
	<key>Entities</key>
	<dict>
		<key>com.apple.contacts.Contact</key>
		<array>
			<string>com.apple.syncservices.[[RecordEntityName]]</string>
			<string>first name</string>
			<string>last name</string>
			<string>image</string>
		</array>
		<key>com.apple.contacts.IM</key>
		<array>
			<string>com.apple.syncservices.[[RecordEntityName]]</string>
			<string>user</string>
			<string>service</string>
			<string>type</string>
			<string>label</string>
		</array>
	</dict>
	<key>[[SyncsWith]]</key>
	<dict>
		<key>[[SyncAlertTypes]]</key>
		<array>
			<string>app</string>
			<string>device</string>
			<string>server</string>
		</array>
	</dict>
	<key>Type</key>
	<string>app</string>
</dict>
</plist>

</code>

Can someone help me understand why it is failing?

Thanks

Michael


------------------------------------------------------------------

You need to include references to the "[[IMs]]" relationship in com.apple.contacts.Contact and the "contact" inverse relationship in com.apple.contacts.IM:

<code>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/[[DTDs]]/[[PropertyList]]-1.0.dtd">
<plist version="1.0">
<dict>
	<key>[[DisplayName]]</key>
	<string>testd</string>
	<key>Entities</key>
	<dict>
		<key>com.apple.contacts.Contact</key>
		<array>
			<string>com.apple.syncservices.[[RecordEntityName]]</string>
			<string>first name</string>
			<string>last name</string>
			<string>image</string>
			'''<string>[[IMs]]</string>'''
		</array>
		<key>com.apple.contacts.IM</key>
		<array>
			<string>com.apple.syncservices.[[RecordEntityName]]</string>
			<string>user</string>
			<string>service</string>
			<string>type</string>
			<string>label</string>
			'''<string>contact</string>'''
		</array>
	</dict>
	<key>[[SyncsWith]]</key>
	<dict>
		<key>[[SyncAlertTypes]]</key>
		<array>
			<string>app</string>
			<string>device</string>
			<string>server</string>
		</array>
	</dict>
	<key>Type</key>
	<string>app</string>
</dict>
</plist>

</code>

Mike