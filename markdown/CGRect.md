General/CGRect is the General/CoreGraphics equivalent of General/NSRect.

In 64 bit, General/NSRect is typedef'd to be the same as General/CGRect.  This means you can call functions taking General/CGRect with an General/NSRect and vice versa with no explicit conversion and without compiler warnings.  Unfortunately, this isn't the case in 32 bit.  General/NSRect predates General/CGRect, and changing the typedef broke apps that were depending on the value of @encode(General/NSRect) in method signatures.  

The upshot is that you need to convert General/NSRect to General/CGRect and vice versa if you target 32 bit Mac OS X.  

    
General/CGRect cgrect1 = General/NSRectToCGRect(nsrect1);
General/NSRect nsrect2 = General/NSRectFromCGRect(cgrect2);


These conversions are no-ops, they just shut up the compiler.