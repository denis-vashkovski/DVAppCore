//
//  UITableViewCell+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableViewCell+AppCore.h"

#import "ACConstants.h"

@implementation UITableViewCell(AppCore)

#define CONTAINER_AFTER_SCROLL_TAG 999
- (UIView *)pp_addContainerAfterScrollWithColor:(UIColor *)color
                                      tableView:(UITableView *)tableView
                                      indexPath:(NSIndexPath *)indexPath {
    UIView *view = [self viewWithTag:CONTAINER_AFTER_SCROLL_TAG];
    
    if (tableView && tableView.delegate && indexPath &&
        indexPath.section == (tableView.numberOfSections - 1) &&
        indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        
        [self setClipsToBounds:NO];
        
        if (!view) {
            view = [UIView new];
            [view setTag:CONTAINER_AFTER_SCROLL_TAG];
            [self addSubview:view];
            [self sendSubviewToBack:view];
        }
        
        [view setFrame:CGRectMake(.0,
                                  [tableView.delegate tableView:tableView heightForRowAtIndexPath:indexPath],
                                  CGRectGetWidth(tableView.frame),
                                  AC_SCREEN_HEIGHT * 2)];
        [view setBackgroundColor:color];
        
        return view;
    } else if (view) {
        [view removeFromSuperview];
    }
    
    return nil;
}

- (UITableView *)ac_tableView {
    UITableView *tableView = nil;
    UIView *view = self;
    while (view != nil) {
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
            break;
        }
        view = [view superview];
    }
    return tableView;
}

@end
