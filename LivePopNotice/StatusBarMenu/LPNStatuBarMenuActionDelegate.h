//
//  LPNStatuBarMenuActionDelegate.h
//  LivePopNotice
//
//  Created by hsmikan on 1/15/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPNStatuBarMenuActionDelegate <NSObject>
- (void)openMainWindow:(id)sender;
- (void)clickedStatusBarLiveListSubMenu:(id)sender;
@end
