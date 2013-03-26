

I want to use regular expressions in my code, to test for patterns, I found the [[MoKit]] Framework.

Why does  the following code output 0?

<code>
 [[MORegularExpression]] ''linkURLExp = 
     [[[MORegularExpression]] regularExpressionWithString: @"test" ignoreCase:YES];
 bool boo = [linkURLExp matchesString:@"test"];

 [[NSLog]](@"The value of the bool is %d\n", boo);
</code>

----
I could get this to work in a new Foundation Tool Project:

<code>
#import <Foundation/Foundation.h>
#import <[[MOKit]]/[[MOKit]].h>

// See: http://www.mactech.com/articles/mactech/Vol.19/19.04/[[RegularExpressions]]/index.html

int main (int argc, const char '' argv[]) {
    [[NSAutoreleasePool]] '' pool = [[[[NSAutoreleasePool]] alloc] init];

    [[MORegularExpression]] ''linkURLExp = 
            [[[MORegularExpression]] regularExpressionWithString:@"test" ignoreCase:YES]; 

    if( linkURLExp ) {
	[[NSLog]]( @"linkURLExp is [%@]\n", linkURLExp ); 
	[[NSLog]]( @"expressionString is /%@/\n", [linkURLExp expressionString] ); 
	bool boo = [linkURLExp matchesString:@"test"];
	[[NSLog]]( @"The value of the bool is %d\n", boo ); 
		
    } else {
	[[NSLog]]( @"Our [[MORegularExpression]] is unexpectedly nil\n" ); 
    }

    [pool release];
    return 0;
}
</code>

I don't claim to be able to answer your direct question.
----
I Just tried this and got null...
<code>
[[NSLog]](@"The value is %@\n", [[[MORegularExpression]] regularExpressionWithString:@"test"]);
</code>

Which is starting to shed some light. <code>[[[MORegularExpression]] : regularExpressionWithString]</code> is not returning an object (as you say above). 

This is the first time I have tried to use third party frameworks, so I presume I may have done something wrong.

Here is my full code for the implementation, does anyone have any ideas where i am going wrong?
<code>
#import "[[MyObject]].h"
#import <[[MOKit]]/[[MORegularExpression]].h>

@implementation [[MyObject]]

- ([[IBAction]])scanText:(id)sender
{
    [[NSLog]](@"The value is %@\n", [[[MORegularExpression]] regularExpressionWithString:@"test"]);
}

@end
</code>
I'm presuming this is the cause..
%%BEGINCODESTYLE%% 
"/usr/bin/ld: warning /Developer/S<nowiki/>[[DKs]]/M<nowiki/>acOSX10.4u.sdk/Library/Frameworks/M<nowiki/>[[OKit]].framework/M<nowiki/>[[OKit]] cputype (18, architecture ppc) does not match cputype (7) for specified -arch flag: i386 (file not loaded)"
%%ENDCODESTYLE%% 
This being the first time of using Intel Mac also. Or am I barking up the wrong tree?
----
Did you download the Framework from somewhere? It may have been a PPC only library. You should check-out the the latest sources (on sourceforge, linked from the [[MOKit]] page) and compile your own. The <code>.xcodeproj</code> in CVS appears to produce a universal library.
----
Yes, it was PPC, I had forgotten to think before downloading. However with the new "Platform-Independent" .dmg, when I try to build it I get <code>"File /Users/ben/Desktop/M<nowiki/>OKit_2.8/build/Development/[[RegexTest]] depends on itself.  This target might include its own product."</code>
----
You were probably (correctly) building the "All" target - <code>M<nowiki/>OKit_2 All</code>, the one at the top of the list. If you build only the second target, <code>[[MOkit]]</code>, perhaps you won't get the error message. Are you in fact saying that you are getting an non-functional [[MOKit]] Framework (on Intel)? Or that you are having difficulty linking with, embedding or using it? If the former, you may want to post on the [[MOKit]] site, ''exempli gratia'' https://sourceforge.net/forum/forum.php?thread_id=1504201&forum_id=232403 .
----
I dont think this is a problem with [[MOKit]] (though I thought so at first), I'm just very confused with [[XCode]]. OK so basically what I'm doing is... 


*Downloading Mokit
*Copy Mokit to Library/Frameworks
*Update the xcode Mokit file changing its suffix from .pbproj to .xcodeproj
*In Xcode: Project/Set Active Target/M<nowiki/>[[OKit]]  (rather than Mokit ALL)
*Switch to Deployment
*Press "Build and Go"


