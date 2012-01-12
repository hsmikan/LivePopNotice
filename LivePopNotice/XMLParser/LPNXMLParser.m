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

#import "../Constants/cavetubeFeedTag.h"





#ifdef DEBUG
static NSString * const kFeedURL    =   @"file://localhost/Users/hsmikan/index_live.xml";
#else
static NSString * const kFeedURL    =   @"http://gae.cavelis.net/index_live.xml";
#endif

#define LPNCTLiveFeedURL [NSURL URLWithString:kFeedURL]



typedef enum {
    kFeedElementNone        =   0,
    kFeedElementEntry       =   1 << 0,
    kFeedElementTitle       =   1 << 1,
    kFeedElementAuthor      =   1 << 2,
    kFeedElementName        =   1 << 3,
    kFeedElementLiveURL     =   1 << 4,
    kFeedElementSummary     =   1 << 5,
    kFeedElementContent     =   1 << 6,
    kFeedElementUpdated     =   1 << 7,
    kFeedElementPublished   =   1 << 8,
    kFeedElementLiveID      =   1 << 9,
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
        // [parser autorelease];
        [parser setDelegate:self];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        
    }
    
    [parser parse];

}














#pragma mark -
#pragma mark NSXMLParserDelegate
/*========================================================================================
 *
 *  NSXMLParserDelegate
 *
 *========================================================================================*/

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if ([_delegate respondsToSelector:@selector(LPNXMLParserDidStartDocyment)]) {
        [_delegate LPNXMLParserDidStartDocyment];
    }
}




- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if ([_delegate respondsToSelector:@selector(LPNXMLParserDidEndDocument)]) {
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
    if      (CompareString(elementName, kCaveTubeFeedElementEntry)) {
        EnableFlag(_feedElementFlag, kFeedElementEntry);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementTitle)) {
        EnableFlag(_feedElementFlag, kFeedElementTitle);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementAuthor)) {
        EnableFlag(_feedElementFlag, kFeedElementAuthor);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementName)) {
        EnableFlag(_feedElementFlag, kFeedElementName);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementLiveURL)) {
        EnableFlag(_feedElementFlag, kFeedElementLiveURL);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementSummary)) {
        EnableFlag(_feedElementFlag, kFeedElementSummary);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementContent)) {
        EnableFlag(_feedElementFlag, kFeedElementContent);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementUpdated)) {
        EnableFlag(_feedElementFlag, kFeedElementUpdated);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementPublished)) {
        EnableFlag(_feedElementFlag, kFeedElementPublished);
    }
    
    else if (CompareString(elementName, kCaveTubeFeedElementLiveID)) {
        EnableFlag(_feedElementFlag, kFeedElementLiveID);
    }
    
    else if (CompareString(elementName, @"link")) {
        if (CompareString([attributeDict objectForKey:@"rel"], @"alternate")) {
            [_entry setURL:[attributeDict objectForKey:@"href"]];
        }
    }
}





NSUInteger useElementFlags
=
kFeedElementName | kFeedElementTitle | kFeedElementLiveURL
| kFeedElementPublished | kFeedElementLiveID | kFeedElementSummary;


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    NSString * text;
    if ( _feedElementFlag &  useElementFlags )
    {
        text = [_currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else {
        text = nil;
    }
    
    if      (CompareString(elementName, kCaveTubeFeedElementEntry)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementEntry);
        
        LPNEntryDictionary * newEntry = [LPNEntryDictionary dictionaryWithDictionary:_entry];

        if ([_delegate respondsToSelector:@selector(LPNXMLParserDidEndEntry:)]) {
            [_delegate LPNXMLParserDidEndEntry:newEntry];
        }
        
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementTitle)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementTitle);
        
        [_entry setTitle:text];
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementAuthor)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementAuthor);
        
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementName)) {
        
        if (_feedElementFlag & kFeedElementAuthor) {
            
            UnenableFlag(_feedElementFlag, kFeedElementName);
            
            [_entry setAuthorName:text];
        }
    }
    
    
//    else if (CompareString(elementName, kCaveTubeFeedElementLiveURL)) {
//        
//        UnenableFlag(_feedElementFlag, kFeedElementLiveURL);
//        
//        [_entry setURL:text];
//    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementSummary)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementSummary);
        [_entry setSummary:text];
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementContent)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementContent);
        
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementUpdated)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementUpdated);
        
        //  [_entry setStartedtime:[text substringWithRange:NSMakeRange(11, 8)]];
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementPublished)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementPublished);
        //        2012-01-05T05:07:28Z
        // FIXME: time calc
        // NSDate
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"T:Z"];
        NSArray * timearr = [text componentsSeparatedByCharactersInSet:set];
        NSMutableString * time = [NSMutableString string];
        [time appendFormat:@"%02d:%@:%@",[[timearr objectAtIndex:1] intValue]+9,[timearr objectAtIndex:2],[timearr objectAtIndex:3]];
        [_entry setStartedtime:time];
        
    }
    
    
    else if (CompareString(elementName, kCaveTubeFeedElementLiveID)) {
        
        UnenableFlag(_feedElementFlag, kFeedElementLiveID);
        
        [_entry setLiveID:text];
    }
    
    
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
    // TODO: NSXMLParser error
}





- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    // TODO: NSXMLParser validation error
}






- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [_currentString appendString:string];
    
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
