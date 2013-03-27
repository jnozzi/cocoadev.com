 

 
*
General/REALBasic has a lot of plugins to wrap Cocoa
*
General/CocoaBasic was started to directly use access/use Cocoa (and frameworks) by a BASIC Dialect

e.g.
    
   FUNCTION x(a as String, b as String) AS STRING
     RETURN a+" "+b
   END FUNCTION


translates (virtually as there is no Objective-C layer in between) to
    
   - (General/NSString *) x:(General/NSString *) a :(General/NSString *) b
     {
     return General/a stringByAppendingString:@" "] stringByAppendingString:b];
     }



----

Chipmunk Basic is an old-skool BASIC interpreter, similar to the [[BASICs from 8-bit computers back in the '80s. Fun to mess around with if you can remember that far back.

[http://www.nicholson.com/rhn/basic/]