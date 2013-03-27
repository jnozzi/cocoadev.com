Since I am using ATSUI for text rendering I figured I would include the proper includes, but what are these? The best one I have been able to find is General/ATSUnicode.h, but it is in the QD framework under the General/ApplicationServices framework.

So which file should I include when using ATSUI? And if General/ATSUnicode.h, what is the path? (I tried adding General/ApplicationServices framework to my project and used QD/General/ATSUnicode.h, but it did not work).

----

If it's in General/ApplicationServices.framework, just     #import <General/ApplicationServices/General/ApplicationServices.h> should be ok. See [http://developer.apple.com/documentation/Carbon/Reference/ATSUI_Reference/]