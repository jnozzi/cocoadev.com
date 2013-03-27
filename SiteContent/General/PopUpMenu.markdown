General/NSView's have a method to associate an event with a context menu (    menuForEvent:). Here's an example of how you can use this method: --zootbobbalu

*some custom view*
    
- (void)copyToPasteboard:(id)sender {General/NSLog(@"copyToPasteboard");}
- (void)deleteFile:(id)sender {General/NSLog(@"deleteFile");}
- (void)openInTextEdit:(id)sender {General/NSLog(@"openInTextEdit");}
- (void)showInFinder:(id)sender {General/NSLog(@"showInFinder");}

- (General/NSMenu *)menuForRightMouseDownEvent {
    General/NSDictionary *editInfo, *info;
    editInfo = General/[NSMenu infoWithTitle:@"Edit" items:@"Copy to Pasteboard/copyToPasteboard:", 
                                                    @"Delete File/deleteFile:", nil];
    info = General/[NSMenu infoWithTitle:@"" items:editInfo, @"Open in General/TextEdit/openInTextEdit:", 
                                                    @"Show in Finder/showInFinder:", nil];
    return General/[NSMenu popUpMenuWithInfo:info target:self];
}

- (General/NSMenu *)menuForEvent:(General/NSEvent *)theEvent {
    if ([theEvent type] == General/NSRightMouseDown) return [self menuForRightMouseDownEvent];
    return nil; 
}


*category addition to General/NSMenu to help create a quick General/PopUpMenu*
    
@interface General/NSMenu (NSMenu_PopUpAdditions)
+ (General/NSMenu *)popUpMenuWithInfo:(General/NSDictionary *)plist target:(id)target;
+ (General/NSDictionary *)infoWithTitle:(General/NSString *)title items:(id)item, ...;
@end General/NSMenu (NSMenu_PopUpAdditions)

@implementation General/NSMenu (NSMenu_PopUpAdditions)

+ (General/NSMenu *)popUpMenuWithInfo:(General/NSDictionary *)info target:(id)target {
    if (![info isKindOfClass:General/[NSDictionary class]]) return nil;
    General/NSString *title = [info objectForKey:@"title"];
    General/NSArray *items = [info objectForKey:@"items"];
    if (!title) title = @"";
    if (![items isKindOfClass:General/[NSArray class]]) return nil;
    General/NSMenu *menu = General/[[[NSMenu alloc] initWithTitle:title] autorelease];
    General/NSEnumerator *itemEnum = [items objectEnumerator]; id item;
    while (item = [itemEnum nextObject]) {
        if ([item isKindOfClass:General/[NSDictionary class]]) {
            General/NSMenu *submenu = [self popUpMenuWithInfo:item target:target];
            if (!submenu) continue; 
            General/NSMenuItem *subItem = General/[[[NSMenuItem alloc] init] autorelease];
            [subItem setTitle:[submenu title]];
            [subItem setSubmenu:submenu];
            [menu addItem:subItem];
        } else if ([item isKindOfClass:General/[NSString class]]) {
            General/NSArray *comps = [item componentsSeparatedByString:@"/"];
            if ([comps count] < 2) continue;
            General/NSMenuItem *menuItem = [menu addItemWithTitle:[comps objectAtIndex:0] 
                                        action:General/NSSelectorFromString([comps lastObject])
                                        keyEquivalent:@""];
            [menuItem setTarget:target];
        }
    }
    return menu;
}

+ (General/NSDictionary *)infoWithTitle:(General/NSString *)title items:(id)item, ... {
    va_list ap; 
    va_start(ap, item);
    id nextItem = nil;
    General/NSMutableDictionary *info = General/[NSMutableDictionary dictionary];
    [info setValue:title forKey:@"title"];
    General/NSMutableArray *items = General/[NSMutableArray array];
    if (item) [items addObject:item];
    while (nextItem = va_arg(ap, id)) [items addObject:nextItem];
    [info setValue:items forKey:@"items"];
    va_end(ap); 
    return info;
}

@end
