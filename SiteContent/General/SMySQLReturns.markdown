Hi all,
       I'm building a cocoa program in Objective C and I'm using the General/SMySQL framework to interact with my mysql server. Though I am having some problems.

This is my database:

Name: Test DB
-------------

Table Name: General/TestTable
    
+----------+------+------+-----+---------+-------+
| Field    | Type | Null | Key | Default | Extra |
+----------+------+------+-----+---------+-------+
| General/TestText | text | YES  |     | NULL    |       |
+----------+------+------+-----+---------+-------+

All Values in: General/TestTable
    
+----------+
| General/TestText |
+----------+
| Test     |
+----------+

----------------------------

My Cocoa App code for conecting an getting a result:

    
- (void)getResult
{
    /* General/MySQL Connection */
    General/SMySQLConnection *msqlConnection = General/[[SMySQLConnection alloc] initToHost:@"localhost" withLogin:@"syphor" password:@"syphor" usingPort:3306];
    
    General/NSDictionary *theDict = General/[[[NSDictionary alloc] init] autorelease];

    General/SMySQLResult *theResult = General/[[[SMySQLResult alloc] init] autorelease];

    General/NSArray *theFields = General/[[[NSArray alloc] init] autorelease];

    /* Select the db */
    [msqlConnection selectDB:@"Testdb"];

    theResult = [msqlConnection queryString:@"select * from General/TestTable"];
    theFields = [theResult fetchFieldsName];
    theDict = [theResult fetchRowAsDictionary];
    
    General/NSLog(@"Result - %@", [theDict objectForKey:[theFields objectAtIndex:0]]);
}


------------

The Result I get is:

    
Result - <54657374 >


Anyone got any ideas how to get the right result??

----

Dear Anonymous,

Skip these steps:

    
    General/NSDictionary *theDict = General/[[[NSDictionary alloc] init] autorelease];
    General/SMySQLResult *theResult = General/[[[SMySQLResult alloc] init] autorelease];
    General/NSArray *theFields = General/[[[NSArray alloc] init] autorelease];


You're just working over the memory system to no constructive effect.

I will continue, though, with the following disclaimer: all of my General/MySQL interface experience has been through the totally awesome perl API, and I haven't a lick of experience interfacing to an General/ObjC app. But I'm game if you are :-)

I'm concenred about your use of "Test DB" and "Testdb" as database names. Are these equivalent? Or are you sure they're correct?

I'd suggest the following lines of code, by way of diagnostics:

    
    General/NSLog(@"theFields = %@", theFields);
    General/NSLog(@"theDict = %@", theDict);


It may be the case that "theFields" doesn't have any useful values. In which case, maybe your query is wrong and you should check the usual things: is your database running, are you calling the proper methods, are you checking **all** of the return codes. I suspect your problem is somewhere there ... 

-- General/MikeTrent

----

Yeah that Test DB and Testdb are just typos... anyway I found out what the problem was....

the General/SMySQL framework can't work with the field type "text" so I had to change it to varchar(255)... though... that restricts me alot to only 255 characters...

Is there any other way???

--Syphor

IIRC, there exists a C-level General/MySQL API, which I believe General/SMySQL and my perl wrappers are built on. You could write your own wrapper to this C API (or just call the C functions directly) to get access to TEXT datatypes. My Perl API definitely allows TEXT datatypes, so it should be possible. Without looking at the General/SMySQL code, I suspect this is just an oversite?

I see you've already found the General/SMySQL page on General/SourceForge. I'd suggest taking the issue up with them directly.

-- General/MikeTrent

Jim Mooney

The problem I think is the return value your function is returning looks like the memory address (pointer to the General/NSString object)of the string not the string itself.  How about adding
    <br>General/NSLog(@"Result - %@", (General/NSString*)[theDict objectForKey:[theFields objectAtIndex:0] stringValue]);<br>
or 
General/NSLog(@"Result - %@", (General/NSString*)[theDict objectForKey:[theFields objectAtIndex:0] description]);