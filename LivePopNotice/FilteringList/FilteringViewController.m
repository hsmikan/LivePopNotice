//
//  FilteringViewController.m
//  LivePopNotice
//
//  Created by hsmikan on 1/10/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "FilteringViewController.h"
#import "../Constants/filteringTypeIdentifier.h"
#import "../XMLParser/LPNEntryDictionary.h"


@interface NSDictionary(FilteringViewControllerContent)
- (NSString *)filteringString;
@end
@implementation NSDictionary(FilteringViewControllerContent)

- (NSString *)filteringString {
    return [self objectForKey:kFilteringStringIdentifier];
}
@end





@implementation FilteringViewController
@synthesize filteringListController = _filteringListController;
@synthesize filterTypePB = _filterTypePB;
@synthesize filterStringTF = _filterStringTF;


- (void)awakeFromNib {
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    NSMutableArray * content = [NSMutableArray arrayWithArray:[df arrayForKey:_filteringListControllerKey]];
    [_filteringListController addObjects:content];
}


- (id)initWithArrayControllerKey:(NSString *)key {
    self = [super initWithNibName:@"FilteringViewController" bundle:nil];
    if (self) {
        _filteringListControllerKey = [key copy];
    }
    
    return self;
}


- (void)dealloc {
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    [df setObject:[_filteringListController content] forKey:_filteringListControllerKey];
    
    [_filteringListControllerKey release];
    [_filteringListController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}





- (IBAction)addElement:(NSButton *)sender {
    if ( ![[_filterStringTF stringValue] length] ) {
        return;
    }
    
    [self addElementWithFilteringType:[_filterTypePB indexOfSelectedItem]
                      filteringString:[_filterStringTF stringValue]];
    
    [_filterStringTF setStringValue:@""];
}
- (void)addElementWithFilteringType:(NSInteger)typeIndex filteringString:(NSString *)string {
    if (!string.length) return;
    NSMutableDictionary * willBeAdded = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInteger:typeIndex],kFilteringTypeIdentifier,
                                         string,kFilteringStringIdentifier,
                                         nil];
    if (! [[_filteringListController content] containsObject:willBeAdded] ) {
        [_filteringListController addObject:willBeAdded];
    }
}


- (IBAction)removeElements:(id)sender {
    [_filteringListController removeObjects:[_filteringListController selectedObjects]];
}





- (BOOL)hasEntry:(LPNEntryDictionary *)entry {
    NSString * authorName   =   nil;
    NSString * title        =   nil;
    NSString * summary      =   nil;
    NSString * tag          =   nil;
    
    BOOL isContained = NO;
#define CHECKSTRING(STRING) ((STRING) ? (STRING) : @"")
    for (NSDictionary * dic in [_filteringListController content]) {
#define DIC_FILTERINGSTRING [dic filteringString]
        NSInteger switchConstant = [[dic objectForKey:kFilteringTypeIdentifier] integerValue];
        switch (switchConstant) {
            case kFilteringTypeAuthor:
                if (authorName == nil) authorName = CHECKSTRING([entry authorName]);
                isContained = [authorName isEqualToString:DIC_FILTERINGSTRING];
                break;
                
            case kFilteringTypeLiveTitle:
                if (title == nil) title = CHECKSTRING([entry title]);
                isContained = [title rangeOfString:DIC_FILTERINGSTRING].location != NSNotFound;
                break;
                
            case kFilteringTypeSummary:
                if (summary == nil) summary = CHECKSTRING([entry summary]);
                isContained = [summary rangeOfString:DIC_FILTERINGSTRING].location != NSNotFound;
                break;
                
            case kFilteringTypeTag:
                if (tag == nil) tag = CHECKSTRING([entry tag]);
                isContained = [tag rangeOfString:DIC_FILTERINGSTRING].location != NSNotFound;
                break;
                
            default:
                break;
        }
        
        if (isContained) {
            break;
        }
#undef DIC_FILTERINGSTRING
    }
#undef CHECKSTRING
    return isContained;
}



@end
