Is there a runtime function that can give the size of a type by name? I am working on a sprintf like function and would like an easier way to type the va_list when scanning the format. I guess I could create a lookup table for a limited number of types (e.g. "%i", "%f", "%s"), but I would like to allow full type descriptions. Here's a crude example of what I would like to do.

<code>
void [[FunctionWithVariableArguments]](char ''format, ...) {
    /''
        scan format for type info and number of arguments
    ''/
    int i, argc;
    char '''argv = [[FormatScanner]](format, &argc);
    va_list argList;
    va_start(argList, request);
    for (i = 0; i < argc; i++) {
		unsigned sizeOfArg = [[SizeOfType]](argv[i]);
		switch (sizeOfArg) {
			case 1:;
				UInt8 arg8 = va_arg(argList, UInt8);
				break;
			case 2:;
				UInt16 arg16 = va_arg(argList, UInt16);
				break;
			case 4:;
				UInt32 arg32 = va_arg(argList, UInt32);
				break;
			case 8:;
				UInt64 arg64 = va_arg(argList, UInt64);
				break;
			default: break;
		}
    }
    va_end(argList);
    if (argv) free(argv);

}

</code>

An example of a call to this function:

<code>
    [[FunctionWithVariableArguments]]("nameForArg0:(int '') nameForArg1:(UInt32)", (int '')NULL, (UInt32)0);
</code>

The type info is tagged with parentheses. I basically want a runtime function that acts like the sizeof operator. --zootbobbalu

----

Type names simply don't exist at runtime. You type "UInt32", but when that gets compiled, you won't find "UInt32" anywhere in the resulting code, just code that knows that it's working with a 32-bit unsigned integer.

You're basically doomed to creating a lookup table. Worse, stuff like UInt32 is typedef'd, and there's an unlimited number of possible typedefs that could exist.

To make the table easier, you might want to write a #define, like:

<code>
#define SIZE_ENTRY(type) sizeof(type), #type

struct { int size; char ''name; } table[] = {
   SIZE_ENTRY(int), ...
</code>

But this is pretty poor.

A better bet would be to force your callers to use <code>@encode</code>. Writing a full parser for <code>@encode</code> strings will not be fun, but it is at least fully specified, and you'd be able to handle any primitive type as well as stuff like structs.

----

I've written a more-or-less working parser for <code>@encode()</code>d types: gives you the size and alignment of any Objective-C type string. Check out the [[LuaObjCBridge]] at www.pixelballistics.com.

Or, if you're not interested in ''how'' it works and you just want something to ''work'', use <code>[[NSGetSizeAndAlignment]]()</code>, described at http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Functions/[[FoundationFunctions]].html#//apple_ref/doc/uid/20000055-DontLinkElementID_6178a

--[[ToM]]

''Doh! I should have known Apple already provided something.''