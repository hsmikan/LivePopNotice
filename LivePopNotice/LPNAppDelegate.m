//
//  LPNAppDelegate.m
//  LivePopNotice
//
//  Created by hsmikan on 1/7/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNAppDelegate.h"


#import "Constants/mainTabIdentifier.h"
#import "Constants/LPNUserDefaultsKey.h"

#import "XMLParser/LPNFeedParser.h"
#import "LPNWindow/LPNWindowController.h"

#import "FilteringList/FilteringViewController.h"

#import "StatusBarMenu/LPNStatusBarMenu.h"



@interface LPNAppDelegate()
- (void)_LPN_stopRefreshTimer;
- (void)_LPN_startRefreshTimer;
- (void)_LPN_getAndParse:(NSTimer*)timer;
- (void)_LPN_cahngeRemainTimeInterval:(NSTimer*)timer;
- (void)_LPN_popUpNewEntry:(NSDictionary *)entry;
@end



@implementation LPNAppDelegate

@synthesize displayIntervalTimeUntilNextRefresh = _displayIntervalTimeUntilNextRefresh;
@synthesize window = _window;
@synthesize mainTab = _mainTab;
@synthesize liveListController = _liveListController;
@synthesize checkedServiceMTRX = _checkedServiceMTRX;
enum {
    checkedSrviceTagCT = 0,
    checkedSrviceTagLT = 1,
};
@synthesize sheetWindow = _sheetWindow;
@synthesize filteringTypeInSheetPB = _filteringTypeInSheetPB;
@synthesize willAddedStringToNoticeListTF = _willAddedStringToNoticeListTF;


- (void)dealloc {
    // won't be called
    [super dealloc];
}

#pragma mark -
#pragma mark - App Delegate
/*========================================================================================
 *
 *  finalize
 *
 *========================================================================================*/
- (void)applicationWillTerminate:(NSNotification *)notification {    
    [self _LPN_stopRefreshTimer];
    
    if (_displayRemainTimeIntervalTimer) {
        [_displayRemainTimeIntervalTimer invalidate];
        _displayRemainTimeIntervalTimer = nil;
    }
    [_currentFeededLiveIDs release]; _currentFeededLiveIDs = nil;
    [_currentSubFeededLiveIDs release]; _currentSubFeededLiveIDs = nil;
    
    [_statusBarItem release];
    [_LPNListController release];
    [_LPNIgnoreListController release];
}




/*========================================================================================
 *
 *  Initialize
 *
 *========================================================================================*/
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* insert application icon in the status bar */
    _statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    {
        [_statusBarItem retain];
        [_statusBarItem setTitle:@""];
        [_statusBarItem setImage:[NSImage imageNamed:@"icon2"]];
        [_statusBarItem setHighlightMode:YES];
        LPNStatusBarMenu * statusBarMenu = [[LPNStatusBarMenu alloc] initWithTitle:@"LPNStatusBarMenu"
                                                                    actionDelegate:self];
        [_statusBarItem setMenu:[statusBarMenu autorelease]];
    }
    
    
    /* storing data */
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    {
        /* register default UI values */
        NSString * guidfpath = [[NSBundle mainBundle] pathForResource:@"LPNGraphicalUserInterfaceDefaults"
                                                               ofType:@"plist"];
        NSDictionary * guidf = [NSDictionary dictionaryWithContentsOfFile:guidfpath];
        [df registerDefaults:guidf];
        
        
        _refreshTimeInterval = [[df stringForKey:kLPNUserDefaultsRefreshIntervalKey] doubleValue];
        _LPNDisplayTimeInterval = [[df stringForKey:kLPNUserDefaultsNoticeDurationKey] doubleValue];
        
    }
    /* _checkedServiceMTRX's content cells statement is saved by Shared User Defaults Controller in IB */
    [self changeFeedStateOfCaveTube:[_checkedServiceMTRX cellWithTag:checkedSrviceTagCT]];
    [self changeFeedStateOfLivetube:[_checkedServiceMTRX cellWithTag:checkedSrviceTagLT]];
    
    
    
    /* ----- */
    /* views */
    /* ----- */
    
    /* toolbar */
    [[_window toolbar] setSelectedItemIdentifier:@"LiveListToolbarItem"];
    
    /* main tab */
    // LPNList
    _LPNListController = [[FilteringViewController alloc] initWithArrayControllerKey:kLPNListArrayControllerKey];
    [[_mainTab tabViewItemAtIndex:kPopUpNoticeTabItemIndex] setView:[_LPNListController view]];
    
    // LPNIgnoreList
    _LPNIgnoreListController = [[FilteringViewController alloc] initWithArrayControllerKey:kLPNIgnoreListArrayControllerKey];
    [[_mainTab tabViewItemAtIndex:kIgnoreListTabItemIndex] setView:[_LPNIgnoreListController view]];
    
    
    
    /* start parse timer */
    [self _LPN_getAndParse:nil];
    [self _LPN_startRefreshTimer];
    
    /* Test */
