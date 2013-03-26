All of a sudden the other day Xcode crashed on me. Now when I open my project file, [[XCode]] crashes after a few minutes and shows this hundreds of times in the crash report:
<code>
508 com.apple.Xcode.[[DevToolsCore]] 	0x98be4824 -[[[PBXProjectIndex]]([[PBXIndexingEngineCallbacks]]) shouldBeginFileForPathEntry:] + 0x588
</code>
Anyone have any idea how to fix this? My other projects open fine... and I'm really really not looking forward to reconstructing the .xcode project file. :(

----

Have you cleaned it? It looks like the index is corrupted - I think cleaning will fix it, or if not, look for some other way of forcing the index to get recreated.

''Fortunately I just needed to delete the com.apple.Xcode.plist preferences file and all is well. Very strange - bah hope Xcode 2.0 is much more stable.''

----

Well, I've never had a problem like this before except when using a beta of the developer tools. It seems like this was a chance happening (preferences can get screwy in any app no matter how stable), so i dont think that Xcode's stability is a problem here.

----

''Xcode crashes more than any other app, so do think it is a problem. How can it not be Xcode's problem?''

----

Well, then I must have some super-duper special build that hardly ever crashes.  I usually leave it running 24-7 and use it a minimum of 8 hours a day, and I don't have crashing issues.

''Same here - we must have the same build. [[XCode]] has crashed a total of three times in the last year since I've moved to my new [[PowerBook]] (according to the crash reporter log, which jives with my memory). That's pretty damned good, considering I use it for several hours a day, ''every'' day. I molest it pretty terribly, too. ;-)''

----

Xcode isn't the guilty part (directly). It's the d@#$@#d indexing code. I have the same problem when using the [[SKIndex]] stuff in my own apps. Once it breaks, I haven't found any other choice but to delete the index files on disk. -[[StuartHalloway]]

%%REPLY

''From a friendly-UI perspective, you could do worse than maintaining a flag while the dangerous part of code is running, and giving the user the option of deleting the index files automatically if you find yourself starting up with that flag still set. Very Microsoft, I'm afraid, but it works.''

----

'''[[XCodeCrashesWithOpenDialog]]'''

My [[XCode]] 1.1 (as well as many ther apps on my system) keeps crashing whenever I try to use the "Open Project" or "Add to Project" commands. The crash log:

<code>
Date/Time:      2005-12-10 23:24:53 -0500
OS Version:     10.3.9 (Build 7W98)
Report Version: 2

Command: Xcode
Path:    /Developer/Applications/Xcode.app/Contents/[[MacOS]]/Xcode
Version: 1.1 (300)
PID:     13940
Thread:  0

Exception:  EXC_BAD_ACCESS (0x0001)
Codes:      KERN_INVALID_ADDRESS (0x0001) at 0xd3a1b1c7

