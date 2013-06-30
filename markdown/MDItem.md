A Carbon object that represents the metadata of a file.

----

kMDItemTextContent attribute can't be obtained from General/MDItemRef.  So I wrote this code, General/SpotlightTextContentRetriever

It parses mdimport -L command to find mdimporter plugins, then compare the bundle identifier of each plugin and the target file's handler identifier.


This code is used in General/SpotInside http://www.oneriver.jp/

    
//
//  General/SpotlightTextContentRetriever.h
//  General/SpotInside
//
//  Created by Masatoshi Nishikata on 06/11/22.
//  Copyright 2006 www.oneriver.jp. All rights reserved.
//


/*
 
 Modified on 2007.11.1
 Modified on 2007.11.3
 
 */

/*
 Using codes from Apple's General/BasicPlugin
 ----------------------------------
 
 Description: Basic General/CFPlugIn sample code shell, Carbon API
 
 Copyright: 	 © Copyright 2001 Apple Computer, Inc. All rights reserved.
 
 Disclaimer:	 IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under Apple’s
 copyrights in this original Apple software (the "Apple Software"), to use,
 reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions of
 the Apple Software.  Neither the name, trademarks, service marks or logos of
 Apple Computer, Inc. may be used to endorse or promote products derived from the
 Apple Software without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or implied,
 are granted by Apple herein, including but not limited to any patent rights that
 may be infringed by your derivative works or by other works in which the Apple
 Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
 OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
 (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

/* Japanese Text General/MDImporter
 * Copyright (c) 2005-2006 KATO Kazuyoshi
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

/*
 * guess.c - guessing character encoding 
 *
 *   Copyright (c) 2000-2003 Shiro Kawai, All rights reserved.
 * 
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 * 
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *   3. Neither the name of the authors nor the names of its contributors
 *      may be used to endorse or promote products derived from this
 *      software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  $Id: guess.c,v 1.4 2004/10/06 09:25:36 shirok Exp $
 */




#import <Cocoa/Cocoa.h>

@interface General/SpotlightTextContentRetriever : General/NSObject {

}
+(void)initialize;
+(BOOL)loadPlugIns;
+(General/NSArray* )loadedPlugIns;
+(General/NSArray* )unloadedPlugIns;
+(General/NSMutableArray* )metaDataOfFileAtPath:(General/NSString*)targetFilePath;
+(General/NSString* )textContentOfFileAtPath:(General/NSString*)targetFilePath;
+(General/NSMutableDictionary*)executeMDImporterAtPath:(General/NSString*)mdimportPath forPath:(General/NSString*)path uti:(General/NSString*)uti;
+(int)General/OSVersion;
+(General/NSString*)readTextAtPath:(General/NSString*)path;

@end

//------


//
//  General/SpotlightTextContentRetriever.m
//  General/SpotInside
//
//  Created by Masatoshi Nishikata on 06/11/22.
//  Copyright 2006 www.oneriver.jp. All rights reserved.
//




#include <Carbon/Carbon.h>
#include <General/CoreFoundation/General/CoreFoundation.h>
#include <General/CoreFoundation/General/CFPlugInCOM.h>
#import "General/SpotlightTextContentRetriever.h"

#import "TEC.h"
#import "General/JapaneseString.h"


typedef struct General/PlugInInterfaceStruct {
    IUNKNOWN_C_GUTS;
	Boolean (*General/GetMetadataForFile)(void* myInstance, 
								  General/CFMutableDictionaryRef attributes, 
								  General/CFStringRef contentTypeUTI,
								  General/CFStringRef pathToFile);
	
} General/MDImporterInterfaceStruct;


static General/MDImporterInterfaceStruct **mdimporterInterface = nil;

@implementation General/SpotlightTextContentRetriever

static General/NSArray* mdimporterArray = nil;
static General/NSArray* unloadedMDImporterArray = nil;

static General/NSDictionary* contentTypesForMDImporter = nil;

static General/NSMutableDictionary* converters_ = nil;
static int osversion = 0;

+ (void)initialize
{
    if ( self == General/[SpotlightTextContentRetriever class] ) {
	
		converters_ = General/[[NSMutableDictionary alloc] init];
		osversion = [self General/OSVersion];
		
		if( mdimporterArray == nil )
			[self loadPlugIns];
    }
}

