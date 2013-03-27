Cocoa reads and write RTF - but ignores the writing direction. 

For example, you can set writing direction in a General/NSMutableParagraphStyle:

    
[paraStyle setBaseWritingDirection:General/NSWritingDirectionRightToLeft];


Then you can add this paragraph style to a General/NSTextStorage. But it will not save this attribute when you write RTF from it. 

Anybody knows of open source/gnu **good** RTF code?

----

You might check General/GnuStep. -- General/RobRix