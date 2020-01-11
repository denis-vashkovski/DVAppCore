//
//  UITableViewController+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACRefreshProtocol.h"

@protocol ACTableViewDataSource <NSObject>
- (UIView *)ac_viewForEmptyTableView:(UITableView *)tableView;
@end

@interface UITableViewController(AppCore)<ACTableViewDataSource, ACRefreshProtocol>
- (BOOL)ac_isDragging;

// TODO make it automatically
- (void)ac_showViewForEmptyTableView;
- (void)ac_hiddenViewForEmptyTableView;
@end
