Please don't flame.

1.  provides 'Cocoa-ish' semantics basically by fibbing its face off about how Apple event IPC actually works

General/ScriptingBridge provides a model which uses General/AppleEvent IPC.  The issue here seems to be a matter of opinion over whether or not that the semantics for a higher-level interface to General/AppleEvent IPC would use the same semantics as General/AppleEvent IPC itself. - Harv

 - Isn't the whole point actually to *ignore* the lower-level IPC details? -- General/EmanueleVulcano aka millenomi

 - I for one appreciate that I get to remain blithely ignorant of the details of General/AppleEvent IPC.  There could be something I'm missing here though. - Harv.

----
Scripting Bridge doesn't just abstract away the low-level details (which is good), it obfuscates quite a few of the high-level details too (which is not). To do this, it makes assumptions about the way that applications' scripting interfaces work, with the result that it breaks any time an application doesn't conform to those assumptions. A practical example of this which has already come up a few times is using -addObject: with iTunes, e.g. see:

http://lists.apple.com/archives/Applescript-implementors/2007/Nov/msg00047.html
----

I'm guessing the assumption here is that apps use Cocoa Scripting which iTunes doesn't. - Harv.

2. General/NSMutableArray-based element collections are, like cake, a lie. 

The General/AppleEventObjectModel is based on object attributes and one-to-one and one-to-many relationships between objects. To pretend that one-to-many relationships are VBA-style Range objects, they had to fudge a whole lot of details.

No idea where you're going with this. - Harv

 - Cocoa has always modeled one-to-one and one-to-many relationships using sets and arrays. General/SBElementArray provides all the semantics of a General/NSMutableArray, while mapping more or less seamlessly to the General/AppleEvents model. In fact, it's pretty much very similar to General/AppleScript's handling of object lists (rather than "the first document" it's     [documents objectAtIndex:0], rather than "file 'abc'" it's     [documents objectWithID:@"abc"] and so on). -- General/EmanueleVulcano aka millenomi

 - The General/SBElementArray's objectAt(Name/ID/Location): are kind of arbitrary.  I'm not sure how this could have been done differently though.  General/NSDictionary isn't much help.  Having one type of collection keeps the mental model simple.  I like that. - Harv.
 
----
Seamless it isn't.

For example, see if you can tell what the following code will do when run:

    
#!/usr/bin/ruby

# delete folders whose name starts with "untitled folder" from folder "~/test"

require 'osx/cocoa'
include OSX
OSX.require_framework 'General/ScriptingBridge'

f = General/SBApplication.alloc.initWithBundleIdentifier('com.apple.finder')

f.home.folders.objectWithName('test').items.each do |item|
    item.delete if /^untitled folder/ === item.name
end



Incidentally, iterator support is something I considered adding to appscript references, but finally decided to leave it out because of the false and unsafe assumptions that built-in iteration would encourage users to make.

----

There is a key lesson here: in Apple event IPC you are *not* dealing with proxy objects that represent real application objects; you are dealing with *query objects*. There are fundamental differences in how the two behave, and no amount of syntactic or semantic sugar can disguise these differences completely. What the sugar does do, however, is make it extremely difficult for the average user to predict with absolute certainty how any given operation will be carried out, and almost impossible to diagnose the root cause when it does go wrong. The only way to become a General/ScriptingBridge expert is to become an Apple event IPC expert first, and then spend a whole bunch of time and effort black-box reverse engineering the General/ScriptingBridge design and implementation till you've correctly figured out all of the magic it's performing - which completely defeats the purpose of inserting all that magic in the first place. 

