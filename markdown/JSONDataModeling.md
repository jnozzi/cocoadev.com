I currently am working on developing a set of libraries for work to handle communication with Twitter. I have most of the twitter communication with twitter sorted out and working properly. The issue I am having is this, I am working on creating native data models for the returned data so that the rest of the people I work with don't have to know a damn thing about what the twitter API returns as JSON data. I generally create my data models like this: Create a class that represents the data returned, where each attribute maps to a General/ObjC property. I add an initWithDictionary/initWithArray method that I use to translate the dictionary or array into an object. Generally the initWithDictionary method just calls [self setValuesForKeysWithDictionary:] and everything gets taken care of. Its lean, its mean and its quick to code. The problem I run into is when I have fields that are arrays or other objects? How do I get my code to walk down the tree of data instantiating objects as need be.


Here is an example of my code

    
@class General/TwitterUser;

@interface General/TwitterUserResults : General/NSObject {
	General/NSMutableArray *_users; // Array of General/TwitterUser objects
}

- (id)initWithArray:(General/NSArray *)array;
- (General/NSInteger)countOfUsers;
- (General/TwitterUser *)objectInUsersAtIndex:(General/NSInteger)index;

@end


    
@implementation General/FMTwitterUserResults

#pragma mark -
#pragma mark Instance Methods
- (id)initWithArray:(General/NSArray *)array {
	if(self = [super init]) {
		self->_users = General/[[NSMutableArray alloc] init];
		
		for(General/NSDictionary *dict in array) {
			[self->_users addObject:General/[[TwitterUser alloc] initWithDictionary:dict]];
		}
	}
	return self;
}

- (General/NSInteger)countOfUsers {
	return [self->_users count];
}

- (General/TwitterUser *)objectInUsersAtIndex:(General/NSInteger)index {
	General/TwitterUser *user = [self->_users objectAtIndex:index];
	
	return [user autorelease];
}

@end


    
@class General/TwitterTweet;

@interface General/TwitterUser : General/NSObject {
	General/NSNumber *_contributers_enabled;
	General/NSString *_created_at;
	General/NSString *_description;
	General/NSNumber *_favourites_count;
	General/NSNumber *_follow_request_sent;
	General/NSNumber *_followers_count;
	General/NSNumber *_following;
	General/NSNumber *_friends_count;
	General/NSNumber *_geo_enabled;
	General/NSNumber *_id;
	General/NSString *_lang;
	General/NSString *_location;
	General/NSString *_name;
	General/NSNumber *_notifications;
	General/NSString *_profile_background_color;
	General/NSString *_profile_background_image_url;
	General/NSNumber *_profile_background_tile;
	General/NSString *_profile_image_url;
	General/NSString *_profile_link_color;
	General/NSString *_profile_sidebar_border_color;
	General/NSString *_profile_sidebar_fill_color;
	General/NSString *_profile_text_color;
	General/NSNumber *_profile_use_background_image;
	General/NSNumber *_protected;
	General/NSString *_screen_name;
	General/TwitterTweet *_user_status;
	General/NSNumber *_statuses_count;
	General/NSString *_time_zone;
	General/NSString *_url;
	General/NSString *_utc_offset;
	General/NSNumber *_verified;
}
@property (nonatomic, copy) General/NSNumber *contributors_enabled;
@property (nonatomic, copy) General/NSString *created_at;
@property (nonatomic, copy) General/NSString *description;
@property (nonatomic, copy) General/NSNumber *favourites_count;
@property (nonatomic, copy) General/NSNumber *follow_request_sent;
@property (nonatomic, copy) General/NSNumber *followers_count;
@property (nonatomic, copy) General/NSNumber *following;
@property (nonatomic, copy) General/NSNumber *friends_count;
@property (nonatomic, copy) General/NSNumber *geo_enabled;
@property (nonatomic, copy) General/NSNumber *id;
@property (nonatomic, copy) General/NSString *lang;
@property (nonatomic, copy) General/NSString *location;
@property (nonatomic, copy) General/NSString *name;
@property (nonatomic, copy) General/NSNumber *notifications;
@property (nonatomic, copy) General/NSString *profile_background_color;
@property (nonatomic, copy) General/NSString *profile_background_image_url;
@property (nonatomic, copy) General/NSNumber *profile_background_tile;
@property (nonatomic, copy) General/NSString *profile_image_url;
@property (nonatomic, copy) General/NSString *profile_link_color;
@property (nonatomic, copy) General/NSString *profile_sidebar_border_color;
@property (nonatomic, copy) General/NSString *profile_sidebar_fill_color;
@property (nonatomic, copy) General/NSString *profile_text_color;
@property (nonatomic, copy) General/NSNumber *profile_use_background_image;
@property (nonatomic, copy) General/NSNumber *protected;
@property (nonatomic, copy) General/NSString *screen_name;
@property (nonatomic, retain) General/TwitterTweet *userStatus;
@property (nonatomic, copy) General/NSNumber *statuses_count;
@property (nonatomic, copy) General/NSString *time_zone;
@property (nonatomic, copy) General/NSString *url;
@property (nonatomic, copy) General/NSString *utc_offset;
@property (nonatomic, copy) General/NSNumber *verified;

