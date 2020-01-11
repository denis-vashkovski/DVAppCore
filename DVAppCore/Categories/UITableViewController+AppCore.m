//
//  UITableViewController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableViewController+AppCore.h"

#import "UIColor+AppCore.h"
#import "ACDesignHelper.h"
#import "NSObject+AppCore.h"
#import "UIView+AppCore.h"

@implementation UITableViewController(AppCore)

#pragma mark - ACRefreshProtocol
- (void)ac_initRefreshView {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl setTintColor:ACDesign(ACDesignColorRefreshControlTVC)];
    [self.refreshControl addTarget:self action:@selector(ac_refreshView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
}

- (void)ac_startRefreshing {
    if (!self.refreshControl || (self.tableView.contentOffset.y > .0)) return;
    
    [self.tableView setContentOffset:CGPointMake(.0, (self.tableView.contentOffset.y - CGRectGetHeight(self.refreshControl.frame))) animated:YES];
    [self.refreshControl beginRefreshing];
}

- (void)ac_endRefreshing {
    if (!self.refreshControl) return;
    
    [self.refreshControl endRefreshing];
}

- (void)ac_refreshView {
    [self ac_endRefreshing];
}

- (BOOL)ac_isDragging {
    return self.tableView.dragging || self.tableView.decelerating;
}

- (void)ac_showViewForEmptyTableView {
    UIView *viewForEmptyTableView = nil;
    if ((self.tableView.visibleCells > 0) || !(viewForEmptyTableView = [self ac_viewForEmptyTableView:self.tableView])) return;
    
    [self.tableView setBackgroundView:viewForEmptyTableView];
}

- (void)ac_hiddenViewForEmptyTableView {
    [self.tableView.backgroundView ac_removeAllSubviews];
}

#pragma mark - ACTableViewDataSource
- (UIView *)ac_viewForEmptyTableView:(UITableView *)tableView {
    return nil;
}

@end
