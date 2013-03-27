

We're working on a utility that needs to resize arbitrary windows (i.e. windows not owned by the utility).  We know about the CGS private functions and have dug up General/CGSSetWindowShape, but we're not convinced that's the solution.  Does anybody have any pointers on this subject?

Also, if General/CGSSetWindowShape is the way to go then does anybody know anything about the General/CGSRegionObj type?

Thanks
- General/NateGray

----
You should probably look into the Accessibility General/APIs.

----
Thanks!  That did the trick!