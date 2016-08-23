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

@implementation UITableViewController(AppCore)

- (void)ac_initRefreshView {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:ACDesign(ACDesignColorRefreshControlTVC)];
    [self.refreshControl addTarget:self
                            action:@selector(ac_refreshView)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
}

- (void)ac_startRefreshingTable {
    if (!self.refreshControl || (self.tableView.contentOffset.y > .0)) {
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(.0,
                                                 (self.tableView.contentOffset.y - CGRectGetHeight(self.refreshControl.frame)))
                            animated:YES];
    [self.refreshControl beginRefreshing];
}

- (void)ac_endRefreshingTable {
    if (!self.refreshControl) {
        return;
    }
    
    [self.refreshControl endRefreshing];
}

- (void)ac_refreshView {
    [self ac_endRefreshingTable];
}

- (BOOL)ac_isDragging {
    return self.tableView.dragging || self.tableView.decelerating;
}

@end
