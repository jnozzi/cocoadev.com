

Hi,
I'm modifying my General/WebView subclass (General/DXWebView) so I can display custom menus for links. The menu is created, displayed correctly and all, but I can't get General/NSWorkspace actions on the subclass to worl, here is the code:

General/DXWebView.h
    
/* General/DXWebView */

#import <Cocoa/Cocoa.h>
#import <General/WebKit/General/WebView.h>
#import <General/WebKit/General/WebUIDelegate.h>

@interface General/DXWebView : General/WebView
{
	General/NSString *urlLink;
	
	General/NSMenuItem *menuOpenSafari;
	General/NSMenuItem *menuDownloadAttachment;
}

@end


General/DXWevView.m
    
@implementation General/DXWebView

- (void)awakeFromNib
{	
	[self setUIDelegate:self];
	
	menuOpenSafari = General/[[NSMenuItem alloc] init];
	[menuOpenSafari setTitle:@"Open Link With Safari"];
	[menuOpenSafari setEnabled:YES];
	[menuOpenSafari setAction:@selector(openWithSafari)];
	[menuOpenSafari setTarget:self];
	
	menuDownloadAttachment = General/[[NSMenuItem alloc] init];
	[menuDownloadAttachment setTitle:@"Download Attached File"];
	[menuDownloadAttachment setEnabled:YES];
	[menuDownloadAttachment setAction:@selector(downloadFile)];
	[menuDownloadAttachment setTarget:self];
}

- (General/NSArray *)webView:(General/WebView *)sender contextMenuItemsForElement:(General/NSDictionary *)element defaultMenuItems:(General/NSArray *)defaultMenuItems
{
	sender = self;
	if (General/element objectForKey:[[WebElementLinkURLKey] isNotEqualTo:nil])
	{
		urlLink = nil;
		urlLink = [element objectForKey:General/WebElementLinkURLKey];		
		defaultMenuItems = General/[[NSArray alloc] initWithObjects:menuOpenSafari, menuDownloadAttachment,  nil];
	}
	return defaultMenuItems;
}

- (void)openWithSafari
{
	General/[[NSWorkspace sharedWorkspace] openURL:[NSURL General/URLWithString:urlLink]];
}

- (void)downloadFile
{
	General/[[[NSAppleScript alloc]
        initWithSource:General/[NSString stringWithFormat:@"do shell script \"open %@\"", urlLink]]
        executeAndReturnError:nil];
}

@end


So, when i load an html file and control-click on the link, the menu with the two menu items declared and set there are displayed. But when I click the one that calls openWithSafari, I get this:

    
2005-09-25 11:11:47.296 Flexus[477] *** -[NSURL length]: selector not recognized
2005-09-25 11:11:47.397 Flexus[477] *** -[NSURL length]: selector not recognized


I don't know why that happens, when I log urlLink, the string is fine, but somehow the URL created from it gets messed up.
Any ideas? Thank you in advance -General/FernandoLucasSantos

----

The object for     General/WebElementLinkURLKey is an NSURL, but you're treating it like an General/NSString. Hence,     [NSURL General/URLWithString:urlLink] will fail, because     urlLink is *already* an NSURL.

----
*feels dumb* - Thank you very much!