(Incidentally, appscript didn't start life in its current, very conservative, incarnation; but over the years all of its attempts to be 'clever' or 'helpful' were found to cause as many problems as they tried to solve and were eventually and unceremoniously stripped out. And that was after studying other earlier bridges in order to avoid repeating some of their even more egregious mistakes in the first place.)

----

----

This seems only tangentially related to the General/SBElementArray complaint.  I agree that General/SBObjects are, in effect, query objects.  The rest though, is a religious issue.  Suffice it to say that General/ScriptingBridge has worked well for me while I find appscript requires too much domain-specific knowledge to use.

----

Is there a technology that *doesn't* require some level of domain-specific knowledge in order to use? Yes, with General/AppleScript, as with most technologies, you can muddle along on minimal knowledge and basic misassumptions up to a point. The question is, what happens once you go past that point? Either you give up in frustration, in which case it's wasted your time, or you go back to the beginning and re-learn everything you thought you knew - hopefully correctly this time. Lack of clarity is a significant problem in General/AppleScript - one that professional programmers have rightly castigated it for over the last 15 years - and it's a significant problem in Scripting Bridge too. General/SBElementArrays fall squarely into the "obfuscated to heck" category; there's nothing religious in pointing this out, along with the deeper implications of this. 

By effectively lying about the way application scripting works, Scripting Bridge reinforces users' misconceptions and encourages a false sense of security. Obviously, it gets away with this up to a point... however, when things suddenly *don't* work as expected -     -addObject:, iterators, etc. - it hangs its users out to dry. Behaviours that make perfect sense when you know you're working with relational queries will drive you insane trying to make sense of them if you've been led to believe you're dealing with proxy objects; for example, try explaining the Ruby puzzler above using only familiar Cocoa terms and concepts.

To paraphrase Theodosius Dobzhansky: nothing in General/AppleScript makes sense except in the light of relational queries. You are, of course, welcome to argue that having something that works for *most* of the time in return for pandering to users' existing assumptions rather than asking them to learn anything new is an acceptable trade-off ("worse is better", etc.). Though FWIW after eight years of using General/AppleScript I've found this to be a false economy myself, with the chronic long-term hassles and confusion not adequately justifying the slightly easier initial entry.

...

As for appscript requiring "too much domain-specific knowledge", here's the thing: 90+% of the domain-specific knowledge you need to become a proficient General/AppleScripter isn't in the client language or the Apple event bridge, it's in the scriptable applications you're targetting. Every application provides a different API, with different features, behaviours, quirks, bugs, good ways of doing things, bad ways of doing things, and, in almost every case, grossly inadequate documentation. Yes this sucks, but it's just something you have to deal with if you want to get things done until (if ever) the problem gets fixed at source (by radically reworking the General/AppleEventObjectModel). And this is not something the bridge can protect you from; all it can do is provide you the means to cope with the existing mess as best as it can, or muddy the waters yet further. (BTW, if you've any specific criticisms of appscript's approach, interface, documentation, etc. please start an General/AppscriptCriticisms page or submit them directly via the bug reporter/email.) 

-- hhas

----

3. clumsy, inferior General/NSPredicate-based substitute for the powerful by-filter ('whose' clause) reference form

examples?

 - Here I have to agree to an extent (General/AppleScript's "update every source whose kind is iPod" stumped me for a while). -- General/EmanueleVulcano aka millenomi

 - What about that stumped you?  How to implement that with General/ScriptingBridge?  If so, could you post the code you ended up with here? - Harv.

----

Ditto on post the code.

----

I don't have the code anymore, but it was along the lines of:

    

iTunesApplication* app = General/[SBApplication ...];
General/NSArray* ipods = General/app sources] filteredArrayUsingPredicate:[[[NSPredicate predicateWithFormat:@"kind == %d", iTunesESRCIPod]];
[app update:ipods];



I do have the previous, working objc-appscript version, which is verbatim as follows:

    
//		// whose kind is iPod
//		iTReference* query = General/iTIts kind] equals:[iTConstant iPod;
//		
//		// every source whose kind is iPod
//		iTReference* iPods = General/iTunes sources] byTest:query];
//		
//		// update every source whose kind is iPod
//		[self sendAndLogError:[iTunes update:iPods;


(with a sendAndLogError utility method that does the -send... and logs the error.) -- General/EmanueleVulcano aka millenomi

@millenomi:  So the SB code didn't work? - Harv.

(I'll discuss this area myself at a later date - it's a bit of an essay in itself.)

----

4. completely crap enumerator support

What's wrong with this?
    
	for(General/MailMailbox * mailbox in General/[[[MailApplication application] mailboxes] get])
	{
		General/NSLog(@"%@", mailbox);
	}


 - Yep, this is just random. -- General/EmanueleVulcano aka millenomi

----

Remember you're in General/AppleScript's world now: 'enumerator' = an General/AEDesc of typeEnumerated, e.g. yes/no/ask in a 'close' command's 'saving' parameter.

In General/AppleScript:

    
close docRef saving no


In Python/Ruby/General/ObjC appscript:

    
docRef.close(saving=k.no)
docRef.close(saving => :no)
General/docRef close] saving: [[[ASConstant no]]


In General/ScriptingBridge:

    
[docRef closeSaving: General/[NSAppleEventDescriptor descriptorWithEnumCode: 'no  '] savingIn: nil]


It's like Apple forgot to finish it or something.

----

5. presence of thread-unsafe state

examples?  Thread-unsafe state is everywhere.  How is this different from the rest of Cocoa? - Harv

----

One of the compromises General/ScriptingBridge made in order to squeeze building, packing and sending an Apple event into a single method call was to move all the per-event attribute settings (send mode, timeout) into the General/SBApplication class, so instead of affecting just a single event, any changes to those will affect all events subsequently sent.

Come to think of it, I believe General/ScriptingBridge caches General/SBApplication instances once created, so this behaviour would also introduce some unpleasant hidden coupling issues that could easily trip up otherwise unrelated code within an application if they both happen to talk to the same application and one of them changes these settings and doesn't change them back.

----

 - In fact, *all of General/AppleScript is basically meant to be used from the main thread*. A little googling reveals that using AS from non-main threads has always been frowned upon at best. General/AppleScript, like General/AppKit, should be considered main-thread-only. -- General/EmanueleVulcano aka millenomi

- Since there's no way to know how long the target app will take to respond it would certainly be nice if General/ScriptingBridge could be used on a background thread.  It'd be unacceptable to hold up UI updates because of some other app I'm dependent on.  It's safe to send General/AppleEvents on a background thread and General/ScriptingBridge is independent of General/AppleScript and General/AppKit.  If there's a known limitation here (which would be typical) I'd like to know what it is. - Harv.

----

General/AppleScript has all sorts of threading issues, it's true. However, the Apple Event Manager itself been thread-safe for some time now (at least in the General/APIs for building and sending events) and using it to send events and receive replies from non-main threads is eminently doable. (There is a known bug with disposing Mach ports in 10.4 and earlier, but Apple provide workaround code for this.) Appscript is thread-safe and supports non-main thread usage; I've not tried General/ScriptingBridge yet though.

----

4. intolerably bad error reporting mechanism

examples?

 - It's using exceptions to report errors. While I would have preferred a someCommand:error: variant on all commands with the now-customary General/NSError**, I see nothing wrong with exceptions per se. -- General/EmanueleVulcano aka millenomi

 - Right, the Cocoa way is to use General/NSError and he're we're getting General/NSExceptions.  It makes sense given that relative to the IPC there's no perf hit from setting up a try block and historically error messages here are unlocalized gibberish anyway.  You can also set the delegate of the application to have errors will be forwarded to this method:  - Harv.
    
- (void)eventDidFail:(const General/AppleEvent *)event withError:(General/NSError *)error


----

General/ObjC exceptions are brutal, particularly if you're not using GC to clean up memory afterwards. This is why Cocoa uses General/NSError** for reporting commonly occurring non-fatal errors, which these are. Given that most application commands can potentially fail, your General/ObjC code will end up riddled with try blocks if you want to handle them with any degree of granularity.

As for the delegate option, it's absolutely useless in principle alone: if an error occurs in part A of your code it's no good delegating the task of error recovery to unrelated part Z. It's not like the General/NSError even includes any sort of recovery options that you could invoke there, which would at least make it useful to a degree. Error recovery for a failed application command needs to be done locally.

In addition, if you do use the delegate option, there's a bug in Scripting Bridge where the failed command returns an invalid object pointer instead of nil, causing your application to crash unless you want to have your delegate method set some sort of global 'commandDidFail' flag that your code can check before trying to use that value. So it's utterly useless in practice too.

Incidentally, objc-appscript follows best Cocoa practice here, providing a -sendWithError: method as well as a convenient shortcut, -send, that can be used when detailed error information isn't needed. Example:

    
    General/NSError *error;
    General/TEGetCommand *getCmd = General/[[textedit documents] at: 100] text] get];
    id result = [getCmd sendWithError: &error];
    if (result) 
        [[NSLog(@"result:\n%@\n\n", result);
    else
        General/NSLog(@"error:\n%@\n\n", error);


Both methods are also guaranteed to return nil whenever an error occurs, so for minimal error checking you just need to test for a nil/non-nil return value - something that General/ScriptingBridge doesn't allow since command methods can return either General/ObjC objects or C primitives, depending on what the application dictionary *claims* is the return value. (Oh, and dictionaries are less than 100% reliable on type declarations, resulting in additional application compatibility issues for bridges that rely on this type information.)

----

5. ugly and error-prone Python syntax

examples?

----

Every property and element name needs to be written as a method call rather than an attribute, otherwise you get 'objc-selector doesn't have attribute' errors. Those extra parentheses are very easy to forget, and look like crap when you remember, e.g.:

    
textedit.documents().objectWithName_('General/ReadMe.txt').text().paragraphs()[0].get()


versus:

    
textedit.documents['General/ReadMe.txt'].text.paragraphs[1].get()


----

 - It wasn't even *made* for Python! And since 90% of it is General/NSMutableArray syntax, it's not General/ScriptingBridge's problem. -- General/EmanueleVulcano aka millenomi

----

Apple are the ones promoting General/ScriptingBridge for Python and Ruby. They had the option of including native Python and Ruby bridges (and Python and Ruby appscript were considered) but chose not to. Thus such criticisms are completely valid.

----

6. lack of support tools

For doing what?

----

With General/AppleScript and Python/Ruby/General/ObjC appscript you get excellent dictionary viewers/exporters. General/ScriptDebugger (for General/AppleScript) and Python/Ruby appscript also provide interactive tools for exploring applications' dictionaries and live object models. With appscript you also get a very handy utility, General/ASTranslate, for converting General/AppleScript commands to Python/Ruby syntax (General/ObjC support is on the TODO list). 

With General/ScriptingBridge you get one not very pretty and somewhat inadequately annotated C header from sdp.

----

To summarise, General/ScriptingBridge should be a best-of-breed solution: Apple have had the last several years and the best engineers to work on it, along with the full General/AppleScript specifications and source code for reference, and plenty of access to test machines and third-party software. In addition, they've had full access to the appscript source code, which is the best third-party bridge since General/UserTalk and easily gives General/AppleScript a run for its money these days, and which has already solved almost every problem facing all Apple event bridges-not-called-General/AppleScript today. Finally, they've got a not insignificant brain trust available to them in the form of the expert end of the General/AppleScript community who would be only too delighted to have their brains picked on the subject.


Apple dropped the ball on General/CocoaScripting and have been slowly trying to patch it up ever since. Understanding the complexities of the General/AppleEventObjectModel (which is over-engineered to the point where it's damnably difficult for application developers to implement 100% reliably), I was sympathetic to their situation even as other General/AppleScripters were raging about the sorry state of Cocoa applications' scriptability.

Apple dropped the ball on General/AppleScriptStudio. Appreciating that they must be developing it on an extremely limited budget where 'just good enough' had to do, I was sympathetic to their situation even as other General/AppleScripters were raging that it wasn't the next General/HyperCard.

However, when they drop the ball on General/ScriptingBridge, if someone like me who has none of their education, experience or resources can write an Apple event bridge to rival General/AppleScript then they have no excuses for not doing so.

-- hhas