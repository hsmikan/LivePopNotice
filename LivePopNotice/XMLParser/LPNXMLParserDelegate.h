//
//  LPNXMLParserDelegate.h
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol LPNXMLParserDelegate <NSObject>

//    @optional
- (void)LPNXMLParserDidStartDocument;
- (void)LPNXMLParserDidEndDocument;
- (void)LPNXMLParserDidEndEntry:(NSDictionary *)entry;
- (void)LPNXMLParserOccuredError;
@end
