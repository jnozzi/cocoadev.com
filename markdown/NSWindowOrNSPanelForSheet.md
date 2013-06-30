

Does anybody know why General/NSWindows and General/NSPanels animate differently as sheets?  Which is preferred?  Apple seems to not have a set policy.

Personally I can't see an instance where you would logically use an General/NSWindow (not-General/NSPanel) as a sheet, because General/NSWindows are logically modeless.  Any pros/cons to using either method?

----

They appear to animate in the same way to me.

----
The principal difference between General/NSWindow and General/NSPanel, as far as practical aspects go, is that an General/NSWindow can be main, and an General/NSPanel cannot. This supports the idea of using an General/NSPanel for sheets. However, I've never seen any differences between using one or the other in this respect, particularly when animations are concerned. The system does use different animations in different circumstances, depending on the size and style of the windows, perhaps you saw differences there and attributed it to a window/panel difference by mistake?

----
Perhaps.  I thought I had been able to reproduce General/NSPanel as a "sliding" motion and General/NSWindow as an "unfurling" motion.  Perhaps it was just the way I was invoking the sheet.

----

Both window types "unfurl" if their parent windows are narrower than the sheets. The idea is that the sheets have to "squeeze" out of a smaller space, kind of like an octopus or something.