+(BOOL)loadPlugIns
{
	
	// Get and store General/MDImporter list	
	General/NSTask *task = General/[[NSTask alloc] init];
	General/NSPipe *messagePipe = General/[NSPipe pipe];
	
	[task setLaunchPath:@"/usr/bin/mdimport"];
	[task setArguments:General/[NSArray arrayWithObjects: @"-L" ,nil]];
	
	
	[task setStandardError : messagePipe];				
	[task launch];
	[task waitUntilExit];
	
	
	
	General/NSData *messageData = General/messagePipe fileHandleForReading] availableData]; 
	
	
	[[NSString* message;
	message = General/[[[NSString alloc] initWithData:messageData
									 encoding:NSUTF8StringEncoding] autorelease];
	
	[task release];
	
	
	
	// Cut unwanted string
	
	General/NSRange firstReturn = [message rangeOfString:@"(\n"];
	if( firstReturn.location == General/NSNotFound )
	{
		mdimporterArray = General/[[NSArray array] retain];
	}else
	{
		
		General/NSString* arrayStr = [message substringFromIndex:  firstReturn.location ];
		
		
		// Convert string to array
		
		General/NSData* data = [arrayStr dataUsingEncoding:General/NSASCIIStringEncoding];
		General/NSMutableArray *array = General/[NSPropertyListSerialization propertyListFromData:data 
																 mutabilityOption:General/NSPropertyListMutableContainers
																		   format:nil errorDescription:nil];
		
		
		if( array == nil ){
			General/NSLog(@"Parse Error");
			return NO;
		}
		
		
		
		//sortMDImporterArray
		General/NSMutableArray* sortedArray = General/[NSMutableArray array];
		int hoge;
		
		//(1) ~/Library/Spotlight/
		General/NSString* userFolder = General/[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Spotlight"];
		
		for( hoge = 0; hoge < [array count]; hoge++ )
		{
			General/NSString* aStr = [array objectAtIndex:hoge];
			if( [aStr hasPrefix: userFolder] )
			{
				[sortedArray addObject: aStr];
			}
		}
		
		
		//(2) /Library/Spotlight/
		General/NSString* pluginFolder = @"/Library/Spotlight/";
		for( hoge = 0; hoge < [array count]; hoge++ )
		{
			General/NSString* aStr = [array objectAtIndex:hoge];
			if( [aStr hasPrefix: pluginFolder] )
			{				
				[sortedArray addObject: aStr];
			}
		}
		
		//(3) /System/Library/Spotlight/
		General/NSString* sysPluginFolder = @"/System/Library/Spotlight";
		for( hoge = 0; hoge < [array count]; hoge++ )
		{
			General/NSString* aStr = [array objectAtIndex:hoge];
			if( [aStr hasPrefix: sysPluginFolder] )
			{				
				[sortedArray addObject: aStr];
			}
		}
		
		
		//(4) others
		[array removeObjectsInArray: sortedArray];
		[sortedArray addObjectsFromArray: array];
		
		
		
		// exclude dynamic plugins ... check General/CFPlugInDynamicRegistration
		General/NSMutableArray* unloadedArray = General/[NSMutableArray array];
		
		for( hoge = 0; hoge < [sortedArray count]; hoge++ )
		{
			General/NSString* aStr = [sortedArray objectAtIndex:hoge];
			
			General/CFTypeRef dynamicValue = General/[[NSBundle bundleWithPath:aStr] objectForInfoDictionaryKey: @"General/CFPlugInDynamicRegistration"];
			
			
			BOOL removeFlag = NO;
			
			
			if( General/CFGetTypeID(dynamicValue) == General/CFBooleanGetTypeID()  )
			{
				
				removeFlag = General/CFBooleanGetValue(dynamicValue);
				
				
			}else if( General/CFGetTypeID(dynamicValue) == General/CFStringGetTypeID()  )
			{
				
				removeFlag = ( General/dynamicValue lowercaseString] isEqualToString:@"yes"] ? YES:NO);
			}
			
			
			if( removeFlag )
			{		
				[unloadedArray addObject:aStr];
				[sortedArray removeObjectAtIndex:hoge];
			}
			
			
		}
		
		mdimporterArray = [[[[NSArray alloc] initWithArray:sortedArray];
		unloadedMDImporterArray = General/[[NSArray alloc] initWithArray:unloadedArray];
		
		
		// Read value for key:General/CFBundleDocumentTypes in Info.plist
		// Get one item and check if it has key:General/CFBundleTypeRole value:General/MDImporter  
		// Read the value for key:General/LSItemContentTypes
		// set the value to contentTypesForMDImporter 
		
		General/NSMutableDictionary* contentTypesForMDImporterMutableDictionary = General/[[NSMutableDictionary alloc] init];
		
		for( hoge = 0; hoge < [mdimporterArray count]; hoge++ )
		{
			General/NSString* aStr = [mdimporterArray objectAtIndex:hoge];
			
			id value = General/[[NSBundle bundleWithPath:aStr] objectForInfoDictionaryKey: @"General/CFBundleDocumentTypes"];
			if( value != nil )
			{
				if( [value isKindOfClass:General/[NSArray class]] && [value count] >0 )
				{
					int piyo=0;
					for( piyo = 0; piyo < [value count] ; piyo++ )
					{
						id typeDictionary = [value objectAtIndex:piyo];
						if( [typeDictionary isKindOfClass:General/[NSDictionary class]] && 
							General/typeDictionary valueForKey:@"[[CFBundleTypeRole"] isEqualToString: @"General/MDImporter"]   )
						{
							id array = [typeDictionary objectForKey: @"General/LSItemContentTypes"];
							if( array != nil && [array isKindOfClass:General/[NSArray class]] )
							{
								if( [contentTypesForMDImporterMutableDictionary objectForKey: aStr] == nil )
									[contentTypesForMDImporterMutableDictionary setObject:General/[NSMutableArray array] forKey:aStr];
								
								General/contentTypesForMDImporterMutableDictionary objectForKey: aStr] addObjectsFromArray: array ];
							}
						
						}
					
					}
				
				}
			
			}
			
		}

		contentTypesForMDImporter = [[[[NSDictionary alloc] initWithDictionary:contentTypesForMDImporterMutableDictionary];
		
	}	
	
	return YES;
}

