click here to go back -> [[OpenGLScript]]

<code>

//
//  [[UmGLScript]].h
//  [[UmGL]]
//
//  Created by Benjamin on Sat Feb 08 2003.
//  Copyright (c) 2003 Unified Modular All rights reserved.
//  www.unifiedmodular.com
//

#import <Cocoa/Cocoa.h>
#import <[[OpenGL]]/[[OpenGL]].h>
#import <[[OpenGL]]/gl.h>
#import <[[OpenGL]]/glu.h>
#include <stdlib.h>
#include <string.h>

#define ARGC_MAX 10

typedef struct [[UmGLCommandInfo]] {
    char type;
    int command;
    BOOL error;
    int argc;
    struct [[UmGLCommandInfo]] ''next;
    float floats[10];
    id defs[10];
    int ints[10];
    id format;
} _UmGLCommandInfo;

typedef struct [[UmGLEquivalent]] {
    char ''shortHand;
    char ''glCall;
    int shortHandLength;
    int glCallLength;
    id format;
}_UmGLEquivalent;

// 	[[UmGLCommand]] is only used to act as a link for a chain of commands
// 	The only instance variable is a stucture that has a component to store 
// 	a pointer to the info structure of the next [[UmGLCommand]] in the chain
// 
// 	[[UmGLCommand]] violates encapsulation rules, so beginners please be 
// 	aware that this is not a proper Cocoa programming technique. 
// 	I just wanted to take advantage of the autorelease pool.
#import "[[UmGLScriptEditor]].h"

@interface [[UmGLCommand]] : [[NSObject]] {
    struct [[UmGLCommandInfo]] info;
}
+([[UmGLCommand]] '')command;
-(struct [[UmGLCommandInfo]] '')infoPointer;
@end


@interface [[UmGLScript]] : [[NSObject]] {
    [[NSArray]] ''commands;
    [[NSMutableArray]] ''glScript;
    struct [[UmGLCommandInfo]] ''firstGLCommandInfo;
    struct [[UmGLCommandInfo]] ''glCommandInfo;
    struct [[UmGLCommandInfo]] ''lastGLCommandInfo;
    int argumentTemplateTypeForCallNameAtIndex[256];
    struct [[UmGLEquivalent]] equivalents[256];
    id printFormats[256];
    char args[ARGC_MAX][64];
    BOOL hasEOF;
    [[UmGLScriptEditor]] ''scriptEditor;
    [[NSMutableString]] ''top, ''tabs;
    int argc, glCallNameCount, glCallNameCandidateIndex, floatVectorCount;
    id glView;
    [[NSMutableArray]] ''tableData;
    id tableView;
    [[NSMutableDictionary]] ''formatAttributes;
    [[NSMutableArray]] ''scriptSyntax;
    [[NSMutableArray]] ''formatPool;

}
-(void)updateFormat;
-(void)updateData;
-([[NSDictionary]] '')entryFromInfo:(struct [[UmGLCommandInfo]] '')info appendToString:([[NSMutableString]] '')code tabs:([[NSString]] '')_tabs;
-(BOOL)compareCandidate:(char '')candidate withName:(char '')name length:(int)length;
-(void)setArgs:(char '')cString;
-(void)configureCommandInfo:(struct [[UmGLCommandInfo]] '')info;
-(BOOL)loadScript:([[NSString]] '')script;
-(void)runScript;
-(BOOL)loadScriptAtPath:([[NSString]] '')path;
-(BOOL)parseScript:([[NSString]] '')script;
-(void)performScript;
-([[NSString]] '')sourceFromGLScriptWithTabOffset:(int)tabCount;
-(void)setGLView:(id)view;
-(void)setTableView:(id)tableView;
@end

//
//  [[UmGLScript]].m
//  [[UmGL]]
//
//  Created by Benjamin on Sat Feb 08 2003.
//  Copyright (c) 2003 Unified Modular
//  www.unifiedmodular.com 
// All rights reserved.
//

#import "[[UmGLScript]].h"

@implementation [[UmGLCommand]]
+([[UmGLCommand]] '')command {
    return [[[[[UmGLCommand]] alloc] init] autorelease];
}
-(struct [[UmGLCommandInfo]] '')infoPointer {
    return &info;
}
@end

