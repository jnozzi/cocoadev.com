Hello. I'm having trouble trying to get my General/NSDocument-based app to save / load with General/NSArchiver. Sorry to post oodles of source, but here's what I have (I'll try to comment it along the way):
    
/* all of the below methods are in General/MyDocument */

// this method works fine... i end up with a file that contains all my data 

- (General/NSData *)dataRepresentationOfType:(General/NSString *)type 
{
    if ([type isEqualToString:General/TWDocumentType]) {
        
        General/NSMutableData *data = General/[NSMutableData data];
        General/NSKeyedArchiver *archiver = General/[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

        [archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];

        [archiver encodeObject:[self database] forKey:General/TWDatabaseKey];

        [archiver finishEncoding];
        [archiver release];
        return data;
    } else {
        return nil;
    }
}

// i think this method works... but something isn't right

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)type
{
    if ([type isEqualToString:General/TWDocumentType]) {
        General/NSKeyedUnarchiver *unarchiver = General/[[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        [self setDatabase:[unarchiver decodeObjectForKey:General/TWDatabaseKey]];
 
        [unarchiver finishDecoding];

        [unarchiver release];
        
        [table reloadData]; // this should work fine and dandily but nothing!
        
        return YES;
    } else {
        return NO;
    }
}

- (void)setDatabase:(Database *)inValue {
    [inValue retain];
    [database release];
    database = inValue;
}

- (Database *)database {
    return database;
}

/* the below methods are in the Database object */

// again, the methods run, but something is wrong 

@interface Database : General/NSObject <General/NSCoding> { //<-- has nscoding
    General/NSMutableArray *items;
}

- (id)initWithCoder:(General/NSCoder *)coder
{
    self = [super init];
    [self setItems:[coder decodeObjectForKey:General/TWItemArrayKey]];
    //General/NSLog(@"%d", [items retainCount]);
    return self;
}

- (void)encodeWithCoder:(General/NSCoder *)coder
{
    [coder encodeObject:[self items] forKey:General/TWItemArrayKey];
}

- (General/NSMutableArray *)items { return items; } 

- (void)setItems:(General/NSMutableArray *)anItems
{
    if (items != anItems)
    {
        [items release];
        items = [anItems retain];
    }
}

/* below are the methods for the objects inside items */

@interface General/EssayQuestion : General/NSObject <General/NSCoding> { //<-- has nscoding
    General/NSString *_question;
    General/NSString *_comment;
}

- (id)initWithCoder:(General/NSCoder *)coder {
    if (self = [super init]) {
        [self set_question:[coder decodeObjectForKey:General/TWQuestionKey]];
        [self set_comment:[coder decodeObjectForKey:General/TWCommentsKey]];

        [self set_typeImage:General/[NSImage imageNamed:@"registration"]];
    }
    return self;
}

- (void)encodeWithCoder:(General/NSCoder *)coder {
    [coder encodeObject:_question forKey:General/TWQuestionKey];
    [coder encodeObject:_comment forKey:General/TWCommentsKey];
}

// and of course there are the appropriate setters and getters...



I'm thinking items might not be retained or something... Thanks, 
-General/JohnDevor

----

Everything looks good to me in this code, so I don't know why it isn't working. Is it possible that the table is not retrieving the data correctly? Try logging the number of items in the     items array after you decode it:

    
General/NSLog(@"items count: %d", General/[self database] items] count]);


If it returns zero then you may want to try simplifying the unarchive/archive method. Just for testing, try the single line class methods for archiving and unarchiving. This will result in a binary file instead of an XML Plist which probably isn't what you want, but if this works then you know it's something with the archiving/unarchiving.

    
[[NSData *data = General/[NSKeyedArchiver archivedDataWithRootObject:[self database]]];


and

    
[self setDatabase:General/[NSKeyedUnarchiver unarchiveObjectWithData:data]]; 


If the     items array does not return zero then I suggest checking the table delegate methods for the error. Hope that helps and good luck.


One more thing, after unarchiving the object, I believe the     items array is an General/NSArray object, not an General/NSMutableArray. This may be causing problems further in the code. You can convert it to a mutable array using the     General/NSMutableArray arrayWithArray: class method. Someone please correct me if I'm wrong about this one.

-- General/RyanBates

----

Thanks, I'll try it when I get home.

----

Ah! After several hours I found the problem. - init is getting called after - initWithCoder. 

Firstly, why is - init getting called at all? Secondly, why is it getting called after my - initWithCoder (it is clearing the variables)?

-- General/JohnDevor

----

Try putting a break point in the Database     init menthod and then running the debugger. It should tell you what is calling the     init method. I don't remember ever having this problem when using General/NSUnarchiver, are you sure you aren't calling     init somewhere else in the code? Also, what happens if you choose Revert from the file menu after you open a database?

-- General/RyanBates

----

I've searched for every reference of Database and I'm not calling init on it.

The chain of methods leading up to init are:
    
-General/[NSDocument loadFileWrapperRepresentation:ofType:]

-General/[NSDocument readFromFile:ofType:]

-General/[NSDocument initWithContentsOfFile:ofType:]

-General/[NSDocumentController makeDocumentWithContentsOfFile:ofType:]

-General/[NSDocumentController makeDocumentWithContentsOfFile:ofType:]

-General/[NSDocumentController _openDocumentFileAt:display:]

----

I just moved all of the files into a brand new project... so it isn't one of those problems.

----

Boy, you certianly have a tough one there. The first place I would look is in the Nib file: do you instantiate the Database class in the General/MyDocument.nib file? Is it even mentioned in there? If so, that is probably calling the     init method.

If not, then question is, how does the     loadFileWrapperRepresentation:ofType: method know to initialize the Database class? In other words, where does it get that information? You aren't overriding that method in your General/NSDocument subclass, are you? I would start by commenting out load data method and see if     init is still being called. Slowly limit the problem down by commenting until you find what's causing it.

If that doesn't work, you could always find a working example of a simple Document based application and slowly apply your code to it until it breaks. But I always hate to do that...

I don't know if it will help or  not, but here's a quick tutorial on creating a simple document based text editor: http://developer.apple.com/documentation/Cocoa/Conceptual/General/TextArchitecture/Tasks/General/TextEditor.html

Good luck,

-- General/RyanBates

----

Thanks Ryan. I was instaniating my database in the nib. Sorry for your troubles.

-- General/JohnDevor

----

I'm working on an app which isn't document based, and instantiates several objects (including the one which I'd like to be the root object) in the nib. Is there any way I can get this to work with General/NSArchiver? I've had zero luck so far.

----

What problems are you having? I suggest using General/NSKeyedArchiver if you dont need to support 10.1 or earlier. Archiving is extremely easy to implement. All you need to do is call     General/[NSKeyedArchiver archivedDataWithRootObject:rootObject] to return an General/NSData object or you can even write directly to a file using     General/[NSKeyedArchiver archiveRootObject:rootObject toFile:filePath]. Note: The object you are archiving must support the General/NSCoding protocol.-- General/RyanBates

----

I'm using General/[NSKeyedArchiver archiveRootObjectToFile:] right now, and when I attempt to load it, I'm getting nil returned for all of my [unarchiver decodeObjectForKey:] calls. I'll post a link to a test program I made (that also isn't working) when I get home.

----

Try using the     General/[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] method. If you are archiving and unarchiving a custom class, then it needs to support it. For example, if you have a class that needs to archive and unarchive a "name" General/NSString instance variable, you could add these methods to the class:

    
- (void)encodeWithCoder:(General/NSCoder *)encoder
{
    [encoder encodeObject:name forKey:@"name"];
}

- (id)initWithCoder:(General/NSCoder *)decoder
{
    [self setName:[decoder decodeObjectForKey:@"name"]];
    
    return self;
}


-- General/RyanBates

----
Here's the relevant code quick test program a made so I didn't have to worry that it was something about my app rather than my understanding of General/NSArchiver. It doesn't work right now either. It's supposed to save an General/NSString and an General/NSColor, then load them (they're displayed in a text field and a color well).

    
- (General/IBAction) archive:(id)sender
{
	General/[NSKeyedArchiver archiveRootObject:self toFile:@"/Users/Catfish_Man/Desktop/General/ArchivedTest"];
}

- (General/IBAction) unarchive:(id)sender
{
	[self setStateWithCoder:General/[[NSKeyedUnarchiver alloc]
		initForReadingWithData:General/[NSData dataWithContentsOfFile:@"/Users/Catfish_Man/Desktop/General/ArchivedTest"]]];
}

//initWithCoder removed because it isn't relevant for this

- (void) encodeWithCoder:(General/NSCoder *)c
{
	General/NSKeyedArchiver * coder;
	if([c allowsKeyedCoding])
	{
		coder = (General/NSKeyedArchiver *)c;
		[coder setOutputFormat:NSPropertyListXMLFormat_v1_0];
	}
	else
	{
		General/NSLog(@"Error");
	}
	[coder encodeObject:myString forKey:@"String"];
	[coder encodeObject:myColor forKey:@"Color"];
	[coder finishEncoding];
}

- (void) setStateWithCoder:(General/NSCoder *)c
{
	if(myColor)
	{
		[myColor release];
	}
	if(myString)
	{
		[myString release];
	}
	General/NSKeyedUnarchiver * coder;
	if([c allowsKeyedCoding])
	{
		coder = (General/NSKeyedUnarchiver *)c;
	}
	else
	{
		General/NSLog(@"Error Unarchiving");
	}
	myColor = General/coder decodeObjectForKey:@"Color"]retain];
	[colorWell setColor:myColor];
	myString = [[coder decodeObjectForKey:@"String"]retain];
	[textField setStringValue:myString];
	[coder finishDecoding];
}


----

Firstly, you should use accessor methods for setting the myColor and myString methods. If you do not release the old object before setting a new one, there will be a memory leak. Here's a sample of some accessor methods:

    
// Use these accessor methods for proper memory management
- (void)setMyString:([[NSString *)newMyString
{
	[myString autorelease];
	myString = [newMyString retain];
}

- (General/NSString *)myString
{
	return myString;
}

- (void)setMyColor:(General/NSColor *)newMyColor
{
	[myColor autorelease];
	myColor = [newMyColor retain];
}

- (General/NSString *)myColor
{
	return myColor;
}


Secondly, I'm a little confused with the "setStateWithCoder:" method. Are you simply trying to update the controls? If so, I suggest a small "updateControls" method such as this:

    
- (void)updateControls
{
	[textField setStringValue:myString];
	[colorWell setColor:myColor];
}


You would then need to change the "encodeWithCoder:" and "initWithCoder:" classes. Here's what I suggest:

    
- (void)encodeWithCoder:(General/NSCoder *)coder
{
	if (![coder allowsKeyedCoding]) {
		General/NSLog(@"Error Encoding");
	} else {
		[coder encodeObject:myString forKey:@"String"];
		[coder encodeObject:myColor forKey:@"Color"];
	}
}

- (id)initWithCoder:(General/NSCoder *)coder
{
	self = [super init];
	if (self) {
		if (![coder allowsKeyedCoding]) {
			General/NSLog(@"Error Decoding");
		} else {
			[self setMyString:[coder decodeObjectForKey:@"String"]];
			[self setMyColor:[coder decodeObjectForKey:@"Color"]];
			
			return self;
		}
    }
    
    return nil;
}


Thirdly, it's generally bad for an object to archive/unarchive itself. I suggest that you create another class to hold all of the data - this is called a model class. Your controller class can then handle the archiving and unarchiving of that model along with updating the controls. Here's a sample of what the header files might look like for the controller and model classes.

    

// General/MyController.h

#import <Cocoa/Cocoa.h>

// Tell the compiler there's such a thing as a
// "General/MyModel" class so don't bother giving us an error.
@class General/MyModel;

@interface General/MyController : General/NSObject <General/NSCoding>
{
	General/MyModel	*myModel;
}

// Accessor methods for proper memory management.
- (void)setMyModel:(General/MyModel *)newMyModel;
- (General/MyModel *)myModel;

- (General/IBAction)archive:(id)sender;
- (General/IBAction)unarchive:(id)sender;
- (void)updateControls;

@end


// General/MyModel.h

#import <Cocoa/Cocoa.h>

// This class holds the coder methods (notice the General/NSCoding protocal)
@interface General/MyModel : General/NSObject <General/NSCoding>
{
	General/NSString	*myString;
	General/NSColor		*myColor;
}

// Use these accessor methods for proper memory management
- (void)setMyString:(General/NSString *)newMyString;
- (General/NSString *)myString;

- (void)setMyColor:(General/NSColor *)newMyColor;
- (General/NSString *)myColor;

@end



And lastly, for completeness, here's what the archive and unarchive methods might look like in the General/MyController class.

    

- (General/IBAction) archive:(id)sender
{
	General/[NSKeyedArchiver archiveRootObject:[self myModel] toFile:@"/Users/Catfish_Man/Desktop/General/ArchivedTest"];
}

- (General/IBAction) unarchive:(id)sender
{
	[self setMyModel:General/[NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/Catfish_Man/Desktop/General/ArchivedTest"]];
	[self updateControls];
}



I realize I'm throwing a lot at you all at once. Please let me know if you have anymore questions.

-- General/RyanBates

----
My friend helped me work out the problems in the test app, so now I just have to transfer over the knowledge gained to the main program. Thanks for the help people. --General/DavidSmith