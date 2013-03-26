I need some help on how to share/communicate variable between classes.
Let's say i have 2 classes, Controller1 and Controller2.  
In Controller1, I have methods getUserID, setUserID and a variable [[NSString]]'' _userid in my header file.

When i tried to access the _userid in Controller2 by calling 

<code>Controller1 ''l = [ [ Controller1 alloc ] init ];</code>
<code>[ l getUserID ]</code>

I got nil in return.

I'm guessing that it's because 'l' is a new instance of Controller1 class so that the variable was never set.

----

The variable was ''not'' 'never set'. It is actually set to nil!!
I think this is the default for instance variable of any type. This is better than C, which would just give you anything.

If you want to change that value, set it in the init method.

Another comment: You should not name your method 'getUserID', as this is normally used to feed buffers provided by the caller of the method,

e.g. <code>- ( void ) getManyDoubleValuesInArray: ( double '' ) buffer count: ( int ) sizeOfArray</code>.

You should simply call the method <code>userID</code>.
When I say ''you should not'', I just mean ''if you follow the conventions of Cocoa''.

----

I think there is a misunderstanding here.
the _userid was set by Controller1 class using method <code>setUserID( )</code>.
I created a new instance of Controller1 in my Controller2 class called "l".
The question now is how do I get the _userid from Controller2 class?

----

Where are you calling <code>setUserID</code> for <code>Controller1</code>?
Try putting an <code>[[NSLog]](@"Setting [[UserID]]");</code> there or running the debugger to see if it's actually getting called.

----
In response to the question, I also think there is a misunderstanding here!! Can you make your question clearer?

�Exactly what do you do in your Controller1 class?

�Is <code>_userid</code> an instance variable or a global variable? What do you mean by ''variable [[NSString]]'' _userid in my header file''?

�When do you call <code>setUserID:</code> (or is it <code>setUserID( )</code> ???) ? I don't see any call to setUserID in your snippet

<code>Controller1 ''l = [ [ Controller1 alloc ] init ]; [ l getUserID ];</code>

... except if it is in your <code>init</code> mehod, hence my suggestion to call it in the <code>init</code> method.

----

Maybe you are looking for something like this? It is a contrived example that is a pseudo-singleton-superclass-oddity and it leaks...

<code>
//Controller1.h
#import <Foundation/Foundation.h>

@interface Controller1 : [[NSObject]]
{
    [[NSString]] '' user_id;
}

+(Controller1 '')sharedController;

-(void)setUserID: ([[NSString]] '')aUserID;
-([[NSString]] '')getUserID;

@end

//Controller1.m
#import "Controller1.h"

static id _sharedController = nil;

@implementation Controller1

+(Controller1 '')sharedController;
{
    if (_sharedController == nil) {
        _sharedController = [[Controller1 alloc] init];
    }
    return _sharedController;
}

-(id)init;
{
    self = [super init];
    [self setUserID: @"default"];
    return self;
}

-(void)setUserID: ([[NSString]] '')aUserID;
{
    [user_id release];
    user_id = [aUserID retain];
}

-([[NSString]] '')getUserID;
{
    return user_id;
}

@end

//Controller2.h
#import <Foundation/Foundation.h>

#import "Controller1.h"

@interface Controller2 : Controller1

@end

//Controller2.m
#import "Controller2.h"

@implementation Controller2

-(id)init;
{
    Controller1 ''l = [Controller1 sharedController];
    Controller1 ''k = [[Controller1 alloc] init];
    self = [super init];
    [[NSLog]](@"sharedController's user id is %@", [l getUserID]);
    [l setUserID: @"baz"];
    [[NSLog]](@"sharedController's user id is now %@", [l getUserID]);
    [[NSLog]](@"----------------------------------");
    [[NSLog]](@"controller2's user id is %@", [self getUserID]);
    [self setUserID: @"foo"];
    [[NSLog]](@"controller2's user id is now %@", [self getUserID]);
    [[NSLog]](@"----------------------------------");
    [[NSLog]](@"sharedController's user id is still %@", [l getUserID]);
    [[NSLog]](@"----------------------------------");
    [[NSLog]](@"a brand new controller1's user id is %@", [k getUserID]);
    [k setUserID: @"blarg"];
    [[NSLog]](@"a brand new controller1's user id is now %@", [k getUserID]);
    [[NSLog]](@"----------------------------------");
    [[NSLog]](@"the sharedController's user id is still %@", [l getUserID]);
    return self;
}

@end
</code>

Why does it leak? what would make it not leak?