//
//  LPNXMLParser.h
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPNXMLParserDelegate;

enum feedSiteMask {
    feedSiteNone = 0,
    feedSiteCaveTube = 1 << 0,
    feedSiteLiveTube = 1 << 1,
    };
typedef unsigned LPNFeedSiteMask;

@interface LPNXMLParser : NSObject <NSXMLParserDelegate> {
    id <LPNXMLParserDelegate> _delegate;
    LPNFeedSiteMask _serviceSiteMask;
    LPNFeedSiteMask _currentSiteMask;
    NSUInteger _feedElementFlag;
    NSMutableString * _currentString;
    NSMutableDictionary * _entry;
}


@property (assign) id <LPNXMLParserDelegate> delegate;



- (id)initWithDelegate:(id <LPNXMLParserDelegate> )delegate;


- (void)parse DEPRECATED_ATTRIBUTE;
- (void)parseWithSiteMask:(LPNFeedSiteMask)mask;


@end
