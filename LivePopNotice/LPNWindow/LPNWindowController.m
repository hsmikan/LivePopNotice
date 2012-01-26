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
    
    originFrame.origin = [displayInfo mapPoint];
    originFrame.size = NSMakeSize(kLPNWidth, kLPNHeight);
    
    LPNPanel * LPN = [[LPNPanel alloc] initWithContentRect:originFrame
                                                     entry:attribute
                                                  delegate:self];
    
    originFrame.size.height = kLPNHeightIncludedTitleBar;
    
    if (LPN) {
    self = [super initWithWindow:[LPN autorelease]];
    if (self) {
        _mapNumber = [displayInfo mapNumber];
    }
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
    static const CGFloat exposeWidth    =   14.0;//kLPNWidth/20
    static const CGFloat exposeHeight   =   5.95;//kLPNHeightIncludedTitlbar/20
    static const CGFloat exposeX        =   7.0; //exposeWidth/2
    static const CGFloat exposeY        =   2.975; //exposeHeight/2
    
    NSWindow * win = [self window];
    
    [win orderFront:nil];
    NSRect exposeRect;{
        NSSize currentSize = originFrame.size;
        exposeRect.size   = NSMakeSize(currentSize.width+exposeWidth, currentSize.height+exposeHeight);
        
        NSPoint currentPoint = originFrame.origin;
        exposeRect.origin = NSMakePoint(currentPoint.x-exposeX, currentPoint.y-exposeY);
    }
    [win setFrame:exposeRect display:YES animate:YES];
    
    
    if ([_closeTimer isValid]) {
        [_closeTimer invalidate];
        _closeTimer = nil;
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self window] setFrame:originFrame display:YES animate:YES];
    
    if ([[self window] isVisible]) {
        [self _LPN_closeTimerStart];
    }
}




/*========================================================================================
 *
 *  WebView Policy Delegate
 *
 *========================================================================================*/
/* open link */
- (void)                webView:(WebView *)sender
 decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
                        request:(NSURLRequest *)request
                   newFrameName:(NSString *)frameName
               decisionListener:(id)listener
{
    /* TODO: graphically notice that the link is clicked */
	NSURL *url = [[request URL] absoluteURL];
	[[NSWorkspace sharedWorkspace] openURL:url];
}


@end