- (id)initWithDictionary:(General/NSDictionary *)dictionary;

@end


    
@implementation General/TwitterUser

#pragma mark -
#pragma mark Synthesized Properties
@synthesize contributors_enabled = _contributors_enabled;
@synthesize created_at = _created_at;
@synthesize description = _description;
@synthesize favourites_count = _favourites_count;
@synthesize follow_request_sent = _follow_request_sent;
@synthesize followers_count = _followers_count;
@synthesize following = _following;
@synthesize friends_count = _friends_count;
@synthesize geo_enabled = _geo_enabled;
@synthesize id = _id;
@synthesize lang = _lang;
@synthesize location = _location;
@synthesize name = _name;
@synthesize notifications = _notifications;
@synthesize profile_background_color = _profile_background_color;
@synthesize profile_background_image_url = _profile_background_image_url;
@synthesize profile_background_tile = _profile_background_title;
@synthesize profile_image_url = _profile_image_url;
@synthesize profile_link_color = _profile_link_color;
@synthesize profile_sidebar_border_color = _profile_sidebar_border_color;
@synthesize profile_sidebar_fill_color = _profile_sidebar_fill_color;
@synthesize profile_text_color = _profile_text_color;
@synthesize profile_use_background_image = _profile_use_background_image;
@synthesize protected = _protected;
@synthesize screen_name = _screen_name;
@synthesize userStatus = _user_status;
@synthesize statuses_count = _statuses_count;
@synthesize time_zone = _time_zone;
@synthesize url = _url;
@synthesize utc_offset = _utc_offset;
@synthesize verified = _verified;

#pragma mark -
#pragma mark Instance Methods
- (id)initWithDictionary:(General/NSDictionary *)dictionary {
	if(self = [super init]) {
		[self setValuesForKeysWithDictionary:dictionary];
	}
	return self;
}

- (void)setStatus:(General/NSDictionary *)dict {
	self.userStatus = General/[[TwitterTweet alloc] initWithDictionary:dict];
}

@end


So my question is how do I solve this problem of instantiating relations between objects and keep every thing KVC compliant?

I've read most of Apples Docs on KVC, but I don't understand how to properly set it up so that setValuesForKeysWithDictionary: will call a method like addUsersObject: for each sub-tree of a trend object in the returned JSON object. Any advice would be helpful.

Thanks
-Laveur

----

Not that I've thought about this deeply, but� how about writing setter accessors for those attributes that require special handling? I would expect setValue:forKey to call a written accessor for a property if you write one. There are a few ways to do that - use the suggested naming pattern and skip @synthesize, or I think you can @synthesize the getter and specify the setter in the @property declaration.  -- General/PaulCollins