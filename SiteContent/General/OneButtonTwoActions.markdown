

Is this possible?  I have a Data.m and Categories.m files, and I want a delete button that removes all Data and Categories, which are stored as General/NSMutableArrays in their respective files.  Is this possible, with the one button?  Thanks...

----

If you create a subclass of General/NSObject, and write an action that performs those two methods, (i.e. [dataArray setContent:nil];) for each array and then connect the action to the button in IB. Just off the top of my head maybe this will work for you:

    
- (void)deleteEverything:(id)sender {

[dataArray setContent:nil];
[categoryArray setContent:nil];

}


 --General/LoganCollins

----

Let me explain to be a little clearer.  I have arrays in the General/NSUserDefaults, and they are made into General/NSMutableArray<nowiki/>s in their respective .m files.  So, what I need to do is access the General/NSMutableArray<nowiki/>s in both seperate .m files.  I think the easiest way to do this would be to have the one button perform two actions, one in each Controller.  Is this possible?

*Well, Logan's idea basically does just that, except that     dataArray and     categoryArray need to be changed to     dataController and     categoryController. These two variables should be General/IBOutlet<nowiki/>s of a third class, and the button is hooked up to this class'     deleteEverything: method. If you want, you can change the     setContent: method to a     delete: General/IBAction, which can still be triggered from code. Oh, and     void should be changed to     General/IBAction (it's not mandatory, but it's a bit more explanatory). --General/JediKnil.*

I think the idea here is not to have a button that has 2 actions, as interface builder is not going to let you. Logan's idea is essentially the only way to do it. While your button cannot have 2 actions, an General/NSObject can have a method that does 2 things (or as many things as you want it to). So to simplify what Logan and General/JediKnil said, Your button CANNOT have 2 actions, BUT, your button can access an object that will access both of those .m files for you. --General/FreedomDumlao

*Or, put another way, your button's one action can call any other actions it wants.*