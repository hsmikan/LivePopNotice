//
//  LPNEntryDictionary.h
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LPNEntryDictionary NSDictionary
@interface LPNEntryDictionary(LPNEntryDictionaryAddition)
- (NSString*)service;
- (NSString*)title;
- (NSString*)URL;
- (NSString*)authorName;
- (NSString*)startedTime;
- (NSString*)liveID;
- (NSString*)summary;
@end

#define LPNEntryMutableDictionary NSMutableDictionary
@interface LPNEntryMutableDictionary(LPNEntryDictionaryAddition)
- (void)setService:(NSString*)service;
- (void)setTitle:(NSString*)title;
- (void)setURL:(NSString*)url;
- (void)setAuthorName:(NSString*)author;
- (void)setStartedtime:(NSString*)time;
- (void)setLiveID:(NSString*)liveID;
- (void)setSummary:(NSString*)summary;

@end
