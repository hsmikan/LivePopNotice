//
//  LPNAppDelegate.h
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/* feed parser */
#import "XMLParser/LPNXMLParserDelegate.h"




@class FilteringList;
@class FilteringViewController;
@class FilteringLPNListViewController;

@class WebView;

@interface LPNAppDelegate : NSObject <NSApplicationDelegate,LPNXMLParserDelegate> {
    
    /* ------ */
    /* Member */
    /* ------ */
    
    /* refreshing feed */
    NSTimer * _refreshTimer;
    NSUInteger _refreshTimeIntervalCount;
    NSTimeInterval _refreshTimeInterval;
    
    NSTimer * _displayRemainTimeIntervalTimer;
    NSTimeInterval _LPNDisplayTimeInterval;
    
    /* got liveIDs from feed */
    NSArray * _currentFeededLiveIDs;
    NSMutableArray * _currentSubFeededLiveIDs;
    
    
    
    /* --------------------- */
    /* View & Related Outlet */
    /* --------------------- */
    
    /* status menu */
    NSStatusItem * _statusBarItem;
    
    /* tool bar */
    NSTextField *_displayIntervalTimeUntilNextRefresh;
    
    /* main window */
    NSWindow * _window;
    
    /* main tabView */
    NSTabView *_mainTab;
    /* liveList Tab Item */
    NSArrayController * _liveListController;// TODO: live list viewer
    /* Pop Up Notice List Tab Item */
    FilteringLPNListViewController * _LPNListController;
    /* Ignore List Tab Item */
    FilteringViewController * _LPNIgnoreListController;
    
}

@property (assign) IBOutlet NSTextField *displayIntervalTimeUntilNextRefresh;

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTabView *mainTab;

@property (assign) IBOutlet NSArrayController * liveListController;


/* status bar */
- (IBAction)openMainWindow:(id)sender;


/* tool bar */
- (IBAction)refreshLiveList:(NSToolbarItem *)sender;
- (IBAction)changeRefreshInterval:(NSTextFieldCell *)sender;

- (IBAction)selectLiveListTab:(NSToolbarItem *)sender;
- (IBAction)selectPopUpListTab:(NSToolbarItem *)sender;
- (IBAction)selectIgnoreListTab:(NSToolbarItem *)sender;

- (IBAction)changeLPNDisplayDuration:(NSTextField *)sender;





/* live list */
- (void)openLivePage:(id)sender;



@end
