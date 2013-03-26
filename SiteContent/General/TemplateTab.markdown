
I've created a tabView and am trying to put a custom view inside it. This tab is to serve as the model for tabs created afterwards. So, I tried this:
<code>
[[NSTabViewItem]] ''item = [[[[NSTabView]] selectedTabViewItem] copy];
</code>
It seems that [[NSTabView]] does not conform to [[NSCopying]]. So I then tried.
<code>
[[NSTabViewItem]] ''item = [[[[NSTabViewItem]] alloc] init];
[tabView addTabViewItem:item];
</code>
This didn't copy the view inside the original [[NSTabViewItem]] to the new one. Finally, I tried:
<code>
[tabView addSubview:myView];
[[NSTabViewItem]] ''item = [[[[NSTabViewItem]] alloc] init];
[tabView addTabViewItem:item];
</code>
This crashed the application. So I'm at a loss and hoping someone can enlighten me as to what's wrong. If you do post an answer, also forward it to me by email at hdiwan-at-mac.com as I don't usually check this site. Cheers!
----
The step I was missing was that I need to call [item setView:myView] after creating the tab. All's fine now! -- Hasan