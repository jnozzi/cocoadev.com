I bind a custom General/NSMatrix this way :

[myMatrix bind:@"content" toObject:myArrayController withKeyPath:@"arrangedObjects" options:nil];

[myMatrix bind:@"contentValues" toObject:myArrayController withKeyPath:@"arrangedObjects.title" options:nil];

And that work fine with title, but what can I do if i want to bind pictures of the General/NSCell ?
Can I define a method in my General/NSMatrix subclass wich the bind "content" will use ?