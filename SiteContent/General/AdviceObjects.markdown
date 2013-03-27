General/AdviceObjects - 

We use the term General/AdviceObject to refer to an object that contains advice.  In General/AspectCocoa our advice objects will generally respond to some variation of *before:* or *after:* .  *before:* and *after:* will get called on all General/AdviceObjects that have been assigned to a given General/PointCut and whenever a General/JoinPoint within the scope of that General/PointCut is encountered during the execution of a program.  In general, General/AdviceObjects are applied to General/PointCuts via the creation of Aspects.  The functionality of *before:* and *after:* will vary depending on what purpose the Aspect was created for.  But a most simplistic example is the General/ACLoggingAdvice class.

see General/AdviceObject for specific usage.