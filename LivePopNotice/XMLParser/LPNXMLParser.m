//
//  LPNXMLParser.m
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

//#import "LPNXMLParser.h"
//#import "LPNXMLParserDelegate.h"
//#import "LPNEntryDictionary.h"
#import "LPNFeedParser.h"

#import "../Constants/FeedTag.h"





#ifdef DEBUG
static NSString * const kCTFeedURLString    =   @"file://localhost/Users/hsmikan/index_live.xml";
static NSString * const kLTFeedURLString    =   @"file://localhost/Users/hsmikan/index.live.xml";
#else
static NSString * const kCTFeedURLString    =   @"http://gae.cavelis.net/index_live.xml";
static NSString * const kLTFeedURLString    =   @"http://livetube.cc/index.live.xml";
#endif

#define LPNCTLiveFeedURL [NSURL URLWithString:kCTFeedURLString]



typedef enum {
    kFeedElementNone        =   0,
    kFeedElementEntry       =   1UL << 0,
    kFeedElementTitle       =   1UL << 1,
    kFeedElementAuthor      =   1UL << 2,
    kFeedElementName        =   1UL << 3,
    kFeedElementID          =   1UL << 4,
    kFeedElementSummary     =   1UL << 5,
    kFeedElementContent     =   1UL << 6,
    kFeedElementUpdated     =   1UL << 7,
    kFeedElementPublished   =   1UL << 8,
    kFeedElementLiveID      =   1UL << 9,
    kFeedElementTag         =   1UL << 10,
} elementFlag;







@implementation LPNXMLParser

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<LPNXMLParserDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _currentString = [[NSMutableString alloc] init];
        _entry = [[LPNEntryMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)dealloc {
    [_entry release];
    [_currentString release];
    [super dealloc];
}



- (void)parse {
    
    NSXMLParser * parser = [[[NSXMLParser alloc] initWithContentsOfURL:LPNCTLiveFeedURL] autorelease];
    {
        [parser setDelegate:self];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        
    }
    
    [parser parse];

}



- (void)parse:(NSString *)siteurl {
    
    NSXMLParser * parser = [[[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:siteurl]] autorelease];
    {
        [parser setDelegate:self];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        
    }
    
    [parser parse];
}



- (void)parseWithSiteMask:(LPNFeedSiteMask)mask {
    if (!mask) {// mask == none
        [self parserDidEndDocument:nil];
    }
    
    if (! _serviceSiteMask)
        _serviceSiteMask = mask;
    
    if (mask & feedSiteCaveTube) {
        _currentSiteMask = feedSiteCaveTube;
        [self parse:kCTFeedURLString];
    }
    
    else if (mask & feedSiteLiveTube) {
        _currentSiteMask = feedSiteLiveTube;
        [self parse:kLTFeedURLString];
    }
}













#pragma mark -
#pragma mark NSXMLParserDelegate
/*========================================================================================
 *
 *  NSXMLParserDelegate
 *
 *========================================================================================*/

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if ([_delegate respondsToSelector:@selector(LPNXMLParserDidStartDocument)]) {
        [_delegate LPNXMLParserDidStartDocument];
    }
}




- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_serviceSiteMask) {
        _serviceSiteMask ^= _currentSiteMask;
        [self parseWithSiteMask:_serviceSiteMask];
    }
    else if ([_delegate respondsToSelector:@selector(LPNXMLParserDidEndDocument)]) {
        [_delegate LPNXMLParserDidEndDocument];
    }
}







#define CompareString(STR,ING) ([(STR) localizedCaseInsensitiveCompare:(ING)] == NSOrderedSame)
#define EnableFlag(FLAG,BIT) (FLAG) |= (BIT)
#define UnenableFlag(FLAG,BIT) (FLAG) ^= (BIT)
#define CheckElementFlag(FLAG,BIT) (FLAG) & (BIT)


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if      (CompareString(elementName, kFeedElementNameEntry)) {
        EnableFlag(_feedElementFlag, kFeedElementEntry);
        if (_currentSiteMask & feedSiteCaveTube ) {
            [_entry setService:@"CaveTube"];
        }
        else if (_currentSiteMask & feedSiteLiveTube) {
            [_entry setService:@"Livetube"];
        }

    }
    
    else if (CompareString(elementName, kFeedElementNameTitle)) {
        EnableFlag(_feedElementFlag, kFeedElementTitle);
    }
    
    else if (CompareString(elementName, kFeedElementNameAuthor)) {
        EnableFlag(_feedElementFlag, kFeedElementAuthor);
    }
    
    else if (CompareString(elementName, kFeedElementNameName)) {
        EnableFlag(_feedElementFlag, kFeedElementName);
    }
    
    else if (CompareString(elementName, kFeedElementNameID)) {
        if (_currentSiteMask & feedSiteLiveTube) {
            EnableFlag(_feedElementFlag, kFeedElementID);
        }
    }
    
    else if (CompareString(elementName, kFeedElementNameSummary)) {
        if (_currentSiteMask & feedSiteCaveTube) {
            EnableFlag(_feedElementFlag, kFeedElementSummary);
        }
    }
    
    else if (CompareString(elementName, kFeedElementNameContent)) {
        EnableFlag(_feedElementFlag, kFeedElementContent);
    }
    
    else if (CompareString(elementName, kFeedElementNameUpdated)) {
        EnableFlag(_feedElementFlag, kFeedElementUpdated);
    }
    
    else if (CompareString(elementName, kFeedElementNamePublished)) {
        EnableFlag(_feedElementFlag, kFeedElementPublished);
    }
    
    else if (CompareString(elementName, kFeedElementNameLiveID)) {
        if (_currentSiteMask & feedSiteCaveTube) {
            EnableFlag(_feedElementFlag, kFeedElementLiveID);
        }
    }
    
    else if (CompareString(elementName, kFeedElementNameLink)) {
        if (CompareString([attributeDict objectForKey:@"rel"], @"alternate")) {
            [_entry setURL:[attributeDict objectForKey:@"href"]];
        }
    }
    
    else if (CompareString(elementName, kFeedElementNameTag)) {
        if (_currentSiteMask & feedSiteCaveTube) {
            EnableFlag(_feedElementFlag, kFeedElementTag);
        }
    }
}




