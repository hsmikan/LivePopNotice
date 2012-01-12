//
//  LPNStatusBarMenu.m
//  LivePopNotice
//
//  Created by hsmikan on 1/11/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNStatusBarMenu.h"

@implementation LPNStatusBarMenu
- (id)initWithTitle:(NSString *)aTitle actionDelegate:(id)delegate {
    self = [super initWithTitle:aTitle];
    if (self) {
        /* show main window */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"LPNStatusMenuShowMainWindow", @"")
                                                           action:@selector(openMainWindow:)
                                                    keyEquivalent:@""];
            [item setTarget:delegate];
            [item setTag:LPNStatusBarTabShowWindow];
            [self addItem:[item autorelease]];
        }
        
        /* separator */
        [self addItem:[NSMenuItem separatorItem]];
        
        /* Cavetube */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:@"CaveTube"
                                                           action:nil
                                                    keyEquivalent:@""];
            [item setTag:LPNStatusBarTagCaveTube];
            [self addItem:[item autorelease]];
        }
        
        /* livetube */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:@"Livetube"
                                                           action:nil
                                                    keyEquivalent:@""];
            [item setTag:LPNStatusBarTagLivetube];
            [self addItem:[item autorelease]];
        }
        
        /* separator */
        [self addItem:[NSMenuItem separatorItem]];
        
        /* about￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"LPNStatusMenuAboutLivePopNOtice", @"")
                                                           action:@selector(orderFrontStandardAboutPanel:)
                                                    keyEquivalent:@""];
            [item setTarget:NSApp];
            [item setTag:LPNStatusBarTabAbout];
            [self addItem:[item autorelease]];
        }
        
        /* help￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"LPNStatusMenuHelp", @"")
                                                           action:@selector(showHelp:)
                                                    keyEquivalent:@""];
            [item setTarget:NSApp];
            [item setTag:LPNStatusBarTabHelp];
            [self addItem:[item autorelease]];
        }
        
        /* separator */
        [self addItem:[NSMenuItem separatorItem]];
        
        /* quit￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"LPNStatusMenuQuit", @"")
                                                           action:@selector(terminate:)
                                                    keyEquivalent:@""];
            [item setTarget:NSApp];
            [item setTag:LPNStatusBarTabQuit];
            [self addItem:[item autorelease]];
        }
    }
    
    return self;
}
@end
