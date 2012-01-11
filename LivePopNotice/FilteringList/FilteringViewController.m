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
    // TODO: addition check
    if ( ![[_filterStringTF stringValue] length] ) {
        return;
    }
    [_filteringListController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInteger:[_filterTypePB indexOfSelectedItem]],kFilteringTypeIdentifier,
                                         [_filterStringTF stringValue],kFilteringStringIdentifier,
                                         nil]];
    [_filterStringTF setStringValue:@""];
}


- (IBAction)removeElements:(id)sender {
    [_filteringListController removeObjects:[_filteringListController selectedObjects]];
}





- (BOOL)isContainendEntry:(LPNEntryDictionary *)entry {
    NSString * authorName = nil;
    NSString * title = nil;
    NSString * summary = nil;
    
    BOOL isContained = NO;
    
    for (NSDictionary * dic in [_filteringListController arrangedObjects]) {
        NSInteger switchConstant = [[dic objectForKey:kFilteringTypeIdentifier] integerValue];
        switch (switchConstant) {
            case kFilteringTypeAuthor:
                if (authorName == nil) authorName = [entry authorName];
                isContained = [authorName isEqualToString:[dic filteringString]];
                break;
                
            case kFilteringTypeLiveTitle:
                if (title == nil) title = [entry title];
                isContained = [title rangeOfString:[dic filteringString]].location != NSNotFound;
                break;
                
            case kFilteringTypeSummary:
                if (summary == nil) summary = [entry summary];
                isContained = [summary rangeOfString:[dic filteringString]].location != NSNotFound;
                break;
                
            default:
                break;
        }
        
        if (isContained) {
            break;
        }
    }
    
    return isContained;
}



@end
