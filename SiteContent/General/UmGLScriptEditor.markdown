[[OpenGLScript]]

<code>


//
//  [[UmGLScriptEditor]].h
//  [[UmGL]]
//
//
//  Created by Benjamin on Sat Feb 08 2003.
//  Copyright (c) 2003 Unified Modular All rights reserved.
//  www.unifiedmodular.com
//


#import <Cocoa/Cocoa.h>
#import "[[UmGLScriptEditor]].h"

@interface [[UmGLScriptEditor]] : [[NSWindow]] {
    [[NSTabView]] ''tabView;
    [[NSTableView]] ''tableView;
    [[NSScrollView]] ''tableScrollView;
    [[NSTextView]] ''textView;
    [[NSNotificationCenter]] ''myCenter;
    id glView;
    id scriptor;
    [[NSArray]] ''script;
}
-(void)initWithFrame:([[NSRect]])_frame;
-(void)setGLView:(id)view;
-(void)setGLScript:(id)_scriptor;
-(void)setDataSource:(id)source;
-(id)textView;
-(id)tableView;

@end


//
//  [[UmGLScriptEditor]].m
//  [[UmGL]]
//
//
//  Created by Benjamin on Sat Feb 08 2003.
//  Copyright (c) 2003 Unified Modular All rights reserved.
//  www.unifiedmodular.com
//

#import "[[UmGLScriptEditor]].h"


@implementation [[UmGLScriptEditor]]

- (id)initWithFrame:([[NSRect]])_frame {
    unsigned int styleMask = [[NSTitledWindowMask]] | [[NSClosableWindowMask]]
                         | [[NSMiniaturizableWindowMask]] | [[NSResizableWindowMask]];
    [[NSNotificationCenter]] ''myCenter=[[[NSNotificationCenter]] defaultCenter];
    [[NSRect]] cRect;
    self=[super initWithContentRect: _frame
                     styleMask: styleMask
                     backing: [[NSBackingStoreBuffered]]
                     defer: NO];
    if (self) {
        id columnNames=[[[NSArray]] arrayWithObjects:@"glCall",@"arg1", @"arg2", @"arg3", @"arg4", @"arg5", @"arg6", @"arg7", @"arg8", @"arg9", @"arg10", nil];
        id nameEnum=[columnNames objectEnumerator];
        id name, column, columnHeader;
        tabView=[[[[NSTabView]] alloc] initWithFrame:[[NSMakeRect]](0,200,_frame.size.width, _frame.size.height-200)];
        [self setContentView:tabView];
        cRect=[tabView contentRect];
        tableView=[[[[NSTableView]] alloc] initWithFrame:cRect];
        tableScrollView=[[[[NSScrollView]] alloc] initWithFrame:cRect];
        [tableScrollView setHasVerticalScroller:YES];
        [tableScrollView setHasHorizontalScroller:YES];
        [tableScrollView setDocumentView:tableView];
        textView=[[[[NSTextView]] alloc] initWithFrame:[tabView contentRect]];
        column=[[[[[NSTableColumn]] alloc] initWithIdentifier:@"spacer"] autorelease];
        columnHeader=[column headerCell];
        [columnHeader setStringValue:@""];
        [column setWidth:20];
        [tableView addTableColumn:column];
        name=[nameEnum nextObject];
        column=[[[[[NSTableColumn]] alloc] initWithIdentifier:name] autorelease];
        [column setWidth:300];
        [column setEditable:NO];
        columnHeader=[column headerCell];
        [columnHeader setStringValue:name];
        [tableView addTableColumn:column];
        [tableView setDrawsGrid:YES];
        [tableView tile];
        [tableView setDelegate:self];
        while (name=[nameEnum nextObject])  {
            column=[[[[[NSTableColumn]] alloc] initWithIdentifier:name] autorelease];
            [column setWidth:100];
            [column setEditable:YES];
            columnHeader=[column headerCell];
            [columnHeader setStringValue:name];
            [tableView addTableColumn:column];
        }
        id textViewTab=[[[[[NSTabViewItem]] alloc] init] autorelease];
        id tableViewTab=[[[[[NSTabViewItem]] alloc] init] autorelease];
        [tableViewTab setView:tableScrollView];
        [textViewTab setView:textView];
        [textViewTab setLabel:@"Editor View"];
        [tableViewTab setLabel:@"Script View"];
        [tabView selectLastTabViewItem:self];
        [tabView addTabViewItem:textViewTab];
        [tabView addTabViewItem:tableViewTab];
        [self makeKeyAndOrderFront:YES];

    }
    return self;
}
-(id)textView {
    return textView;
}
-(id)tableView {
    return tableView;
}

-(void)setGLScript:(id)_scriptor {
    scriptor=_scriptor;
}
-(void)setGLView:(id)view {
   glView=view; 
}
-(void)setDataSource:(id)source {
    [tableView setDataSource:source];
    [source setTableView:tableView];
}

 
@end



</code>