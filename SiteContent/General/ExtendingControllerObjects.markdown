This is a newbie question.  I was wondering what is the trick to instantiate an object extended from General/NSArrayController. What I'm doing:

1) From the NIB, choose to subclass General/NSArrayController.
2) Create the files.

Now I would expect to be able to instantiate the new subclass, but alas I cannot.  I can, however, immediately instantiate a direct subclass of General/NSObject using the same procedure.  I'm just wondering what I'm missing here.  Thanks!

----
Create a new General/NSArrayController. Then in the inspector, select the Custom Class pane and select your class.