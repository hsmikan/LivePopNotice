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
static const CGFloat marginBottom = 10.0;
static const NSUInteger autosizingMask = (NSViewMaxXMargin | NSViewMinXMargin | NSViewWidthSizable |
                                          NSViewMaxYMargin | NSViewMinYMargin | NSViewHeightSizable);

- (WebView *)initWithSizeOfSuperView:(NSSize)size
                               entry:(NSDictionary *)entry
                      policyDelegate:(id)policyDelegate
{/*--------------------------------------------------------------------------------------*/
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
    NSMutableString * LPNHTML = [NSMutableString string];
#define ELEMENT(X) [LPNHTML appendString:(X)];
    ELEMENT(@"<html>"){
        ELEMENT(@"<head>"){
            ELEMENT(@"<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
            ELEMENT(@"<link rel='stylesheet' href='Contents/Resources/LPN.CSS' type='text/css'>")
        }ELEMENT(@"</head>")
        
        ELEMENT(@"<body>"){
            ELEMENT(@"<div id='body'>"){
                ELEMENT(@"<div id='title'>"){
                    ELEMENT(@"<a href='")ELEMENT([entry URL])ELEMENT(@"' target='_blank'>"){
                        ELEMENT([entry title])
                    }ELEMENT(@"</a>")
                }ELEMENT(@"</div>")
                
                ELEMENT(@"<div id='author'>"){
                    ELEMENT([entry authorName])ELEMENT(@"&nbsp;&nbsp;さん")
                }ELEMENT(@"</div>")
                
                ELEMENT(@"<div id='summary'>"){
                    ELEMENT([entry summary])
                }ELEMENT(@"</div>")
                
            }ELEMENT(@"</div>")
        }ELEMENT(@"</body>")
    }ELEMENT(@"</html>")
#undef ELEMENT
    
    return LPNHTML;
}

@end
