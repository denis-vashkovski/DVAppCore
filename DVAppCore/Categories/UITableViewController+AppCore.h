//
//  UITableViewController+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewController(AppCore)
- (void)ac_initRefreshView;
- (void)ac_startRefreshingTable;
- (void)ac_endRefreshingTable;
- (void)ac_refreshView;

- (BOOL)ac_isDragging;
@end
