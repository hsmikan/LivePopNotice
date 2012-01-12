//
//  LPNLiveListTableView.m
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNLiveListTableView.h"

@implementation LPNLiveListTableView

@synthesize contextMenuItemActionDelegate = _contextMenuItemActionDelegate;

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    NSUInteger row = [self rowAtPoint:[self convertPoint:[event locationInWindow] fromView:nil]];
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    
    NSMenu * menu = [[NSMenu alloc] initWithTitle:@"LiveListTableViewMenu"];
    {
        NSMenuItem * openLivePageItem = [[NSMenuItem alloc] init];{
            [openLivePageItem setTitle:NSLocalizedString(@"LPNOpenLivePageMenuItem", @"")];
            [openLivePageItem setKeyEquivalent:@""];
        }
        
        NSMenuItem * addItem = [[NSMenuItem alloc] init];{
            [addItem setTitle:NSLocalizedString(@"LPNAddToNoticeListMenuItem", @"")];
            [addItem setKeyEquivalent:@""];
        }
        
        if ([self selectedRow] != -1) {
            [openLivePageItem setTarget:_contextMenuItemActionDelegate];
            [openLivePageItem setAction:@selector(openLivePage:)];
            
            [addItem setTarget:_contextMenuItemActionDelegate];
            [addItem setAction:@selector(addToPopUpNoticeList:)];
        }
        
        [menu addItem:[openLivePageItem autorelease]];
        [menu addItem:[addItem autorelease]];
    }
    
    return [menu autorelease];
}
@end
