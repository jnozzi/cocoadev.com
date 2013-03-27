I am fairly new to IOS Dev so please bear with me.  I am using X Code 4, and I have tried to upgrade my project to IOS 5, although I think that has little to do with anything.  I am calling an Odata Service that is returning data and I am calling [self.General/TableName reloadData].  The debugger does NOT get into the Cell Creation method...It just pops back out to the main application position and gives me a General/SigKill message or if I click on the arrow to keep debugging, I get the EXC_BAD_ACCESS method.  I know I am probably autoreleasing wrong or incorrectly...I've seen notes on using Zombies, but I don't think I enabled it correctly because it did not connect until I "attached to process" and pointed it at xcode.  It looked like it was doing something, but I didn't see anything that pointed to my bad objects...I have included my code below.  Any help would be greatly appreciated.

thanks

mark


#import "General/CustomTalentSearchController.h"
#import "General/CAEntities.h"
#import "General/TalentDetailController.h"

@implementation General/CustomTalentSearchController

@synthesize talentSearchResults;
@synthesize talentSearchResultsTable;
@synthesize talentTitleTextField, talentAgentTextField, talentAgencyTextField;
@synthesize searchProgressTimer, searchProgressView, searchTalentProgressLabel, searchResultCountLabel;
@synthesize currentProgress;

