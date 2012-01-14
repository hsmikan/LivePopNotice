//
//  LPNWindowController.h
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface LPNWindowController : NSWindowController <NSWindowDelegate> {
    
    NSUInteger _mapNumber;
    
    NSTimer * _closeTimer;
    NSTimeInterval _closeTimeInterval;
    
    NSRect originFrame;
}

- (id)initWithLPNAttribute:(NSDictionary *)attribute;
- (void)showWindowForDuration:(double)duration;

@end

