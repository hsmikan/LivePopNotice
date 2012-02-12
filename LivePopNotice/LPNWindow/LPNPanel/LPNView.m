//
//  LPNView.m
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNView.h"
#import "../../XMLParser/LPNEntryDictionary.h"

#import <WebKit/WebKit.h>

@interface LPNEntryView : WebView
- (id)initWithSizeOfSuperView:(NSSize)size entry:(NSDictionary *)entry policyDelegate:(id)policyDelegate;
- (NSString *)createLPNHTMLString:(NSDictionary *)entry;
@end


@implementation LPNView


- (id)initWithFrame:(NSRect)frameRect entry:(NSDictionary *)entry policyDelegate:(id)policyDelegate {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setAutoresizesSubviews:YES];
        WebView * entryView;
        entryView = [[LPNEntryView alloc] initWithSizeOfSuperView:frameRect.size
                                                        entry:entry
                                               policyDelegate:policyDelegate];
        [self addSubview:[entryView autorelease]];
    }
    
    return self;
}

- (void)viewDidMoveToWindow {
    // enable mouseEnterd and mouseExited
    [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[self window] mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self window] mouseExited:theEvent];
}


@end





@implementation LPNEntryView : WebView

- (WebView *)initWithSizeOfSuperView:(NSSize)size
                               entry:(NSDictionary *)entry
                      policyDelegate:(id)policyDelegate
{/*--------------------------------------------------------------------------------------*/
    static const CGFloat marginBottom = 10.0;
    static const NSUInteger autosizingMask = (NSViewMaxXMargin | NSViewMinXMargin | NSViewWidthSizable |
                                              NSViewMaxYMargin | NSViewMinYMargin | NSViewHeightSizable);
    NSRect frame;{
        frame.size   = NSMakeSize(size.width, size.height-marginBottom);
        frame.origin = NSMakePoint(0, marginBottom);
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:autosizingMask];
        [self setPolicyDelegate:policyDelegate];
        [self setDrawsBackground:NO];
        
        [[self mainFrame] loadHTMLString:[self createLPNHTMLString:entry]
                                 baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    
    return self;
}



- (NSString *)createLPNHTMLString:(NSDictionary *)entry
{
#define CHECK(X) ( [(X) length] ? (X) : @"" )
    return
    [NSString stringWithFormat:
     @"<html>"
     "<head>"
     "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>"
     "<link rel='stylesheet' href='Contents/Resources/LPN.CSS' type='text/css'>"
     "</head>"
     
     "<body>"
      "<div id='body'>"
#ifdef DEBUG
     "<font color=red>debug</font>"
#endif
       "<div id='title'>"
        "<a href='%@' target='_blank'>%@</a>"
        //    [entry URL]        [entry title]
       "</div>"
      
       "<div id='author'>%@&nbsp;&nbsp;さん</div>"
        //         [entry authorname]
        
       "<div id='summary'>%@</div>"
       //           [entry summary]
     
      "</div>"
     "</body>"
     "</html>"
     ,[entry URL],[entry title],[entry authorName],[entry summary]];
#undef CHECK
}

@end
