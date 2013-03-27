I realise it's undocumented, but anyone know if there's any way to get the current path from a General/CGContext? If I can get that, I can convert it to an General/NSBezierPath, and then it becomes a lot more useful. The reason being that I want to take advantage of     General/CGContextReplacePathWithStrokedPath(...); in my own code, rather than just leaving it in the context where all I can do with it is fill or stroke it. --General/GrahamCox

Yes there is a way - and its undocumentedness is documented here: http://archives.devshed.com/forums/bsd-93/how-to-get-the-stroke-geometry-of-a-nsbezierpath-2171896.html --General/BjoernKriews

----

Thanks, just the ticket :). Basically it's:

    extern General/CGPathRef	General/CGContextCopyPath( General/CGContextRef context );

A worthwhile piece of General/UndocumentedGoodness. --GC.