Feel free to add more stuff that should/could be done here.


== Things that should to be done ==

Every page should to be checked and (<nowiki>''</nowiki>)'s in the page source need to be replaced with (*)'s where appropriate. (usually in code blocks)

The importer inserted internal links in <nowiki><code></nowiki> blocks these should to be removed because it screws up the code.
<code>
 ''For example:''
 [[NSString]] *aString = [[[NSString]] stringWithString:@"Test"];
 ''Is invalid code and needs to be changed to:''
 NSString *aString = [NSString stringWithString:@"Test"];
</code>
 
All pages should be checked and <nowiki><code></nowiki> tags should be added where they are missing.

All external links should be checked to see if they are broken up with internal links:
<code>
 ''Change:''
 https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/[[MemoryMgmt]]/Articles/[[MemoryMgmt]].html
 ''to:''
 https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html
</code>

Also consider updating the pages to use correct mediawiki headers, etc.


Suggested procedure for these changes is to go to [[Special:AllPages]] pick a section and work your way through it.


----
Templates such as [[Template:Languages]] are broken because the following extension is not installed: http://www.mediawiki.org/wiki/Extension:ParserFunctions

Perhaps this extension should be installed? (If this is indeed the case.)


== Things that could be done ==
Improve the <nowiki><syntaxhighlight></nowiki> plugin CSS and replace all <nowiki><code></nowiki> blocks with it. (Currently the font kinda sucks, imo.)


== Things that might make sense ==
Possibly move all the conversations on a page into its talk page?