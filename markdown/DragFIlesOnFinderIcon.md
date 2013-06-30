

How do I accept/recieve files dropped on my applications program. I mean icon.

----

In your App delegate, implement - (BOOL)application:(General/NSApplication *)sender openFile:(General/NSString *)filename

-- General/DavidRemahl

----

In case anyone else is interested I'll answer my whole question here:

First implement the following method in your App delagate:

 - (BOOL)application:(General/NSApplication *)sender openFile:(General/NSString *)filename

Then goto your target pane and under document types have an entry whose extensions field is "*" and whose type field is "****'". Including the qoutations.

Thanks to everyone who has helped me figure this out, both here and cocoahelp.com!