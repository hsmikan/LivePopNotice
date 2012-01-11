//
//  LPNView.h
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>

@class WebView;

@interface LPNView : NSView
- (id)initWithFrame:(NSRect)frameRect entry:(NSDictionary *)entry policyDelegate:(id)policyDelegate;
@end
