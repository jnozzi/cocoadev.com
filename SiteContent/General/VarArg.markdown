[[VarArg]] refers to the capacity in a method or function for it to take a variable number of arguments above a fixed minimum. You declare a function with a variable number of arguments (var args) like this:

<code>void myFunc(int a, ...);</code>

and a vararg method like this:

<code>-(void)myMethod:(int)a, ...;</code>

The ellipsis is three periods in a row, and is how the compiler knows that this function/method can take more arguments after the explicitly specified ones.

An example of a vararg function is [[NSLog]], which lets you pass a variable number of arguments after the initial [[NSString]].

See also: [[UsingVariableNumbersOfArguments]], [[VarArgsInObjCMethods]], [[VariableLengthArgumentLists]].