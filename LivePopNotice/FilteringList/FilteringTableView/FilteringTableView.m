//
//  FilteringTableView.m
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "FilteringTableView.h"

@implementation FilteringTableView

@synthesize contextMenuItemActionDelegate = _contextMenuItemActionDelegate;

- (void)awakeFromNib {
    [self setAllowsMultipleSelection:YES];
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    NSInteger row = [self rowAtPoint:[self convertPoint:[event locationInWindow] fromView:nil]];
    
    if (row == -1) {// clicked point is out of selectable range
        [self deselectAll:nil];
    }
    else if ( ![self numberOfSelectedRows] ) {// any row is not selected 
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
    
    
    NSMenu * menu = [[[NSMenu alloc] initWithTitle:@"remove"] autorelease];
    {
        NSMenuItem * item = [[[NSMenuItem alloc] init] autorelease];
        [item setTitle:NSLocalizedString(@"LPNFilteringRemoveSelectedItems", @"")];
        [item setKeyEquivalent:@""];
        
        if ([self numberOfSelectedRows]) {
            [item setTarget:_contextMenuItemActionDelegate];
            [item setAction:@selector(removeElements:)];
        }
        
        [menu addItem:item];
    }
    
    
    return menu;
}

@end
