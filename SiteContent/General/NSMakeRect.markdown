General/NSMakeRect() is a function that is used to create (can ya' guess?) an General/NSRect.

The docs say:

General/NSRect General/NSMakeRect(float x, float y, float w, float h)

The first two arguments are the origin and the second two are the size.

An General/NSRect is an General/NSPoint (origin) and an General/NSSize.

You can get values from an General/NSRect by using:

    
General/NSRect myRect = General/NSMakeRect(10,20,30,40);
myRect.origin.x; // Equals 10
myRect.origin.y; // Equals 20
myRect.size.width; // Equals 30
myRect.size.height; // Equals 40


A quick look at the Functions reference (always remember that...) and the headers will tell you this.

-General/SamGoldman (minor change by General/KritTer)