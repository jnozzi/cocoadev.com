


I have things set so a checkbox in my app toggles a preference and writes it to the prefs. I tried setting this checkbox's state at startup according to the prefs file with [[NSUserDefaults]], and it works, except that the checkbox gets turned on even when the preference is set to off. Is there something wrong with my code? Here it is:


<code>
if( [defaults boolForKey: @"transparentEnabled"] == NO ) {
		[transparentCheckbox setState:[[NSOnState]]];
				
	} else if( [defaults boolForKey: @"transparentEnabled"] == YES ) {
		[transparentCheckbox setState:[[NSOffState]]];
	}
</code>

Also, before someone mentions it, switching YES/NO's positions just produces the opposite effect; the checkbox is off no matter what.



Any idea of what's wrong? Thanks!
----
It's much easier to simply bind the check box to [[NSUserDefaults]] in [[InterfaceBuilder]] -- bind the <code>value</code> setting on the check box, to <code>transparentEnabled</code> in [[NSUserDefaults]] (you can use a value transformer to negate it if necessary). However, most likely you never actually set the key <code>@"transparentEnabled"</code>, or you misspell it when setting it, because <code>NO</code> is the default value for <code>boolForKey:</code>. Good luck... --[[JediKnil]]
----

This is probably not your problem, but you should ''never'' directly compare a <code>BOOL</code> with <code>YES</code> or <code>TRUE</code>. A <code>BOOL</code> is actually
 typedef'd as a
<code>signed char</code>, which has 256 possible values. Zero is used to mean "false", and all of the other 255 values mean "true". <code>YES</code> 
is defined as 1, so if you happen to have a <code>BOOL</code> which contains -1 or 42 or any other such number, comparing <code>myBool == YES</code> will be 
false, even though <code>myBool</code> is true.