#ifdef DEBUG
    LPNWindowController * testWindow;{
        NSDictionary * lpnAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Live Title",@"entryDictionaryTitle",
                                  @"Author",@"entryDictionaryAuthorName",
                                  @"Live Summary",@"entryDictionarySummary",
                                  @"http://google.co.jp",@"entryDictionaryURL",
                                  nil];
        testWindow = [[LPNWindowController alloc] initWithLPNAttribute:lpnAttr];
    }
    [testWindow showWindowForDuration:1000];
    
#endif
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    /* agent Application */
    return NO;
}







#pragma mark -
#pragma mark Status Bar Action
/*========================================================================================
 *
 *  Status Bar Action
 *
 *========================================================================================*/

/* AT status bar menu */
- (IBAction)openMainWindow:(id)sender {// (NSMenuItem *)sender
    [_window orderFrontRegardless];
}




#pragma mark -
#pragma mark Tool Bar Actions
/*========================================================================================
 *
 *  TabView Selection
 *
 *========================================================================================*/

- (IBAction)selectLiveListTab:(NSToolbarItem *)sender {
    [_window setTitle:@"LivePopNotice - Live List -"];
    [_mainTab selectTabViewItemWithIdentifier:kLiveListTabIdentifier];
}

- (IBAction)selectPopUpListTab:(NSToolbarItem *)sender {
    [_window setTitle:@"LivePopNotice - Pop Up Notice List -"];
    [_mainTab selectTabViewItemWithIdentifier:kPopUpTabIdentifier];
}

- (IBAction)selectIgnoreListTab:(NSToolbarItem *)sender {
    [_window setTitle:@"LivePopNotice - Ignore List -"];
    [_mainTab selectTabViewItemWithIdentifier:kIgnoreListTabIdentifier];
}



/*========================================================================================
 *
 *  refresh
 *
 *========================================================================================*/

- (IBAction)refreshLiveList:(NSToolbarItem *)sender {
    [self _LPN_stopRefreshTimer];
    [self _LPN_getAndParse:nil];
    [self _LPN_startRefreshTimer];
}


static const CGFloat refreshIntervalMin = 10;
- (IBAction)changeRefreshInterval:(NSTextFieldCell *)sender {
    if ([sender integerValue] == _refreshTimeInterval) {
        return;
    }
    
    if ([sender integerValue] < refreshIntervalMin) {
        [sender setIntegerValue:refreshIntervalMin];
        _refreshTimeInterval = refreshIntervalMin;
    }
    else {
        _refreshTimeInterval = [sender doubleValue];
    }
    
    [self _LPN_stopRefreshTimer];
    [self _LPN_startRefreshTimer];
    
}



/*========================================================================================
 *
 *  Duration of Pop Up Notice Window
 *
 *========================================================================================*/

