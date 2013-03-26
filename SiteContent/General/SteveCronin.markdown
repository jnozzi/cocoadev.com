<code>
myLearning= [Anguish [Hillgrass study] study];
myHome = @"Austin, TX";
myHope = [Home/SOHO [Tiger [[[NSApplication]]]];
myEmail = @"steve_cronin@mac.com";
</code>

----

Not exactly Objective-C pseudo-source, is it? :D -- l0ne aka [[EmanueleVulcano]]

----

Well, it's Aaron Hillegass, not Hillgrass. ;-) At any rate, perhaps this 'code' will work better for you ...

<code>
[[CocoaBook]] '' book = [[[[CocoaBook]] bookWithAuthors:@"Anguish", "Hillegass", nil] retain];
[learnedSubjects addSubject:[book study]];
myHome = @"Austin, TX";
myHope = [possibleHopes objectForKeyPath:@"applications.tiger.homeandsoho"];
myEmail = @"steve_cronin@mac.com";
</code>

  The only thing I can't figure out is what you intend to do with all of these variables ... Indeed it is wise to add objects to your learnedSubjects container, however, I'm baffled by your compulsion to send multiple <code>-study</code> messages to your <code>[[CocoaBook]]</code> instance. As long as your <code>Brain</code> is properly initialized, and <code>book</code> is a valid pointer, you should only need to call <code>study</code> once per session. Of course,  since <code>learnedSubjects</code>, unlike most containers, does not automatically retain its subjects, you must make sure you take steps to retain it yourself (see example above) otherwise you may have to send <code>-study</code> again. At any rate, good luck with your code! - [[JNozzi]]