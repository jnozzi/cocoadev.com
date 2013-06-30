If I want to load "localized" images dynamically during runtime (and they are stored in their respective language.lproj folders), do I have to do anything special, or will General/[[NSBundle mainBundle] pathForResource:@"image1" ofType:@"tiff"] automatically use the Resources folder for the localization of the computer it resides on?

Thanks,
General/MarcWeil

----
Well, never mind. No one seems to have answered, and I found the answer to my question anyway.

General/MarcWeil
----
*What was the answer?*
----
The answer is yes, using pathForResource:ofType: does indeed look in the .lproj folder appropriate for the user's language settings. I ended up finding the answer in "Cocoa Programming".