+(General/NSArray* )loadedPlugIns
{
	return mdimporterArray;
}
+(General/NSArray* )unloadedPlugIns
{
	return unloadedMDImporterArray;
}

+(General/NSDictionary*)contentTypesForMDImporter
{
	return contentTypesForMDImporter;
}

+(General/NSMutableArray* )metaDataOfFileAtPath:(General/NSString*)targetFilePath
{
	//Check plugIn list
	if( mdimporterArray == nil )
	{
		if( !General/[SpotlightTextContentRetriever loadPlugIns] ) 
			return General/[NSMutableArray array];
	}

	
	// Get UTI of the given file
	
	General/NSString* targetFilePath_converted = [targetFilePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSURL* anUrl = [NSURL General/URLWithString: targetFilePath_converted];
	General/FSRef ref;
	General/CFURLGetFSRef(anUrl,&ref);
	General/CFTypeRef outValue;
	General/LSCopyItemAttribute (
						 &ref,
						 kLSRolesAll,
						 kLSItemContentType,
						 &outValue
						 );
	
	if( outValue == nil ) return nil;
	
	General/NSString* uti = General/[NSString stringWithString:outValue];
	General/CFRelease(outValue);
	
	//mdimporterArray
	//contentTypesForMDImporter

	
	
	int hoge;
	for (hoge = 0; hoge < [mdimporterArray count]; hoge++) {
		General/NSString* mdimporterPath = [mdimporterArray objectAtIndex:hoge];
		
		General/NSArray* contentUTITypes = [contentTypesForMDImporter objectForKey:mdimporterPath ];
		
		if( [contentUTITypes containsObject:uti ] )
		{

			// found one mdimporter
			General/NSMutableDictionary* attributes = 
			General/[SpotlightTextContentRetriever executeMDImporterAtPath:mdimporterPath 
														   forPath:targetFilePath_converted
															   uti:uti];
			
				
			//In 10.5, text content created by General/SourceCode.mdimporter contains only minimum keywords.
			// Overwrite full text here.
			if( osversion >= 1050 && General/UTTypeConformsTo ( uti, kUTTypeSourceCode  )) 
			{
			   
			   General/NSString* contents = General/[SpotlightTextContentRetriever readTextAtPath: targetFilePath];
			   if ( contents) {
				   [attributes setObject:contents forKey:kMDItemTextContent];
								
			   }			   
			}

		   return attributes;
		}
	}
	
	

		
	
	/* Original idea and code.  Did not work on Leopard for source code.
	
	
	//----------------
	
	
	//Get handlers that can handle the file
	General/CFArrayRef ha = General/LSCopyAllRoleHandlersForContentType (
														 uti,
														 kLSRolesAll
														 );	
	General/NSArray* handlerArray;
	
	if( ha == nil )
	{
		return nil;
	}else
	{
		handlerArray = General/[NSArray arrayWithArray: ha];
		General/CFRelease(ha);
	}
	
	//----------------
	
	//Evaluate
	
	int hoge;
	for( hoge = 0; hoge < [mdimporterArray count]; hoge++ )
	{
		General/NSString* mdimporterPath = [mdimporterArray objectAtIndex:hoge];			
		General/NSBundle* bndl = General/[NSBundle bundleWithPath: mdimporterPath ];
		
		if( bndl != nil )
		{
			
			int piyo;
			for( piyo = 0; piyo < [handlerArray count]; piyo++ )
			{
				General/NSString* aHandler = [handlerArray objectAtIndex:piyo];
				
	
				if( [aHandler isEqualToString:[bndl bundleIdentifier] ] )
				{

					//General/NSLog(@"Reading using %@",mdimporterPath);
					// found one mdimporter
					General/NSMutableDictionary* attributes = 
					General/[SpotlightTextContentRetriever executeMDImporterAtPath:mdimporterPath 
																   forPath:targetFilePath
																	   uti:uti];
					
					
					if( [attributes objectForKey:kMDItemTextContent] != nil )
						return attributes;

				}
			}
			
		}else
		{
			//General/NSLog(@"bndl is null");
			
		}
		
	}	
	*/
	
	return nil;
	
}

+(General/NSString*)readTextAtPath:(General/NSString*)path
{
	// When handling only ascii text, the source can be much more simple.
	
	
	
	General/NSData* data = General/[NSData dataWithContentsOfFile: path ];
	if ( data) {
		
		// Detect Encoding
		General/NSStringEncoding encoding;
		encoding = General/[JapaneseString detectEncoding: data];
		
		// Convert Encoding
		General/NSString* contents = nil;
		if (encoding == General/NSUnicodeStringEncoding ||
			encoding == General/CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE) ||
			encoding == General/CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16LE)) {
			contents = General/[[[NSString alloc] initWithData: data
											  encoding: encoding] autorelease];
		} else {
			General/TECConverter* converter = General/[SpotlightTextContentRetriever createConverter:encoding];
			contents = [converter convertToString: data];
		}
		return contents;
	}

	return nil;
}

