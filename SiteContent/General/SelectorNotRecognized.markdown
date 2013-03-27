How do I work out why a selector is not being recognized?

from the General/OmniGroup mailing list:

> Can anyone tell me on what object I'm not implementing setStringValue?
>
> 2001-12-17 21:10:38.000 General/ISBattleTerminal[1473] *** -General/[NSCFType 
> setStringValue:]: selector not recognized

Put a breakpoint on -General/[NSObject doesNotRecognizeSelector:] and you'll 
find out.

Larry Campbell           
     Wed Dec 19 19:38:00 2001