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
#import "Constants/filteringTypeIdentifier.h"

#import "XMLParser/LPNFeedParser.h"
#import "LPNWindow/LPNWindowController.h"

#import "FilteringList/FilteringViewController.h"

#import "StatusBarMenu/LPNStatusBarMenu.h"




#ifdef DEBUG

//#define POPUP_TEST 1

#ifdef POPUP_TEST
#define POPUP_TEST_IGNORE_GOT 1
#define POPUP_TEST_IGNORE_LIST 1
#endif

#endif


#ifdef DEBUG
#define RE_START_INTERVAL 5
#else
#define RE_START_INTERVAL 300
#endif


#define REFRESH_INTEVAL_MIN 10

#define DISPLAY_TIMEINTERVAL_MIN 1





@interface LPNAppDelegate()

- (void)_LPN_stopRefreshTimer;
- (void)_LPN_startRefreshTimer;

- (void)_LPN_getAndParse:(NSTimer*)timer;

- (void)_LPN_cahngeRemainTimeInterval:(NSTimer*)timer;

- (void)_LPN_popUpNewEntry:(NSDictionary *)entry;


- (NSDictionary *)_manipulateSwapedAddingEntry:(NSDictionary *)entry command:(int)command;


typedef enum {
    refreshTimeIntervalCountReset     = 'rest',
    refreshTimeIntervalCountIncrement = 'incl',
} LPNRefreshTimeIntervalManipulateCommad;
NSUInteger refreshTimeIntervalManipulator(LPNRefreshTimeIntervalManipulateCommad command);
@end




@implementation LPNAppDelegate

@synthesize window = _window;

@synthesize displayIntervalTimeUntilNextRefresh = _displayIntervalTimeUntilNextRefresh;

@synthesize mainTab = _mainTab;

@synthesize liveListController = _liveListController;
@synthesize checkedServiceMTRX = _checkedServiceMTRX;
@synthesize displayInLIveCountTF = _displayInLIveCountTF;
enum {
    checkedSrviceTagCT = 0,
    checkedSrviceTagLT = 1,
};
@synthesize sheetWindow = _sheetWindow;
@synthesize filteringTypeInSheetPB = _filteringTypeInSheetPB;
@synthesize willAddedStringToNoticeListTF = _willAddedStringToNoticeListTF;
@synthesize filteringCommentInSheetTF = _filteringCommentInSheetTF;

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
    
    [self _manipulateSwapedAddingEntry:nil command:'free'];
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
    
    
    /* registering data */
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    {
        /* register default UI values */
        NSString * guidfpath = [[NSBundle mainBundle] pathForResource:@"LPNGraphicalUserInterfaceDefaults"
                                                               ofType:@"plist"];
        NSDictionary * guidf = [NSDictionary dictionaryWithContentsOfFile:guidfpath];
        [df registerDefaults:guidf];
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
    /*
    [self _LPN_popUpNewEntry:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Live Title",@"entryDictionaryTitle",
                              @"Author",@"entryDictionaryAuthorName",
                              @"Live Summary",@"entryDictionarySummary",
                              @"http://google.co.jp",@"entryDictionaryURL",
                              nil]];
     */
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    /* agent Application */
    return NO;
}







#pragma mark -
#pragma mark Status Bar Action Delegate
/*========================================================================================
 *
 *  Status Bar Action
 *
 *========================================================================================*/

/* AT status bar menu */
- (void)openMainWindow:(id)sender {// (NSMenuItem *)sender
    [_window orderFrontRegardless];
}