Thread 0 Crashed:
0   com.apple.[[CoreFoundation]]       	0x901c114c [[CFEqual]] + 0x2c
1   com.apple.[[CoreFoundation]]       	0x901c2c6c __CFDictionaryFindBuckets1b + 0xcc
2   com.apple.[[CoreFoundation]]       	0x901c206c [[CFDictionaryGetValue]] + 0xec
3   com.apple.[[CoreFoundation]]       	0x901e0e98 _CFApplicationPreferencesCreateValueForKey + 0x6c
4   com.apple.Foundation           	0x90a2bcf4 -[[[NSUserDefaults]] objectForKey:] + 0x98
5   com.apple.Foundation           	0x90a63a8c -[[[NSUserDefaults]] integerForKey:] + 0x24
6   com.apple.[[AppKit]]               	0x93005dc8 [[MaxRecentPlaces]] + 0x40
7   com.apple.[[AppKit]]               	0x92facab0 -[[[NSNavView]] _recentPlacesNode] + 0x100
8   com.apple.[[AppKit]]               	0x930098e0 -[[[NSNavView]] _configurePathComponentPicker] + 0x5c
9   com.apple.[[AppKit]]               	0x93009834 -[[[NSNavView]] _handleRootNodeChanged] + 0x40
10  com.apple.[[AppKit]]               	0x930081dc -[[[NSSavePanel]]([[NSSavePanelRuntime]]) _configureForDirectory:name:] + 0x238
11  com.apple.[[AppKit]]               	0x93007e90 -[[[NSSavePanel]]([[NSSavePanelRuntime]]) runModalForDirectory:file:types:] + 0x28
12  ...ple.Xcode.[[DevToolsInterface]] 	0x979bd2c0 -[[[PBXDocumentController]] runModalOpenPanel:forTypes:] + 0x78
13  com.apple.[[AppKit]]               	0x93104700 -[[[NSDocumentController]] fileNamesFromRunningOpenPanel] + 0x50
14  ...ple.Xcode.[[DevToolsInterface]] 	0x979bcf3c -[[[PBXDocumentController]] openDocument:] + 0x44
15  com.apple.[[AppKit]]               	0x92f276fc -[[[NSApplication]] sendAction:to:from:] + 0x6c
16  com.apple.[[AppKit]]               	0x92f5cf48 -[[[NSMenu]] performActionForItemAtIndex:] + 0x188
17  com.apple.[[AppKit]]               	0x92fa17f4 -[[[NSCarbonMenuImpl]] performActionWithHighlightingForItemAtIndex:] + 0x68
18  com.apple.[[AppKit]]               	0x92ede89c _NSHandleCarbonMenuEvent + 0x174
19  com.apple.[[AppKit]]               	0x92e825fc _DPSNextEvent + 0x4d0
20  com.apple.[[AppKit]]               	0x92e98d2c -[[[NSApplication]] nextEventMatchingMask:untilDate:inMode:dequeue:] + 0x74
21  com.apple.[[AppKit]]               	0x92ead0ac -[[[NSApplication]] run] + 0x21c
22  com.apple.[[AppKit]]               	0x92f697bc [[NSApplicationMain]] + 0x1d0
23  com.apple.Xcode                	0x0000a084 0x1000 + 0x9084
24  dyld                           	0x8fe1a278 _dyld_start + 0x64

Thread 1:
0   libSystem.B.dylib              	0x90017238 semaphore_wait_signal_trap + 0x8
1   libSystem.B.dylib              	0x9000ea1c _pthread_cond_wait + 0x270
2   com.apple.Foundation           	0x90a7c5f0 -[[[NSConditionLock]] lockWhenCondition:] + 0x44
3   com.apple.[[AppKit]]               	0x92e7a14c -[[[NSUIHeartBeat]] _heartBeatThread:] + 0x190
4   com.apple.Foundation           	0x90a6a510 forkThreadForFunction + 0x6c
5   libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

Thread 2:
0   libSystem.B.dylib              	0x900078b8 mach_msg_trap + 0x8
1   libSystem.B.dylib              	0x90007438 mach_msg + 0x38
2   com.apple.[[CoreFoundation]]       	0x901c15e8 __CFRunLoopRun + 0x350
3   com.apple.[[CoreFoundation]]       	0x901c5d74 [[CFRunLoopRunSpecific]] + 0x148
4   com.apple.Foundation           	0x90a2d1b8 -[[[NSRunLoop]] runMode:beforeDate:] + 0xac
5   com.apple.Foundation           	0x90a45dbc -[[[NSRunLoop]] run] + 0x4c
6   com.apple.Foundation           	0x90a98054 +[[[NSURLConnection]]([[NSURLConnectionInternal]]) _resourceLoadLoop:] + 0x20c
7   com.apple.Foundation           	0x90a6a510 forkThreadForFunction + 0x6c
8   libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

Thread 3:
0   libSystem.B.dylib              	0x900078b8 mach_msg_trap + 0x8
1   libSystem.B.dylib              	0x90007438 mach_msg + 0x38
2   com.apple.[[CoreFoundation]]       	0x901c15e8 __CFRunLoopRun + 0x350
3   com.apple.[[CoreFoundation]]       	0x901c5d74 [[CFRunLoopRunSpecific]] + 0x148
4   com.apple.Foundation           	0x90a2d1b8 -[[[NSRunLoop]] runMode:beforeDate:] + 0xac
5   com.apple.Foundation           	0x90a45dbc -[[[NSRunLoop]] run] + 0x4c
6   com.apple.Foundation           	0x90a98594 +[[[NSURLCache]] _diskCacheSyncLoop:] + 0xa8
7   com.apple.Foundation           	0x90a6a510 forkThreadForFunction + 0x6c
8   libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

