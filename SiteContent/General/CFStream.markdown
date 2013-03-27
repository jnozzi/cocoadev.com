General/CFStream works with sockets, memory, and files. It is documented at file:///Developer/ADC%20Reference%20Library/documentation/Networking/Conceptual/General/CFNetwork/index.html#//apple_ref/doc/uid/TP30001132

See also General/CFNetwork.

----

Some notes on the functions:

*General/CFReadStreamRead - Use this to read up to a certain number of bytes. Only blocks if no bytes are available, but does not block until all bytes are read.
*General/CFReadStreamGetBuffer - Use this to read all available bytes. Only blocks if no bytes are available, but does not block until all bytes are read.


Really, General/CFReadStreamRead and General/CFReadStreamGetBuffer are pretty much interchangable, except that not all streams support General/CFReadStreamGetBuffer.