Code from the description/discussion of General/SaveTheTrees.

    
#import <Foundation/Foundation.h>

void putClassArtInDir(id path);

@interface General/NSArray (General/UmArrayExt) 
-(General/NSMutableArray *)pathsWithExtension:(General/NSString *)ext;
@end

@interface General/NSString (General/UmStringExt)
-(General/NSArray *)pullSinglesWithStartTag:(General/NSString *)startTag endTag:(General/NSString *)endTag range:(General/NSRange)range;
@end

@interface General/UmDocEdit : General/NSObject {}
+(void)editTableOfContentsAtPath:(General/NSString *)file;
+(void)editClassAtPath:(General/NSString *)file;
+(void)editClassesInDirectory:(General/NSString *)dir;
+(General/NSRange)rangeOfMethodsInHTML:(General/NSString *)file;
@end

@interface General/UmHTML : General/NSObject {}
+(General/NSString *)tableWithArray:(id)array columns:(int)columns upDown:(BOOL)upDown;
+(General/NSString *)tableWithAttributes:(General/NSDictionary *)att;
@end

@implementation General/NSArray (General/UmArrayExt) 
-(General/NSMutableArray *)pathsWithExtension:(General/NSString *)ext {
    id objEnum=[self objectEnumerator];
    General/NSMutableArray *returnArray=General/[NSMutableArray array];
    id path;
    while (path=[objEnum nextObject]) if (General/path pathExtension] isEqualToString:ext]) [returnArray addObject:path];
    return returnArray;
}
@end