- (id)initWithNibName:(General/NSString *)nibNameOrNil bundle:(General/NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showSearchProgress
{
    self.searchProgressView.hidden = NO;
    self.searchTalentProgressLabel.hidden = NO;
}

-(void)hideSearchProgress
{
    self.searchProgressView.hidden = YES;
    self.searchTalentProgressLabel.hidden = YES;
}

-(void)initiateSearchProgress
{
    [self.searchProgressView setProgress:0.0];
    [self showSearchProgress];
    self.currentProgress = 0.0;
}

-(void)startTimer
{
    [self.searchProgressTimer invalidate];
    self.searchProgressTimer = General/[NSTimer scheduledTimerWithTimeInterval: 5.0
                                                                target: self
                                                              selector: @selector(handleTimer:)
                                                              userInfo: nil
                                                               repeats: YES];
}

-(void)stopTimerAndProgressView
{
    [self hideSearchProgress];
    
    [self.searchProgressTimer invalidate];
    self.searchProgressTimer = nil;
    
}

-(void)searchTalent:(General/NSDictionary *)args
{
    //---------------------------------
    //Create a proxy to the service...
    //---------------------------------
    General/CAEntities *proxy;
    @try 
    {
        
        proxy = General/[[CAEntities alloc] initWithUri:@"http://SERVERNAMEANDPORT/WCFODATASERVICE.svc/" credential:nil];
        
        
        //[self performSelectorOnMainThread:@selector(initiateSearchProgress) withObject:nil waitUntilDone:NO];
        //[self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
        
        General/DataServiceQuery *qry = [proxy talents];
        
        //BUILDING A FILTER STRING FOR SEARCHING TALENT ON THE SERVER...
        General/NSMutableString* filterString = General/[NSMutableString stringWithString: @"substringof('"];
        
        General/NSString *searchName = [args objectForKey:@"searchName"];
        General/NSString *searchAgent = [args objectForKey:@"searchAgent"];
        General/NSString *searchAgency = [args objectForKey:@"searchAgency"];
        
        if([searchName length] > 0)
        {
            [filterString appendString: searchName];
            [filterString appendString:@"',name)"];
            
        }
        
        if([searchAgent length] > 0)
        {
            if([searchName length] > 0)
            {
                [filterString appendString:@" and substringof('"];
            }
            [filterString appendString: searchAgent];
            [filterString appendString:@"',Agent/name)"];
            
        }
        
        if([searchAgency length] > 0)
        {
            if([searchName length] > 0 || [searchAgent length] > 0)
            {
                [filterString appendString:@" and substringof('"];
            }
            [filterString appendString: searchAgency];
            [filterString appendString:@"',Agency/name)"];
        }
        
        [qry filter:filterString];
        //WHAT "substringof" looks like with multiple filters...
        //[qry filter:@"substringof('mark',name) and substringof('boo',name)"];
        
        [qry orderBy:@"name"];
        
        [qry expand:@"Credits/Show,Credits/Craft,Credits/Show/Genre,Credits/Show/Studio,Strengths/Genre,Agency,Agent"];
        
        General/QueryOperationResponse *result = [qry execute];
        
        self.talentSearchResults = General/result getResult] retain];
        
       //RELOAD THE TABLEVIEW DATA...
        [self.talentSearchResultsTable reloadData];
        self.searchResultCountLabel.text = [[[NSString stringWithFormat:@"%d", [talentSearchResults count]];
                
    }
    @catch(General/DataServiceRequestException *exception)
    {
        [self showErrorMessage:exception];
    }
    @finally {
        //cleanup
        //REMMED OUT THE PROXY RELEASE TO SEE IF THAT WOULD HELP...IT DIDN'T...
        //[proxy release];
        
    }
    
}

//NOT CALLING THIS METHOD CURRENTLY...
-(void)loadSearchResults
{
    
    @try {
        if([talentSearchResults count] > 0)
        {
            //Have to refresh the Data in the Table...
            //self.talentSearchResults = searchResults;
            General/self talentSearchResultsTable] reloadData];
            self.searchResultCountLabel.text = [[[NSString stringWithFormat:@"%d", [talentSearchResults count]];
            
            [self stopTimerAndProgressView];
        }
        else
        {
            //Show Simple Alert to let Viewer know they need to search again...
            General/UIAlertView* alertView = General/[[UIAlertView alloc] initWithTitle:@"Message Center"
                                                                message:@"0 Search Results.  Please refine your search" delegate:self 
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }

    }
    @catch (General/NSException *exception) {
        General/UIAlertView *alertView = General/[[UIAlertView alloc] initWithTitle:@"Error Message Center"
                                                            message:exception.reason delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];    
    }
    @finally 
    {
        //nothing currently...
    }
}

-(void)showErrorMessage:(General/DataServiceRequestException *)exception
{
    General/NSString *errMessage = [exception reason];
    //General/NSLog(errMessage);
    General/UIAlertView* alertView = General/[[UIAlertView alloc] initWithTitle:@"Message Center"
                                                        message:errMessage
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [self stopTimerAndProgressView];
}

-(void)handleTimer:(General/NSTimer*)theTimer
{
    
    if(currentProgress < 1.0)
    {
        currentProgress += .1;
        self.searchProgressView.progress = currentProgress;
    }
    
}

//NOT USING THIS YET...USING THE ENTER KEY FOR SEARCHING CURRENTLY>>>>
-(General/IBAction)searchButtonClicked
{
    General/NSString *searchName = talentTitleTextField.text;
    General/NSString *searchAgent = talentAgentTextField.text;
    General/NSString *searchAgency = talentAgencyTextField.text;
    
    General/NSDictionary *args = General/[NSDictionary dictionaryWithObjectsAndKeys:
                          searchName, @"searchName",
                          searchAgent, @"searchAgent",
                          searchAgency, @"searchAgency",
                          nil];
    
    [self performSelectorInBackground:@selector(searchTalent:) withObject:args];
    //[self searchTalent];
    
}

//USING THIS METHOD TO SEARCH TALENT WHEN THE USER CLICKS THE ENTER KEY>>>>
- (BOOL)textField:(General/UITextField *)textField shouldChangeCharactersInRange: (General/NSRange)range replacementString: (General/NSString *)string     
{
    
    if ([string isEqualToString:@"\n"]) 
    {
        General/NSString *searchName = talentTitleTextField.text;
        General/NSString *searchAgent = talentAgentTextField.text;
        General/NSString *searchAgency = talentAgencyTextField.text;
        
        General/NSDictionary *args = General/[NSDictionary dictionaryWithObjectsAndKeys:
                              searchName , @"searchName",
                              searchAgent, @"searchAgent",
                              searchAgency, @"searchAgency",
                              nil];
        [self initiateSearchProgress];
        [self startTimer];
        //[self performSelectorInBackground:@selector(searchTalent:) withObject:args];
        [self searchTalent:args];
        
    }
    
    return YES;
    
}

- (void)dealloc
{
    [talentSearchResultsTable release], talentSearchResultsTable = nil;
    [talentSearchResults release], talentSearchResults = nil;
    [talentTitleTextField release], talentTitleTextField = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(General/UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
#pragma mark - Table view data source

- (General/NSInteger)numberOfSectionsInTableView:(General/UITableView *)tableView
{
    return 1;
}

- (General/NSInteger)tableView:(General/UITableView *)tableView numberOfRowsInSection:(General/NSInteger)section
{
    // Return the number of rows in the section.
    return [self.talentSearchResults count];
}

- (General/UITableViewCell *)tableView:(General/UITableView *)tableView cellForRowAtIndexPath:(General/NSIndexPath *)indexPath
{
    static General/NSString *General/CellIdentifier = @"Cell";
    
    General/UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:General/CellIdentifier];
    if (cell == nil) {
        cell = General/[[[UITableViewCell alloc] initWithStyle:General/UITableViewCellStyleDefault reuseIdentifier:General/CellIdentifier]autorelease];
    }
    
    // Configure the cell...
    
    CAModel_Talent *talent = [self.talentSearchResults objectAtIndex:indexPath.row];
    
    General/NSMutableString *talentRowText = General/[NSMutableString stringWithString:talent.m_name];
    
    if(talent.m_Agent !=nil)
    {
        [talentRowText appendString:@", Agent:  "];
        CAModel_Agent *agent = (CAModel_Agent*)[talent.m_Agent objectAtIndex:0];
        
        [talentRowText appendString:agent.m_name];
    }
    
    if(talent.m_Agency != nil)
    {
        [talentRowText appendString:@", Agency:  "];
        CAModel_Agency *agency = (CAModel_Agency*)[talent.m_Agency objectAtIndex:0];
        [talentRowText appendString:agency.m_name];
    }
    
    cell.textLabel.text = talentRowText;
    
    cell.accessoryType = General/UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

#pragma mark - Table view delegate

//NOT GETTING THIS FAR YET...CODE BLOWS UP WHEN TRYING TO RENDER THE TABLEVIEW>>>>
- (void)tableView:(General/UITableView *)tableView didSelectRowAtIndexPath:(General/NSIndexPath *)indexPath
{
    General/TalentDetailController *talentDetailController = General/[[TalentDetailController alloc] initWithNibName:@"General/TalentDetailController" bundle:nil];
    
    talentDetailController.talentDetail = [self.talentSearchResults objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:talentDetailController animated:YES];
    
    [talentDetailController release];
    
}

@end

----

This is not a maiing list. It's meant to be a library of helpful pages a la Wikipedia. Please read the rules and don't pollute the wiki.