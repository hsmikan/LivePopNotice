//
//  FilteringTypePBCell.m
//  LivePopNotice
//
//  Created by hsmikan on 1/8/12.
//  Copyright (c) 2012 PPixy. All rights reserved.
//

#import "FilteringTypePBCell.h"

@implementation FilteringTypePBCell
- (void)awakeFromNib {
    [self addItemsWithTitles:[NSArray arrayWithObjects:
                              NSLocalizedString(@"LPNFilteringTypeAuthor", @""),
                              NSLocalizedString(@"LPNFilteringTypeLiveTitle", @""),
                              NSLocalizedString(@"LPNFilteringTypeLiveSummary", @""),
                              nil]];
}
@end
