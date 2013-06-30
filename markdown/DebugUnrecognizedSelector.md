

Is there any convenient way to debug an error with a selector not recognized via breaking, in the debugger, when such an error occurs or, in a more general sense, is there any facility we can use to make an application decipher its call stack with its debugging symbols to print out a stack trace at any arbitrary point in the code?

--General/JeffDisher

----

Didn't totally understand the second bit, but is the info at General/StackTraces what you're after?  For the first, you should break on -General/[NSException raise].  See General/DebuggingTechniques.  

- Ken Ferry

----

Thanks, that looks like exactly what I needed.  At work I have been getting used to the conveniences in Java's Throwable for printing stack traces and I have been craving something similar for my own work.

--General/JeffDisher