//
//  UITableViewCell+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UITableViewCell
@interface UITableViewCell(AppCore)
- (UIView *)pp_addContainerAfterScrollWithColor:(UIColor *)color
                                      tableView:(UITableView *)tableView
                                      indexPath:(NSIndexPath *)indexPath;
- (UITableView *)ac_tableView;
@end
