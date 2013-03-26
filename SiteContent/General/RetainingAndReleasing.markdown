

[[RetainingAndReleasing]] are the procedures for managing an object's [[RetainCount]]; understanding the way they work is crucial to making sure your application uses proper [[MemoryManagement]]. Several specific examples are outlined in [[RetainReleaseTips]].

In Java you're free to create as many objects as you like and simply drop all references on them when you're done with them.
The [[GarbageCollection]] system will notice and sooner or later come to clean up the data you've left behind.
[[ObjC]] is more strict about [[MemoryManagement]] than Java. This means that you have to take a little more responsibility for your objects.

[[ObjC]] [[MemoryManagement]] does not automatically detect which objects are ready to be thrown away. Instead you have to declare that explicitly.

Every object has a [[RetainCount]] that goes up by one when the object gets a <code>retain</code> message.
It goes down by one when the object gets a <code>release</code> message.
When the [[RetainCount]] reaches 0, the object will call <code>[self dealloc]</code>, thereby releasing the object's memory.

I can tell the system that I need [[AnObject]] by sending it a <code>retain message</code>. If I do, I must send it a <code>release</code> message when I don't need it anymore.

Scenario 1:
When I create [[AnObject]] with the <code>alloc</code> method, I'm implicitly sending that object a <code>retain</code> message. That means it has a [[RetainCount]] of 1.
I am held responsible for sending it a <code>release</code> message when I no longer need the object, and everyone else will assume that I do so.
That's part of the Social Contract of Cocoa. When I do, the [[RetainCount]] will become 0 and sooner or later the [[GarbageCollection]] will come to get the thing.

(The <code>copy</code> message also increments the [[RetainCount]], so it should be considered equivalent to a <code>retain</code> message, at least as it affects the [[RetainCount]])

Scenario 2:
Now suppose you need to use [[AnObject]] that you get from My_Class (e.g. a method of My_Class somehow supplies you with [[AnObject]]
that it creates by the procedure outlined in Scenario 1.

Since you have no prior knowledge of, and more importantly, ''no control over'' the lifetime that [[AnObject]]
has by virtue of its creation in My_Class, you claim control by sending it a <code>retain</code> message, and its [[RetainCount]] becomes 2. 

When you later send [[AnObject]] a <code>release</code> message (because you are done with it and want to let the system know you no longer need it) 
[[AnObject]] will ''not necessarily'' be deallocated! Your <code>release</code> message simply decreases the [[RetainCount]] by 1.
If My_Class was not finished with [[AnObject]], it would still have a [[RetainCount]] of 1 because I would not have sent it my own <code>release</code> message,
and [[AnObject]] will not be deallocated.
Likewise, if I should send MY <code>release</code> message to [[AnObject]] before YOU are done with it, I would still only decrease the <code>retain</code> count by 1.
If you are still using the object, your own retention of [[AnObject]] should suffice to leave it usable to you until you are done with it.

Simply put: An object is ONLY deallocated when it has received equal numbers of <code>retain</code> and <code>release</code> messages, thus zeroing its [[RetainCount]].

Scenario 3:
You can also choose to [[AutoRelease]] an object:

If you create an object within a method, you typically will want to dispose of it within the scope of that method (see bookkeeping remarks below).
However, if you also want to <code>return</code> the object from that method you are faced with what is referred to in topic [[AutoRelease]] as a "conundrum".
If you just <code>release</code> the object before you <code>return</code> from the method, the object pointer that is returned will be garbage.
If you <code>return</code> from the method before you <code>release</code> the object, that <code>release</code> message will never
be sent to the object, and will at best cause you bookkeeping problems if you try to balance it with a <code>release</code> message someplace else,
and will cause [[MemoryLeak]]<nowiki/>s if you don't deal with it at all.

To make it possible to <code>release</code> objects you're <code>return</code>ing, the [[AutoReleasePool]] was introduced.
The technical niceties of [[AutoReleasePool]] are fairly complicated, but from the programmer's perspective, it looks like this:
When you send an object the <code>autorelease</code> message, it is added to the local [[AutoReleasePool]] (technically, the most recently-created
one in the current thread, discussed in more detail under [[AutoReleasePool]]).

At some point (not specified, but currently the next iteration of the [[RunLoop]]) the [[AutoReleasePool]] in which that object is listed will be destroyed and all the objects in it get a <code>release</code> message. 
Other methods thus have time to <code>retain</code> the object if they still need it.

Most methods that <code>return</code> objects use [[AutoRelease]],
so if you get an object back from such a method, you should generally <code>retain</code> it if you want to keep it.

The <code>autorelease</code> message should not be used casually where a <code>release</code> message is more appropriate.

Keep in mind that the [[AutoRelease]] machinery adds some
overhead, and could impose a performance penalty in extreme circumstances (e.g., a tight loop that creates thousands of <code>autorelease</code>d objects.)

Sample code dealing with specific what-ifs can be found in the topic [[RetainReleaseTips]].

The heading External Articles under [[MemoryManagement]] contains links to several good basic
explanations of these principles, several of which are at the [[StepWise]] site.

There you can also read about nasty things called [[RetainCycles]] and hints on how to avoid them.
In [[MultiThreading]] apps [[RetainCycles]] can be a real headache, so if you're that far along, see the topic of
[[WeakReferences]] that Ken Case from [[TheOmniGroup]] came up with.