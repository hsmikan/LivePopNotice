//
//  LPNPanel.h
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LPNPanel : NSPanel
- (id)initWithContentRect:(NSRect)contentRect entry:(NSDictionary *)entry delegate:(id<NSWindowDelegate>)delegate;
@end