- (void)clickedStatusBarLiveListSubMenu:(id)sender {
    NSString * url;
    for (NSDictionary * entry in [_liveListController content]) {
        //TODO: display format
        if ([[sender title] isEqualToString:[NSString stringWithFormat:@"%@\t|\t%@",[entry authorName],[entry title]]]) {
            url = [entry URL];
            break;
        }
    }
    
    if (url)
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
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
- (void)enableRefreshButton:(NSToolbarItem *)button {
    [button setEnabled:YES];
}

- (IBAction)refreshLiveList:(NSToolbarItem *)sender {
    [self _LPN_stopRefreshTimer];
    [self _LPN_getAndParse:nil];
    [self _LPN_startRefreshTimer];
    [sender setEnabled:NO];
    [self performSelector:@selector(enableRefreshButton:)
               withObject:sender
               afterDelay:RE_START_INTERVAL];
}


- (IBAction)changeRefreshInterval:(NSTextFieldCell *)sender {
    static const CGFloat refreshIntervalMin = REFRESH_INTEVAL_MIN;
    
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    NSInteger senderContentInteger = [sender integerValue];
    NSInteger dfContentInteger = [df integerForKey:kLPNUserDefaultsRefreshIntervalKey];
    
    if (senderContentInteger == dfContentInteger) {
        return;
    }
    
    if (senderContentInteger < dfContentInteger) {
        [sender setIntegerValue:refreshIntervalMin];
        [df setInteger:refreshIntervalMin forKey:kLPNUserDefaultsRefreshIntervalKey];
    }
    else {
        [df setInteger:senderContentInteger forKey:kLPNUserDefaultsRefreshIntervalKey];
    }
    
    [self _LPN_stopRefreshTimer];
    [self _LPN_startRefreshTimer];
    
}



/*========================================================================================
 *
 *  Duration of Displaying Pop Up Notice Window
 *
 *========================================================================================*/

- (IBAction)changeLPNDisplayDuration:(NSTextField *)sender {
    static const CGFloat displayTimeIntervalMin = DISPLAY_TIMEINTERVAL_MIN;
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    CGFloat senderContentDouble = [sender doubleValue];
    CGFloat dfContentDouble = [df doubleForKey:kLPNUserDefaultsNoticeDurationKey];
    if (senderContentDouble == dfContentDouble) {
        return;
    }
    
    else if ( senderContentDouble <= dfContentDouble) {
        [df setDouble:displayTimeIntervalMin forKey:kLPNUserDefaultsNoticeDurationKey];
    }
    
}








#pragma mark -
#pragma mark Live List Tab
/*========================================================================================
 *
 *  Live List Tab
 *
 *========================================================================================*/

- (IBAction)changeNoticeSoundPath:(id)sender {
    
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:kLPNIsPlayNoticeSound])
        return;
    
    
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel runModalForTypes:[NSArray arrayWithObjects:@"aiff",@"aif",@"wav",nil]];
    
    NSString * filePath = [panel filename];
    if (filePath.length) {
        [df setValue:filePath forKey:kLPNNoticeSoundPath];
    }
}


/* livelist tableview delegate */
- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    [cell setDrawsBackground:YES];{
        NSColor * bgcolor;
        
        NSDictionary * entryDictionaryWillBeDisplay = [[_liveListController arrangedObjects] objectAtIndex:row];
        
        if ([_LPNListController hasEntry:entryDictionaryWillBeDisplay] ) {
            bgcolor = [NSColor colorWithDeviceRed:0 green:1.0 blue:1.0 alpha:0.3];
        }
        else {
            bgcolor = [NSColor whiteColor];
        }
        
        [cell setBackgroundColor:bgcolor];
    }
}


- (CGFloat)_getCellRowWithColumnWidth:(CGFloat)columnWidth string:(NSString *)string {
    NSSize stringSize;{
        NSDictionary * stringAttr = [NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
        stringSize = [string sizeWithAttributes:stringAttr];
    }
    
    if ( stringSize.width <= columnWidth ) {
        return stringSize.height;
    }
    else {
        return ( stringSize.height * ceil(stringSize.width/columnWidth) );
    }

}

- (CGFloat)_getCellRowWithColumnWidth:(CGFloat)columnWidth tags:(NSString *)tags {
    CGFloat ret = 0;
    
    NSArray * tagsArray = [tags componentsSeparatedByString:@"\n"];
    for (NSString * tag in tagsArray) {
        CGFloat tagHeight = [self _getCellRowWithColumnWidth:columnWidth string:tag];
        if (ret < tagHeight) ret = tagHeight;
    }
    
    return ret;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    NSDictionary * entry  = [[_liveListController arrangedObjects] objectAtIndex:row];
    
    CGFloat titleHeight =   [self _getCellRowWithColumnWidth:[[tableView tableColumnWithIdentifier:@"liveListTitle"] width] string:[entry title]];
    CGFloat tagHeight   =   [self _getCellRowWithColumnWidth:[[tableView tableColumnWithIdentifier:@"liveListTag"] width] string:[entry tag]];
    
    //#define MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
    //return MAX(titleHeight,tagHeith);
    return ( (titleHeight > tagHeight)? titleHeight : tagHeight );
}


#pragma mark -
#pragma mark LPNLiveListTableViewContextMenuDelegate
/*========================================================================================
 *
 *  LPNLiveListTableViewContextMenuDelegate
 *
 *========================================================================================*/
- (void)openLivePage:(id)sender {
    NSUInteger index = [_liveListController selectionIndex];
    NSString * urlstring = [(NSDictionary*)[[_liveListController arrangedObjects] objectAtIndex:index] URL];
    NSURL * url = [NSURL URLWithString:urlstring];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (void)copyLink:(id)sender {
    NSUInteger index = [_liveListController selectionIndex];
    NSString * urlstring = [(NSDictionary*)[[_liveListController arrangedObjects] objectAtIndex:index] URL];
    NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteBoard setString:urlstring forType:NSPasteboardTypeString];
}




/*========================================================================================
 *
 *  add notice element from context menu
 *
 *========================================================================================*/

enum SwapAddingEntryCommand {
    SWAP_ADDING_ENTRY_REGISTER  = 'regs',
    SWAP_ADDING_ENTRY_FREE      = 'free',
    SWAP_ADDING_ENTRY_GET       = 'fetc',
};
- (NSDictionary *)_manipulateSwapedAddingEntry:(NSDictionary *)entry command:(int)command {
    static NSDictionary * swap = nil;
    
    id ret;
    
    switch (command) {
        case SWAP_ADDING_ENTRY_REGISTER:
            if   (swap == nil) ;
            else [swap release];
            swap = [entry copy];
            ret = nil;
            break;
            
        case SWAP_ADDING_ENTRY_FREE:
            [swap release];
            swap = nil;
            ret = nil;
            break;
            
        case SWAP_ADDING_ENTRY_GET:
            ret = swap;
            break;
            
        default:
            break;
    }
    
    return ret;
}
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:nil];
}

