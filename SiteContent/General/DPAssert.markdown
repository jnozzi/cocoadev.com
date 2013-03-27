General/DPAssert is an assertion macro identical to General/NSAssert, except it can handle any number of arguments to its format string. There's no need to use variants like NSAssert2 to use more arguments.

    
@class General/NSAssertionHandler, General/NSString;

/* Asserts for Objective-C that accepts unlimited number of arguments */
#if !defined(NS_BLOCK_ASSERTIONS)

#if !defined(General/DPAssert)
/*
 * The usage of this macro is the same as with General/NSAssert, exept you don't need DPAssert1, DPAssert2, etc.
 * This macro accepts any number of arguments passed to the description.
 */
#define General/DPAssert(condition, desc...)\
do {\
	if (!(condition)) {\
		General/[[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd\
															object:self\
															  file:General/[NSString stringWithUTF8String:__FILE__] \
														lineNumber:__LINE__\
													   description:desc];\
	}\
} while(0)
#endif

#if !defined(General/DPCAssert)
/*
 * The usage of this macro is the same as with General/NSAssert, exept you don't need DPAssert1, DPAssert2, etc.
 * This macro accepts any number of arguments passed to the description.
 */
#define General/DPCAssert(condition, desc...)\
do {\
	if (!(condition)) {\
		General/[[NSAssertionHandler currentHandler] handleFailureInFunction:General/[NSString stringWithUTF8String:__PRETTY_FUNCTION__]\
																file:General/[NSString stringWithUTF8String:__FILE__] \
														  lineNumber:__LINE__\
														 description:desc];\
	}\
} while(0)
#endif

#endif	// !defined(NS_BLOCK_ASSERTIONS)


-General/OfriWolfus