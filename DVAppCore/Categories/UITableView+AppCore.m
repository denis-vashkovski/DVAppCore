//
//  UITableView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableView+AppCore.h"

#import "ACReusable.h"

#import "NSArray+AppCore.h"
#import "NSIndexPath+AppCore.h"
#import "UINib+AppCore.h"
#import "NSObject+AppCore.h"

#import "ACConstants.h"

@implementation UITableView(AppCore)

- (void)ac_registerHeaderFooterViewClass:(Class)headerFooterViewClass {
    [self ac_checkClass:headerFooterViewClass isConformsToProtocol:@protocol(ACReusable)];
    
    UINib *nib = [UINib ac_nibWithNibClass:headerFooterViewClass];
    if (nib) {
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:[headerFooterViewClass reusableIdentifier]];
    } else {
        [self registerClass:headerFooterViewClass forHeaderFooterViewReuseIdentifier:[headerFooterViewClass reusableIdentifier]];
    }
}

- (void)ac_registerCellClass:(Class)cellClass {
    [self ac_checkClass:cellClass isConformsToProtocol:@protocol(ACReusable)];
    
    UINib *nib = [UINib ac_nibWithNibClass:cellClass];
    if (nib) {
        [self registerNib:nib forCellReuseIdentifier:[cellClass reusableIdentifier]];
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:[cellClass reusableIdentifier]];
    }
}

- (void)ac_setTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    if ([topColor isEqual:bottomColor]) {
        [self setBackgroundColor:topColor];
        self.tableFooterView = [[UIView alloc] init];
    } else {
        [self setBackgroundColor:topColor];
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        UIView *bigFooterView = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT * 2.)];
        bigFooterView.backgroundColor = bottomColor;
        bigFooterView.opaque = YES;
        [self.tableFooterView addSubview:bigFooterView];
    }
}

- (void)ac_insertRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    NSArray *insertCells = [NSIndexPath ac_indexPathsForSection:section rangeRows:rangeRows];
    if (ACValidArray(insertCells)) {
        [self insertRowsAtIndexPaths:insertCells withRowAnimation:animation];
    }
}

- (void)ac_reloadVisibleRows {
    [self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

- (void)ac_reloadRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    NSArray *reloadCells = [NSIndexPath ac_indexPathsForSection:section rangeRows:rangeRows];
    if (ACValidArray(reloadCells)) {
        [self reloadRowsAtIndexPaths:reloadCells withRowAnimation:animation];
    }
}

- (void)ac_deleteRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation {
    NSArray *deleteCells = [NSIndexPath ac_indexPathsForSection:section rangeRows:rangeRows];
    if (ACValidArray(deleteCells)) {
        [self deleteRowsAtIndexPaths:deleteCells withRowAnimation:animation];
    }
}

- (NSString *)ac_registerNibByCellClass:(Class)cellClass {
    NSString *cellClassName = NSStringFromClass(cellClass);
    [self registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
    
    return cellClassName;
}

- (NSString *)ac_registerNibByHeaderFooterClass:(Class)headerFooterClass {
    NSString *viewClassName = NSStringFromClass(headerFooterClass);
    [self registerNib:[UINib nibWithNibName:viewClassName bundle:nil] forHeaderFooterViewReuseIdentifier:viewClassName];
    
    return viewClassName;
}

#pragma mark - Utils
- (BOOL)ac_isValidRangeRows:(NSRange)rangeRows forSection:(NSUInteger)section {
    return (self.numberOfSections > section) && ([self numberOfRowsInSection:section] > NSMaxRange(rangeRows));
}
@end
