If you're looking for a very quick and simple way to add synchronous ICMP ping support to your app, here's how:


* Grab Apple's General/SimplePing sample code from:

http://developer.apple.com/samplecode/General/SimplePing/General/SimplePing.html

* Open General/SimplePing.c and add the following lines to the top of the file, after the includes:

    
#define printf
#define fflush


This stops the code from dumping all those printf messages to the console. Now we need to change the code to return the number of ping packets we successfully received:

* Change the declaration of the General/SimplePing function to the following in the .h and the .c file:

    
int General/SimplePing(const char* General/HostToPing, const int General/NumberOfPacketsToSend, const int General/PingTimeoutInSeconds, const int General/ReturnimmediatelyAfterReply,  int *numberPacketsReceived );


* Delete the local declaration of "int numberPacketsReceived" in the General/SimplePing function. We've added "numberPacketsReceived" as a param so we don't need the local declaration.

* Change the usage of "numberPacketsReceived" in the General/SimplePing function to "*numberPacketsReceived". 



That's it. It's a bit of a hack, but if you're in a hurry it'll do the trick.