I am interested in using [[OCMock]] but there is little documentation and I am unsure of how to begin.  I have been using [[OCUnit]] successfully.  The reason I think I need to use mock objects is that I am designing an object that will function in response to user input.  I want the object (functioning as a controller) I am going to test to present some choice to the user, then respond to the user's choice by manipulating model objects.  I want to be able to tell the object what the user's choices were and then test what it will do based on these choices.  I think I need a [[MockObject]] to substitute for the view object.Can anyone point me to a useful tutorial or at least post a few hints?  ----Martin Fowler has a very good article on Mock Objects here:http://www.martinfowler.com/articles/mocksArentStubs.html Basically, you're right - if you want to test that a controller properly interacts with a view - without actually using the view, than Mock Objects are a good way to go.--[[TimHart]]!
----
Original Poster (or anybody else): Have you had success?  Anybody care to write up a brief HOWTO for [[OCMock]]?  I'm in the same boat.
Or, how about a more concrete question: I'm trying to mock an object that is a delegate for another object, to make sure that the appropriate messages get passed to the delegate.  I have an informal protocol in the object that sends the delegate messages (the protocol is on [[NSObject]]).  I don't have any classes that "implement" this informal protocol - that's for people who use my framework to do.  So how can I create a mock object that responds to the message?  When I try something like:
<code>
  // I've declared an informal protocol in [[MYObject]].h on [[NSObject]], called [[MYInformalProtocol]]
  [[MYObject]] ''mo = [[[[MYObject]] alloc] init];
  [[OCMockObject]] ''delegateMock = [[[OCMockObject]] [[MYInformalProtocol]]];

  [mo setDelegate:delegateMock];
  [[delegateMock expect] myDelegateMessage:mo];

  [mo myMessage];

  [delegateMock verify];
</code>
I get an error: %%BEGINCODESTYLE%%error: -[[[MYTestTarget]] myTestName]: ''''' -[[[NSProxy]] methodSignatureForSelector:] called!%%ENDCODESTYLE%%.  I assume that this is because [[MYObject]] checks whether its delegate responds to myDelegateMessage before sending the message.  Is there a good way to do this?  Do I need to create a formal protocol for classes to use as a delegate??
----
A request for [[OCMock]] (posted here, because I don't see any way to contact the author on [[OCMock]]'s site): allow andReturn: (or some similar method) to return BOOL values.  NO works (by chance, because 0=NO=nil), but YES doesn't work.  Generally, it would be useful to andReturn:YES, and specifically when I'm using delegates.  I cannot mock a delegate object because the code checks whether or not the delegate respondsToSelector:, which needs to return YES, which I can't do in my mock object.  So I can't test code that has delegates with [[OCMock]] (at least not test whether they properly call the delegate).
----
Values such as YES are supported but you have to specify them with OCMOCK_VALUE, eg. %%BEGINCODESTYLE%%[[[myMock expect] andReturn:OCMOCK_VALUE(YES)] foo]%%ENDCODESTYLE%%
----
Actually, that won't ''quite'' work. You cannot pass something other than a variable into %%BEGINCODESTYLE%%OCMOCK_VALUE%%ENDCODESTYLE%%. So the boolean would have to look like this:
<code>
BOOL no = NO;
[[[myMock expect] andReturn:OCMOCK_VALUE(no)] haveYouGotAnyLimburger];
</code>
----
To the above poster, you have to get the mock object as follows: 
<code>
[[OCMockObject]] ''delegateMock = [[[OCMockObject]] mockForClass:[[[NSObject]] class]];
</code>
----
The [[OCMock]] homepage at Mulle Kybernetik now has a how-to and contact details, even a mailing list.