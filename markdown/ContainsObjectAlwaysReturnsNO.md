I am new to Cooa programming. I use Aaron Hillegass' book. Having gone through the lottery example (Ch. 3), I was trying to play around, and modified the code so as to have an array of unique random numbers, i.e., each number appears once, and only once, in the array. If a new random number exists already in the array, it is discarded, and a new one is generated. The code looks like this:

    
int main (int argc, const char * argv[])
{
    General/NSMutableArray *array;
    int i;
    General/LotteryEntry *entry;
    
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
    
    //initialise the random number generator
    srandom(time(NULL));
    array = General/[[NSMutableArray alloc] init];
    
    for ( i = 0; [array count] < 10 ; i++) {
        //create a new instance of lottery entry
        entry = General/[[LotteryEntry alloc] initWithANumber];
        if (![array containsObject: entry]) { 
            [array addObject: entry];
        }
        //decrement the retain count of the lottery entry
        [entry release];
    }
...


General/LotteryEntry is an object containing only the number (without the date, as in the book).

Problem - I get duplicate/triplicate/etc. numbers in the array, apparently because [array containsObject: entry] returns NO always, so the IF test always evaluates to true, no matter what the number.

Can anyone explain what I am doing wrong?

TIA, Gidi

----

It sounds like you are trying to do an equality check, not a duplicate check. I'm assuming the class "General/LotteryEntry" is just a container for a number (i.e. General/NSNumber). If this is the case why don't you just use General/NSNumber? If General/NSNumber is the super class of General/LotteryEntry then your code should work because General/NSNumber does implement a method for "isEqual" (which is needed in order for an General/NSArray to perform the "containsObject" method). Hope that helps --zootbobbalu

oh yeah, it should go without saying that if General/NSNumber is not the superclass to General/LotteryEntry and if General/LotteryEntry does not implement the method "isEqual" then all you would have to do is add the following method to the class:

    
-(BOOL)isEqual:(id)obj {

    if ([self whateverTheGetterMethodIsForTheValue]==[obj whateverTheGetterMethodIsForTheValue]) return YES;
    else return NO;

}


----
Hmm, what I was trying to do was to avoid doing any checking myself, and let the predefined methods of General/NSArray and General/NSMutableArray do the work for me. I thought that the method containsObject should take care of all the details for me.

General/LotteryEntry is actually a container for an integer, just like in the example in Hillegass.

And, BTW, following the suggestion above, I defined an isEqual method, but no change - my array is still full of duplicates. No wonder, because if I put a breakpoint on the isEqual method I defined in my class, I see it is not called at all.

Sigh, I think I do not understand.

----

Part of your problem is that you need to add at least one object to the array first before the array needs to check anything --zootbobbalu 

BTW I don't have Hillegass's book, so I'm don't know what the getter method is to get the int value stored in the General/LotteryEntry instance. "whateverTheGetterMethodIsForTheValue" was just a hint. You have to replace this method call for the one that is implemented in the General/LotteryEntry class.

You know, I debated with myself if I should just let you have a "duh" moment (I usually like having them every now and then), but I decided to spare you the torture :-)
----
I'm ashamed to say that the IF statement was commented out, so quite naturally isEqual was not called. Once fixed, it works fine. Thanks for the tip, zootbobbalu. (And, btw, it works with General/NSNumber, too).

However, the deeper understanding still escapes me. Is the moral of this that I should always override a superclasses' methods I want to use to be sure they do what I want them to do? Or is it just isEqual that should always be redefined?

----

You don't need to redefine the "isEqual" method if the superclass already implements it. You only need to redefine "isEqual" if you want to customize how your objects decides if it is equal to another object. But in your case, if the General/LotteryEntry class doesn't respond to an "isEqual" message, then you needed to implement an "isEqual" method. There's no harm in redefining a superclass method to keep on top of things (I do it all the time). Just remember that if you redefine a method which also uses the superclass's implementation, you are taking a slight speed hit because two messages are involved. --zootbobbalu

----

It is not mentioned here, and maybe this is missing in your way to the big understanding. The default -isEqual: method simply checks for the identity of the two pointers of the objects to compare. But even if two objects have the same contents they are not necessarily the same. If your wallet has 10 $ in it and mine too, you could say they are equal, or you could say they are different, because they are not in the same pocket; for sure, your wallet is equal to your wallet, no matter what (assuming you have only one wallet...).

Using General/NSNumber makes your life easier (at least for this), because it has isEqual already implemented.