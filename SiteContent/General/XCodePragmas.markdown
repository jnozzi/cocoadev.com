


Some documentation and Apple source examples reveal that [[XCode]] seems to support some helpful pragmas.

The most notable of these is the pragma "mark". This pragma allows developers to suggest a description for groups of methods. This mark pragma most noticably affects the method finder menu at the top of each editor field. For example:

%%BEGINCODESTYLE%%
#pragma mark Drag Helper Methods
%%ENDCODESTYLE%%

Would place a mark in the menu, and subsequent methods will appear beneath it. It also seems that you can place a blank line in the menu (to help grouping) by making your mark just a dash, like so:

%%BEGINCODESTYLE%%
#pragma mark -
%%ENDCODESTYLE%%

Also, [[XCode]] interprets

%%BEGINCODESTYLE%%
#pragma mark - My Cool Group
%%ENDCODESTYLE%%

as

%%BEGINCODESTYLE%%
#pragma mark -

#pragma mark My Cool Group
%%ENDCODESTYLE%%

With these rules and the default indentation scheme, the menu becomes much easier to rapidly scan through. You can see a good example of this in 
file:///Developer/Examples/[[DiscRecording]]/[[ObjectiveC]]/[[EnhancedDataBurn]]/[[AppController]].m

You can also use more than just a dash. You can put any text you want in the pragma and it will show up in the fuction reference pop-up menu.
<code>
#pragma mark Class methods
#pragma mark Public object methods
#pragma mark Private object methods
</code>

If you have large files, this can be very handy.

Does anyone want to list other helpful pragmas if there are any?
-- [[DaveFayram]]

As a side note: #pragma mark is new in PB2, IIRC. [[CodeWarrior]] also had that (or maybe it was MPW) and I really missed it in PB. Proof that Apple ''do'' listen to programmers' requests, so keep filing those bugs! :-) --[[UliKusterer]]

Another side note, Xcode also accepts, e.g.:
<code>
// MARK: Class methods
// MARK: -
</code>
As an alternative to #pragma mark - [[ChristopherLloyd]] , credit goes to [[JensAyton]] for pointing this out
----

%%BEGINCODESTYLE%%
#warning !FIX! only one element and Document Type allowed
%%ENDCODESTYLE%%

Not a #pragma but this creates a compiler warning. It's often more useful than e.g. "fixme" comments because of the increased visibility.

----

There's also

#error blah

which comes in useful inside preprocessor conditionals:

<code>
#if TARGET_RT_MACHO
#include "[[MachoDefinitions]].h"
#else
#error Unsupported runtime - No customized definitions available
#endif
</code>

and there is

<code>
#pragma unused(varname)
</code>

which lets you suppress the "unused variable" warning for dummy parameters.

--[[UliKusterer]]

----

Though the most portable way to supress the "unused variable" warning is to do this:

int foo (int bar)
{
  (void)bar;
  return 0;
}

then you won't get warnings about 'unknown pragmas'.  See this thread more a long discussion:
<http://lists.apple.com/archives/carbon-dev/2005/Dec/msg00475.html>
-- smcbride