Thread 4:
0   libSystem.B.dylib              	0x900078b8 mach_msg_trap + 0x8
1   libSystem.B.dylib              	0x90007438 mach_msg + 0x38
2   com.apple.[[CoreFoundation]]       	0x901c15e8 __CFRunLoopRun + 0x350
3   com.apple.[[CoreFoundation]]       	0x901c5d74 [[CFRunLoopRunSpecific]] + 0x148
4   com.apple.Foundation           	0x90a2d1b8 -[[[NSRunLoop]] runMode:beforeDate:] + 0xac
5   com.apple.Foundation           	0x90a45dbc -[[[NSRunLoop]] run] + 0x4c
6   com.apple.[[WebKit]]               	0x94ff2384 +[[[WebFileDatabase]] _syncLoop:] + 0xa8
7   com.apple.Foundation           	0x90a6a510 forkThreadForFunction + 0x6c
8   libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

Thread 5:
0   com.apple.[[CoreFoundation]]       	0x901c4ad0 __CFStringCreateImmutableFunnel3 + 0x74
1   com.apple.[[CoreFoundation]]       	0x901dde30 [[CFStringCreateWithCharacters]] + 0x3c
2   com.apple.[[LaunchServices]]       	0x919e9f60 _LSCopyDisplayNameForNode + 0x2b8
3   com.apple.[[LaunchServices]]       	0x919ea800 _LSCopyDisplayNameForRefInfo + 0xf8
4   com.apple.[[DesktopServices]]      	0x90943814 [[THFSPlusRef]]::[[SetDisplayName]](unsigned long, [[FSCatalogInfo]]&) + 0x58
5   com.apple.[[DesktopServices]]      	0x90942d44 [[THFSPlusRef]]::Set(bool, [[FSRef]] const&, HFSUniStr255 const'', short, unsigned long, bool, unsigned long, [[FSCatalogInfo]]'') + 0x150
6   com.apple.[[DesktopServices]]      	0x9094d498 [[THFSPlusIterator]]::Next([[THFSPlusRef]]&) + 0x188
7   com.apple.[[DesktopServices]]      	0x9094c408 [[THFSPlusSynchronizer]]::Next([[THFSPlusStore]]&) + 0x20
8   com.apple.[[DesktopServices]]      	0x9094f58c [[THFSPlusStore]]::[[CreateChildren]]([[TChildrenList]]&, [[TNodeTask]]'') + 0x98
9   com.apple.[[DesktopServices]]      	0x9095b470 [[TNode]]::[[CreateChildren]]([[TNode]]::[[StInitialCreate]] const&, [[TNodeTask]]'') + 0x48
10  com.apple.[[DesktopServices]]      	0x9095389c [[TNodeOpenSyncTask]]::[[OpenSyncTaskProc]](void'') + 0x12c
11  ...ple.[[CoreServices]].[[CarbonCore]] 	0x902f6b90 [[PrivateMPEntryPoint]] + 0x4c
12  libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

Thread 6:
0   libSystem.B.dylib              	0x90018e78 semaphore_timedwait_signal_trap + 0x8
1   libSystem.B.dylib              	0x9000ea14 _pthread_cond_wait + 0x268
2   ...ple.[[CoreServices]].[[CarbonCore]] 	0x902c5a50 [[MPWaitOnQueue]] + 0xe0
3   com.apple.[[DesktopServices]]      	0x90948e7c [[TNodeSyncTask]]::[[SyncTaskProc]](void'') + 0x70
4   ...ple.[[CoreServices]].[[CarbonCore]] 	0x902f6b90 [[PrivateMPEntryPoint]] + 0x4c
5   libSystem.B.dylib              	0x90024990 _pthread_body + 0x28

PPC Thread State:
  srr0: 0x901c114c srr1: 0x0200f030                vrsave: 0x00000000
    cr: 0x24044244  xer: 0x20000004   lr: 0x901c112c  ctr: 0x901c1120
    r0: 0x901c2c6c   r1: 0xbfffe550   r2: 0x00000209   r3: 0x00000001
    r4: 0xa2e8e9c4   r5: 0x00000000   r6: 0xa01c0dcc   r7: 0xa01c0dcc
    r8: 0xa01c0dcc   r9: 0xe385ef30  r10: 0x00000016  r11: 0x00000016
   r12: 0x901c1120  r13: 0x00000000  r14: 0x00000000  r15: 0x00000000
   r16: 0x00000000  r17: 0xbffff660  r18: 0x00000000  r19: 0x003014b0
   r20: 0xffffffff  r21: 0xa2ea2144  r22: 0x00000000  r23: 0x00000000
   r24: 0x019b4800  r25: 0x00000174  r26: 0xa2e8e9c4  r27: 0xa2e8e9c4
   r28: 0xd3a1b1c1  r29: 0xa01c3140  r30: 0x00000174  r31: 0x901c112c

