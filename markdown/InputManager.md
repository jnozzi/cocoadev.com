

Officially, an General/InputManager is a plugin that allows the development of alternate input methods which work in any (Cocoa) application. Unofficially, the General/InputManager mechanism is one of the simplest and most popular ways to load arbitrary external code into other applications. Used in this way, it is similar to General/ApplicationEnhancer, but built in to the system and lacking General/ApplicationEnhancer's sophisticated function patching facilities.

Official Docs:

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSInputManager_Class/

also useful:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/InputManager/

I built a small wrapper General/InputManager that allows you to load bundles for specific applications.  This is basically for abusing the General/InputManager as a code infection vector for making your own modifications to a Cocoa app. The wrapper is called SIMBL.  You can read more and download the source from my website. http://culater.net/software/SIMBL/SIMBL.php -- General/MikeSolomon 

----

I just wanted to reposted a snippet that appeared on the Cocoa-Dev list recently that is applicable to this discussion.  It's a C macro that allows you to detect is a class is being posed for... ie if an General/InputManager or similar injection hack is being used.  Probably not perfect, but a step in the right direction.

    
/* Originally posted by Dan Camper on Cocoa-Dev list on 6/29/05 */

 #import <objc/objc-class.h>

#define  IS_POSED(x)
     ((((struct objc_class*)General/NSClassFromString(x))->info & CLS_POSING) ==
     CLS_POSING ? YES : NO)


--General/OwenAnderson

----

Of course, this is (probably, untested) trivially worked around by adding this code to the hack:

    
General/[HackClass poseAsClass:General/[OtherClass class]];
((struct objc_class *)General/[OtherClass class])->info &= ~CLS_POSING;



----

The General/InputManager (or rather a the existence of a directory into which one is placed) has been implicated in certain types of system security compromises that affect General/MacOSX. This notion may be old hat to most developers who would want to use such a strategy, but I think that as the user community becomes aware of potential risks, the use of the input managers might be, how shall I say? deprecated.

----

If that happened, it would be rather misguided. I do view input managers as a last resort patching mechanishm, but it is no less of a security risk than startup items, launch agents, and similar. I.e. if a malicious program can write to ~/Library/General/InputManagers, then the damage has already happened.

----

This isn't exactly correct. The problem is that some GUI programs with basically root privileges run in user space and load input managers. Hence, they can be used for privilege escalation. I wouldn't say this is the input manager's fault, though.

----
Is there any way to, as a developer, opt-out ones applications from General/InputManagers and APE haxies?
 Pour participer   garder le  numéro, vous aurez  pu   compte   propriétaire  ( Règle) [http://obtenir-rio.info numéro rio]. Vous obtiendrez  pour  aucun coût par  téléphonant   du serveur ou du service à la clientèle  clientèle   votre actuel  fournisseur de services  [http://obtenir-rio.info/rio-bouygues numero rio bouygues] . Vous ne   get un SMS  avec vos . Avec votre  [http://obtenir-rio.info/rio-orange code rio orange], alors vous pouvez   la  offre de  de son   en  rouge.