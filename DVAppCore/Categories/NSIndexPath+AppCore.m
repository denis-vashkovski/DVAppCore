//
//  NSIndexPath+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 06/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSIndexPath+AppCore.h"

#import <UIKit/UITableView.h>

@implementation NSIndexPath(AppCore)

+ (NSArray<NSIndexPath *> *)ac_indexPathsForSection:(NSInteger)section rangeRows:(NSRange)rangeRows {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSUInteger row = rangeRows.location; row < NSMaxRange(rangeRows); row++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return [NSArray arrayWithArray:indexPaths];
}

@end