Binary Images Description:
    0x1000 -    0x14fff com.apple.Xcode 1.1 (300)	/Developer/Applications/Xcode.app/Contents/[[MacOS]]/Xcode
   0xb6000 -    0xb7fff com.unsanity.snt Menu Extra Enabler version 0.0.1d1 (1.0)	/Users/poodimoos/Library/[[InputManagers]]/[[SafariNoTimeout]]/[[SafariNoTimeout]].bundle/Contents/[[MacOS]]/[[SafariNoTimeout]]
  0x265000 -   0x272fff com.apple.Xcode.[[BuildSettingsPanes]] 3.1 (300)	/Developer/Applications/Xcode.app/Contents/[[PlugIns]]/[[BuildSettingsPanes]].pbsettingspanespec/Contents/[[MacOS]]/[[BuildSettingsPanes]]
  0x289000 -   0x291fff com.apple.[[AppleScriptStudio]].[[ASKDebuggerPlugin]] 1.3.1 (36)	/Library/Application Support/Apple/Developer Tools/Plug-ins/[[ASKDebuggerPlugin]].pbplugin/Contents/[[MacOS]]/[[ASKDebuggerPlugin]]
  0x2ac000 -   0x2b7fff com.apple.[[AppleScriptStudio]].[[ASKDictionaryPlugin]] 1.3.1 (36)	/Library/Application Support/Apple/Developer Tools/Plug-ins/[[ASKDictionaryPlugin]].pbplugin/Contents/[[MacOS]]/[[ASKDictionaryPlugin]]
  0x2c8000 -   0x2cbfff com.apple.[[AppleScriptStudio]].[[ASKPlugin]] 1.3.1 (36)	/Library/Application Support/Apple/Developer Tools/Plug-ins/[[ASKPlugin]].pbplugin/Contents/[[MacOS]]/[[ASKPlugin]]
  0x2db000 -   0x2e1fff com.apple.xcode.plugins.[[DocViewerPlugIn]] 3.1 (287)	/Library/Application Support/Apple/Developer Tools/Plug-ins/[[DocViewerPlugIn]].pbplugin/Contents/[[MacOS]]/[[DocViewerPlugIn]]
  0x2ee000 -   0x2f4fff com.apple.[[DocViewerWebKit]] 3.1 (287)	/Library/Application Support/Apple/Developer Tools/Plug-ins/[[DocViewerPlugIn]].pbplugin/Contents/[[PlugIns]]/[[DocViewerWebKit]].bundle/Contents/[[MacOS]]/[[DocViewerWebKit]]
  0x61e000 -   0x623fff com.apple.j2ee.Assistant 1.0 (0.0.1d1)	/Library/Application Support/Apple/Developer Tools/Plug-ins/J2EEAssistant.pbplugin/Contents/[[MacOS]]/J2EEAssistant
  0x65d000 -   0x682fff com.apple.xcode.plugins.[[ProjectImporters]] 3.1 (294)	/Library/Application Support/Apple/Developer Tools/Plug-ins/Project Importers.pbplugin/Contents/[[MacOS]]/Project Importers
  0x700000 -   0x738fff com.apple.Xcode.[[GDBMIDebuggingPlugin]] 3.1 (300)	/Developer/Applications/Xcode.app/Contents/[[PlugIns]]/[[GDBMIDebugging]].pbplugin/Contents/[[MacOS]]/[[GDBMIDebugging]]
  0x7b3000 -   0x7d7fff com.apple.Xcode.[[JavaDebugging]] 3.1 (300)	/Developer/Applications/Xcode.app/Contents/[[PlugIns]]/[[JavaDebugging]].pbplugin/Contents/[[MacOS]]/[[JavaDebugging]]
