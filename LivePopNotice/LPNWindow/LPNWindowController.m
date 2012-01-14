//
//  LPNWindowController.m
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNWindowController.h"


#import "../XMLParser/LPNEntryDictionary.h"

#import "LPNPanel/LPNPanel.h"


#import <WebKit/WebKit.h>
#import "../Model/LPNWindowMap.h"
#import "../Constants/LPNWindowSize.h"




@implementation LPNWindowController

- (id)initWithLPNAttribute:(NSDictionary *)attribute {
    NSDictionary * displayInfo = [[LPNWindowMap sharedMap] availableDisplayInfo];
    NSRect frame;
    {
        frame.origin = [displayInfo mapPoint];
        frame.size = NSMakeSize(kLPNWidth, kLPNHeight);
    }
    LPNPanel * LPN = [[LPNPanel alloc] initWithContentRect:frame
                                                     entry:attribute
                                                  delegate:self];
    
    self = [super initWithWindow:[LPN autorelease]];
    if (self) {
        _mapNumber = [displayInfo mapNumber];
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}


- (void)dealloc {
    if ( _closeTimer ) {
        [_closeTimer invalidate];
        _closeTimer = nil;
    }
    [super dealloc];
}





#pragma mark -
#pragma mark NSWindowDelegate
/*========================================================================================
 *
 *  NSWindowDelegate
 *
 *========================================================================================*/
- (BOOL)windowShouldClose:(id)sender {
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    LPNWindowMap * map = [LPNWindowMap sharedMap];
    [map unenableDisplayPointAtIndex:_mapNumber];
    [self autorelease];
}





#pragma mark -
#pragma mark 
/*========================================================================================
 *
 *  <#index title#>
 *
 *========================================================================================*/

- (void)_LPN_closeTimerStart {
    _closeTimer = [NSTimer scheduledTimerWithTimeInterval:_closeTimeInterval
                                                   target:[self window]
                                                 selector:@selector(close)
                                                 userInfo:nil
                                                  repeats:NO];
}


- (void)showWindowForDuration:(double)duration {
    [[self window] orderFront:nil];
    _closeTimeInterval = duration;
    [self _LPN_closeTimerStart];
}



- (void)mouseEntered:(NSEvent *)theEvent {
    if ([_closeTimer isValid]) {
        [_closeTimer invalidate];
        _closeTimer = nil;
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if ([[self window] isVisible]) {
        [self _LPN_closeTimerStart];
    }
}




/*========================================================================================
 *
 *  WebView Delegate
 *
 *========================================================================================*/
/* open link */
- (void)                webView:(WebView *)sender
 decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
                        request:(NSURLRequest *)request
                   newFrameName:(NSString *)frameName
               decisionListener:(id)listener
{
	NSURL *url = [[request URL] absoluteURL];
	[[NSWorkspace sharedWorkspace] openURL:url];
}


@end