@implementation [[UmGLScript]]
-(id)initWithFrame:([[NSRect]])frame {
    self=[self init];
    if (!self) return nil;
    scriptEditor=[[[[UmGLScriptEditor]] alloc] initWithFrame:frame];
    [scriptEditor setDataSource:self];
    tableData=[[[[NSMutableArray]] array] retain];
    return self;
}
-(id)init {
    scriptSyntax=[[[[NSMutableArray]]  array] retain];
    self=[super self];
    if (!self) return nil;
    glScript=[[[[NSMutableArray]] alloc] init];
    formatAttributes=[[[[NSMutableDictionary]] dictionary] retain];
    [formatAttributes setObject:@".2f" forKey:@"floatFormat"];
    [formatAttributes setObject:@"\tfloat %@[]={ %[float], %[float], %[float], %[float] };\n" 			
                        forKey:@"4fVectorFormatTemplate"];
    [formatAttributes setObject:@"GL_LIGHT1" forKey:@"GL_LIGHT1"];
    [formatAttributes setObject:@"GL_AMBIENT" forKey:@"GL_AMBIENT"];
    [formatAttributes setObject:@"GL_POSITION" forKey:@"GL_POSITION"];
    [formatAttributes setObject:@"GL_TRIANGLES" forKey:@"GL_TRIANGLES"];
    [formatAttributes setObject:@"GL_QUADS" forKey:@"GL_QUADS"];
    [formatAttributes setObject:@"GL_TEXTURE_2D" forKey:@"GL_TEXTURE_2D"];
    [formatAttributes setObject:[[[NSArray]] arrayWithObjects:@"arg1", @"arg2", @"arg3", @"arg4", @"arg5", @"arg6", @"arg7", @"arg8", @"arg9", @"arg10", nil] forKey:@"argumentKeys"];
    formatPool=[[[[NSMutableArray]] array] retain];
        
    id entry;
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"EOF", @"shortHand", 
            @"[[EndOfFile]]", @"glCall",		// 0 - end of file or script in this case
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"reset", @"shortHand", 
            @"glLoadIdentity", @"glCall",		// 1 - reset the current modelview matrix
            @"%@glLoadIdentity();\n", @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"begin", @"shortHand", 
            @"glBegin", @"glCall",		// 2 - begin
            @"%@glBegin(%@);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"disable", @"shortHand", 
            @"glDisable", @"glCall",		// 3 - disable
            @"%@glDisable(%@);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"end", @"shortHand", 
            @"glEnd", @"glCall",			// 4 - to declare the end of a triangle or quadrangle
            @"%@glEnd();\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"tex", @"shortHand", 
            @"glBindTexture", @"glCall",		// 5 - selects texture
            @"%@glBindTexture(%@, %i);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"texcord", @"shortHand", 
            @"glTexCoord2f", @"glCall",		// 6 - sets texture cordinates
            @"%@glTexCoord2f(%[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"norm", @"shortHand", 
            @"glNormal3f", @"glCall",		// 7 - sets normal pointing toward viewer
            @"%@glNormal3f(%[float], %[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"light", @"shortHand", 
            @"glLightfv", @"glCall",		// 8 - sets lighting (only responds to light1 so far)
            @"%@glLightfv(%@, %@, );\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"enable", @"shortHand", 
            @"glEnable", @"glCall", 		// 9 - enable
            @"%@glEnable(%@);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"rgb", @"shortHand", 
            @"glColor3f", @"glCall",		// 10 - sets rgb color
            @"%@glColor3f(%[float], %[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"vert", @"shortHand", 
            @"glVertex3f", @"glCall", 		// 11 - vertex
            @"%@glVertex3f(%[float], %[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"trans", @"shortHand", 
            @"glTranslatef", @"glCall", 		// 12 - translate
            @"%@glTranslatef(%[float], %[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    entry=[[[NSDictionary]] dictionaryWithObjectsAndKeys:
            @"rot", @"shortHand", 
            @"glRotatef", @"glCall", 		// 13 - rotate
            @"%@glRotatef(%[float], %[float], %[float], %[float]);\n",  @"format", 
            nil];
    [scriptSyntax addObject:entry];
    [self updateFormat];                                                    
    //	argumentTemplateInfo is to provide information about the
    //	argument types involved for a specific [[OpenGL]] call.
    //	Most of the [[OpenGL]] calls only involve sending float values,
    // 	but there are some special cases.
    
    id argumentTemplateInfo=[[[NSMutableDictionary]] dictionaryWithObjectsAndKeys:
                                                                @"3", @"tex",
                                                                @"2", @"light",
                                                                @"1", @"disable",
                                                                @"4", @"begin",
                                                                @"1", @"enable", nil];
    
    //	this while loop is to initialize an array of structs called "equivalents"
    //	equivalents are to match the short hand name with the corresponding
    //	glCall (i.e. begin=glBegin). The interpreter will able to understand both
    //	short hand and glCalls in a script, therefore you will be able to import
    //	[[OpenGL]] source if it is simple and all the argument values are explicitly 
    //	filled in: 
    //		
    //		explicit call glColor3f(0.0f, 1.0f, 0.0f)
    //		implicit call glColor3f(r, g, b) <- will not be interpreted
    //
    
    id syntaxEnum=[scriptSyntax objectEnumerator];
    for (int count=0; entry=[syntaxEnum nextObject]; count++) {
        id shortHand=[entry objectForKey:@"shortHand"];
        equivalents[count].shortHand=[shortHand cString];
        equivalents[count].glCall=[[entry objectForKey:@"glCall"] cString];
        equivalents[count].shortHandLength=[shortHand length];
        equivalents[count].glCallLength=[[entry objectForKey:@"glCall"] length];
        equivalents[count].format=[entry objectForKey:@"format"];
        id templateType;
        if (templateType=[argumentTemplateInfo objectForKey:shortHand]) 	argumentTemplateTypeForCallNameAtIndex[count]=[templateType intValue];
        else argumentTemplateTypeForCallNameAtIndex[count]=0;
    }
    glCallNameCount=[scriptSyntax count];
    return self;
}
-(void)setGLView:(id)view {
    glView=view;
    [scriptEditor setGLView:view];
}

