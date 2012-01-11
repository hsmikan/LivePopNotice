//
//  LPNWindowMap.h
//  LivePopNotice
//
//  Created by hsmikan on 1/12/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LPNMapDictionary NSDictionary
@interface NSDictionary(LPNMap)
- (NSPoint)mapPoint;
- (NSValue *)mapPointValue;
- (BOOL)isDisplay;
- (NSUInteger)mapNumber;
@end


/* singleton */
@interface LPNWindowMap : NSObject
+ (LPNWindowMap *)sharedMap;
- (NSDictionary *)availableDisplayInfo;
- (void)unenableDisplayPointAtIndex:(NSUInteger)index;
@end
