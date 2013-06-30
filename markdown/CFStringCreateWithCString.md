http://developer.apple.com/documentation/General/CoreFoundation/Reference/General/CFStringRef/Reference/chapter_2.1_section_2.html#//apple_ref/doc/uid/20001211-DontLinkChapterID_1-F11124
 
and add any comments here...

some simple examples http://www.carbondev.com/site/?page=General/CStrings+

*Is this any safer than General/StringWithCString?*

Yep.  The problem with methods like     -General/[NSString stringWithCString:] is that they don't specify encoding.  This function does take an encoding argument.