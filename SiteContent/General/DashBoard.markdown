The Dashboard zooms on top of your Desktop with a click of a function key and, like Expos�, disappears just as quickly and easily. Use the Dashboard to access nifty new mini-applications called Widgets.

http://www.apple.com/macosx/tiger/dashboard.html

Dashboard widgets are written in DHTML & [[JavaScript]]. http://developer.apple.com/macosx/dashboard.html

----
Anyone know if widget preferences (<code>preferenceForKey()</code>) are compatible with [[NSUserDefaults]]?
''They appear to be stored that way, though I am not sure.'' -- l0ne aka [[EmanueleVulcano]]

Yes, the widget preferences are stored in a domain with "widget-" prepended to the bundle identifier, i.e. "widget-com.apple.widget.stocks".