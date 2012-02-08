//
//  LPNWindowMap.m
//  LivePopNotice
//
//  Created by hsmikan on 1/12/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNWindowMap.h"
#import "../Constants/LPNWindowSize.h"


#pragma mark -
#pragma mark Map Dictionary 
static NSString * const kLPNMapPointKey        =   @"LPNPoint";
static NSString * const kLPNMapIsDisplayKey    =   @"LPNIsDisplay";
static NSString * const kLPNMapNumberKey       =   @"LPNMapNumber";



@implementation LPNMapDictionary(LPNMap)
- (NSPoint)mapPoint {
    return [[self objectForKey:kLPNMapPointKey] pointValue];
}
- (NSValue *)mapPointValue {
    return [self objectForKey:kLPNMapPointKey];
}

- (BOOL)isDisplay {
    return [[self objectForKey:kLPNMapIsDisplayKey] boolValue];
}
- (NSUInteger)mapNumber {
    return [[self objectForKey:kLPNMapNumberKey] integerValue];
}
@end







#define LPNMapMutableDictionary NSMutableDictionary
@interface LPNMapMutableDictionary(LPNMap)
+ (LPNMapMutableDictionary *)LPNMapDictionaryWithPoint:(NSPoint)point;
- (void)setMapPoiont:(NSPoint)point;
- (void)setIsDisplay:(BOOL)isDisplay;
- (void)setDisplayNumber:(NSUInteger)number;
@end



@implementation LPNMapMutableDictionary(LPNMap)

+ (LPNMapMutableDictionary *)LPNMapDictionaryWithPoint:(NSPoint)point {
    return [LPNMapMutableDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithPoint:point],kLPNMapPointKey,
            [NSNumber numberWithBool:NO],kLPNMapIsDisplayKey,
            nil];
}

- (void)setMapPoiont:(NSPoint)point {
    [self setObject:[NSValue valueWithPoint:point] forKey:kLPNMapPointKey];
}
- (void)setIsDisplay:(BOOL)isDisplay {
    [self setObject:[NSNumber numberWithBool:isDisplay] forKey:kLPNMapIsDisplayKey];
}
- (void)setDisplayNumber:(NSUInteger)number {
    [self setObject:[NSNumber numberWithUnsignedInteger:number] forKey:kLPNMapNumberKey];
}

@end








@interface LPNWindowMap()
+ (NSArray *)popUpPositionMap;
@end




@implementation LPNWindowMap

static LPNWindowMap * _sharedMap = nil;
static NSArray * _map = nil;


+ (LPNWindowMap *)sharedMap {
    @synchronized(self) {
        if (_sharedMap == nil) {
            [[self alloc] init];
            
            NSNotificationCenter * ntc = [NSNotificationCenter defaultCenter];
            [ntc addObserver:[LPNWindowMap class]
                    selector:@selector(releaseLNPMap:)
                        name:NSApplicationWillTerminateNotification
                      object:NSApp];
        }
    }
    
    return _sharedMap;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        _sharedMap = [super allocWithZone:zone];
        if (_sharedMap) {
            _map = [[NSArray alloc] initWithArray:[LPNWindowMap popUpPositionMap]];
        }
        
        return _sharedMap;
    }
    
    return nil;
}

+ (void)releaseLNPMap:(NSNotification *)notification {
    [_map release]; _map = nil;
    [_sharedMap release]; _sharedMap = nil;
    
    NSNotificationCenter * ntc = [NSNotificationCenter defaultCenter];
    [ntc removeObserver:[LPNWindowMap class] name:NSApplicationWillTerminateNotification object:NSApp];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
    return;
}

- (id)autorelease {
    return self;
}





- (NSDictionary *)availableDisplayInfo {
    NSUInteger mapNumber = 0;
    NSDictionary * ret = nil;
    
    for (LPNMapMutableDictionary * info in _map) {
        if (![info isDisplay]) {
            [info setIsDisplay:YES];
            ret = [LPNMapDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithUnsignedInteger:mapNumber],kLPNMapNumberKey,
                   [info mapPointValue],kLPNMapPointKey,
                   nil];
            break;
        }
        mapNumber++;
    }
    
    return ret;
}

- (void)enableDisplayPointAtIndex:(NSUInteger)index {
    if (_map) {
        [[_map objectAtIndex:index] setIsDisplay:NO];
    }
}



+ (NSArray *)popUpPositionMap {
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSMutableArray * popUpWindowMap = [NSMutableArray array];
    
    int i,j;
    for (i = (screenRect.size.width-kLPNWidth);                   i >= 0; i -= kLPNWidth)
    for (j = (screenRect.size.height-kLPNHeightIncludedTitleBar); j >= 0; j -= kLPNHeightIncludedTitleBar)
    {
        [popUpWindowMap addObject:[LPNMapMutableDictionary LPNMapDictionaryWithPoint:NSMakePoint(i, j)]];
    }
    
    return (NSArray*)popUpWindowMap;
}

@end
