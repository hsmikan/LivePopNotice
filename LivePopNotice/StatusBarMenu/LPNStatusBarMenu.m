//
//  LPNStatusBarMenu.m
//  LivePopNotice
//
//  Created by hsmikan on 1/11/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNStatusBarMenu.h"
#import "LPNStatuBarMenuActionDelegate.h"
#import "LPNEntryDictionary.h"

@implementation LPNStatusBarMenu

@synthesize actionDelegate = _actionDelegate;

- (id)initWithTitle:(NSString *)aTitle actionDelegate:(id<LPNStatuBarMenuActionDelegate>)delegate {
    self = [super initWithTitle:aTitle];
    if (self) {
        
        self.actionDelegate = delegate;
        
        
        /* show main window */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:NSLocalizedString(@"LPNStatusMenuShowMainWindow", @"")];
                if ([delegate respondsToSelector:@selector(openMainWindow:)]) {
                    [item setTarget:delegate];
                    [item setAction:@selector(openMainWindow:)];
                }
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTabShowWindow];
            [self addItem:[item autorelease]];
        }
        
        /* jump to live page */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:NSLocalizedString(@"LPNStatusMenuJumpToLivePage", @"")];
                [item setAction:nil];
                [item setKeyEquivalent:@""];
                
                NSMenu * submenu;{
                    submenu = [[[NSMenu alloc] initWithTitle:@"livelist"] autorelease];
                }
                [item setSubmenu:submenu];
            }
            [self addItem:[item autorelease]];
        }
        
        
        /* separator */{
            [self addItem:[NSMenuItem separatorItem]];
        }
        
        
        /* Cavetube */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:@"CaveTube"];
                [item setAction:nil];
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTagCaveTube];
            [self addItem:[item autorelease]];
        }
        
        
        /* livetube */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:@"Livetube"];
                [item setAction:nil];
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTagLivetube];
            [self addItem:[item autorelease]];
        }
        
        /* separator */{
            [self addItem:[NSMenuItem separatorItem]];
        }
        
        
        /* about￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:NSLocalizedString(@"LPNStatusMenuAboutLivePopNOtice", @"")];
                [item setTarget:NSApp];
                [item setAction:@selector(orderFrontStandardAboutPanel:)];
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTabAbout];
            [self addItem:[item autorelease]];
        }
        
        
        /* help￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:NSLocalizedString(@"LPNStatusMenuHelp", @"")];
                [item setTarget:NSApp];
                [item setAction:@selector(showHelp:)];
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTabHelp];
            [self addItem:[item autorelease]];
        }
        
        
        /* separator */{
            [self addItem:[NSMenuItem separatorItem]];
        }
        
        
        /* quit￼ */{
            NSMenuItem * item = [[NSMenuItem alloc] init];{
                [item setTitle:NSLocalizedString(@"LPNStatusMenuQuit", @"")];
                [item setTarget:NSApp];
                [item setAction:@selector(terminate:)];
                [item setKeyEquivalent:@""];
            }
            [item setTag:LPNStatusBarTabQuit];
            [self addItem:[item autorelease]];
        }
    }
    
    return self;
}




- (void)updateLiveList:(NSArray *)livelistTitles {
    NSMenuItem * submenuItem =
    [self itemWithTitle:NSLocalizedString(@"LPNStatusMenuJumpToLivePage", @"")];
    NSMenu * submenu = [submenuItem submenu];
    
    [submenu removeAllItems];
    for (NSString * title in livelistTitles) {
        NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:title action:@selector(clickedStatusBarLiveListSubMenu:) keyEquivalent:@""];
        [item setTarget:_actionDelegate];
        [submenu addItem:[item autorelease]];
    }
}

@end
