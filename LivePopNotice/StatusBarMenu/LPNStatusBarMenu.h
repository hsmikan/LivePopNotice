//
//  LPNStatusBarMenu.h
//  LivePopNotice
//
//  Created by hsmikan on 1/11/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>


enum {
    LPNStatusBarTabShowWindow,
    LPNStatusBarTagCaveTube,
    LPNStatusBarTagLivetube,
    LPNStatusBarTabAbout,
    LPNStatusBarTabHelp,
    LPNStatusBarTabQuit,
};

@protocol LPNStatuBarMenuActionDelegate;

@interface LPNStatusBarMenu : NSMenu {
    id <LPNStatuBarMenuActionDelegate> _actionDelegate;
}
@property (assign) id <LPNStatuBarMenuActionDelegate> actionDelegate;
- (id)initWithTitle:(NSString *)aTitle actionDelegate:(id<LPNStatuBarMenuActionDelegate>)delegate;
- (void)updateLiveList:(NSArray *)livelist;
@end