0x806c0000 - 0x806e9fff libxslt.1.dylib 	/usr/lib/libxslt.1.dylib
0x80830000 - 0x8090efff libxml2.2.dylib 	/usr/lib/libxml2.2.dylib
0x87fa0000 - 0x87fe3fff com.apple.[[AppleScriptKit]] 1.3.1 (38)	/System/Library/Frameworks/[[AppleScriptKit]].framework/Versions/A/[[AppleScriptKit]]
0x8fe00000 - 0x8fe4ffff dyld 	/usr/lib/dyld
0x90000000 - 0x9014ffff libSystem.B.dylib 	/usr/lib/libSystem.B.dylib
0x901c0000 - 0x9026dfff com.apple.[[CoreFoundation]] 6.3.8 (299.36)	/System/Library/Frameworks/[[CoreFoundation]].framework/Versions/A/[[CoreFoundation]]
0x902b0000 - 0x90529fff com.apple.[[CoreServices]].[[CarbonCore]] 10.3.7	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/Frameworks/[[CarbonCore]].framework/Versions/A/[[CarbonCore]]
0x905a0000 - 0x90610fff com.apple.framework.[[IOKit]] 1.3.6 (???)	/System/Library/Frameworks/[[IOKit]].framework/Versions/A/[[IOKit]]
0x90640000 - 0x906c8fff com.apple.[[CoreServices]].[[OSServices]] 3.0.1	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/Frameworks/[[OSServices]].framework/Versions/A/[[OSServices]]
0x9071d000 - 0x90730fff libRIP.A.dylib 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/Resources/libRIP.A.dylib
0x90737000 - 0x907cafff com.apple.print.framework.[[PrintCore]] 3.3	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[PrintCore]].framework/Versions/A/[[PrintCore]]
0x90810000 - 0x90810fff com.apple.[[ApplicationServices]] 1.0 (???)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/[[ApplicationServices]]
0x90812000 - 0x90879fff com.apple.audio.[[CoreAudio]] 2.1.3	/System/Library/Frameworks/[[CoreAudio]].framework/Versions/A/[[CoreAudio]]
0x908d0000 - 0x908e6fff com.apple.[[JavaKit]] 3.1 (281)	/System/Library/[[PrivateFrameworks]]/[[JavaKit]].framework/Versions/A/[[JavaKit]]
0x90940000 - 0x909b3fff com.apple.[[DesktopServices]] 1.2.5	/System/Library/[[PrivateFrameworks]]/[[DesktopServicesPriv]].framework/Versions/A/[[DesktopServicesPriv]]
0x90a04000 - 0x90a10fff com.apple.help 1.0.1	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Help.framework/Versions/A/Help
0x90a20000 - 0x90b7bfff com.apple.Foundation 6.3.7 (500.59)	/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
0x90c32000 - 0x90c4cfff libresolv.9.dylib 	/usr/lib/libresolv.9.dylib
0x90d40000 - 0x90d40fff com.apple.Carbon 10.3 (???)	/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon
0x90d50000 - 0x90d6bfff com.apple.[[SystemConfiguration]] 1.7.1 (???)	/System/Library/Frameworks/[[SystemConfiguration]].framework/Versions/A/[[SystemConfiguration]]
0x90d7c000 - 0x90d8cfff com.apple.[[ImageCapture]] 2.1.5	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[ImageCapture]].framework/Versions/A/[[ImageCapture]]
0x90ec0000 - 0x90ec0fff com.apple.Cocoa 6.3 (???)	/System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
0x9102d000 - 0x91045fff com.apple.[[WebServices]] 1.1.1 (1.1.0)	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/Frameworks/[[WebServicesCore]].framework/Versions/A/[[WebServicesCore]]
0x910e0000 - 0x91133fff com.apple.bom 1.2.5 (63.2)	/System/Library/[[PrivateFrameworks]]/Bom.framework/Versions/A/Bom
0x91141000 - 0x91141fff com.apple.[[CoreServices]] 10.3 (???)	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/[[CoreServices]]
0x912e0000 - 0x912f7fff com.apple.[[LangAnalysis]] 1.5.4	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[LangAnalysis]].framework/Versions/A/[[LangAnalysis]]
0x91303000 - 0x9136cfff com.apple.htmlrendering 1.1.2	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[HTMLRendering]].framework/Versions/A/[[HTMLRendering]]
0x913a0000 - 0x9145ffff [[ColorSync]] 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[ColorSync]].framework/Versions/A/[[ColorSync]]
0x917f6000 - 0x91813fff com.apple.audio.[[SoundManager]] 3.9	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[CarbonSound]].framework/Versions/A/[[CarbonSound]]
0x919e7000 - 0x91a1ffff com.apple.[[LaunchServices]] 10.3.5 (98.4)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[LaunchServices]].framework/Versions/A/[[LaunchServices]]
0x91b30000 - 0x91b44fff libCGATS.A.dylib 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/Resources/libCGATS.A.dylib
0x91b60000 - 0x91b6bfff libCSync.A.dylib 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/Resources/libCSync.A.dylib
0x91e10000 - 0x91e7bfff com.apple.[[HTMLDisplay]] 1.3 (132)	/System/Library/[[PrivateFrameworks]]/[[HTMLDisplay]].framework/Versions/A/[[HTMLDisplay]]
0x91ebd000 - 0x91ef5fff com.apple.AE 1.4	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/AE.framework/Versions/A/AE
0x92070000 - 0x92096fff com.apple.[[FindByContent]] 1.4 (1.2)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[FindByContent]].framework/Versions/A/[[FindByContent]]
0x92170000 - 0x92357fff com.apple.security 2.4 (179)	/System/Library/Frameworks/Security.framework/Versions/A/Security
0x927f0000 - 0x92827fff com.apple.[[CFNetwork]] 1.2.2 (7)	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/Frameworks/[[CFNetwork]].framework/Versions/A/[[CFNetwork]]
0x92880000 - 0x92c05fff com.apple.[[HIToolbox]] 1.3.7 (???)	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[HIToolbox]].framework/Versions/A/[[HIToolbox]]
0x92de0000 - 0x92e30fff com.apple.[[HIServices]] 1.4.1 (0.0.1d1)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[HIServices]].framework/Versions/A/[[HIServices]]
0x92e70000 - 0x9336ffff com.apple.[[AppKit]] 6.3.9 (743.41)	/System/Library/Frameworks/[[AppKit]].framework/Versions/C/[[AppKit]]
0x93680000 - 0x93958fff com.apple.[[CoreGraphics]] 1.203.30 (???)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/[[CoreGraphics]]
0x939d0000 - 0x939d4fff libmathCommon.A.dylib 	/usr/lib/system/libmathCommon.A.dylib
0x93a50000 - 0x93a64fff libcups.2.dylib 	/usr/lib/libcups.2.dylib
0x93a6a000 - 0x93a7dfff com.apple.speech.synthesis.framework 3.2	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[SpeechSynthesis]].framework/Versions/A/[[SpeechSynthesis]]
0x93bec000 - 0x93c3afff com.apple.print.framework.Print 3.3	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Print.framework/Versions/A/Print
0x9400b000 - 0x94016fff com.apple.securityhi 1.2 (90)	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[SecurityHI]].framework/Versions/A/[[SecurityHI]]
0x941cd000 - 0x94259fff com.apple.ink.framework 101.1.4 (55.12)	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Ink.framework/Versions/A/Ink
0x94580000 - 0x9458ffff libPSRIP.A.dylib 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/Resources/libPSRIP.A.dylib
0x94596000 - 0x945a3fff com.apple.[[CommonPanels]] 1.2.1 (1.0)	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[CommonPanels]].framework/Versions/A/[[CommonPanels]]
0x945b0000 - 0x945b9fff libz.1.dylib 	/usr/lib/libz.1.dylib
0x94610000 - 0x9462afff libPDFRIP.A.dylib 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/[[CoreGraphics]].framework/Versions/A/Resources/libPDFRIP.A.dylib
0x94650000 - 0x946affff com.apple.[[SearchKit]] 1.0.2	/System/Library/Frameworks/[[CoreServices]].framework/Versions/A/Frameworks/[[SearchKit]].framework/Versions/A/[[SearchKit]]
0x946ed000 - 0x946fdfff com.apple.speech.recognition.framework 3.3	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[SpeechRecognition]].framework/Versions/A/[[SpeechRecognition]]
0x94da7000 - 0x94e60fff com.apple.QD 3.4.70 (???)	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/QD.framework/Versions/A/QD
0x94ea0000 - 0x94ee2fff com.apple.Xcode.[[DevToolsSupport]] 3.1 (300)	/System/Library/[[PrivateFrameworks]]/[[DevToolsSupport]].framework/Versions/A/[[DevToolsSupport]]
0x94fe0000 - 0x95077fff com.apple.[[WebKit]] 1.1 (312.5.2)	/System/Library/Frameworks/[[WebKit]].framework/Versions/A/[[WebKit]]
0x952b5000 - 0x952befff com.apple.[[DiskArbitration]] 2.0.5	/System/Library/[[PrivateFrameworks]]/[[DiskArbitration]].framework/Versions/A/[[DiskArbitration]]
0x952e0000 - 0x952e7fff com.apple.Xcode.[[DevToolsRemoteClient]] 3.1 (300)	/System/Library/[[PrivateFrameworks]]/[[DevToolsRemoteClient]].framework/Versions/A/[[DevToolsRemoteClient]]
0x95400000 - 0x95473fff com.apple.[[NavigationServices]] 3.3.3	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[NavigationServices]].framework/Versions/A/[[NavigationServices]]
0x954c0000 - 0x95ac6fff libBLAS.dylib 	/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
0x95b20000 - 0x95df0fff libLAPACK.dylib 	/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libLAPACK.dylib
0x95f00000 - 0x95f20fff libvMisc.dylib 	/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvMisc.dylib
0x96028000 - 0x960f0fff libcrypto.0.9.7.dylib 	/usr/lib/libcrypto.0.9.7.dylib
0x961b0000 - 0x96292fff com.apple.[[JavaScriptCore]] 1.1 (312.1.1)	/System/Library/Frameworks/[[WebKit]].framework/Versions/A/Frameworks/[[JavaScriptCore]].framework/Versions/A/[[JavaScriptCore]]
0x9689b000 - 0x9689bfff com.apple.audio.units.[[AudioUnit]] 1.3.3	/System/Library/Frameworks/[[AudioUnit]].framework/Versions/A/[[AudioUnit]]
0x9689d000 - 0x968b7fff com.apple.openscripting 1.2.1 (???)	/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/[[OpenScripting]].framework/Versions/A/[[OpenScripting]]
0x968d0000 - 0x969b2fff libicucore.A.dylib 	/usr/lib/libicucore.A.dylib
0x96aa0000 - 0x96acefff libssl.0.9.7.dylib 	/usr/lib/libssl.0.9.7.dylib
0x96b50000 - 0x96bdffff ATS 	/System/Library/Frameworks/[[ApplicationServices]].framework/Versions/A/Frameworks/ATS.framework/Versions/A/ATS
0x96c00000 - 0x96c6ffff libobjc.A.dylib 	/usr/lib/libobjc.A.dylib
0x96cb0000 - 0x96d9efff libiconv.2.dylib 	/usr/lib/libiconv.2.dylib
0x96de0000 - 0x96df0fff com.apple.vecLib 3.0.3 (vecLib 3.0.3)	/System/Library/Frameworks/vecLib.framework/Versions/A/vecLib
0x96ee0000 - 0x96ee8fff libbsm.dylib 	/usr/lib/libbsm.dylib
0x96f20000 - 0x971b7fff com.apple.Xcode.[[DevToolsCore]] 3.1 (300)	/System/Library/[[PrivateFrameworks]]/[[DevToolsCore]].framework/Versions/A/[[DevToolsCore]]
0x97345000 - 0x973b2fff libvDSP.dylib 	/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvDSP.dylib
0x973e0000 - 0x976cbfff com.apple.[[WebCore]] 1.1 (315.10.1)	/System/Library/Frameworks/[[WebKit]].framework/Versions/A/Frameworks/[[WebCore]].framework/Versions/A/[[WebCore]]
0x9784a000 - 0x97902fff com.apple.audio.toolbox.[[AudioToolbox]] 1.3.4	/System/Library/Frameworks/[[AudioToolbox]].framework/Versions/A/[[AudioToolbox]]
0x979b0000 - 0x97c8afff com.apple.Xcode.[[DevToolsInterface]] 3.1 (300)	/System/Library/[[PrivateFrameworks]]/[[DevToolsInterface]].framework/Versions/A/[[DevToolsInterface]]
</code>