and now I get...%%BEGINCODESTYLE%%
"Command /Developer/Private/jam failed with exit code 1"
%%ENDCODESTYLE%%
or if I switch to Development I get <code>"No launchable executable at path    /Library/Frameworks/M<nowiki/>OKit_2.8/build/Development/[[RegexTest]]"</code>

I don't understand where I'm going wrong!
----
In order to do smoothly that which you are trying to accomplish, yes, you almost certainly do need to learn a little more about [[XCode]]. There is probably enough information on this site, but I would recommend that you get one of top rated [[CocoaBooks]].

You might want to check the information on this site concerning [[ApplicationLinkingIssues]].

If there is a recent (universal) compiled version of the [[MOKit]] framework, then you will not need to compile it yourself. Otherwise, you might be better off getting the source out of CVS. I am not sure whether you meant <code>~/Library/Frameworks</code> or <code>/Library/Frameworks</code> - if it was the latter, then you ought to be seeing permissions problems - either way, this is non-ideal. I would suggest that you keep a folder such as <code>~/COCOA</code> or <code>~/PROJECTS</code> for your source code folders and if you wish, copy built Frameworks to one of the 'Library/Frameworks' folders, though if you are simply creating these products to use in your own projects, then you do not need to install them at all: This is using them in way that the FSF speak of 'convenience libraries'. (FWIW, I have installed <code>A<nowiki/>utoDoc.framework</code>, <code>I<nowiki/>mageGear.framework</code>, <code>dotneato.framework</code>, <code>pathplan.framework</code>, <code>C<nowiki/>aminoViewsPaletteFramework.framework</code>, <code>cdt.framework</code> and <code>graph.framework</code>, which are now available to me and my Applications without needing to give attention to linking).

I assume you meant opening the <code>.pbproj</code> package in [[XCode]], rather than renaming it. Even so, note that there is a <code>.xcodeproj</code> package available, and there should be no necessity to do even this.

You are getting an error message from the "Go" part of "Build and Go", because you are creating a library not an executable.

I suggest that you copy the <code>[[MOKit]].Framework</code> to the folder of your current project and follow the steps in [[LinkingLibrariesIntoACocoaApp]] (''inter alios''); and my apologies if this is what you have already done, and you are simply back at the point from which you started.

BTW, given the times that you post, are you based in England?

----
Thankyou for your help, yes I am based in England, I presume you are too? I have been using [[XCode]] for quite a while now, but have never had to delve into mysteries of linking in third party frameworks. I imagined it to be as simple as plonking a folder in another folder, then including the headers in my source code. I originally have a C background and also various web technologies, where the IDE is relatively simple.
I definitely need to brush up on a few topics. 

To answer a couple of your questions:
I was keeping the file in /Library/Frameworks before building, I have now moved to ~/COCOA

"Even so, note that there is a <code>.xcodeproj</code> package available"  where would I find such a file? I only find .pbproj which xcode asks me to convert.
I can only find M<nowiki/>OKit_2.8_Source.dmg platform independent on sourceforge.

Anyhow, I have just removed everything named Mokit and started afresh, and was still getting <code>"Command /Developer/Private/jam failed with exit code 1"</code>. so I Cleaned  All (which finally built, but with a few warnings), added Mokit to my project and now it works fine. PHEW!

Once again thanks for your help.
----
I am assuming that you are now up and running, and no longer need assistance. I am in the West Riding. There is a large Yorkshire Macintosh User Group, but we don't do much programming. There aren't that many Mac Developers in England - I was astonished to find a nest in Grantham (Kesteven) and I have a few other kennings, one in Ashby-de-la-Zouch - in fact the nearest Cocoa developer whose abilities I can testify to is in Odessa.

There really is sufficient information on this to handle linking, frameworks and embedding; perhaps because we have each individually have had to learn how to do it. If thye spirit moves you, you may want to tidy up any of the pages which you feel are too long or too vague. Yes, you copy the framework to your Applications folder, and add it to the [[XCode]] <code>.xcodeproj</code> package; if embedding, you also add that framework to a new Copy build Phase. As with programming in C, you need to link with the library (sometimes written as ''against'' the library, in the case of a dynamic library) as well as inlcude'ing the headers.

You should be able to see the [[XCode]] <code>.xcodeproj</code> package at http://mokit.cvs.sourceforge.net/mokit/[[MOKit]]/ .

Sometimes errors of the form <code>"Command /Developer/Private/jam failed with exit code 1"</code> cannot be cleared up - [[XCode]] appear not to display enough details. In such a case you can sometimes find a way in by copying the command that failled into a terminal prompt, and thereby executing it "locally".