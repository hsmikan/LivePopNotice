//
//  LPNLiveListTableView.h
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol LPNLiveListTableViewContextMenuDelegate;

@interface LPNLiveListTableView : NSTableView {
    id <LPNLiveListTableViewContextMenuDelegate> _contextMenuItemActionDelegate;
}
@property (assign) IBOutlet id <LPNLiveListTableViewContextMenuDelegate> contextMenuItemActionDelegate;
@end