Can anyone help me?

----

Repair permissions. Restart. Upgade to the newest Xcode version.

----

No success with that.

----
Try again without unsanity: com.unsanity.snt Menu Extra Enabler version 0.0.1d1 (1.0)
----

----
Delete your xcode preference file since it is crashing in the user defaults.
----

Already trashed prefs. I have no idea how to remove unsanity, since I have no idea how it got there in the first place. Hmmm...

----
----

I am having a different type of problem with [[XCode]].  When I am editing one specific document in my project, I will randomly get this error pop up, which will pop up about 40 times, with different values where [[CoursesAndTextbooks]] is:

http://burgundylogan.com/media/[[XCodeError]].jpg

checking the Logs, there is no [[XCode]] crash log, since clicking Quit isnt technically crashing, but the Console does say this a ton of times:

<code>
2006-06-05 14:14:01.767 Xcode[7243] Bad symbol compare @ row 955064
</code>

and then a random long piece with a lot of this:

<code>
l)+ Structure       declaration  line#   90 (null)+ Field           declaration  line#  189 (null)+ Parameter       declaration  line#  415 (null)+ Parameter       declaration  line#  385 (null)+ Parameter       declaration  line#   10 (null)+ Constant        declaration  line#  129 (null)+ Structure       declaration  line#  345 (null)+ Type            declaration  line#  280 (null)+ Type            declaration  line#  285 (null)+ Structure       declaration  line#  338 (null)+ Function        declaration  line#  480 (null)+ Type            declaration  line#  591 (null)+ Instance Method declaration  line#   93 (null)+ Instance Method declaration  line#   11 (null)+ Function        declaration  line#  344 (null)+ Macro           definition   line#   78 (null)+ Field           declaration  line#  443 (null)+ Constant        declaration  line# 1927 (null)+ Type            declaration  line#  300 (null)+ Parameter       declaration  line# 5020 (null)+ Instance Method declaration  line#  104 (null)+ Type            declaration  line#   14 (null)+ Function        declaration  line#  460 (null)+ Structure       declaration  line#  119 (null)+ Type            declaration  line#  120 (null)+ Function        declaration  line#   77 (null)+ Type            declaration  line#  169 (null)+ Function        declaration  line#  390 (null)+ Function        declaration  line#  202 (null)+ Function        declaration  line#  267 (null)+ Function        declaration  line#   90 (null)+ Function        declaration  line#  163 (null)+ Structure       declaration  line#  345 (null)+ Type            declaration  line#  280 (null)+ Type            declaration  line#  285 (null)+ Structure       declaration  line#  338 (null)+ Function        declaration  line#  480 (null)+ Type            declaration  line#  591 (null)+ Instance Method declaration  line#   93 (null)+ Instance Method declaration  line#   11 (null)+ Function        declaration  line#  344 (null)+ Macro           definition   line#   78 (null)+ Field           declaration  line#  443 (null)+ Constant        declaration  line# 1927 (null)+ Type            declaration  line#  300 (null)+ Parameter       declaration 
</code>