- (IBAction)changeLPNDisplayDuration:(NSTextField *)sender {
    static const CGFloat LPNDisplayTimeIntervalMin = 1;
    
    if ( _LPNDisplayTimeInterval == [sender doubleValue] ) {
        return;
    }
    
    if ( [sender doubleValue] <= 0 ) {
        _LPNDisplayTimeInterval = LPNDisplayTimeIntervalMin;
        [sender setIntValue:LPNDisplayTimeIntervalMin];
    }
    else {
        _LPNDisplayTimeInterval = [sender doubleValue];
    }
}








#pragma mark -
#pragma mark Action Called From Table View's Context Menu
/*========================================================================================
 *
 *  Open Live URL with Default Web Browser
 *
 *========================================================================================*/
- (void)openLivePage:(id)sender {
    NSUInteger index = [_liveListController selectionIndex];
    NSString * urlstring = [(NSDictionary*)[[_liveListController arrangedObjects] objectAtIndex:index] URL];
    NSURL * url = [NSURL URLWithString:urlstring];
    [[NSWorkspace sharedWorkspace] openURL:url];
}






#pragma mark -
#pragma mark add from livelist tableview
/*========================================================================================
 *
 *  add notice element from context menu
 *
 *========================================================================================*/

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:nil];
}

- (void)addToPopUpNoticeList:(id)sender {
    [NSApp beginSheet:_sheetWindow
       modalForWindow:_window
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (NSString *)getWillBeAddedStringWithTypeIndex:(NSInteger)index {// private like
    NSDictionary * dic = [[_liveListController selectedObjects] objectAtIndex:0];
    NSString * str;{
        // TODO: case constant
        switch (index) {
            case 0:
                str = [dic authorName];
                break;
                
            case 1:
                str = [dic title];
                break;
                
            case 2:
                str = [dic summary];
                break;
                
            default:
                break;
        }
    }
    
    return str;
}


- (IBAction)showWillAddedStringToNoticeList:(NSPopUpButton *)sender {
    NSString * str = [self getWillBeAddedStringWithTypeIndex:[sender indexOfSelectedItem]];
    [_willAddedStringToNoticeListTF setStringValue:str];
}


- (IBAction)sheetEndWithAdding:(NSButton *)sender {
    NSInteger index = [_filteringTypeInSheetPB indexOfSelectedItem];
    NSString * str = [self getWillBeAddedStringWithTypeIndex:index];
    if (str.length) {
        [_LPNListController addElementWithFilteringType:index
                                        filteringString:str];
    }
    
    [NSApp endSheet:_sheetWindow];
}


- (IBAction)sheetEnd:(id)sender {
    [NSApp endSheet:_sheetWindow];
}




#pragma mark -
#pragma mark select feed site
/*========================================================================================
 *
 *  feed site
 *
 *========================================================================================*/

// FIXME: UI Action sender incorrectly become NSMatrix. 
//  sender,NSButtonCell, is in NSMatrix
//
- (IBAction)changeFeedStateOfCaveTube:(NSButtonCell *)sender {
    NSInteger state;
    if ([sender class] == [NSMatrix class]) {
        state = [[(NSMatrix *)sender cellWithTag:checkedSrviceTagCT] state];
    }
    else {
        state = [sender state];
    }
    
    [[[_statusBarItem menu] itemWithTag:LPNStatusBarTagCaveTube] setState:state];
}

- (IBAction)changeFeedStateOfLivetube:(NSButtonCell *)sender {
    NSInteger state;
    if ([sender class] == [NSMatrix class]) {
        state = [[(NSMatrix *)sender cellWithTag:checkedSrviceTagLT] state];
    }
    else {
        state = [sender state];
    }
    [[[_statusBarItem menu] itemWithTag:LPNStatusBarTagLivetube] setState:state];
}





#pragma mark -
#pragma mark LPNXMLParser Delegate
/*========================================================================================
 *
 *  LPNXMLParser delegate
 *
 *========================================================================================*/

- (void)LPNXMLParserDidStartDocyment {
}

- (void)LPNXMLParserDidEndDocument {
    [_currentFeededLiveIDs release];
    _currentFeededLiveIDs = [[NSArray alloc] initWithArray:_currentSubFeededLiveIDs];
    
    [_currentSubFeededLiveIDs release];
    _currentSubFeededLiveIDs = nil;
}


- (void)LPNXMLParserDidEndEntry:(NSDictionary *)entry {
    BOOL isIgnorable = [_LPNIgnoreListController isContainendEntry:entry];
    if (isIgnorable) return;
    
    [_liveListController addObject:entry];
    [_currentSubFeededLiveIDs addObject:[entry liveID]];
    
    [self _LPN_popUpNewEntry:entry];
    
}








#pragma mark -
#pragma mark Private-like Method
/*========================================================================================
 *
 *  Private-like Method
 *
 *========================================================================================*/

- (void)_LPN_stopRefreshTimer {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}


- (void)_LPN_startRefreshTimer {
    if (_refreshTimeInterval < refreshIntervalMin) _refreshTimeInterval = refreshIntervalMin;
    NSTimeInterval interval;
#ifdef DEBUG
    interval = _refreshTimeInterval;
#else
    interval = (_refreshTimeInterval*60.0);
#endif
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                     target:self
                                                   selector:@selector(_LPN_getAndParse:)
                                                   userInfo:nil repeats:YES];
}


- (void)_LPN_getAndParse:(NSTimer*)timer {
    _refreshTimeIntervalCount = 0;
    if ([_displayRemainTimeIntervalTimer isValid]) {
        [_displayRemainTimeIntervalTimer invalidate];
        _displayRemainTimeIntervalTimer = nil;
    }
    _displayRemainTimeIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                       target:self
                                                                     selector:@selector(_LPN_cahngeRemainTimeInterval:)
                                                                     userInfo:nil
                                                                      repeats:YES];
    
    
    [_liveListController removeObjects:[_liveListController content]];
    _currentSubFeededLiveIDs = [[NSMutableArray alloc] init];
    
    LPNFeedSiteMask mask = 0;
    LPNXMLParser * parser = [[[LPNXMLParser alloc] initWithDelegate:self] autorelease];
    for (NSCell * cell in [_checkedServiceMTRX cells] ) {
        if ([cell state]) {
            switch ([cell tag]) {
                case checkedSrviceTagCT:
                    mask |= feedSiteCaveTube;
                    break;
                    
                case checkedSrviceTagLT:
                    mask |= feedSiteLiveTube;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    [parser parseWithSiteMask:mask];
}






/*========================================================================================
 *
 *  display remained time interval
 *
 *========================================================================================*/
- (void)_LPN_cahngeRemainTimeInterval:(NSTimer *)timer {
    unsigned int min,sec;
    {
        unsigned int seconds = _refreshTimeInterval*60 - (++_refreshTimeIntervalCount);
        min = seconds/60;
        sec = seconds%60;
    }
    [_displayIntervalTimeUntilNextRefresh setStringValue:[NSString stringWithFormat:@"%02u:%02u",min,sec]];
}



- (void)_LPN_popUpNewEntry:(LPNEntryDictionary *)entry {
    if (/*--------------------------------------------------------------------------------------*/
#ifndef DEBUG

        /* is firsrt load */
        ( ![_currentFeededLiveIDs count] )
        
        /* is new live */||
        ( [_currentFeededLiveIDs containsObject:[entry liveID]] )
        
        /* is able to pop up */||
#endif
        ( ![_LPNListController isContainendEntry:entry] )
        
        /*--------------------------------------------------------------------------------------*/)
    {
        return;
    }
        
    
    LPNWindowController * win = [[LPNWindowController alloc] initWithLPNAttribute:entry];
    [win showWindowForDuration:_LPNDisplayTimeInterval];
    
}


@end