-(BOOL)loadScript:([[NSString]] '')script {
    return [self parseScript:script];
}
-(BOOL)loadScriptAtPath:([[NSString]] '')path {
    [[NSString]] ''script=[[[NSString]] stringWithContentsOfFile:path];
    return [self parseScript:script];
}

-(BOOL)parseScript:([[NSString]] '')script {

// 	this parsing function is not optimized, but the glScript it generates is slightly
//	optimized (in the sense that no message calls are made when it runs!!)
//	the glScript can also be used to generate [[OpenGL]] lines of code
// 	that can be cut and pasted into Object C methods or C functions.
    
    [glScript removeAllObjects];
    [tableData removeAllObjects];
    [[NSArray]] ''lines=[script componentsSeparatedByString:@"\n"];
    if ([lines count]==1) return NO;
    lastGLCommandInfo=nil;
    hasEOF=NO;
    [[scriptEditor textView] setString:script];
    [[scriptEditor textView] display];
    [[NSEnumerator]] ''lineEnum=[lines objectEnumerator];
    [[NSString]] ''line;
    while (line=[lineEnum nextObject]) {
        [[NSRange]] openP=[line rangeOfString:@"("];
        [[NSString]] ''glCall;
        if (openP.length>0) {
            [[NSRange]] closeP=[line rangeOfString:@")" options:[[NSBackwardsSearch]]];
            if (closeP.length>0) {
                glCall=[line substringWithRange:[[NSMakeRange]](0,openP.location)];
                line=[line substringWithRange:[[NSMakeRange]](openP.location+1, closeP.location-openP.location-1)];
            }
            else {
                glCall=line;
                line=nil;
                argc=0;
            }
        }
        else {
            glCall=line;
            line=nil;
            argc=0;
        }
        if (line) [self setArgs:[line cString]];
        char ''glCallCandidate=[glCall cString];
        int length=[glCall length];
        for (int i=0;i<length;i++) {
            if (''glCallCandidate==' ' || ''glCallCandidate=='\t') glCallCandidate++;

            else break;
        }
        glCallNameCandidateIndex=0;
        for (int i=0;i<glCallNameCount;i++) {
            if ([self compareCandidate:glCallCandidate 
                                withName:equivalents[i].glCall 
                                length:equivalents[i].glCallLength]) break;
            if ([self compareCandidate:glCallCandidate 
                                withName:equivalents[i].shortHand 
                                length:equivalents[i].shortHandLength]) break;
            glCallNameCandidateIndex++;
        }
    }
    if (hasEOF) {
        firstGLCommandInfo=[[glScript objectAtIndex:0] infoPointer];
        [[NSLog]](@"hasEOF: YES glScript count: %i", [glScript count]);
        [self updateData];
    }
    else firstGLCommandInfo=nil;
    
    return hasEOF;
}
-(void)updateData {
    if ([glScript count]==0) return;
    struct [[UmGLCommandInfo]] ''info=[[glScript objectAtIndex:0] infoPointer];
    id argKeys=[formatAttributes objectForKey:@"argumentKeys"];
    while (info->next) {
        id entry=[self entryFromInfo:info appendToString:nil tabs:@""];
        //[[NSLog]](@"entry: %@", entry);
        if (entry) {
            [tableData addObject:entry];
            id glCall=[entry objectForKey:@"glCall"];
            [[NSRange]] openP=[glCall rangeOfString:@"("];
            if (openP.length>0) {
                [[NSRange]] closeP=[glCall rangeOfString:@")" options:[[NSBackwardsSearch]]];
                if (closeP.length>0) {
                    id argumentString=[glCall substringWithRange:[[NSMakeRange]](openP.location+1, closeP.location-openP.location-1)];
                    if (argumentString) [self setArgs:[argumentString cString]];
                    else continue;
                    //[[NSLog]](@"argc: %i %@", argc, argumentString);
                    for (int i=0;i<argc;i++) {
                        [entry setObject:[[[NSString]] stringWithCString:args[i]] forKey:[argKeys objectAtIndex:i]];
                    }                
                }
            }
        }
        info=info->next;
    }
    [tableView reloadData];
}
-(void)setTableView:(id)_tableView {
    tableView=_tableView;
}
-(void)updateFormat {
    [[NSString]] ''floatFormat=[formatAttributes objectForKey:@"floatFormat"];
    if (!floatFormat) floatFormat=@".4f";
    id syntaxEnum=[scriptSyntax objectEnumerator];
    for (int i=0;i<256;i++) printFormats[i]=0;
    [formatPool removeAllObjects];
    id obj;
    for (int i=0; obj=[syntaxEnum nextObject]; i++) {
        id format=[obj objectForKey:@"format"];
        if (format) {
            id comp=[format componentsSeparatedByString:@"[float]"];
            if ([comp count]>1) format=[comp componentsJoinedByString:floatFormat];
        }
        printFormats[i]=format;
        if (format) [formatPool addObject:format];
    }
    id format=[formatAttributes objectForKey:@"4fVectorFormatTemplate"];
    if (format) {
        comp=[format componentsSeparatedByString:@"[float]"];
        if ([comp count]>1) format=[comp componentsJoinedByString:floatFormat];
    }
    if (format) [formatAttributes setObject:format forKey:@"4fVectorFormat"];
    else [formatAttributes setObject:@"\tfloat %@[]={ %.4f, %.4f, %.4f, %.4f };\n" forKey:@"4fVectorFormat"];
}


