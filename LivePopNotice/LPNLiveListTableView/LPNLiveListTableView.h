//
//  LPNLiveListTableView.h
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LPNLiveListTableView : NSTableView {
    id _contextMenuItemActionDelegate;
}
@property (assign) IBOutlet id contextMenuItemActionDelegate;
@end
