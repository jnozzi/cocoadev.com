

Is there anway in cocoa (Obj-C) to have a [[NSString]] (Bam) and find an occurance of "BAM" in Bam.

sorta like:

<code>
[[NSString]] ''Bam = [[[[NSString]] alloc] init];
Bam = @"abc def ghi";

if (Bam contains @"def") {
     [[NSLog]](@"Bam contains def");
}
</code>

----
Well, if you mean to find a word surrounded by two spaces (or commas, or colons, or whatever), like you have it above, it's simple:

<code>
[[NSString]] ''Bam = [[[NSString]] stringWithString:@"abc def ghi"];
[[NSArray]] ''[[BamPieces]] = [Bam componentsSeparatedByString:@" "]; // The string here being the short string that separates each word, spaces here.

for(int i = 0; i < [[[BamPieces]] length]; ++i) {
	if([[[BamPieces]] objectAtIndex:i] isEqualTo:theWordYouWant]) // Here theWordYouWant is @"def"
		return YES;	
	}
}
return NO;
</code>

Or something like that...

Now, if you want to find (for example) "def" in "abcdefghi", then this obviously doesn't work, and I wasted all my time :-) Does anyone else have a solution for this, besides checking all substrings for equality?
----

Oh wait, duh... I'll answer my own question:

<code>
[[NSString]] ''Bam = [[[NSString]] stringWithString:@"abc def ghi"];

if([[[NSString]] rangeOfString:theStringYouWant] != [[NSMakeRange]]([[NSNotFound]],0)) {	[[NSLog]](@"theWordYouWant is contained in Bam");
}
</code>

Heh... sorry about that, this is much simpler...
----
Or even better...
<code>
[[NSString]] ''bam = @"abc def ghi";

if ([bam rangeOfString:theStringYouWant].location != [[NSNotFound]])
{
	[[NSLog]](@"theWordYouWant is contained in bam");
}
</code>
Use lowercase for variable names (except for statics or exported variables). Why are you calling +[[[NSString]] stringWithString:]? There's no point. Also, you can't call +[[[NSString]] rangeOfString:] because the method doesn't exist.
----
Oh man I'm dumb... looks like I won't be signing this one :-) Thank goodness for anonymity. (and the OSX spell checker, because I wouldn't know how to spell that word otherwise) It's been awhile since I've actually coded anything, as you can tell. Hopefully I'll get back into it when I start my CS classes this semester.
----
Don't feel bad.   These answers really helped me.  I'd found rangeOfString but didn't know a way to easily check for the [[NSNotFound]] (I wanted to do it in one line of code!) since I'm new to Objective-C and [[NSRange]] is one of those weird things that isn't an object, and when learning a new language my brain assumes all the rules have changed and you can't just say blah.location to get at it.