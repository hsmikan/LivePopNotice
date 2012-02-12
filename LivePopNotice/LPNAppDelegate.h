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

#import "LPNLiveListTableView/LPNLiveListTableViewContextMenuDelegate.h"
#import "StatusBarMenu/LPNStatuBarMenuActionDelegate.h"

@class FilteringList;
@class FilteringViewController;

@class WebView;

@interface LPNAppDelegate : NSObject <NSApplicationDelegate,LPNXMLParserDelegate,LPNLiveListTableViewContextMenuDelegate,LPNStatuBarMenuActionDelegate,NSTableViewDelegate>
{
    /* refresh timer */
    NSTimer * _refreshTimer;
    NSTimer * _displayRemainTimeIntervalTimer;
    
    
    /* liveIDs container */
    NSArray * _currentFeededLiveIDs;
    NSMutableArray * _currentSubFeededLiveIDs;
    
    
    
    /* --------------------- */
    /* View & Related Outlet */
    /* --------------------- */
    
    /* status bar */
    NSStatusItem * _statusBarItem;
    
    /* main window */
    NSWindow * _window;
    
    /* tool bar */
    NSTextField *_displayIntervalTimeUntilNextRefresh;
    
    /* main tabView */
    NSTabView *_mainTab;
    // liveList Tab Item
    //    TODO: live list viewer
    NSArrayController * _liveListController;
    NSMatrix      * _checkedServiceMTRX;
    NSTextField   * _displayInLIveCountTF;
    NSWindow      * _sheetWindow;
    NSPopUpButton * _filteringTypeInSheetPB;
    NSTextField   * _willAddedStringToNoticeListTF;
    NSTextField   * _filteringCommentInSheetTF;
    // Pop Up Notice List Tab Item
    FilteringViewController * _LPNListController;
    // Ignore List Tab Item
    FilteringViewController * _LPNIgnoreListController;
    
}

@property (assign) IBOutlet NSTextField *displayIntervalTimeUntilNextRefresh;

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTabView *mainTab;

@property (assign) IBOutlet NSArrayController * liveListController;
@property (assign) IBOutlet NSMatrix *checkedServiceMTRX;
@property (assign) IBOutlet NSTextField *displayInLIveCountTF;
@property (assign) IBOutlet NSWindow *sheetWindow;
@property (assign) IBOutlet NSPopUpButton *filteringTypeInSheetPB;
@property (assign) IBOutlet NSTextField *willAddedStringToNoticeListTF;
@property (assign) IBOutlet NSTextField *filteringCommentInSheetTF;

/* tool bar */
- (IBAction)refreshLiveList:(NSToolbarItem *)sender;
- (IBAction)changeRefreshInterval:(NSTextFieldCell *)sender;

- (IBAction)selectLiveListTab:(NSToolbarItem *)sender;
- (IBAction)selectPopUpListTab:(NSToolbarItem *)sender;
- (IBAction)selectIgnoreListTab:(NSToolbarItem *)sender;

- (IBAction)changeLPNDisplayDuration:(NSTextField *)sender;




/* live list */
- (IBAction)changeNoticeSoundPath:(id)sender;
- (IBAction)showWillAddedStringToNoticeList:(NSPopUpButton *)sender;
- (IBAction)sheetEndWithAdding:(NSButton *)sender;
- (IBAction)sheetEnd:(id)sender;


- (IBAction)changeFeedStateOfCaveTube:(NSButtonCell *)sender;
- (IBAction)changeFeedStateOfLivetube:(NSButtonCell *)sender;


@end