-(BOOL)compareCandidate:(char '')candidate withName:(char '')name length:(int)length {
        //[[NSLog]](@"<%s><%s> length: %i", candidate, name, length);
        if (strncmp(candidate, name, length)==0) {
            //[[NSLog]](@"<%s><%s>", candidate, name);
            if (glCallNameCandidateIndex==0) hasEOF=YES;
            [[UmGLCommand]] ''command=[[[UmGLCommand]] command];
            glCommandInfo=[command infoPointer];
            glCommandInfo->next=nil;
            glCommandInfo->argc=argc;
            glCommandInfo->type=argumentTemplateTypeForCallNameAtIndex[glCallNameCandidateIndex];
            glCommandInfo->command=glCallNameCandidateIndex;
            if (lastGLCommandInfo) {
                lastGLCommandInfo->next=glCommandInfo;
            }
            lastGLCommandInfo=glCommandInfo;
            [glScript addObject:command];
            if (argc) [self configureCommandInfo:glCommandInfo];
            return YES;
        }
        return NO;
}
-(void)setArgs:(char '')cString {
    char byte;
    int count=0;
    argc=0;
    
    for (int i=0;i<ARGC_MAX;i++) args[i][0]=0;
    if (''cString==0) return;
    while (byte=''cString) {
        args[argc][count]=''cString;
        cString++;
        if (byte==',') {
            args[argc][count]=0;
            argc++;
            count=0;
            if (argc==ARGC_MAX) return;
            continue;
        }
        count++;
        if (count==64) {
            args[argc][0]=0;
            return;
        }
    }
    args[argc][count]=0;
    argc++;
}
-(void)configureCommandInfo:(struct [[UmGLCommandInfo]] '')info {
    int type=info->type;
    int ''ints=info->ints;
    int i;
    float ''floats=info->floats;
    id ''defs=info->defs;
    info->error=YES;
    if (!(argc<ARGC_MAX) || argc<1) return;
    switch (type) {
        case 0 : { 	// all arguments are of type float
            for (int i=0;i<argc;i++, floats++) {
                ''floats=atof(args[i]);
            }
            info->error=NO;
            break;
        }
        case 1 : {	// only one argument that is of type int
            if (argc<1) return;
            if (strstr(args[0], "light1") || strstr(args[0], "GL_LIGHT1") || atoi(args[0])==GL_LIGHT1) {
                ints[0]=GL_LIGHT1;
                defs[0]=[formatAttributes objectForKey:@"GL_LIGHT1"];
            }
            else break;
            info->error=NO;
            break;
        }
       case 2 : {	// setup for glLightfv( light number, operation, arguments)
            ints[0]=0; defs[0]=nil;
            if (strstr(args[0], "light1") || strstr(args[0], "GL_LIGHT1")) {
                ints[0]=GL_LIGHT1;
                defs[0]=[formatAttributes objectForKey:@"GL_LIGHT1"];
            }
            else break;
            ints[1]=0; defs[1]=nil;
            if (strstr(args[1], "ambient") || strstr(args[1], "GL_AMBIENT")) {
                ints[1]=GL_AMBIENT;
                defs[1]=[formatAttributes objectForKey:@"GL_AMBIENT"];
            }
            else if (strstr(args[1], "diffuse") || strstr(args[1], "GL_DIFFUSE")) {
                ints[1]=GL_DIFFUSE;
                defs[1]=[formatAttributes objectForKey:@"GL_DIFFUSE"];
            }
            else if (strstr(args[1], "position") || strstr(args[1], "GL_POSITION")) {
                ints[1]=GL_POSITION;
                defs[1]=[formatAttributes objectForKey:@"GL_POSITION"];
            }
            else break;
            for (i=2;i<argc;i++, floats++) {
                ''floats=atof(args[i]);
            }
            info->error=NO;
            break;
        }
        case 3 : {	// glBindTexture
            ints[0]=0; defs[0]=nil;
           if (strstr(args[0], "2D") || strstr(args[0], "GL_TEXTURE_2D")) {
                ints[0]=GL_TEXTURE_2D;  // 1 = GL_TEXTURE_2D (0x0DE1)
                defs[0]=[formatAttributes objectForKey:@"GL_TEXTURE_2D"];
            }
            else break;
            ints[1]=atoi(args[1]); // sets the index for texture[]
            info->error=NO;
            break;
        }
         case 4 : {
            ints[0]=0; defs[0]=nil;
            if (strstr(args[0], "tri") || strstr(args[0], "GL_TRIANGLES")) {
                ints[0]=GL_TRIANGLES;
                defs[0]=[formatAttributes objectForKey:@"GL_TRIANGLES"];
            }
            else if (strstr(args[0], "quad") || strstr(args[0], "GL_QUADS")) {
                ''ints=GL_QUADS;
                ''defs=[formatAttributes objectForKey:@"GL_QUADS"];
            }
            else break;
            info->error=NO;
            break;
        }

        default : return;
    }
}

