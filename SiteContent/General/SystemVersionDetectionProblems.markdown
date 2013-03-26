Hello there, I am having trouble getting my code to detect the current operating system using Gestalt, I am running 10.3.

[[NSProcessInfo]] Category:<code>typedef enum {
	[[TRUnknownVersion]] = -1,
	[[TRCheetahVersion]] = 0,
	[[TRPumaVersion]] = 1,
	[[TRJaguarVersion]] = 2,
	[[TRPantherVersion]] = 3,
	[[TRTigerVersion]] = 4
} [[TROperatingSystemVersion]];

+ ([[TROperatingSystemVersion]])operatingSystemVersion
{
	long response;
	
	if (Gestalt(gestaltSystemVersion,(SInt32 '')&response) != noErr)
	{
		return [[TRUnknownVersion]];
	}
	
	switch (response)
	{
		case 0x1000:
		{
			return [[TRCheetahVersion]];
			break;
		}
		case 0x1020:
		{
			return [[TRJaguarVersion]];
			break;
		}
		case 0x1030:
		{
			return [[TRPantherVersion]];
			break;
		}
		case 0x1040:
		{
			return [[TRTigerVersion]];
			break;
		}
	}
}
</code>

Code I am using to test it:<code>- action:(id)sender
{
	switch ([[[NSProcessInfo]] operatingSystemVersion]) {
		case [[TRUnknownVersion]]: default:
		{
			[[NSLog]](@"Unknown");
			break;
		}
		case [[TRCheetahVersion]]:
		{
			[[NSLog]](@"10.0");
			break;
		}
		case [[TRPumaVersion]]:
		{
			[[NSLog]](@"10.1");
			break;
		}
		case [[TRJaguarVersion]]:
		{
			[[NSLog]](@"10.2");
			break;
		}
		case [[TRPantherVersion]]:
		{
			[[NSLog]](@"10.3");
			break;
		}
		case [[TRTigerVersion]]:
		{
			[[NSLog]](@"10.4");
			break;
		}
	}
}</code>

It always ends up telling me that it is 10.0 (or 0 basically) no matter how I create the enum'd value. I haven't had much experiance with Gestalt but it seems like I am doing the correct things, unfortunately I can't test the current [[AppKit]] version or I would.

----

is SInt32 equivalent to a long? ''And are you sure it's signed? (My previous comment was wrong...sorry)''

----

First of all, initialize the value that you are passing as response.  That way you can make sure that it isn't just being used as bogus stack data.  Variables should ALWAYS be initialized!  Also, why not use the SInt32 type instead of using a long and then casting?

That said, the cast may be an issue.  I have heard of problems like this before where a cast is considered a temporary variable so it doesn't need to persist for any length of time.  In this case of something like this, it could cause a problem.  That issue is probably just a C++ ism and usually only shows up at higher optimization levels.

Also, the function doesn't necessarily return anything in particular since the fall-through isn't caught so you are quite likely getting some random random data returned.  It is probably a good idea to only return a variable which is initialized to something eye-catching and only assigned in the cases.  Generally speaking, explicit returns are a bad thing for code quality and maintenance.

Additionally, you should probably use the 0 enum value to be something invalid since 0 is a very common value for random data.

----

Thanks for the rash response. Continuing, I was using sample code to do this, I rewrote it completely from scratch and it worked. I am using the int values to correspond to the versions of [[MacOS]] X. Anyways I fixed it for all who are interested.

<code>enum {
	kSystemVersionCheetah = 0x01000,
	kSystemVersionPuma = 0x01010,
	kSystemVersionJaguar = 0x01020,
	kSystemVersionPanther = 0x01030,
	kSystemVersionTiger = 0x01040,
	kSystemVersionMaxKnown = kSystemVersionTiger
};

- ([[TROperatingSystemVersion]])operatingSystemVersion
{
	long response = NULL;
	Gestalt(gestaltSystemVersion, &response);
	
	if (response > kSystemVersionMaxKnown) return [[TRGreaterVersion]];
	if (response >= kSystemVersionTiger) return [[TRTigerVersion]];
	if (response >= kSystemVersionPanther) return [[TRPantherVersion]];
	if (response >= kSystemVersionPanther) return [[TRJaguarVersion]];
	if (response >= kSystemVersionPanther) return [[TRPumaVersion]];
	if (response >= kSystemVersionPanther) return [[TRCheetahVersion]];
	return [[TRUnknownVersion]];
}</code>



----
No, that code is still flawed.
<code>
	if (response >= kSystemVersionPanther) return [[TRJaguarVersion]];
	if (response >= kSystemVersionPanther) return [[TRPumaVersion]];
	if (response >= kSystemVersionPanther) return [[TRCheetahVersion]];
</code>
Is wrong.
----
Okay, whatever.