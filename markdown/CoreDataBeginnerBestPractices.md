

Hi all,

I am a student and been using Cocoa for just a short while now, and am trying to get my head around General/CoreData. I have a simple question about custom code in a mutator:

Without General/CoreData I would just write a data object as a subclass of General/NSObject, and if I wanted to trigger something on the 'setting' of an instance variable, I would just add a line of code into that IV's mutator to call whatever I needed. 

Now, I'd like a bit of advice on the best way to do this when I have General/CoreData managing my entities. For example, I have an entity which is a subclass of an General/NSManagedObject, now the General/CoreData way to set an IV is to call setValue:General/ForKey:. But this doesn't give me an opportunity to trigger some custom code on the 'setting' of that instance variable. It seems to me that I should write a new mutator method in my General/NSManagedObject subclass, this method is responsible for calling setValue:General/ForKey: on 'self' and then I can continue with my custom line of code below that. Is this a sensible way to do things?

Thanks for the advice,

- Pete

----

You can add a setXXXX method to your subclass, where XXXX is your General/CoreData key. In this method, you need to do manual KVO, e.g.:

    
- (void)setIndentifier:(General/NSString *)identifierNew
{
	[self willChangeValueForKey:@"identifier"];
	[self setPrimitiveValue:identifierNew forKey:@"identifier"];
	[self didChangeValueForKey:@"identifier"];
}


You can add whatever is needed in this call.

Note that this is documented in Apple's documentation. Read the General/CoreData documentation ;-)

Addendum: the reason why you use 'setPrimitiveValue:forKey:' is that 'setValue:forKey:' will actually call setXXXX if it exists, so you would get an infinite recursion  if you used it.