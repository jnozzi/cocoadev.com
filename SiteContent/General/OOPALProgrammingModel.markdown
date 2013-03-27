OOPAL is a high-level programming model for manipulating objects. It goes beyond the classic "one object at a time" model and provides a way to query and manipulate whole sets of objects at once using the principles and idioms of array programming languages. To do so, it introduces a new messaging abstraction called "message pattern".

OOPAL, which stands for "Object-Oriented Programming and Array Languages integration", is implemented in General/FScript, an open source scripting language for Cocoa.

Example: given an General/NSArray named "strings", containing General/NSString objects, we want to create an array that contains only the strings of length less than 10.

Objective-C:

    
General/NSString *aString;
General/NSMutableArray *result = General/[NSMutableArray array];
General/NSEnumerator *stringEnumerator = [strings objectEnumerator];
while (aString = [stringEnumerator nextObject])
{
  if ([aString length] < 10) 
    [result addObject:aString];  
}
return result;


F-Script using OOPAL:

    
strings where:strings length < 10


OOPAL can be used from the F-Script environment or directly embedded inside Objective-C code (see the paper about embedding below). 

Some papers and discussions about OOPAL:

* OOPAL: Integrating Array Programming in Object-Oriented Programming: http://www.fscript.org/download/OOPAL.pdf
* The F-Script Smalltalk Extensions: http://www.smalltalk.org/articles/article_20040920_a1.html
* Some Basic F-Script Examples: http://www.smalltalk.org/articles/article_20040920_a4.html
* F-Script Guide: http://www.fscript.org/download/General/FScriptGuide.pdf
* Embedding F-Script into Cocoa: http://www.macdevcenter.com/pub/a/mac/2002/07/12/embed_fscript.html (see example 2 on page 2)
* An example of scripting Cocoa with F-Script: http://rentzsch.com/cocoa/anExampleOfScriptingCocoaWithFScript


----

As of OS 10.4 the General/NSPredicate class allows for a similarly concise query.  Here is the updated Objective-C:

    
return [strings filteredArrayUsingPredicate:General/[NSPredicate predicateWithFormat:@"length < 10"]];


Okay, so it's still a bit more wordy than the General/FScript.  If it weren't it wouldnt' be Cocoa.

- Harvey S.