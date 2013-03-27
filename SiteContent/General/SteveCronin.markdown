    
myLearning= [Anguish [Hillgrass study] study];
myHome = @"Austin, TX";
myHope = [Home/SOHO [Tiger General/[NSApplication]];
myEmail = @"steve_cronin@mac.com";


----

Not exactly Objective-C pseudo-source, is it? :D -- l0ne aka General/EmanueleVulcano

----

Well, it's Aaron Hillegass, not Hillgrass. ;-) At any rate, perhaps this 'code' will work better for you ...

    
General/CocoaBook * book = General/[[CocoaBook bookWithAuthors:@"Anguish", "Hillegass", nil] retain];
[learnedSubjects addSubject:[book study]];
myHome = @"Austin, TX";
myHope = [possibleHopes objectForKeyPath:@"applications.tiger.homeandsoho"];
myEmail = @"steve_cronin@mac.com";


  The only thing I can't figure out is what you intend to do with all of these variables ... Indeed it is wise to add objects to your learnedSubjects container, however, I'm baffled by your compulsion to send multiple     -study messages to your     General/CocoaBook instance. As long as your     Brain is properly initialized, and     book is a valid pointer, you should only need to call     study once per session. Of course,  since     learnedSubjects, unlike most containers, does not automatically retain its subjects, you must make sure you take steps to retain it yourself (see example above) otherwise you may have to send     -study again. At any rate, good luck with your code! - General/JNozzi