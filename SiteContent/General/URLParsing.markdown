



----
'''Overview:'''

----
NSURL only goes so far in providing you access to chunks of a URL. If you need more parsing (like the parameters and query string etc) you can use these methods written by Jerry Krinock. http://goo.gl/[[OeSCu]]


----
'''Related Topics:'''

----
[Topic]


----
'''The Header'''

----
<code>
// NSSTRING METHODS WRITTEN BY JERRY KRINOCK [jerry]-[ieee]-[org]

@interface [[NSString]] ([[URIQuery]])

// [[NSString]] has a method for decoding percent escapes but none for encoding
// So, here they are:
- ([[NSString]]'')encodePercentEscapesPerRFC2396 ;
- ([[NSString]]'')encodePercentEscapesStrictlyPerRFC2396 ;
// Decodes any existing percent escapes which should not be encoded per RFC 2396 sec. 2.4.3
// Encodes any characters which should be encoded per RFC 2396 sec. 2.4.3.
- ([[NSString]]'')encodePercentEscapesPerRFC2396ButNot:([[NSString]]'')butNot butAlso:([[NSString]]'')butAlso ;

// butNot and/or butAlso may be nil
// I did an experiment to find out which ASCII characters are encoded,
// by encoding a string with all the nonalphanumeric characters available on the
// Macintosh keyboard, with and without the shift key down.  There were fourteen:
//       ` # % ^ [ ] { } \ | " < >
// You only see thirteen because the fourtheenth one is the space character, " ".
// This agrees with the lists of "space" "delims" and "unwise" in  by RFC 2396 sec. 2.4.3
// Also, I found that all of the non-ASCII characters available on the Macintosh
// keyboard by using option or shift+option are also encoded.  Some of these have
// two bytes of unicode to encode, for example %C2%A4 for 0xC2A4

/''!
@brief    Returns a string of the form "key0=value0&key1=value1&...".
All keys and values are percent-escape encoded

@details  For compatibility with POST, does not prepend a "?"
All keys and all values must be [[NSString]] objects
@param    The  dictionary of keys and values to be encoded into the string
''/
+ stringWithQueryDictionary:([[NSDictionary]]'')dictionary ;

/'' Not sure how this is different than -stringByReplacingPercentEscapesUsingEncoding:
Performing test in implementation to see if I can use that instead of this.
''/
- ([[NSString]]'')decodeAllPercentEscapes ;

/''!
@brief    Assuming that the receiver is a query string of key=value pairs,
of the form "key0=value0&key1=value1&...", with keys and values percent-escape
encoded per RFC 2396, returns a dictionary of the keys and values.

@details  Supports both ampersand "&" and semicolon ";" to delimit key-value
pairs.  The latter is recommended here:
http://www.w3.org/TR/1998/REC-html40-19980424/appendix/notes.html#h-B.2.2
''/
- ([[NSDictionary]]'')queryDictionaryUsingEncoding:([[NSStringEncoding]])encoding ;

@end

</code>



----
'''The Code'''

----
<code>
#import "[[NSString]]+[[URIQuery]].h"


@implementation [[NSString]] ([[URIQuery]])

- ([[NSString]]'')encodePercentEscapesPerRFC2396 {
   return ([[NSString]]'')[([[NSString]]'')[[CFURLCreateStringByAddingPercentEscapes]](NULL, ([[CFStringRef]])self, NULL, NULL, kCFStringEncodingUTF8) autorelease] ;
}