+(int)General/OSVersion
{
	long General/SystemVersionInHexDigits;
	long General/MajorVersion, General/MinorVersion, General/MinorMinorVersion;
	
	Gestalt(gestaltSystemVersion, &General/SystemVersionInHexDigits);
	
	
	General/MinorMinorVersion = General/SystemVersionInHexDigits & 0xF;
	
	General/MinorVersion = (General/SystemVersionInHexDigits & 0xF0)/0xF;
	
	General/MajorVersion = ((General/SystemVersionInHexDigits & 0xF000)/0xF00) * 10 +
	(General/SystemVersionInHexDigits & 0xF00)/0xF0;
	
	
	////General/NSLog(@"ver %ld", General/SystemVersionInHexDigits);
	////General/NSLog(@"%ld.%ld.%ld", General/MajorVersion, General/MinorVersion, General/MinorMinorVersion);	
	
	
	return (int)General/MajorVersion*100 + General/MinorVersion*10 + General/MinorMinorVersion ;
}





+(General/NSString* )textContentOfFileAtPath:(General/NSString*)targetFilePath
{
	General/NSMutableDictionary* attributes = 
	General/[SpotlightTextContentRetriever metaDataOfFileAtPath:targetFilePath];
	
	id textContent = [attributes objectForKey:kMDItemTextContent];
	if( [textContent isKindOfClass:General/[NSString class]]  )
	{
		return textContent;
	}
	
	return nil;
}


