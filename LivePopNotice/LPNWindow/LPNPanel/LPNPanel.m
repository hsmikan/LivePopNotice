//
//  LPNPanel.m
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNPanel.h"
#import "LPNView.h"



@implementation LPNPanel
- (id)initWithContentRect:(NSRect)contentRect entry:(NSDictionary *)entry delegate:(id<NSWindowDelegate>)delegate {
    static const NSUInteger windowMask = NSUtilityWindowMask | NSHUDWindowMask | NSTitledWindowMask | NSClosableWindowMask;
    self = [super initWithContentRect:contentRect
                            styleMask:windowMask
                              backing:NSBackingStoreBuffered
                                defer:YES];
    if (self) {
        [self setDelegate:delegate];
        [self setReleasedWhenClosed:YES];
        //[self setRestorable:NO];
        [self setHidesOnDeactivate:NO];
        
        [[self contentView] setAutoresizesSubviews:YES];
        LPNView * view = [[LPNView alloc] initWithFrame:contentRect
                                                  entry:entry
                                         policyDelegate:delegate];
        [self setContentView:[view autorelease]];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[self windowController] mouseEntered:theEvent];

}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self windowController] mouseExited:theEvent];
}

@end
