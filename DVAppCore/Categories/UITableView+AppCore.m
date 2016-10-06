//
//  UITableView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableView+AppCore.h"

#import "NSArray+AppCore.h"
#import "NSIndexPath+AppCore.h"

#import "ACConstants.h"

@implementation UITableView(AppCore)
- (void)ac_setTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    if ([topColor isEqual:bottomColor]) {
        [self setBackgroundColor:topColor];
        self.tableFooterView = [[UIView alloc] init];
    } else {
        [self setBackgroundColor:topColor];
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        UIView *bigFooterView = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, SCREEN_WIDTH, SCREEN_HEIGHT * 2.)];
        bigFooterView.backgroundColor = bottomColor;
        bigFooterView.opaque = YES;
        [self.tableFooterView addSubview:bigFooterView];
    }
}

- (void)ac_insertRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self ac_isValidRangeRows:rangeRows forSection:section]) return;
    
    NSArray *updateCell = [NSIndexPath indexPathsForSection:section rangeRows:rangeRows];
    if (ValidArray(updateCell)) {
        [self insertRowsAtIndexPaths:updateCell withRowAnimation:animation];
    }
}

- (void)ac_reloadVisibleRows {
    [self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ac_reloadRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self ac_isValidRangeRows:rangeRows forSection:section]) return;
    
    NSArray *updateCell = [NSIndexPath indexPathsForSection:section rangeRows:rangeRows];
    if (ValidArray(updateCell)) {
        [self reloadRowsAtIndexPaths:updateCell withRowAnimation:animation];
    }
}

- (void)ac_deleteRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    if (![self ac_isValidRangeRows:rangeRows forSection:section]) return;
    
    NSArray *updateCell = [NSIndexPath indexPathsForSection:section rangeRows:rangeRows];
    if (ValidArray(updateCell)) {
        [self deleteRowsAtIndexPaths:updateCell withRowAnimation:animation];
    }
}

#pragma mark - Utils
- (BOOL)ac_isValidRangeRows:(NSRange)rangeRows forSection:(NSUInteger)section {
    return (self.numberOfSections > section) && ([self numberOfRowsInSection:section] > NSMaxRange(rangeRows));
}
@end
