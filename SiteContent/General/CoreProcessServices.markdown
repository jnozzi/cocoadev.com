    
// CPS.h

#pragma once

#include <Carbon/Carbon.h>


#ifdef __cplusplus
extern "C" {
#endif

#if PRAGMA_STRUCT_ALIGN
    #pragma options align=mac68k
#elif PRAGMA_STRUCT_PACKPUSH
    #pragma pack(push, 2)
#elif PRAGMA_STRUCT_PACK
    #pragma pack(2)
#endif


struct General/CPSProcessSerNum
{
	UInt32		lo;
	UInt32		hi;
};

typedef struct General/CPSProcessSerNum	General/CPSProcessSerNum;

enum
{
	kCPSNoProcess		=	0,
	kCPSSystemProcess	=	1,
	kCPSCurrentProcess	=	2
};


enum
{
	bfCPSIntraProcessSwitch =	1,
	bfCPSDeathBySignal	=	2
};

typedef UInt16	General/CPSEventFlags;


enum
{
	kCPSBlueApp	=	0,
	kCPSBlueBox	=	1,
	kCPSCarbonApp	=	2,
	kCPSYellowApp	=	3,
	kCPSUnknownApp	=	4
};

typedef UInt32	General/CPSAppFlavour;


enum
{
	kCPSBGOnlyAttr		=	1024,
	kCPSUIElementAttr	=	65536,
	kCPSHiddenAttr		=	131072,
	kCPSNoConnectAttr	=	262144,
	kCPSFullScreenAttr	=	524288,
	kCPSClassicReqAttr	=	1048576,
	kCPSNativeReqAttr	=	2097152,
        kCPSMenuBarHiddenAttr	=	805306368
};

typedef UInt32	General/CPSProcAttributes;


struct General/CPSProcessInfoRec
{
	General/CPSProcessSerNum 	Parent;
	UInt64			General/LaunchDate;
	General/CPSAppFlavour		Flavour;
	General/CPSProcAttributes	Attributes;
	UInt32			General/ExecFileType;
	UInt32			General/ExecFileCreator;
	UInt32			General/UnixPID;
};

typedef struct General/CPSProcessInfoRec	General/CPSProcessInfoRec;


enum
{
	kCPSNotifyChildDeath	=	1,
	kCPSNotifyNewFront	=	2,
	kCPSNotifyAppBirth	=	4,
	kCPSNotifyAppDeath	=	8,
	kCPSNotifyLaunch	=	9,
	kCPSNotifyServiceReq	=	16,
	kCPSNotifyAppHidden	=	32,
	kCPSNotifyAppRevealed	=	64,
	kCPSNotifyFGEnabled	=	128,
	kCPSNotifyLaunchStart	=	256,
	kCPSNotifyAppReady	=	512,
	kCPSNotifyLaunchFail	=	1024,
	kCPSNotifyAppDeathExt	=	2048,
	kCPSNotifyLostKeyFocus	=	4096
};

typedef UInt32	General/CPSNotificationCodes;


enum
{
	bfCPSLaunchInhibitDaemon	=	128,
	bfCPSLaunchDontSwitch		=	512,
	bfCPSLaunchNoProcAttr		=	2048,
	bfCPSLaunchAsync		=	65536,
	bfCPSLaunchStartClassic		=	131072,
	bfCPSLaunchInClassic		=	262144,
	bfCPSLaunchInstance		=	524288,
	bfCPSLaunchAndHide		=	1048576,
	bfCPSLaunchAndHideOthers	=	2097152
};

typedef UInt32	General/CPSLaunchOptions;


typedef	UInt8	*General/CPSLaunchRefcon;


typedef	UInt8	*General/CPSLaunchData;


enum
{
	bfCPSExtLaunchWithData	=	2,
	bfCPSExtLaunchByParent	=	4,
	bfCPSExtLaunchAsUidGid	=	8
};

typedef UInt32	General/CPSLaunchPBFields;


struct General/CPSLaunchPB
{
	General/CPSLaunchPBFields	Contents;
	General/CPSLaunchData		pData;
	UInt32			General/DataLen;
	UInt32			General/DataTag;
	UInt32			General/RefCon;
	General/CPSProcessSerNum	Parent;
	UInt32			General/ChildUID;
	UInt32			General/ChildGID;
};

typedef struct General/CPSLaunchPB	General/CPSLaunchPB;


enum
{
	bfCPSKillHard		=	1,
	bfCPSKillAllClassicApps	=	2
};

typedef UInt32	General/CPSKillOptions;


enum
{
	kCPSLaunchService	=	0,
	kCPSKillService		=	1,
	kCPSHideService		=	2,
	kCPSShowService		=	3,
	kCPSPrivService		=	4,
	kCPSExtDeathNoteService	=	5
};

typedef UInt32	General/CPSServiceReqType;


struct General/CPSLaunchRequest
{
	General/CPSProcessSerNum	General/TargetPSN;
	General/CPSLaunchOptions 	Options;
	General/CPSProcAttributes 	General/ProcAttributes;
	UInt8			*pUTF8TargetPath;
	UInt32			General/PathLen;
};

typedef struct General/CPSLaunchRequest	General/CPSLaunchRequest;


struct General/CPSKillRequest
{
	General/CPSProcessSerNum	General/TargetPSN;
	General/CPSKillOptions		Options;
};

typedef struct General/CPSKillRequest	General/CPSKillRequest;


struct General/CPSHideRequest
{
	General/CPSProcessSerNum 	General/TargetPSN;
};

typedef struct General/CPSHideRequest	General/CPSHideRequest;


struct General/CPSShowRequest
{
	General/CPSProcessSerNum 	General/TargetPSN;
};

typedef struct General/CPSShowRequest	General/CPSShowRequest;


struct General/CPSExtDeathNotice
{
	General/CPSProcessSerNum 	General/DeadPSN;
	UInt32			Flags;
	UInt8			*pUTF8AppPath;
	UInt32			General/PathLen;
};

typedef struct General/CPSExtDeathNotice	General/CPSExtDeathNotice;


union General/CPSRequestDetails
{
	General/CPSLaunchRequest 	General/LaunchReq;
	General/CPSKillRequest 		General/KillReq;
	General/CPSHideRequest 		General/HideReq;
	General/CPSShowRequest 		General/ShowReq;
	General/CPSExtDeathNotice 	General/DeathNotice;
};

typedef union General/CPSRequestDetails	General/CPSRequestDetails;


struct General/CPSServiceRequest
{
	General/CPSServiceReqType 	Type;
	SInt32			ID;
	General/CPSRequestDetails 	Details;
};

typedef struct General/CPSServiceRequest	General/CPSServiceRequest;


enum
{
	kCPSProcessInterruptKey	=	0,
	kCPSAppSwitchFwdKey	=	1,
	kCPSAppSwitchBackKey	=	2,
	kCPSSessionInterruptKey	=	3,
	kCPSScreenSaverKey	=	4,
	kCPSDiskEjectKey	=	5,
	kCPSSpecialKeyCount	=	6
};

typedef SInt32	General/CPSSpecialKeyID;


extern Boolean	General/CPSEqualProcess( General/CPSProcessSerNum *psn1, General/CPSProcessSerNum *psn2);

extern General/OSErr	General/CPSGetCurrentProcess( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSGetFrontProcess( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSGetNextProcess( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSGetNextToFrontProcess( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSGetProcessInfo( General/CPSProcessSerNum *psn, General/CPSProcessInfoRec *info, char *path, int maxPathLen, int *len, char *name, int maxNameLen);

extern General/OSErr	General/CPSPostHideMostReq( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSPostHideReq( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSPostKillRequest( General/CPSProcessSerNum *psn, General/CPSKillOptions options);

extern General/OSErr	General/CPSPostShowAllReq( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSPostShowReq( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSSetFrontProcess( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSReleaseKeyFocus( General/CPSProcessSerNum *psn);

extern General/OSErr	General/CPSStealKeyFocus( General/CPSProcessSerNum *psn);


#if PRAGMA_STRUCT_ALIGN
    #pragma options align=reset
#elif PRAGMA_STRUCT_PACKPUSH
    #pragma pack(pop)
#elif PRAGMA_STRUCT_PACK
    #pragma pack()
#endif

#ifdef __cplusplus
}
#endif

