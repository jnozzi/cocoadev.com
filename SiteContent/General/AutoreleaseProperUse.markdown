I've got an array in my class, and a method to resort this array, but this array is non-mutable, so I call <code>sortedArrayUsingFunction:context:</code> and replace the non-sorted array with the new sorted array. However after finally getting it to work after several crashes, I am wondering if the memory management is correct, or proper (by the time this method is called, <code>_viewedTracks</code> should already have a retain count of 1):
<code>_viewedTracks = [[_viewedTracks autorelease] sortedArrayUsingFunction:kSort context:@"title"];
[_viewedTracks retain];</code>
I was previously using this and am still slightly puzzled why it wasn't working (it always crashed) - shouldn't the retain count stay the same??
<code>
_viewedTracks = [[[_viewedTracks copy] sortedArrayUsingFunction:kSort context:@"title"] release];
</code>
Any thoughts?

''The [[NSArray]] sort methods all work on non-mutable arrays, as opposed to the [[NSMutableArray]] <code>sortBy...</code> methods. Therefore, like any other accessor-type method, they return autoreleased instances of a new array (basically calling <code>copy</code> on it's own). <code>_viewedTracks</code> is then set to this new array, so the old array is lost. The <code>autorelease</code> ensures that the old array isn't left "orphaned" in the application's memory. Finally, the last <code>retain</code> ensures that the sorted array is not deallocated. Basically, the first method ends up like this:''
<code>
original _viewedTracks: retainCount of 0
sorted version of _viewedTracks: retainCount of 1
</code>
''whereas your code ends up like this:''
<code>
original _viewedTracks: retainCount of 1
copy of _viewedTracks: retainCount of 1
sorted version of _viewedTracks: retainCount of -1
</code>
''Which, of course, has problems. Good luck! --[[JediKnil]]''