//
//  LPNStatusBarMenu.h
//  LivePopNotice
//
//  Created by hsmikan on 1/11/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>


enum {
    LPNStatusBarTagCaveTube,
    LPNStatusBarTagLivetube,
};


@interface LPNStatusBarMenu : NSMenu
- (id)initWithTitle:(NSString *)aTitle actionDelegate:(id)delegate;
@end
