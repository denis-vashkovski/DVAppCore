//
//  UITableView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableView+AppCore.h"

#import "NSArray+AppCore.h"

#import "ACConstants.h"

@implementation UITableView(AppCore)
- (void)ac_reloadVisibleRows {
    [self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

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

- (void)ac_reloadRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    if ((self.numberOfSections < section) || ([self numberOfRowsInSection:section] < NSMaxRange(rangeRows))) {
        return;
    }
    
    NSMutableArray *updateCell = [NSMutableArray new];
    for (NSUInteger row = rangeRows.location; row < NSMaxRange(rangeRows); row++) {
        [updateCell addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    if (ValidArray(updateCell)) {
        [self reloadRowsAtIndexPaths:[NSArray arrayWithArray:updateCell] withRowAnimation:animation];
    }
}
@end
