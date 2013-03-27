General/DocBook is a SGML and XML-format for documents. Many programming books are written in General/DocBook (for example General/BookCocoaProgMacOSX and General/BookCoreMacOSXandUnix). The SGML-version is being phased-out (I believe) in favour of the XML-version.

Being XML, General/DocBook can be transformed into any other XML-format, for example XHTML (and HTML), XSL-FO or text. XSL-FO, in turn can be converted to PDF (even though that does not work very well with current non-commercial tools).

General/DocBook is a modern alternative to General/LaTeX.

More information: http://www.docbook.org

Constructing the toolchains for docbook can be very painful, but once you have the tools in place, it's pretty easy to create HTML, PDF, and other versions of the document.  The SGML tools are more mature and produce better output (especially PDF).  The XML tools are the ones being maintained, but the free ones aren't up to the quality of the SGML ones.  The for-pay XML tools I understand generate pretty good output.

As an aside, has anyone ever done anything with General/DocBook and Adobe inDesign?

----

I played with it only briefly when searching for a format for writing documentation, but I found that the visual output looked sort of amateurish -- but I only tried the free tools for PDF output.

--General/AllanOdgaard

----

General/DocBook XML to XSL-FO is a dream with Saxon ( http://saxon.sourceforge.net ) but the XSL-FO to PDF conversion with FOP (http://xml.apache.org/fop/) is a nightmare. FOP is the only non-commercial XSL-FO renderer that I'm aware of, and it sucks bigtime.

I've tried openjade for General/DocBook SGML to PDF, but since the documentation is non-existant I never got it to work.

General/DocBook is a good idea, but because of the lack of a free PDF-renderer it's close to useless. 

--General/TheoHultberg/Iconara

----

I haven't actually tried it, but theoretically shouldn't you be able to export to HTML and then use Print to save it as a PDF...?

--General/JediKnil

*The point of rendering to PDF is that you get things like page breaks and actual control over the layout, line lengths and so on. Rendering as HTML throws all that out the door, and you can't really automate "Save as PDF" anyway. --Theo* 

----

General/OpenJade is a wonderful tool. It transforms General/DocBook into General/TeX and then into PDF. You can customize its behavior by writing a stylsheet, which is a snippet of Scheme (Lisp-like) code. It's open-source and gives outstanding results. We took the generated PDF directly from General/OpenJade, put it on a CD, sent it to a printer, and they sent us back the General/BookCoreMacOSXandUnix book. General/DocBook is far from useless. General/OpenJade was designed for SGML General/DocBook files, but XML *is* SGML, so it works just fine with General/DocBook XML files, too. But I agree, stay away from FOP.

*If we go the way around General/TeX, I think that using Saxon to transform the General/DocBook XML to General/TeX-source is easier, but you may have found the documentation to General/OpenJade? I'd love to hear more about it. --Theo*

----

I'm using General/DocBook to generate documentation for Hog Bay Notebook. It's a pain to setup, but once working it does OK. I like it because the PDF files that it generates have tables of contents that show up in Preview's browser drawer. What are the other options do people use to generate "User Guide" style PDF documents. (ie title pages, tables of contents, figures... not just General/TextEdit and print to PDF). What's the best tool for authoring PDF on the Mac?

Jesse