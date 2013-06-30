Anyone know the easiest way to get the local IPv4 address of

the Mac an application is running on as an General/NSString ?

Cheers.

General/ChrisEccles

----

You should keep in mind that there is not necessarily any such thing as "the" local IPv4 address. It's very easy for a Mac to have multiple local addresses; any Mac that's sharing its internet connection or using a VPN will have multiple active non-loopback addresses.

That said, you can get info on the local addresses by using General/NSHost.

----

Also look at General/HowToGetHardwareAndNetworkInfo --General/CharlesParnot

----

General/HowToGetHardwareAndNetworkInfo IS really informative. Thanks Charles !

The multiple local address thing is determined by active location, though, isn't it ? 

Meaning, if you're not internet sharing and your location specifies ONE IP address for your LAN ?      General/ChrisEccles

----

Yes, you will not have more than one local IPv4 address unless you have more than one configured. However, it's pretty easy to have more than one configured, even without using internet sharing. And of course you'll always have the loopback address, and there are IPv6 addresses to worry about. Just keep all of that in mind when writing your code.