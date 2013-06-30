A Foundation function to return the class by giving it the name as string.

    id myObj = General/[[NSClassFromString(@"General/MySpecialClass") alloc] init];
is equal to:
    id myObj = General/[[MySpecialClass alloc] init];

----
This is very useful when trying to use the General/JavaBridge (deprecated or not). Because Java classes are not integrated into the program until runtime, you have to use General/NSClassFromString to reach them. Example:
    
Class General/JavaArrayList = General/NSClassFromString(@"java.util.General/ArrayList");
id myJavaArrayList = General/[[JavaArrayList alloc] init];
// You can also combine these two calls, as seen above.
