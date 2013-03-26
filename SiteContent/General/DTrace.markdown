[[DTrace]] is a dynamic tracing facility originating at Sun which ships with Mac OS X Leopard. Given its incredible utility to developers and the fact that there is an [[ObjC]] provider (making it easy to probe [[ObjC]] methods), I thought we should start putting some information on how to use it in debugging, measuring, and exploring your Cocoa programs. I'll start off:

I'm using the following dtrace invocation on the command-line to print the stack trace of any exceptions:

<code>
dtrace -n "pid\$target::objc_exception_throw:entry { ustack() }" -p PID_OF_PROGRAM_UNDER_INSPECTION
</code>

Since I frequently relaunch the app between runs of <code>dtrace</code>, I find it convenient to use a bit of shell magic to grab the pid of the process I want:

<code>
dtrace � -p $(ps axc|grep [[MyApp]]|awk '{print $1}')
</code>

More conveniently, you can put this into a <code>bash</code> function:

<code>
function pid {
	ps axc | grep "$1" | awk '{print $1}'
}
</code>

and use it more succinctly in your <code>dtrace</code> call:

<code>
dtrace � -p $(pid [[MyApp]])
</code>

----

See also http://www.mactech.com/articles/mactech/Vol.23/23.11/[[ExploringLeopardwithDTrace]]/index.html for a very pleasant introduction to dtrace by Greg Miller. -- [[RobRix]]

----

<code>ustack()</code> outputs a stack trace with lines like this:

<code>
Chromosome`-[[[ChromSceneView]]([[ChromSceneViewDrawing]]) drawRect:]+0xb0
</code>

Does anybody know how to get a line number from that (presumably from the <code>0xb0</code> bit)? Would I be better off telling dtrace not to look up the symbolic name for the address in the trace (assuming that's even possible!) and looking it up myself with <code>atos</code>? -- [[RobRix]]

----

Does anybody know how to make dtrace run an app as a non-root user? I'm trying to run soemthing like:
<code>
sudo dtrace -s somecode.d -c /path/to/myApp.app/Contents/[[MacOS]]/myApp
</code>
Except it runs myApp as root, I need to run myApp as another user. Everything I've found online for this seems to be Sun specific. (usermod, etc)