- (void)addToPopUpNoticeList:(id)sender {
    
    NSDictionary * dic = [[_liveListController selectedObjects] objectAtIndex:0];
    [self _manipulateSwapedAddingEntry:dic command:SWAP_ADDING_ENTRY_REGISTER];
    
    [_willAddedStringToNoticeListTF setStringValue:[dic authorName]];
    
    [_filteringCommentInSheetTF setSelectable:YES];
    [_filteringCommentInSheetTF becomeFirstResponder];
    if ([_filteringCommentInSheetTF isEditable]) ;
    else {
        [_filteringCommentInSheetTF setEditable:YES];
    }
    
    [NSApp beginSheet:_sheetWindow
       modalForWindow:_window
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (NSString *)getWillBeAddedStringWithTypeIndex:(NSInteger)index {// private like
    NSDictionary * dic = [self _manipulateSwapedAddingEntry:nil command:SWAP_ADDING_ENTRY_GET];
    NSString * str;{
        switch (index) {
            case kFilteringTypeAuthor:
                str = [dic authorName];
                break;
                
            case kFilteringTypeLiveTitle:
                str = [dic title];
                break;
                
            case kFilteringTypeSummary:
                str = [dic summary];
                break;
            
            case kFilteringTypeTag:;
                str = [dic tag];
                break;
            default:
                break;
        }
    }
    
    return str;
}




- (IBAction)showWillAddedStringToNoticeList:(NSPopUpButton *)sender {
    if ( [sender indexOfSelectedItem] == kFilteringTypeTag) {
    }
    else {
        NSString * str = [self getWillBeAddedStringWithTypeIndex:[sender indexOfSelectedItem]];
        [_willAddedStringToNoticeListTF setStringValue:str];
    }
}


- (IBAction)sheetEndWithAdding:(NSButton *)sender {
    NSInteger index = [_filteringTypeInSheetPB indexOfSelectedItem];
    NSString * str = [self getWillBeAddedStringWithTypeIndex:index];
    NSString * comment = [NSString stringWithString:[_filteringCommentInSheetTF stringValue]];
    
    
    if (index == kFilteringTypeTag) {
        NSArray * tags = [str componentsSeparatedByString:@"\n"];
        for (NSString * tag in tags) {
            NSString * trimmedTag = [tag substringFromIndex:2];
            if (trimmedTag.length) {
                [_LPNListController addElementWithFilteringType:index
                                                filteringString:trimmedTag
                                                        comment:comment];
            }
        }
    }
    else {
        if (str.length) {
            [_LPNListController addElementWithFilteringType:index
                                            filteringString:str
                                                comment:comment];
        }
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

- (void)LPNXMLParserDidStartDocument {
}

- (void)LPNXMLParserDidEndDocument {
    [_currentFeededLiveIDs release];
    _currentFeededLiveIDs = [[NSArray alloc] initWithArray:_currentSubFeededLiveIDs];
    
    [_currentSubFeededLiveIDs release];
    _currentSubFeededLiveIDs = nil;
    
    [_displayInLIveCountTF setIntegerValue:[[_liveListController content] count]];
    
    
    // update livelist in status menu
    NSMutableArray * livetitles = [NSMutableArray array];
    for (NSDictionary * entry in [_liveListController content]) {
        // TODO: display format
        NSString * livetitle = [NSString stringWithFormat:@"%@\t|\t%@",[entry authorName],[entry title]];
        [livetitles addObject:livetitle];
    }
    LPNStatusBarMenu * statubarMenu = (LPNStatusBarMenu *)[_statusBarItem menu];
    [statubarMenu updateLiveList:livetitles];
}


#pragma mark Catch a entry
/*========================================================================================
 *
 *  Catch a entry
 *
 *========================================================================================*/

- (void)LPNXMLParserDidEndEntry:(NSDictionary *)entry {
    BOOL isIgnorable = [_LPNIgnoreListController hasEntry:entry];
    if (isIgnorable) return;
    
    [_liveListController addObject:entry];
    [_currentSubFeededLiveIDs addObject:[entry liveID]];
    
    [self _LPN_popUpNewEntry:entry];
    
}


- (void)LPNXMLParserOccuredError {
    // TODO: put the error in error log
    NSBeginAlertSheet(@"LivePopNotice",@"OK",nil,nil,_window,nil,nil,nil,nil,
                      NSLocalizedString(@"LPNXMLParserErrorMessage", @""));
}








#pragma mark -
#pragma mark Private-like Method
/*========================================================================================
 *
 *  Private-like Method
 *
 *========================================================================================*/

- (void)_LPN_stopRefreshTimer {
    if ([_refreshTimer isValid]) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}


- (void)_LPN_startRefreshTimer {
    NSTimeInterval interval;
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
#ifdef DEBUG
    interval = [df doubleForKey:kLPNUserDefaultsRefreshIntervalKey];
#else
    interval = ([df doubleForKey:kLPNUserDefaultsRefreshIntervalKey]*60.0);
#endif
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                     target:self
                                                   selector:@selector(_LPN_getAndParse:)
                                                   userInfo:nil repeats:YES];
}


- (void)_LPN_getAndParse:(NSTimer*)timer {
    refreshTimeIntervalManipulator(refreshTimeIntervalCountReset);
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
    if (_currentSubFeededLiveIDs) {
        [_currentSubFeededLiveIDs release];
    }
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
NSUInteger refreshTimeIntervalManipulator(LPNRefreshTimeIntervalManipulateCommad command) {
    static NSUInteger counter = 0;
    switch (command) {
        case refreshTimeIntervalCountReset:
            counter = 0;
            break;
        
        case refreshTimeIntervalCountIncrement:
            counter++;
            break;
            
        default:
            break;
    }
    
    return counter;
}


- (void)_LPN_cahngeRemainTimeInterval:(NSTimer *)timer {
    unsigned int min,sec;
    {
        NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
        unsigned int seconds = [df doubleForKey:kLPNUserDefaultsRefreshIntervalKey]*60 - refreshTimeIntervalManipulator(refreshTimeIntervalCountIncrement);
        min = seconds/60;
        sec = seconds%60;
    }
    [_displayIntervalTimeUntilNextRefresh setStringValue:[NSString stringWithFormat:@"%02u:%02u",min,sec]];
}


- (BOOL)_canPopUpWithEntry:(LPNEntryDictionary*)entry {// LPNEntryDictionary == NSDictionary
    return
    
#ifndef POPUP_TEST_IGNORE_GOT
    /* is firsrt load */
    ( [_currentFeededLiveIDs count] )
    
    &&
    /* is new live */
    ( ![_currentFeededLiveIDs containsObject:[entry liveID]] )
    
    &&
#endif
    
    
#ifdef POPUP_TEST_IGNORE_LIST
    YES;
#else
    /* is entry contained in notice list */
    ( [_LPNListController hasEntry:entry] )
    ;
#endif

}




#pragma mark -
#pragma mark Pop Up Notice Window
/*========================================================================================
 *
 *  Pop Up Notice Window
 *
 *========================================================================================*/
- (void)_LPN_popUpNewEntry:(LPNEntryDictionary *)entry {
    if (![self _canPopUpWithEntry:entry]){
        return;
    }
    
    
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    if ( [df boolForKey:kLPNIsPlayNoticeSound] ) {
        NSSound * snd;
        {
            snd = [[NSSound alloc] initWithContentsOfFile:[df stringForKey:kLPNNoticeSoundPath]
                                              byReference:YES];
            [[snd autorelease] play];
        }
    }
    
    LPNWindowController * win = [[LPNWindowController alloc] initWithLPNAttribute:entry];
    [win showWindowForDuration:[df doubleForKey:kLPNUserDefaultsNoticeDurationKey]];
}


@end
