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
    
    NSMenu * menu = [[NSMenu alloc] initWithTitle:@"OpenLiveURL"];
    {
        NSMenuItem * item = [[NSMenuItem alloc] init];
        [item setTitle:NSLocalizedString(@"LPNOpenLivePageMenuItem", @"")];
        [item setKeyEquivalent:@""];
        
        if ([self selectedRow] != -1) {
            [item setTarget:_contextMenuItemActionDelegate];
            [item setAction:@selector(openLivePage:)];
        }
        
        [menu addItem:[item autorelease]];
    }
    
    return [menu autorelease];
}
@end
