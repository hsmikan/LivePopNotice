//
//  FilteringViewController.h
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FilteringViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource> {
    
    NSArrayController * _filteringListController;
    NSString * _filteringListControllerKey;
    NSPopUpButton * _filterTypePB;
    NSTextField * _filterStringTF;
}

@property (assign) IBOutlet NSArrayController * filteringListController;
@property (assign) IBOutlet NSPopUpButton * filterTypePB;
@property (assign) IBOutlet NSTextField * filterStringTF;

- (id)initWithArrayControllerKey:(NSString *)key;

- (IBAction)addElement:(NSButton *)sender;
- (void)addElementWithFilteringType:(NSInteger)typeIndex filteringString:(NSString *)string;
- (IBAction)removeElements:(id)sender;
- (BOOL)hasEntry:(NSDictionary *)entry;


@end
