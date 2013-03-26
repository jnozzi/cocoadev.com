Hi all,

I'd like to respectfully request feedback for a comprehensive higher order message framework for Cocoa, which is nearing completion (ie, passing most unit tests without memory leaks).

The documentation is available at:

http://www.beaversoft.co.uk/~mikeamy/Documentation.tar.gz

In particular I'd like to know if you think you would use any of the features, any improvements or suggestions, any test cases you can think of that might fail.

Cheers for your time if you read it, anyone who gives useful feedback will be credited in the release.

-- [[MikeAmy]]

Oh and Happy Christmas & New Year to you all.

----

Hmm, seems no-one noticed, perhaps my approach was all wrong... oh well, if at first you don't succeed... 

The following is an updated extract from the docs, it tries to sum things up.

All higher order messages are defined for root classes. Most except -all and -forever are capable of returning results.

In the following, "message" refers to some arbitrary message with an arbitrary number of arguments. Where you see "id result =" that means that you don't have to wait for the result (say if it hasn't been computed yet).

 Forwarding
 <code>    [[object forward] message]</code>
 "perform [(encapsulated message) invokeWithTarget:object] (Nothing really special)"
 <code>    [[object reforward] message]</code>
 "perform [object forwardInvocation:(encapsulated message)] (Useful for hiding methods behind a proxy)"

 Using Collections

 Referring to elements
 <code>    [collection elements]</code>
 "each element in collection"

Number elements
 <code>    [[[NSNumber]] ints:1 to:100]</code>
 "[[NSNumbers]] from 1 to 100 representing ints, all other primitive types (chars, shorts, longs, floats, etc) are also available."

 Collection operations
 Note that this is a subset of the possible collection manipulation higher order messages. You can also use collections as iterating arguments. Refer to the documentation for full details.
 <code>    [[[collection elements] all] message]</code>
 "send message to each element in collection"
 <code>    [[[collection elements] collectEach] messageReturningObject] </code>
 "collect each result from sending message to each element in collection in a matching collection"
 <code>    [[[collection elements] selectIf] messageReturningBOOL]</code>
 "select elements from collection if [element messageReturningBOOL] returns YES, in a matching collection"
 <code>    [[[collection elements] rejectIf] messageReturningBOOL]</code>
 "opposite of selectIf"
 <code>    [[[collection elements] detectIf] messageReturningBOOL]</code>
 "return first element that meets criteria"
 <code>    [[[collection elements] detectIfNot] messageReturningBOOL]</code>
 "return first element that doesn't meet criteria"
 <code>    [[[collection elements] combine] combineMessage:initialElement]</code>
 "combine all elements in collection into one object using combineMessage:, whose target and first argument types are the compatible"

 [[MultiProcessing]]
 <code>    id result = [[object inParallel] message]</code>
 "perform [object message] using symmetric multi processing if multiple processors are available, otherwise just perform [object message] normally. Result is available immediately."
 <code>    id result = [[object inNewThread] message]</code>
 "perform [object message] in a new thread."

 Laziness
 <code>    id result = [[object lazily] message]</code>
 "return result but don't bother to perform message until the result actually gets used"
 <code>    id result = [[object eagerly] message]</code>
 "same as lazily, but compute the result anyway if there is no other processing to perform"

 Scheduling
 <code>    id result = [[object scheduleFor:date] message]</code>
 "schedule message delivery for date" 

 Getting invocations
 <code>    [[object getMessage] message]</code>
 "return [object message] as an [[NSInvocation]] instead of performing it"

 Wrapping primitives
 <code>    [[object wrapResult] messageReturningPrimitive]</code>
 "Wrap primitive return values as objects"
 <code>    [[object unwrapArguments] messageWithPrimitive:object]</code>
 "Unwrap object arguments into primitives where necessary"

 Thread safety
 <code>    [object threadSafe]</code>
 "Create a thread-safe access point to object"

 General control
 <code>    [[object repeat:n] message] </code>
 "perform [object message] n times. Result is result of last message"
 <code>    [[object while:condition] message]</code>
 "perform [object message] while condition evaluates to YES"
 <code>    [[object until:condition] message]</code>
 "perform [object message] until condition evaluates to YES"
 <code>    [[object forever] message]</code>
 "perform [object message] forever"

 Debugging, testing & performance
 <code>    [object logMessages]</code>
 "log every message received by object to standard output"
 <code>    [[object mustThrow:exception] message]</code>
 "Ensure that object throws exception when sent message"

 Handling exceptions
 <code>    [[object ignoreExceptions] message]</code>
 "try performing [object message] but ignore any exceptions"
 <code>    [[object logExceptions] message]</code>
 "try performing [object message] but log any exceptions"
 <code>    [[object ignore:exceptionName] message]</code>
 "perform [object message] ignoring specified exception"
 <code>    [[object ignoreFromSet:exceptionNameSet] message]</code>
 "perform [object message] ignoring any of a specified set of exceptions"

 Autorelease pools
 <code>    [[object inNewAutoreleasePool] message]</code>
 "perform [object message] using a new autorelease pool"

 Sorting
 <code>    [[collection sort:direction] message]</code>
 "sort elements of collection using message"

 Repeating at specified interval
 <code>    id result = [[object repeatWithInterval:interval] message]</code>
 "perform [object message] every interval seconds"

 State pattern
 <code>    [object changeClassTo:[[[NewState]] class]]</code> 
 "safely change class of object to [[NewState]]"

 Observation
 <code>    [invocation invokeWhenever:object posts:notification]</code>
 "invoke invocation whenever object posts notification"

 Target action extension
 <code>    [invocation attachTo:object]</code>
 "attach invocation to object using the target action mechanism"

----