- ([[NSString]]'')encodePercentEscapesStrictlyPerRFC2396 {

   [[CFStringRef]] decodedString = ([[CFStringRef]])[self decodeAllPercentEscapes] ;
   // The above may return NULL if url contains invalid escape sequences like %E8me, %E8fe, %E800 or %E811,
   // because [[CFURLCreateStringByReplacingPercentEscapes]]() isn't smart enough to ignore them.
   [[CFStringRef]] recodedString = [[CFURLCreateStringByAddingPercentEscapes]](kCFAllocatorDefault, decodedString, NULL, NULL, kCFStringEncodingUTF8);
   // And then, if decodedString is NULL, recodedString will be NULL too.
   // So, we recover from this rare but possible error by returning the original self
   // because it's "better than nothing".
   [[NSString]]'' answer = (recodedString != NULL) ? [([[NSString]]'')recodedString autorelease] : self ;
   // Note that if recodedString is NULL, we don't need to [[CFRelease]]() it.
   // Actually, [[CFRelease]](NULL) causes a crash.  That's kind of stupid, Apple.
   return answer ;
}

- ([[NSString]]'')encodePercentEscapesPerRFC2396ButNot:([[NSString]]'')butNot butAlso:([[NSString]]'')butAlso {
   return ([[NSString]]'')[([[NSString]]'')[[CFURLCreateStringByAddingPercentEscapes]](
                                                                         NULL,
                                                                         ([[CFStringRef]])self,
                                                                         ([[CFStringRef]])butNot,
                                                                         ([[CFStringRef]])butAlso,
                                                                         kCFStringEncodingUTF8
                      ) autorelease] ;
}

+ stringWithQueryDictionary:([[NSDictionary]]'')dictionary {
   [[NSMutableString]]'' string = [[[NSMutableString]] string] ;
   [[NSUInteger]] countdown = [dictionary count] ;
   [[NSString]]'' additionsToRFC2396 = @"+=;" ;
   for ([[NSString]]'' key in dictionary) {
       [string appendFormat:@"%@=%@",
        [key encodePercentEscapesPerRFC2396ButNot:nil
                                          butAlso:additionsToRFC2396],
        [[dictionary valueForKey:key] encodePercentEscapesPerRFC2396ButNot:nil
                                                                   butAlso:additionsToRFC2396]
       ] ;
       countdown-- ;
       if (countdown > 0) {
           [string appendString:@"&"] ;
       }
   }
   return [[[NSString]] stringWithString:string] ;
}



- ([[NSString]]'')decodeAllPercentEscapes {
   // Unfortunately, [[CFURLCreateStringByReplacingPercentEscapes]]() seems to only replace %[NUMBER] escapes
   [[NSString]]'' cfWay = ([[NSString]]'')[([[NSString]]'')[[CFURLCreateStringByReplacingPercentEscapes]](kCFAllocatorDefault, ([[CFStringRef]])self, CFSTR("")) autorelease] ;
   [[NSString]]'' cocoaWay = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
   if (![cfWay isEqualToString:cocoaWay]) {
       [[NSBeep]]() ;
       [[NSLog]](@"[%@ %s]: CF and Cocoa different for %@", [self class], _cmd, self) ;
   }

   return cfWay ;
}

- ([[NSDictionary]]'')queryDictionaryUsingEncoding:([[NSStringEncoding]])encoding {
   [[NSCharacterSet]]'' delimiterSet = [[[NSCharacterSet]] characterSetWithCharactersInString:@"&;"] ;
   [[NSMutableDictionary]]'' pairs = [[[NSMutableDictionary]] dictionary] ;
   [[NSScanner]]'' scanner = [[[[[NSScanner]] alloc] initWithString:self] autorelease] ;
   while (![scanner isAtEnd]) {
       [[NSString]]'' pairString ;
       [scanner scanUpToCharactersFromSet:delimiterSet
                               intoString:&pairString] ;
       [scanner scanCharactersFromSet:delimiterSet intoString:NULL] ;
       [[NSArray]]'' kvPair = [pairString componentsSeparatedByString:@"="] ;
       if ([kvPair count] == 2) {
           [[NSString]]'' key = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding] ;
           [[NSString]]'' value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding] ;
           [pairs setObject:value forKey:key] ;
       }
   }

   return [[[NSDictionary]] dictionaryWithDictionary:pairs] ;
}

@end


</code>