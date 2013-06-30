

A test function for General/LSTrampoline.

    
void General/LSHOMTest(void)
{
	General/NSArray *one = [@"one two three four five six seven eight nine ten" componentsSeparatedByString:@" "];
	General/NSArray *two = General/one select] hasPrefix:@"t"];
	[[NSArray *three = General/two reject] hasSuffix:@"e"];
	[[NSArray *four = General/three collect] stringByAppendingString:@" potato"];
	[[NSArray *five = General/one collect] mutableCopy];
	[[five do] appendString:@"_vegetable"];
	
	[[NSLog(@"%@", one);
	General/NSLog(@"%@", two);
	General/NSLog(@"%@", three);
	General/NSLog(@"%@", four);
	General/NSLog(@"%@", five);
}


I ran this just now, and here is the output:

    
2003-02-25 02:46:05.669 Lodestone[1360] (one, two, three, four, five, six, seven, eight, nine, ten)
2003-02-25 02:46:05.706 Lodestone[1360] (two, three, ten)
2003-02-25 02:46:05.707 Lodestone[1360] (two, ten)
2003-02-25 02:46:05.707 Lodestone[1360] ("two potato", "ten potato")
2003-02-25 02:46:05.708 Lodestone[1360] (
    "one_vegetable", 
    "two_vegetable", 
    "three_vegetable", 
    "four_vegetable", 
    "five_vegetable", 
    "six_vegetable", 
    "seven_vegetable", 
    "eight_vegetable", 
    "nine_vegetable", 
    "ten_vegetable"
)


-- General/RobRix