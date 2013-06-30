Apple added the ability for an General/NSMenuItem to have a General/NSAttributedString for its title (instead of a General/NSString) with 10.3.

I have programmatically created a General/NSMenuItem and passed a very long string to setAttributedTitle.  Although I have told the General/NSAttributedString to use word wrapping, the text is truncated; it runs off the end of the General/NSMenuItem.  Since Apple has deprecated General/NSMenuItemCell, I think I might have to dive into Carbon to find a solution.  I thought I'd check here to see if anyone had any ideas.

Here's my code:

    
General/NSMutableParagraphStyle *style = General/[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
[style setLineBreakMode:General/NSLineBreakByWordWrapping];
[style setAlignment:General/NSLeftTextAlignment];

General/NSMutableAttributedString *attributedTitle = General/[[NSMutableAttributedString alloc] initWithString:reallyLongTitle
												 attributes:General/[NSDictionary dictionaryWithObjectsAndKeys:
												 style,General/NSParagraphStyleAttributeName,nil]];
			
General/NSMenuItem *menuItem = General/[[NSMenuItem alloc] initWithTitle:plainTitle action:NULL keyEquivalent:@""];	
[menuItem setAttributedTitle:attributedTitle];
[theMenu addItem: menuItem];

[menuItem release];
[attributedTitle release];


Thanks,
General/JoeCrow