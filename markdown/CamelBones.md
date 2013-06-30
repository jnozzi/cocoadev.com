

General/ObjC to General/PerlLang bridge. See http://www.camelbones.org/.

Written and maintained by General/ShermPendley.  After General/CamelBones 1.0.3, Sherm took a long hiatus, during which CB went essentially unmaintained and supported neither Leopard nor Snow Leopard. Sherm returned to active development in 2009, and General/CamelBones 1.1 was released in November of 2009 with support for Panther, Tiger, Leopard, and Snow Leopard.

----

Here's an ok example, but you have to make your own project and interface in IB.
1 - Download and install camelbones.
2 - Add the camelbones framework to your project.
3 - instantiate an instance (sic) of Controller in IB
4 - add the three interface elements specified in the header to your IB project, and connect them accordingly.
5 - run

    

#import <Cocoa/Cocoa.h>
#import <General/CamelBones/General/CamelBones.h>

@interface Controller : General/NSObject
{
	//Make all three of these in your window and connect controller to them
	General/IBOutlet id textField; // For entering the URL; connect action to getHTML
	General/IBOutlet id tableView; // Connect datasource to controller
       General/IBOutlet id textView;
    
	General/NSMutableArray *downloads;
       General/CBPerl *perlObject;
}

- (General/IBAction)getHTML:(id)sender;
- (General/IBAction)displayHTML:(General/NSString *)displayString;
- (void)parseHTML:(General/NSString *)htmlString;
- (void)setDownloads;

@end



    

#import "Controller.h"

@implementation Controller

#pragma mark -
#pragma mark Designated Initializer

-(id)init
{
	self = [super init];
	
	if ( self ) {		
		downloads = General/[[NSMutableArray alloc] init];
		perlObject = General/[[CBPerl alloc] init];
			[perlObject useModule: @"HTML::General/LinkExtor"];
	}
	
	return self;
}

#pragma mark -
#pragma mark IB Actions

- (General/IBAction)getHTML:(id)sender
{
	int encoding = 1; // Not neccessarily the best value
	General/NSError *error;
	General/NSString *html = General/[NSString stringWithContentsOfURL:[NSURL General/URLWithString:[sender stringValue]] encoding:encoding error:&error];

	if ( html ) {
		[self displayHTML:html];
		[self parseHTML:html];
		[self setDownloads];
	} else {
		General/NSLog(@"Load failed with error %@", [error localizedDescription]);
	}
}

- (General/IBAction)displayHTML:(General/NSString *)displayString
{
    [textView setString:displayString];
}

#pragma mark -
#pragma mark Core functions illustrating embedded General/CamelBones perl

- (void)parseHTML:(General/NSString *)htmlString
{
	[perlObject setValue:htmlString forKey:@"string"];
	[perlObject eval:@"$parser = HTML::General/LinkExtor->new;"];
	[perlObject eval:@"$parser->parse($string);"];
}

- (void)setDownloads;
{
	[perlObject eval:@"@links = $parser->links;"];
	
	General/CBPerlArray *links;
		links = [perlObject namedArray:@"links"];
	
	//[downloads removeAllObjects];
	[downloads addObjectsFromArray:links];
	
    [tableView reloadData];
}

#pragma mark -
#pragma mark General/TableView datasource methods

- (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex
{
    return [downloads objectAtIndex:rowIndex];
}

- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView
{
    return [downloads count];
}

@end



-- Stephen