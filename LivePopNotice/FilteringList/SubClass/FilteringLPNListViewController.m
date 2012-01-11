//
//  FilteringLPNListViewController.m
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "FilteringLPNListViewController.h"
#import "../../Constants/LPNUserDefaultsKey.h"

@implementation FilteringLPNListViewController


- (id)initWithArrayControllerKey:(NSString *)key {
    self = [super initWithArrayControllerKey:key];
    if (self) {
        _isNoticeAnyLiveCB = [[NSButton alloc] initWithFrame:NSMakeRect(50, 337, 118, 18)];
        [_isNoticeAnyLiveCB setTitle:NSLocalizedString(@"LPNPopUpNoticeButton", @"")];
        [_isNoticeAnyLiveCB setButtonType:NSSwitchButton];
        [_isNoticeAnyLiveCB setState:[[NSUserDefaults standardUserDefaults] boolForKey:kLPNUserDefaultsIsNoticeAnyLiveKey]];
        [[self view] addSubview:_isNoticeAnyLiveCB];
    }
    
    return self;
}


- (void)dealloc {
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    [df setBool:[_isNoticeAnyLiveCB state] forKey:kLPNUserDefaultsIsNoticeAnyLiveKey];
    
    [_isNoticeAnyLiveCB release];
    [super dealloc];
}



- (BOOL)isNoticeAnyLive {
    return [_isNoticeAnyLiveCB state];
}

@end
