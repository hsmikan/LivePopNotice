//
//  FilteringLPNListViewController.h
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "../FilteringViewController.h"

@interface FilteringLPNListViewController : FilteringViewController {
    NSButton * _isNoticeAnyLiveCB;
}
- (BOOL)isNoticeAnyLive;
@end