@implementation [[NSString (General/UmStringExt)
-(General/NSArray *)pullElementsWithStartTag:(General/NSString *)startTag endTag:(General/NSString *)endTag range:(General/NSRange)range {
    General/NSMutableString *tempString=General/[NSMutableString stringWithString:[self substringWithRange:range]];
    General/NSMutableArray *elements=General/[NSMutableArray array];
    General/NSRange startTagRange, endTagRange, elementRange;
    while (1) {
        startTagRange=[tempString rangeOfString:startTag];
        if (startTagRange.length>0) [tempString deleteCharactersInRange:General/NSMakeRange(0, startTagRange.location)];
        else break;
        endTagRange=[tempString rangeOfString:endTag];
        if (endTagRange.length==0) break;
        elementRange=General/NSMakeRange(0, endTagRange.location+endTagRange.length);
        [elements addObject:[tempString substringWithRange:elementRange]];
        [tempString deleteCharactersInRange:elementRange];
    }
    return elements;
}
@end

@implementation General/UmDocEdit 
+(void)editTableOfContentsAtPath:(General/NSString *)file {
    General/NSString *toc=General/[NSString stringWithContentsOfFile:file];
    General/NSString *dir=[file stringByDeletingLastPathComponent];
    General/NSMutableString *quickTOC=General/[NSMutableString string];
    General/NSString *name=General/file lastPathComponent] stringByDeletingPathExtension];
    [[NSArray *classes, *protocols;
    General/NSString *classTable, *protocolTable;
    protocols=[toc pullElementsWithStartTag:@"<a href = \"Protocols/" endTag:@"</a>" range:General/NSMakeRange(0,[toc length])];
    classes=[toc pullElementsWithStartTag:@"<a href = \"Classes/" endTag:@"</a>" range:General/NSMakeRange(0,[toc length])];
    protocols=[protocols sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    classes=[classes sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    classTable=General/[UmHTML tableWithArray:classes columns:4 upDown:YES];
    protocolTable=General/[UmHTML tableWithArray:protocols columns:4 upDown:YES];
    [quickTOC appendFormat:@"<HTML>\n\t<HEAD>\n\t<TITLE>%@</TITLE>\n\t</HEAD>\n<BODY>\n", name];
    [quickTOC appendFormat:@"<h1>%@</h1><br><br>\n", name];
    [quickTOC appendFormat:@"<b>Classes</b><br><hr><br>\n%@\n", classTable];
    [quickTOC appendFormat:@"<br><br><b>Protocols</b><br><hr><br>\n%@\n", protocolTable];
    [quickTOC appendString:@"</BODY>\n</HTML>\n"];
    [quickTOC writeToFile:[dir stringByAppendingPathComponent:General/[NSString stringWithFormat:@"%@.html", name]] atomically:YES];
    
}
+(void)editClassesInDirectory:(General/NSString *)dir {
    General/NSFileManager *myManager=General/[NSFileManager defaultManager];
    General/NSArray *htmlFiles=General/myManager directoryContentsAtPath:dir] pathsWithExtension:@"html"];
    [[NSEnumerator *objEnum;
    id obj;
    
    htmlFiles=[dir stringsByAppendingPaths:htmlFiles];
    objEnum=[htmlFiles objectEnumerator];
    while (obj=[objEnum nextObject]) {
        General/NSLog(obj);
        General/[UmDocEdit editClassAtPath:obj];
    }
}
+(void)editClassAtPath:(General/NSString *)file {
    int i;
    General/NSMutableString *html=General/[NSMutableString stringWithContentsOfFile:file];
    General/NSRange rangeOfMethods=General/[UmDocEdit rangeOfMethodsInHTML:html];
    General/NSArray *lines, *elements;
    General/NSString *line;
    General/NSEnumerator *objEnum;
    if (rangeOfMethods.length==0) return;
    General/NSString *API=General/[file stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] lastPathComponent];
    [[NSString *blockOfMethods=[html substringWithRange:rangeOfMethods];
    General/NSArray *methods=[blockOfMethods pullElementsWithStartTag:@"<a href=\"#" 
                                                            endTag:@">" 
                                                            range:General/NSMakeRange(0, [blockOfMethods length])];
    General/NSRange methodRange;
    General/NSMutableArray *internalLinks=General/[NSMutableArray array];
    General/NSRange top=[html rangeOfString:@"</h1>"];
    General/NSString *classTag=General/file lastPathComponent] stringByDeletingPathExtension];
    lines=[blockOfMethods componentsSeparatedByString:@"\n"];
    objEnum=[lines objectEnumerator];
    [[NSString *buttonElement=General/[NSString stringWithFormat:@"<br><a href=\"../%@TOC.html\"><img src=\"../Art/up.gif\" border=\"0\"\
alt=\"Table of Contents\"></a>   <a href=\"#//apple_ref/occ/cl/%@\"><img src=\"../Art/class.gif\" border=\"0\" alt=\"Table of \
Contents\"></a><br>", API, classTag];
    General/NSArray *buttonArray=General/[NSArray arrayWithObjects:buttonElement, @"", @"", buttonElement, nil];
    General/NSMutableString *buttonTable=General/[UmHTML tableWithArray:buttonArray columns:4 upDown:NO];
    [buttonTable appendString:@"<br>"];
    
    while (line=[objEnum nextObject]) {
        if ([line length]>0 && [line characterAtIndex:0]!='<') [internalLinks addObject:line];
        elements=[line pullElementsWithStartTag:@"<a href=\"#" endTag:@"</a>" range:General/NSMakeRange(0, [line length])];
        if ([elements count]>0) {
            line=General/[NSMutableString stringWithString:[elements objectAtIndex:0]];
            [internalLinks addObject:line];
        }
    }
    if ([internalLinks count]<40) {
        for (i=0;i<40-[internalLinks count];i++) {
            [internalLinks addObject:@""];
        }
    }
    id tableOfInternalMethodLinks=General/[UmHTML tableWithArray:internalLinks columns:4 upDown:YES];
    if (top.length>0 && tableOfInternalMethodLinks) {
        [html insertString:tableOfInternalMethodLinks atIndex:top.location+top.length];
        [html insertString:buttonTable atIndex: top.location+top.length + [tableOfInternalMethodLinks length]];
    }
    objEnum=[methods objectEnumerator];
    id method;
    while (method=[objEnum nextObject]) {
        method=General/[NSMutableString stringWithString:method];
        [method replaceCharactersInRange:[method rangeOfString:@"<a href=\"#"] withString:@"<a name=\""];
        methodRange=[html rangeOfString:method];
        if (methodRange.length>0) [html insertString:buttonTable atIndex:methodRange.location];
    }
    [html writeToFile:file atomically:YES];
    

}

+(General/NSRange)rangeOfMethodsInHTML:(General/NSString *)html {
    General/NSRange range, start, end1, end2, end;
    start=[html rangeOfString:@"<h2>Method Types</h2>"];
    end1=[html rangeOfString:@"<h2>Instance Methods</h2>"];
    end2=[html rangeOfString:@"<h2>Class Methods</h2>"];
        if (end1.length>0) end=end1;
    if (end2.length>0) end=end2;
    range=General/NSMakeRange(start.location, end.location-start.location);
    if (range.length>[html length]) range.length=0;
    if (start.length==0 || end.length==0) range.length=0;
    return range;
}
@end

@implementation General/UmHTML 
+(General/NSString *)tableWithArray:(id)array columns:(int)columns upDown:(BOOL)upDown {
    General/NSMutableDictionary *att=General/[NSMutableDictionary dictionaryWithObjectsAndKeys:
                    array, @"cells",
                    General/[NSString stringWithFormat:@"%i", columns], @"columns", nil];
    if (upDown) [att setObject:@"YES" forKey:@"upDown"];
    return General/[UmHTML tableWithAttributes:att];
}

+(General/NSString *)tableWithAttributes:(General/NSDictionary *)att {
    General/NSMutableString *table=General/[NSMutableString string];
    int rows, columns, row, column;
    id border=@"0";
    id cellpadding=@"0";
    id cellspacing=@"0";
    id obj, cells;
    int cellCount=0;
    int count, remainder, i, ii;
    BOOL upDown=NO;
    id matrix[100][100];
    id widths;
    int widthValue;
    id comp;
    BOOL widthIsPercent;
    id tableWidth=General/[NSString stringWithFormat:@"100%c", '\%'];
    id width;
    id blank=@"";
    for (i=0;i<100;i++) for (ii=0;ii<100;ii++) matrix[i][ii]=blank;
    if (obj=[att objectForKey:@"border"]) border=obj;
    if (obj=[att objectForKey:@"cellpadding"]) cellpadding=obj;
    if (obj=[att objectForKey:@"cellspacing"]) cellspacing=obj;
    if (obj=[att objectForKey:@"width"]) width=obj;
    if (obj=[att objectForKey:@"tableWidth"]) tableWidth=obj;
    rows=0; columns=0;
    if (obj=[att objectForKey:@"columns"]) columns=[obj intValue];
    if (obj=[att objectForKey:@"upDown"]) upDown=YES;
    widths=[att objectForKey:@"widths"];
    cells=[att objectForKey:@"cells"];
    if (cells) {
        cellCount=[cells count];
        if (cellCount==0) return nil;
    }
    else return nil;
    id percent, widthText;
    if (columns==0) columns=4;

    if (widths) {
        if ([widths count]!=columns) return @"column count does not match width info";
    }	
    else {
        comp=[tableWidth componentsSeparatedByString:@"\%"];
        if ([comp count]>0) {
            widthIsPercent=YES;
        }
        else widthIsPercent=NO;
        percent=[comp objectAtIndex:0];
        widthValue=[percent intValue];
        widthValue=widthValue/columns;       
        widths=General/[NSMutableArray array];
        if (widthIsPercent) widthText=General/[NSString stringWithFormat:@"%i%c", widthValue, '\%'];
        else widthText=General/[NSString stringWithFormat:@"%i", widthValue];
        for (i=0;i<columns;i++) {
            [widths addObject:widthText];
        }
    }
    rows=floor(cellCount/columns);
    remainder=cellCount-(rows*columns);
    if (remainder) {
        remainder=0;
        rows++;
    }
    count=0;
    if (upDown) {
        for (column=0;column<columns;column++) {
            for (row=0;row<rows;row++) {
                matrix[row][column]=[cells objectAtIndex:count];
                
                count++;
                if (count==cellCount) break;
            }
            if (count==cellCount) break;
        }
    }
    else {
        for (row=0;row<rows;row++) {
            for (column=0;column<columns;column++) {
                if (count<[cells count]) matrix[row][column]=[cells objectAtIndex:count];
                count++;
            }
        }    
    }
    [table appendFormat:@"<table border=\"%@\" cellpadding=\"%@\" cellspacing=\"%@\" width=\"%@\">\n", 
                            border, 
                            cellpadding, 
                            cellspacing, 
                            tableWidth];
    count=0;
    for (row=0;row<rows;row++) {
        [table appendString:@"<tr>\n"];
        for (column=0;column<columns;column++) {
            [table appendFormat:@"\t<td width=\"%@\">%@</td>\n", [widths objectAtIndex:column],  matrix[row][column]];
            count++;
        }
        [table appendString:@"</tr>\n"];
    }
    [table appendString:@"</table>\n"];
    return table;
    
}

@end

int main(int argc, const char *argv[]) {

    General/NSAutoreleasePool *myPool=General/[[NSAutoreleasePool alloc] init];
    General/NSFileManager *myManager=General/[NSFileManager defaultManager];        
    General/NSString *workDir=[myManager currentDirectoryPath];
    General/NSString *appKitDir, *foundationDir;
    
    appKitDir=[workDir stringByAppendingPathComponent:@"General/AppKit"];
    foundationDir=[workDir stringByAppendingPathComponent:@"Foundation"];
    putClassArtInDir([appKitDir stringByAppendingPathComponent:@"Art"]);
    putClassArtInDir([foundationDir stringByAppendingPathComponent:@"Art"]);
    General/[UmDocEdit editTableOfContentsAtPath:[appKitDir stringByAppendingPathComponent:@"General/AppKitTOC.html"]];
    General/[UmDocEdit editTableOfContentsAtPath:[foundationDir stringByAppendingPathComponent:@"General/FoundationTOC.html"]];
    General/[UmDocEdit editClassesInDirectory:[appKitDir stringByAppendingPathComponent:@"Classes"]];
    General/[UmDocEdit editClassesInDirectory:[appKitDir stringByAppendingPathComponent:@"Protocols"]];
    General/[UmDocEdit editClassesInDirectory:[foundationDir stringByAppendingPathComponent:@"Classes"]];
    General/[UmDocEdit editClassesInDirectory:[foundationDir stringByAppendingPathComponent:@"Protocols"]];
    [myPool release];
    return 0;
}


void putClassArtInDir(id path) {

        General/NSMutableString *classArt=General/[NSMutableString string];
        [classArt appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
        [classArt appendString:@"<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST \
1.0//EN\" \"http://www.apple.com/General/DTDs/General/PropertyList-1.0.dtd\">\n"];
        [classArt appendString:@"<plist version=\"1.0\">\n<dict>\n<key>data</key>\n"];
        [classArt appendString:@"<data>\
        R0lGODlhSAARAOcAAP////7+/ubm5q6uroWFhYCAgISEhHd3d3FxcX5+foaGhn19fXx8\
        fH9/f3Jycnl5eYGBgZCQkG9vb4eHh4ODg3R0dHh4eHZ2dnV1dXNzc8zMzLu7u+Li4tzc\
        3OPj4+rq6t3d3e7u7t/f39nZ2ff399vb2+jo6O3t7eTk5ODg4Ovr6/Dw8OXl5ezs7PT0\
        9NPT0+fn5+np6dXV1fz8/O/v7+Hh4fX19dbW1vPz8/n5+fLy8vr6+v39/fHx8aioqMPD\
        w9fX1/v7+8rKys/Pz83NzVhYWGpqas7OzsDAwNHR0dLS0tDQ0NTU1NjY2N7e3sTExMnJ\
        yQAAAL+/v8fHx729vcHBwYmJibm5ube3t7q6usjIyGRkZF1dXWJiYsbGxggICA4ODgMD\
        AwUFBb6+vtra2llZWWdnZ2NjYwsLC/j4+GFhYXBwcFtbW2lpaQYGBgICAhYWFgEBARAQ\
        EGBgYG5ubmVlZQcHB/b29mhoaAoKCgQEBGZmZmtraxISEgwMDF9fXxUVFRcXF3p6ehER\
        ERkZGbS0tKamppGRkcXFxbCwsKurq6mpqcvLy7Ozs5WVlYqKioKCgqGhoZiYmP//////\
        ////////////////////////////////////////////////////////////////////\
        ////////////////////////////////////////////////////////////////////\
        ////////////////////////////////////////////////////////////////////\
        ////////////////////////////////////////////////////////////////////\
        ////////////////////////////////////////////////////////////////////\
        ////////////////////////////////////////////////////////////////////\
        /////////////////////yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAsAAAAAEgAEQAA\
        CP4AAQgcODCAgAEEChg4UABBAgUJFjBo4EABgwMGHhBIwOABBAUOIkgwMIFCBQMWOhYg\
        cAFDSgYMFCzgSCEDhAsJIECooEDRiTQEgwLQMGEDhw4ePoAI4UHECA8kSngwcQLFCRMp\
        VKhYwaKFCw0mTLyAgSLFCgExYMiYMYMFDQ81WAjwcIKFjRgtBICI4eLFFAxQhQo0MeEG\
        DBsAXACYgXggDoEtBK4AQCLHDAA6TgTdIVAHj4EkYvQAEELgZxwfKKcGQENgBxUVVAgG\
        4OMHkBxBOggZAoJIESMvjiBJ8kLJkhdMNNxo4uTJEBRQNESJsiGFFBFTiKSgMoIKjBsa\
        iP6MqKJhgxIOxD08YaJEikAiiBbNtnIFC4AsWjgokbFlC5cuQqxAhAzi3dCBFzBM9wUY\
        0y0Rhhgi3CADEx54MIYATmjAxBJKHMHBCx96UAUZULwgAyNkcNAIAFQU4shsDiTRgRJK\
        1FDCDWVIYIYEZ0jwRAxM0ODECEqsEAUaKIzAgQklkDCdB0v0wAQQNQhwRAcxoCCDCCzU\
        WAIZKaCXBhQn1BBDE0kAoUETfMxnwoQ4pMCCGmuwcYYaZ7QBARQppKCBEwBMJwIHIoAA\
        glNRuFHCCVG8MR0KNTCRQhRwRBHHCkCYIEcUX0QBhA5HeIEaEDQwwgEEszGQQgcBAIHC\
        Gv5nzEGHGXW0McccdQgggg01cBCFHCLEpYIAMLgQRRgxpBCHADTYEcUJKzgaQwglqOAB\
        px9YBUMJK/QwQgs1mLBCCgnMdsAdHoCgQxd4GLEFHnXUYQa8eEjQhAc9pBBGHiyEQMYK\
        ZKjAwhtvtOBECCc4kUcUIbCgRxR2tDDCHR2gceRcXHGAAws12NABCyswMFsDHaQQBAfJ\
        nrDHFnV00QUfMOCgWQ+ARqFHCzrEEMQHrdl8ggpicDodDjiAEMZ0faDgQgxR+DHdCC7w\
        gIIOJrTgQRoyPDLbBCD00AIKAfBwghl/tEEHH0UAwEFZAODQwnQ2IIzCDiqU8DAKFrsw\
        Q/4UgLTAAwsAMJroBybwIEIUgciRggAfBLHCCR+EIAIkswniAs1S4+AEHS5vsQcXALRA\
        Ag4ccCBbFGKQQMMMIuSxdxhGinGCB06T4KsOPcMeBQlp9HDsHSfY0IJXKowAAAKzEUCs\
        CzbQ4EIAatCxBh9mOACEC3e0cBkNNNgwHYNB5zBdz5YO4iwPQU8XBgvi2xwFIT1wAMAd\
        HIQQQAghmEC5YIUYcgdjO8gBAGCwA7aQYAckYA0NdOACGhRQIALA3g4mkwMc2GAHAcQZ\
        AHrQvcvcAQc8uExlTFAZFQQgCAIZTSQKMRsnHKIE8hNIAARiGYHYACidAUAOXJBAHOIA\
        KIcBECBmEhgEEkwmdJe5DABiIBDOAIAHQrwDC5IgCRTMJgCIsIIUgJCGDoQgTGZCgQCu\
        cqYOtCAFTGhBBzqAgiR8ywksYOMNvuWBJohgcSbSwQiaEAMQwLEJNRCBE8hQFgGkgAxJ\
        General/YAAjZgOAGQogERaJyAImSclKWvKSmMykJivJEQUkQgCNDAgAOw==\
        </data>\
</dict>\
</plist>"];
General/CFStringRef errorString;
General/NSData *xmlData=General/[NSData dataWithBytes:[classArt cString] length:[classArt length]];
id plist=(id)General/CFPropertyListCreateFromXMLData(kCFAllocatorDefault, 
                                (General/CFDataRef)xmlData,
                                0, 
                                &errorString);
id artData=[plist objectForKey:@"data"];
General/NSLog(@"artPath: %@", path);
[artData writeToFile:[path stringByAppendingPathComponent:@"class.gif"] atomically:YES];
    
    
}





