I needed a stopwatch to time how long operations take and also for a traffic shaper implementation. Didn't find any public implementations so rolled my own [[ObjC]] class based on this technical Q&A - http://developer.apple.com/qa/qa2004/qa1398.html . I should note that this implementation should have less overhead than using gettimeofday(). The stopwatch provides nanosecond precision and you can get it from http://1nsp1r3d.co.uk/work/cocoa/utilities/stopwatch/ When you want to time some parts of your code, create a stopwatch object and start it.
<code>
[[MDNanoStopWatch]]'' watch = [[[[MDNanoStopWatch]] alloc] init];
[watch start];
// your code
...
[watch stop];
[[NSLog]](@"%qi nanoseconds elapsed", [watch value]);
[watch release];
</code>
The stop method also returns the time elapsed so you can just write
<code>
[[NSLog]](@"%qi nanoseconds elapsed", [watch stop]);
</code>
You can reuse a a single stopwatch object as many times as you want. If you find this class useful/crappy/buggy please leave a comment. Thanks.