static const NSUInteger useElementFlags
=
kFeedElementName      | kFeedElementTitle  | kFeedElementID      | kFeedElementTag |
kFeedElementPublished | kFeedElementLiveID | kFeedElementSummary;

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    NSUInteger foundStringsLength = [_currentString length];
    
    NSString * foundStrings;
    if ( _feedElementFlag &  useElementFlags ) {
        //
        // TODO: trimming strings got from rss
        //
        //
        //
        if ( CompareString(elementName, kFeedElementNameTag) ) {
            foundStrings = [NSString stringWithString:_currentString];
        }
        else {
            foundStrings = [_currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    else {
        foundStrings = nil;
    }
    
    
    if      (CompareString(elementName, kFeedElementNameEntry)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementEntry);
        
        if (_currentSiteMask & feedSiteLiveTube) {
            [_entry setSummary:@""];
        }
        
        LPNEntryDictionary * newEntry = [LPNEntryDictionary dictionaryWithDictionary:_entry];

        if ([_delegate respondsToSelector:@selector(LPNXMLParserDidEndEntry:)]) {
            [_delegate LPNXMLParserDidEndEntry:newEntry];
        }
        
    }
    
    
    else if (CompareString(elementName, kFeedElementNameTitle)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementTitle);
        
        [_entry setTitle:foundStrings];
    }
    
    
    else if (CompareString(elementName, kFeedElementNameAuthor)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementAuthor);
        
    }
    
    
    else if (CompareString(elementName, kFeedElementNameName)) {
        
        if (_feedElementFlag & kFeedElementAuthor) {
            
            UnenableFlag(_feedElementFlag, kFeedElementName);
            
            [_entry setAuthorName:foundStrings];
        }
    }
    
    
    else if (CompareString(elementName, kFeedElementNameID)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementID);
        
        if (_currentSiteMask & feedSiteLiveTube) {
            [_entry setLiveID:foundStrings];
        }
    }
    
    
    else if (CompareString(elementName, kFeedElementNameSummary)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementSummary);
        [_entry setSummary:foundStrings];
    }
    
    
    else if (CompareString(elementName, kFeedElementNameContent)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementContent);
        
    }
    
    
    else if (CompareString(elementName, kFeedElementNameUpdated)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementUpdated);
        
    }
    
    
    else if (CompareString(elementName, kFeedElementNamePublished)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementPublished);
        //        2012-01-05T05:07:28Z
        // FIXME: time calc
        // NSDate
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"T:Z"];
        NSArray * timearr = [foundStrings componentsSeparatedByCharactersInSet:set];
        NSMutableString * time = [NSMutableString string];
        NSInteger hour = [[timearr objectAtIndex:1] intValue]+9;
        
        [time appendFormat:@"%02d:%@:%@",( hour < 24 ? hour : (hour-24) ),[timearr objectAtIndex:2],[timearr objectAtIndex:3]];
        [_entry setStartedtime:time];
        
    }
    
    
    else if (CompareString(elementName, kFeedElementNameLiveID)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementLiveID);
        
        if (_currentSiteMask & feedSiteCaveTube) {
            [_entry setLiveID:foundStrings];
        }
    }
    
    
    else if (CompareString(elementName, kFeedElementNameTag)) {
        if (_currentSiteMask & feedSiteCaveTube) {
            UnenableFlag(_feedElementFlag, kFeedElementTag);
            [_entry setTag:foundStrings];
        }
    }
    
    
    
    if ( foundStringsLength )
        [_currentString deleteCharactersInRange:NSMakeRange(0, [_currentString length])];
    
}





//- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI {
//    
//}
//
//
//
//
//- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix {
//    
//}





//- (NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID {
//    
//}




- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"PARSER ERROR. code:%ld\tdomain:%@\tuserInfor:%@\tDescription:%@\tReason:%@\tSuggestion:%@\tOptions:%@",
          [parseError code],[parseError domain],[parseError userInfo],[parseError localizedDescription],
          [parseError localizedFailureReason],[parseError localizedRecoverySuggestion],[parseError localizedRecoveryOptions]
          );
    if ([_delegate respondsToSelector:@selector(LPNXMLParserOccuredError)]) {
        [_delegate LPNXMLParserOccuredError];
    }
}





- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    // TODO: NSXMLParser validation error
}






- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ( _feedElementFlag &  useElementFlags ) {
        [_currentString appendString:string];
    }
    
}




//- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
//    
//}
//
//
//
//
//- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment {
//    
//}
//
//
//
//
//- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data {
//    
//}
//
//
//
//
//
//- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
//    
//}




//
// delegate for DTD is not implement
//



@end