-(void)performScript { 
    [[NSLog]](@"performScript");
    if ([glScript count]==0) {
        [[NSLog]](@"no lines to draw");
        return;
    }
    firstGLCommandInfo=[[glScript objectAtIndex:0] infoPointer];
    struct [[UmGLCommandInfo]] ''info=firstGLCommandInfo;
    [[NSLog]](@"glScript count: %i", [glScript count]);
    if (!info) {
        [[NSLog]](@"bad script!!");
        return;
    }
    while (info->next) {
        int ''ints=info->ints;
        float ''floats=info->floats;
        //[[NSLog]](@"%i argc: %i i1: %i i2: %i f1: %f f2: %f f3: %f f4: %f", i, info->argc, ints[0], ints[1], floats[0], floats[1], floats[2], floats[3]);
        switch (info->command) {
            case 1: {
                glLoadIdentity();                
                break; 
            }
            case 2: {
                glBegin(ints[0]);
                break; 
            }
            case 3: {
                glDisable(ints[0]);
                break; 
            }
            case 4: {
                glEnd();
                break; 
            }
            case 5: {
                glBindTexture(ints[0], ints[1]);
                break; 
            }
            case 6: {
                glTexCoord2f(floats[0], floats[1]);
                break; 
            }
            case 7: {
                glNormal3f(floats[0], floats[1], floats[2]);
                break; 
            }
            case 8: {
                glLightfv(ints[0], ints[1], floats);
                break; 
            }
            case 9: {
                glEnable(ints[0]);
                break; 
            }
            case 10: {
                glColor3f(floats[0], floats[1], floats[2]);
                break; 
            }
            case 11: {
                glVertex3f(floats[0], floats[1], floats[2]);   // Point 3 (Bottom)
                break;
            }
            case 12: {
                glTranslatef(floats[0], floats[1], floats[2]);   // Point 3 (Bottom)
                break;
            }
            case 13: {
                glRotatef(floats[0], floats[1], floats[2], floats[3]);   // Point 3 (Bottom)
                break;
            }
            
        }
        info=info->next;
    }
}
-([[NSString]] '')sourceFromGLScriptWithTabOffset:(int)tabCount {
    struct [[UmGLCommandInfo]] ''info=firstGLCommandInfo;
    [[NSMutableString]] ''code=[[[NSMutableString]] string];
    tabs=[[[NSMutableString]] string];
    floatVectorCount=1;
    top=[[[NSMutableString]] string];
    for (int i=0;i<tabCount;i++) [tabs appendString:@"\t"];
    [top appendFormat:@"\n%@// float vectors\n", tabs];

    if (!info) {
        [[NSLog]](@"bad script!!");
        return;
    }
    int i=0;
    while (info->next) {
        [self entryFromInfo:info appendToString:code tabs:tabs];
        info=info->next;
        i++;
        //[[NSLog]](@"%i argc: %i i1: %i i2: %i f1: %f f2: %f f3: %f f4: %f", i, info->argc, ints[0], ints[1], floats[0], floats[1], floats[2], floats[3]);

    }
    [top appendFormat:@"%@// start glCalls\n", tabs];
    [top appendString:code];
    //[[NSLog]](top);
    return top;
}