+(General/NSMutableDictionary*)executeMDImporterAtPath:(General/NSString*)mdimportPath forPath:(General/NSString*)path uti:(General/NSString*)uti
{
	
	mdimportPath = [mdimportPath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	General/NSMutableDictionary* attributes = nil;
	General/CFBundleRef		bundle;
	
		

	General/CFURLRef url = General/CFURLCreateWithString (
											 nil,
											 mdimportPath,
											 nil
											 );
	 
	if( url == nil )	return nil;


	// Create General/CFPlugInRef
		
	General/CFPlugInRef plugin = General/CFPlugInCreate(NULL, url);
	General/CFRelease(url);


	
	if (!plugin)
	{
		//General/NSLog(@"Could not create General/CFPluginRef.\n");
		return nil;
	}

	
	//  The plug-in was located. Now locate the interface.

	BOOL foundInterface = NO;
	General/CFArrayRef	factories;
	
	//  See if this plug-in implements the Test type.
	factories	= General/CFPlugInFindFactoriesForPlugInTypeInPlugIn( kMDImporterTypeID, plugin );
	
	
	
	//  If there are factories for the Test type, attempt to get the General/IUnknown interface.
	if ( factories != NULL )
	{
		General/CFIndex	factoryCount;
		General/CFIndex	index;
		
		factoryCount	= General/CFArrayGetCount( factories );
		

		
		if ( factoryCount > 0 )
		{
			for ( index = 0 ; (index < factoryCount) && (foundInterface == false) ; index++ )
			{
				General/CFUUIDRef	factoryID;
				
				//  Get the factory ID for the first location in the array of General/IDs.
				factoryID = (General/CFUUIDRef) General/CFArrayGetValueAtIndex( factories, index );
				if ( factoryID )
				{
					
					General/IUnknownVTbl **iunknown;
					
					//  Use the factory ID to get an General/IUnknown interface. Here the plug-in code is loaded.
					iunknown	= (General/IUnknownVTbl **) General/CFPlugInInstanceCreate( NULL, factoryID, kMDImporterTypeID );
					
					if ( iunknown )
					{
						//  If this is an General/IUnknown interface, query for the test interface.
						(*iunknown)->General/QueryInterface( iunknown, General/CFUUIDGetUUIDBytes( kMDImporterInterfaceID ), (LPVOID *)( &mdimporterInterface ) );
						
						// Now we are done with General/IUnknown
						(*iunknown)->Release( iunknown );
						
						if ( mdimporterInterface )
						{
							//	We found the interface we need
							foundInterface	= true;
						}
					}
				}
			}
		}
		
		
		General/CFRelease( factories );

	}

	

		
	if ( foundInterface == false )
	{
	}
	else
	{
		attributes = General/[NSMutableDictionary dictionary];	


		/* This sometimes fails and causes crash. */
			
		@try {
			path = [path stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

			
			//General/NSLog(@"General/GetMetadataForFile" );

			(*mdimporterInterface)->General/GetMetadataForFile( mdimporterInterface, 
														attributes, 
														uti,
														path);	
		
			//void* ptr = (*mdimporterInterface)->General/GetMetadataForFile;
			//General/NSLog(@"%x",ptr);
			//(*mdimporterInterface)->Release( mdimporterInterface );
			
			
			
		}
		@catch (General/NSException *exception) {
			attributes = nil;
			//General/NSLog(@"exception" );

		}
		
		


	}
	
	// Finished

	General/CFRelease( plugin );
	plugin	= NULL;
	
	return attributes;
}
#pragma mark Japanese Converter
+(General/TECConverter*)createConverter:(General/NSStringEncoding) encoding
{
General/TECConverter* converter;

converter = [converters_ objectForKey: General/[NSNumber numberWithInt: encoding]];

if (! converter) {
converter = General/[[TECConverter alloc] initWithEncoding: encoding];
[converters_ setObject: converter
			   forKey: General/[NSNumber numberWithInt: encoding]];
[converter release];
}

return converter;
}
@end



