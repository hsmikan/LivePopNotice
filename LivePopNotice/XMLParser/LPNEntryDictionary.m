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

- (NSString*)service {
    return [self objectForKey:kLPNEntryDictionaryServiceKey];
}

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


- (NSString*)tag {
    return [self objectForKey:kLPNEntryDictionaryTag];
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
#define SETCHECK(STRING) (STRING ? STRING : @"" )
- (void)setService:(NSString *)service {
    [self setObject:SETCHECK(service) forKey:kLPNEntryDictionaryServiceKey];
}


- (void)setTitle:(NSString *)title {
    
    [self setObject:SETCHECK(title) forKey:kLPNEntryDictionaryTitleKey];
    
}


- (void)setURL:(NSString *)url {
    
    [self setObject:SETCHECK(url) forKey:kLPNEntryDictionaryURLKey];
    
}


- (void)setAuthorName:(NSString *)author {
    
    [self setObject:SETCHECK(author) forKey:kLPNEntryDictionaryAuthorNameKey];
    
}


- (void)setStartedtime:(NSString *)time {
    
    [self setObject:SETCHECK(time) forKey:kLPNEntryDictionaryStartedTime];
    
}


- (void)setLiveID:(NSString*)liveID {
    
    [self setObject:SETCHECK(liveID) forKey:kLPNEntryDictionaryLiveID];
    
}


- (void)setSummary:(NSString *)summary {
    
    [self setObject:SETCHECK(summary) forKey:kLPNEntryDictionarySummary];
    
}


- (void)setTag:(NSString *)tag {
    [self setObject:SETCHECK(tag) forKey:kLPNEntryDictionaryTag];
}

#undef SETCHECK
@end