-([[NSDictionary]] '')entryFromInfo:(struct [[UmGLCommandInfo]] '')info appendToString:([[NSMutableString]] '')code tabs:([[NSString]] '')_tabs {
        [[NSMutableDictionary]] ''entry;
        int ''ints=info->ints;
        float ''floats=info->floats;
        id ''defs=info->defs;
        tabs=_tabs;
        if (!code) entry=[[[NSMutableDictionary]] dictionary];
        //[[NSLog]](@"command: %i formateType: %i format: %@", info->command, info->type, printFormats[info->command]);
        switch (info->type) {
            case 0: {
                if (code) [code appendFormat:printFormats[info->command], tabs, floats[0], floats[1], floats[2], floats[3], floats[4], floats[5], floats[6], floats[7], floats[8], floats[9]];
                else  {
                    id obj=[[[NSString]] stringWithFormat:printFormats[info->command], tabs, floats[0], floats[1], floats[2], floats[3], floats[4], floats[5], floats[6], floats[7], floats[8], floats[9]];
                    if (obj) [entry setObject:obj forKey:@"glCall"];
                }
                // glLoadIdentity();                
                break; 
            }
            case 1: {
                if (code) [code appendFormat:printFormats[info->command], tabs, defs[0]];
                else  {
                    [entry setObject:[[[NSString]] stringWithFormat:printFormats[info->command], tabs, defs[0]] forKey:@"glCall"];
                }
                break;
            }
            case 2: {
                [[NSString]] ''vectorName=[[[NSString]] stringWithFormat:@"[[UmGLFloatVector]]%i", floatVectorCount];
                floatVectorCount++;
                if (code) [code appendFormat:printFormats[info->command], tabs, defs[0], defs[1], vectorName];
                else  {
                    [entry setObject:[[[NSString]] stringWithFormat:printFormats[info->command], tabs, defs[0], defs[1], vectorName] forKey:@"glCall"];
                }
                [top appendFormat:@"\tfloat %@[]={ %.2f, %.2f, %.2f, %.2f };\n", vectorName, floats[0], floats[1], floats[2], floats[3]];
                // glLightfv(ints[0], ints[1], floats);
                break; 
            }
            case 3: {  // tex
                    if (code) [code appendFormat:printFormats[info->command], tabs, defs[0], ints[1]];
                    else [entry setObject:[[[NSString]] stringWithFormat:printFormats[info->command], tabs, defs[0], ints[1]] forKey:@"glCall"];  
                    // glBindTexture(ints[0], ints[1]);   
                break; 
            }
            case 4: {
                    if (code) [code appendFormat:printFormats[info->command], tabs, defs[0]];
                    else [entry setObject:[[[NSString]] stringWithFormat:printFormats[info->command], tabs, defs[0]] forKey:@"glCall"];  
            break;  //glBegin()
            }
    }        
    return entry;

}

