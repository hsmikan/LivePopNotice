//
//  LPNXMLParser.h
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPNXMLParserDelegate;




@interface LPNXMLParser : NSObject <NSXMLParserDelegate> {
    id <LPNXMLParserDelegate> _delegate;
    NSUInteger _feedElementFlag;
    NSMutableString * _currentString;
    NSMutableDictionary * _entry;
}


@property (assign) id <LPNXMLParserDelegate> delegate;



- (id)initWithDelegate:(id <LPNXMLParserDelegate> )delegate;


- (void)parse;



@end
