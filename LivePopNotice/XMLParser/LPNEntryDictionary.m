//
//  LPNEntryDictionary.m
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "LPNEntryDictionary.h"

#import "LPNEntryDictionaryKeys.h"


@implementation LPNEntryDictionary(LPNEntryDictionaryAddition)


- (NSString*)title {
    
    return [self objectForKey:kLPNEntryDictionaryTitleKey];
    
}


- (NSString*)URL {
    
    return [self objectForKey:kLPNEntryDictionaryURLKey];
    
}


- (NSString*)authorName {
    
    return [self objectForKey:kLPNEntryDictionaryAuthorNameKey];
    
}


- (NSString*)startedTime {
    
    return [self objectForKey:kLPNEntryDictionaryStartedTime];
    
}



- (NSString*)liveID {
    
    return [self objectForKey:kLPNEntryDictionaryLiveID];
    
}


- (NSString *)summary {
    
    return [self objectForKey:kLPNEntryDictionarySummary];
    
}

@end





@implementation LPNEntryMutableDictionary(LPNEntryDictionaryAddition)


#pragma mark -
#pragma mark Interface
/*========================================================================================
 *
 *  Interface
 *
 *========================================================================================*/

- (void)setTitle:(NSString *)title {
    
    [self setObject:title forKey:kLPNEntryDictionaryTitleKey];
    
}


- (void)setURL:(NSString *)url {
    
    [self setObject:url forKey:kLPNEntryDictionaryURLKey];
    
}


- (void)setAuthorName:(NSString *)author {
    
    [self setObject:author forKey:kLPNEntryDictionaryAuthorNameKey];
    
}


- (void)setStartedtime:(NSString *)time {
    
    [self setObject:time forKey:kLPNEntryDictionaryStartedTime];
    
}


- (void)setLiveID:(NSString*)liveID {
    
    [self setObject:liveID forKey:kLPNEntryDictionaryLiveID];
    
}


- (void)setSummary:(NSString *)summary {
    
    [self setObject:summary forKey:kLPNEntryDictionarySummary];
    
}

@end
