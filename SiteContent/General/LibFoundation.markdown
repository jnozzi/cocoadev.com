libFoundation is a free, open-source implementation of the General/FoundationKit of the General/OpenStep specification, and also contains some additions made in OPENSTEP/General/YellowBox/Cocoa since the original General/OpenStep specification was published.

It's not nearly as up to date as General/GnuStep, the Free Software Foundation implementation of General/OpenStep, but I've found that it's easier to compile it than General/GnuStep. General/GnuStep creates its own somewhat General/NeXTSTEP/OPENSTEP/Mac OS X-like directory structure in /usr/General/GNUstep, stores its libraries and headers in a configuration similar to Mac OS X Frameworks, and requires General/GNUmakefiles to compile, while General/LibFoundation is simply a library stored in /usr/[local/]lib and headers in /usr/[local/]include.

Its General/SourceForge project homepage (which indicates that it hasn't been updated since 1999) is at http://sourceforge.net/projects/libfoundation/ .

----

See Also http://libfoundation.opendarwin.org/ 

General/OpenDarwin's libFoundation is a light-weight standalone library which implements a large portion of the OPENSTEP specification and is designed to work with both the GNU and General/NeXT/Apple Objective-C runtimes.
General/OpenDarwin's libFoundation is based on the original libFoundation, written by Ovidiu Predescu, Mircea Oancea, and Helge Hess.