

b.1992-d.1996. General/NuKernel was the microkernel heart of the new Mac OS (Copland/Maxwell/OS 8): a microkernel-based, multiple-server design.

General/NuKernel was designed to support: pre-emptive multitasking; synchronization primatives, large, sparse address spaces; memory-mapped files; demand-paged VM; protected memory; and an object-based message system. All other services would be provided by servers running above General/NuKernel.

A primary design criterion was very low-latency interrupt overhead for doing audio and video.

Other notable microkernels in and around Apple: the Vanguard microkernel, Pink, the General/WorkPlaceOS microkernel, "Chrysalis", OSF/Mach (used in General/MkLinux), General/NewtonOS kernel, and of course xnu, the modified Mach 3.0 kernel used in OS X.