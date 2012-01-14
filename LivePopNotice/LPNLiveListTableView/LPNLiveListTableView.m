//
//  LPNLiveListTableView.m
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNLiveListTableView.h"
#import "LPNLiveListTableViewContextMenuDelegate.h"


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
        
        NSMenuItem * copyLinkItem = [[NSMenuItem alloc] init];{
            [copyLinkItem setTitle:NSLocalizedString(@"LPNCopyLinkMenuItem", @"")];
            [copyLinkItem setKeyEquivalent:@""];
        }
        
        NSMenuItem * addItem = [[NSMenuItem alloc] init];{
            [addItem setTitle:NSLocalizedString(@"LPNAddToNoticeListMenuItem", @"")];
            [addItem setKeyEquivalent:@""];
        }
        
        /* set action */
        if ([self selectedRow] != -1) {
            if ([_contextMenuItemActionDelegate respondsToSelector:@selector(openLivePage:)]) {
                [openLivePageItem setTarget:_contextMenuItemActionDelegate];
                [openLivePageItem setAction:@selector(openLivePage:)];
            }
            
            if ([_contextMenuItemActionDelegate respondsToSelector:@selector(copyLink:)]) {
                [copyLinkItem setTarget:_contextMenuItemActionDelegate];
                [copyLinkItem setAction:@selector(copyLink:)];
            }
            
            if ([_contextMenuItemActionDelegate respondsToSelector:@selector(addToPopUpNoticeList:)]) {
                [addItem setTarget:_contextMenuItemActionDelegate];
                [addItem setAction:@selector(addToPopUpNoticeList:)];
            }
        }
        
        [menu addItem:[openLivePageItem autorelease]];
        [menu addItem:[copyLinkItem autorelease]];
        [menu addItem:[addItem autorelease]];
    }
    
    return [menu autorelease];
}
@end