anybody know what's going on, or have any suggestions?  I have tried reinstalling [[XCode]], deleting the [[XCode]] prefs, and even reverting back to an old version of this specific file.  when I revert, this go okay, but if I add anything at all, the crashes start happening again (which i guess implies that its not some specific code i added).  thanks for the help. -- [[LoganRockmore]]

----
If adding anything makes the crash start again, that probably means your older version of the file is corrupted too. Keep going back to still older versions until you find one that's good. If you don't have still older versions, then consider recreating the project and using [[VersionControl]].

----
Yeah, I'm thinking that it might be a problem with [[XCode]].  I'm going to completely uninstall the version, and reinstall.  If that doesn't work, I'll try going back to 2.2.1 (from the CD that came with my [[MacBook]]).  Thankfully, I do already use [[SubVersion]], so I should be able to step back a while.  Thanks for the suggestions. -- [[LoganRockmore]]

----
Well, same problem happened with both fresh versions of [[XCode]].  I guess that my .xcodeproj file became corrupted, so I just recreated the whole thing, and things seem to be alright now.  Thanks for the help!  -- [[LoganRockmore]]

----
I had Xcode 2.3 crash on me repeatedly yesterday, on a project that has worked fine for weeks previous, under versions 2.1, 2.2, and 2.3.  The source of the problem a folder reference in my project.  I had mucked around and created some symbolic links of dubious merit within the folder being referenced in Xcode.  When opening the project, Xcode did some kind of referencing of those symlinks that sent it into a crashing tailspin.  Once I discovered the problem, removing the offending symlinks in the referenced folder made Xcode happy again. --[[BillGarrison]]

----
Thanks for this tip! That looks like a real bug, you might want to report it to Apple.