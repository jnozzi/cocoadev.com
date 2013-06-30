Before I go and reinvent the wheel, does anyone have any code to parse a .plist file and display it in a General/NSOutlineView? I need to do something similar to General/PropertyListEditor.
----
Here is something to start with... I did not write it to the end, because I am almost as lazy as you! :)
    
void add_entry (id src, General/NSMutableArray* dst, General/NSString* name)
{
   General/NSMutableDictionary* entry = General/[NSMutableDictionary dictionaryWithObjectsAndKeys:
      name, @"label",
      src, @"object",
      nil];

   if([src isKindOfClass:General/[NSArray class]])
   {
      General/NSMutableArray* children = General/[NSMutableArray array];
      for(unsigned i = 0; i != [src count]; ++i)
         add_entry([src objectAtIndex:i], children, General/[NSString stringWithFormat:@"%ud", i]);
      [entry setObject:children forKey:@"children"];
   }
   else if([src isKindOfClass:General/[NSDictionary class]])
   {
      General/NSMutableArray* children = General/[NSMutableArray array];
      General/NSEnumerator* enumerator = [src keyEnumerator];
      while(id key = [enumerator nextObject])
         add_entry([src objectForKey:key], children, key);
      [entry setObject:children forKey:@"children"];
   }
   else ...
   {
      ...
   }
   [dst addObject:entry];
}

// load data in init
- (id)initWithPath:(General/NSString*)aPath
{
   if(self = [super init])
   {
      General/NSDictionary* tmp = General/[NSDictionary dictionaryWithContentsOfFile:aPath];
      plist = General/[[NSMutableArray alloc] init];
      add_entry(tmp, plist, @"root");
   }
   return self;
}

// data source methods
- (int)outlineView:(General/NSOutlineView*)outlineView numberOfChildrenOfItem:(id)item
{
   General/NSArray* array = item ? [item objectForKey:@"children"] : plist;
   return array ? [array count] : 0;
}

- (BOOL)outlineView:(General/NSOutlineView*)outlineView isItemExpandable:(id)item
{
   return [item objectForKey:@"children"] != nil;
}

- (id)outlineView:(General/NSOutlineView*)outlineView child:(int)index ofItem:(id)item
{
   General/NSArray* array = item ? [item objectForKey:@"children"] : plist;
   return [array objectAtIndex:index];
}

- (id)outlineView:(General/NSOutlineView*)outlineView objectValueForTableColumn:(General/NSTableColumn*)tableColumn byItem:(id)item
{
   return [item objectForKey:[tableColumn identifier]];
}
