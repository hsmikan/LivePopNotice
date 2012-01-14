//
//  LPNLiveListTableViewContextMenuDelegate.h
//  LivePopNotice
//
//  Created by hsmikan on 1/15/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPNLiveListTableViewContextMenuDelegate <NSObject>
- (void)openLivePage:(id)sender;
- (void)copyLink:(id)sender;
- (void)addToPopUpNoticeList:(id)sender;
@end
