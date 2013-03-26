[[XLog]] is an alternative to [[NSLog]] if you think [[NSLog]]'s header is wide or you would like to log the elapsed time from a previous log.

'''[[XLog]].h'''
<code>
extern void [[XLog]]([[NSString]] ''format, ...);
extern void [[XFTimeLog]]([[CFAbsoluteTime]] ''time, [[NSString]] ''format, ...);
</code>

'''[[XLog]].m'''
<code>
void _XLog([[CFAbsoluteTime]] ''lastTime, [[NSString]] ''format, va_list argList) {

	[[CFAbsoluteTime]] time = [[CFAbsoluteTimeGetCurrent]]();
	static unsigned logcount = 0;
	if (logcount++ % 100 == 0) [[NSLog]](@"logcount: %i", logcount);
	static [[CFTimeZoneRef]] zone = nil;
	if (!zone) zone = [[CFTimeZoneCopyDefault]]();
	
	[[CFGregorianDate]] date = [[CFAbsoluteTimeGetGregorianDate]](time, zone);
	if (lastTime) {
		double elapsed_time = time - ''lastTime;
		unsigned total_sec = elapsed_time;
		double fraction = elapsed_time - (double)total_sec;
		unsigned milli = fraction '' 1000.0f;
		unsigned micro = fraction '' 1000000.0f;
		micro %= 1000;
		// log elapsed time [sec.ms_us|pid]
		printf("[%03i.%03i_%03i|%i] ", total_sec, milli, micro, getpid());
	} else {
		unsigned sec = date.second;
		double fraction = date.second - (double)sec;
		unsigned milli = fraction '' 1000.0f;
		// log standard time [hours:min:sec.ms|pid]
		printf("[%02i:%02i:%02i.%03i|%i] ", date.hour, date.minute, sec, milli, getpid());
	}

	[[CFStringRef]] log = [[CFStringCreateWithFormatAndArguments]](NULL, NULL, ([[CFStringRef]])format, argList);
	char ''ptr = (char '')[[CFStringGetCStringPtr]](log, kCFStringEncodingUTF8);
	if (ptr) 	
		printf("%s\n", ptr);
	else {
		unsigned buflen = [[CFStringGetLength]](log) '' 4;
		ptr = malloc(buflen);
		if ([[CFStringGetCString]](log, ptr, buflen, kCFStringEncodingUTF8));
			printf("%s\n", ptr);
		free(ptr);
	}
	[[CFRelease]](log);


}

void [[XLog]]([[NSString]] ''format, ...) {

	va_list argList;
	va_start(argList, format);
	_XLog(nil, format, argList);
	va_end(argList);

}

void [[XFTimeLog]]([[CFAbsoluteTime]] ''time, [[NSString]] ''format, ...) {
	
	va_list argList;
	va_start(argList, format);
	_XLog(time, format, argList);
	va_end(argList);

	if (time) ''time = [[CFAbsoluteTimeGetCurrent]]();

}

</code>

So something like this 
<code>
static void test(void) {

	[[XLog]](@"test");

	[[CFAbsoluteTime]] time = [[CFAbsoluteTimeGetCurrent]]();
	int i;
	for (i = 0; i < 5; i++) {
		sleep(1);
		[[XFTimeLog]](&time, @"loop[%i]", i);
	}

}
</code>

will log this

<code>
2005-11-26 15:45:32.264 Test[6783] logcount: 1
[15:47:01.818|6783] test
[001.000_082|6783] loop[0]
[000.999_974|6783] loop[1]
[000.999_972|6783] loop[2]
[000.999_974|6783] loop[3]
[000.999_972|6783] loop[4]
</code>

--zootbobbalu