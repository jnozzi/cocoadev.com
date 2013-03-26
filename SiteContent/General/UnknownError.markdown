

Can anyone explain to me what this compile error means or what could have caused it?

ld: multiple definitions of symbol .objc_class_name_ClassName

----

It means the same [[ObjC]] class is being defined in two .m files. You can't do that. Perhaps you put @implementation in a header file? -- [[MikeTrent]]

Or loaded the .m file from a header file; use @class in headers wherever possible! -- [[RobRix]]

----

Possibly one more reason. 
If Xcode has more than one reference to some class (h+m file pair), linking will fail but only with "release" build config being active.