- (id)tableView:([[NSTableView]] '')aTableView
    objectValueForTableColumn:([[NSTableColumn]] '')aTableColumn
    row:(int)rowIndex
{
    [[NSParameterAssert]](rowIndex >= 0 && rowIndex < [tableData count]);
    id theRecord = [tableData objectAtIndex:rowIndex];
    id theValue = [theRecord objectForKey:[aTableColumn identifier]];
    return theValue;
}



- (int)numberOfRowsInTableView:([[NSTableView]] '')aTableView
{
    return [tableData count];
}
 

- (void)tableView:([[NSTableView]] '')aTableView
    setObjectValue:anObject
    forTableColumn:([[NSTableColumn]] '')aTableColumn
    row:(int)rowIndex
{
    id newArgString=[[[NSMutableString]] string];
    id line=[glScript objectAtIndex:rowIndex];
    id argKeys=[formatAttributes objectForKey:@"argumentKeys"];
    if (!line) return;
    struct [[UmGLCommandInfo]] ''info=[line infoPointer];
    if (!info) return;
    id numberString;
    id identifier=[aTableColumn identifier];
    if (![[identifier substringWithRange:[[NSMakeRange]](0,3)] isEqualToString:@"arg"]) return;
    else numberString=[identifier substringWithRange:[[NSMakeRange]](3,[identifier length]-3)];
    int argNumber=[numberString intValue];
    //[[NSLog]](@"argc: %i argNumber: %i",info->argc,  argNumber);
    if (argNumber>info->argc) return;
    id theRecord = [tableData objectAtIndex:rowIndex];
    [[NSParameterAssert]](rowIndex >= 0 && rowIndex < [tableData count]);
    [theRecord setObject:anObject forKey:identifier];
    int i;
    for (i=0;i<info->argc-1;i++) {
        [newArgString appendFormat:@"%@,", [theRecord objectForKey:[argKeys objectAtIndex:i]]];        
    }
    [newArgString appendString:[theRecord objectForKey:[argKeys objectAtIndex:i]]];  
    [self setArgs:[newArgString cString]];
    [self configureCommandInfo:info];
    id entry=[self entryFromInfo:info appendToString:nil tabs:@""];
    if (entry) [theRecord setObject:[entry objectForKey:@"glCall"] forKey:@"glCall"];
    [glView setNeedsDisplay:YES];
    return;
}

-(void)runScript {
    id script=[[scriptEditor textView] string];
    [self parseScript:script];
}


@end

</code>