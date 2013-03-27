** 
Dealing with CSV (Comma Separated Values) and TSV (Tab Separated Values) in Cocoa
**
---- 

After some searching, I've found a few approaches to reading and writing CSV and TSV files in Cocoa but no one place where the approaches can be compared. I'm not sure of what developments General/CoreData brings to this topic but I'll post updates as I learn. August 10, 2005 - General/ChrisMurphy

---- 
** 
Relevant Links to Discussions and Code
**
---- 
Dan Wood's arrayFromTSV General/NSString category approach to importing TSV's into a General/NSMutableArray: http://www.cocoabuilder.com/archive/message/cocoa/2002/6/3/66255

Note this follow up post about line endings: http://www.cocoabuilder.com/archive/message/cocoa/2002/6/4/58962

This gives some insight into how Dan Wood's arrayFromTSV General/NSString category works: General/ReadFileLines

Relevant discussion 'How best to archive in CSV format': http://www.cocoabuilder.com/archive/message/cocoa/2005/5/16/136112

The Rothstein approach: http://www.cocoabuilder.com/archive/message/2005/5/18/136251

Dealing with giant CSV files (includes General/JayFenton's CSV parser that handles Excel "quoted" output): General/CreatingObjectsFromTextData

More on importing Excel CSV files: General/TableFromExcel

(No longer works) Exporting into Excel CSV format: http://cocoa.mamasam.com/MACOSXDEV/2003/01/2/54834.php

Exporting tab delimited data to the pasteboard: http://cocoa.mamasam.com/MACOSXDEV/2003/01/2/54846.php 

Importing CSV files in General/CoreData and typecasting strings: http://forums.macnn.com/showthread.php?t=262004

Possibly outdated and offtopic (now that we have General/CocoaBindings) discussion about dealing with General/NSTableView...CSV and TSV's mentioned: http://www.cocoabuilder.com/archive/message/cocoa/2002/11/18/71445

I have created an General/NSString extension to turn an General/NSString containing CSV data into an array of records: http://mutablelogic.com/cocoa/General/NSString-General/CSVUtils.zip - General/DavidThorpe

There exists a good BSD-licensed utility to parse CSV files from Michael Stapelberg: http://michael.stapelberg.de/cCSVParse.en.php

I recently factored out the CSV parsing code from an app I have and made it available as an embedable framework with source (under MIT License):  http://www.spectralclass.com/downloads/sccsv.dmg

Public-domain code: General/NSString category, to make an General/NSString into General/NSArray, parsing the CSV with an General/NSScanner, and taking into account escape quotes and carriage returns: http://www.macresearch.org/cocoa-scientists-part-xxvi-parsing-csv-data

CSV writer library: http://bitbucket.org/fourplusone/fourcsv/src/

---- 
** 
Applications
**
---- 
General/CSVEdit demonstrates one way of doing it! http://homepage.mac.com/levanj/Cocoa/

---- 
** 
Post Questions and Comments Below
**
---- 
*It seems two most-used ways to do something like this are to use General/NSArray's     componentsJoinedByString: method and using an General/NSMutableString as a buffer (which General/NSArray is probably doing anyway). Are there any easier ways?*

**Maybe write a category? It's pretty straightforward, and not *that* tedious.**
---- 

** 
Another simple class to read CSV files - cCSVParse
**
---- 
Quoted from http://michael.stapelberg.de/cCSVParse :

cCSVParse is a Cocoa-class (Apple�s Objective-C Framework), which parses CSV-files quickly and efficiently. The focus lies on being able to handle all typical features of the non-standardized CSV-format. These include:

Correctly recognizing separators in quoted entries
Quotes in quoted entries
Newlines in entries
Ability to chose any separator and automatically recognizing the used separator in a file
These features are the reason why you can�t just split an General/NSString ;-).

The function which parses the data is written in C and uses C-strings to reach the highest possible speed. The values are returned as General/NSStrings in an General/NSMutableArray for each line.

The whole class (including the headers) is only 218 lines of code big (according to General/SLOCCount) and can therefore be integrated in any project or at least be used as a base for own code.

Using the method -(void)setEncoding:(General/NSStringEncoding)newEncoding you can set the encoding of the file which should be parsed, so you don�t have to convert the data by yourself.