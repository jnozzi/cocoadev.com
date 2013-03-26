Snippet for getting a path url from selection dialog box

<code>

   [[NSOpenPanel]]''	lPanel = [[[NSOpenPanel]] openPanel];
    [lPanel setAllowsMultipleSelection:YES];
    if ([lPanel runModalForDirectory:@"~" file:nil types:nil]==[[NSOKButton]]) {
        int		i;
        for (i=0; i<[[lPanel filenames] count]; i++) {
            [[NSString]]''	lPath = [[lPanel filenames] objectAtIndex:i];
            NSURL''	lUrl = [NSURL  fileURLWithPath:lPath];
            [mPlayList addObject:[lUrl absoluteString]];
        }

 </code>

[[EcumeDesJours]]

----

More OO way:

<code>

[[NSOpenPanel]]'' lPanel = [[[NSOpenPanel]] openPanel];
[lPanel setAllowsMultipleSelection:YES];
if ([lPanel runModalForDirectory:nil file:nil types:nil]==[[NSOKButton]])
{
   [[NSEnumerator]] ''fNamesEnumerator = [[lPanel filenames] objectEnumerator];
   [[NSString]] ''eachPath = nil;

   while (eachPath = [fNamesEnumerator nextObject])
   { 
      NSURL'' lUrl = [NSURL  fileURLWithPath:eachPath];
      [mPlayList addObject:[lUrl absoluteString]];
   }
}

</code>

''Not only is it more OO, but it's probably also more efficient, because it only has to call <code>nextObject</code> with each iteration instead of <code>filenames</code>/<code>count</code> and <code>filenames</code>/<code>objectAtIndex:</code>. The first loop could be improved by storing the array of file names in an ivar. --[[JediKnil]]''

I wouldn't exactly call that an 'improvement' ;) Better would be to store both the array and the count in local variables outside the loop's scope.