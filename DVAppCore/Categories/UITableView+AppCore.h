//
//  UITableView+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 27/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(AppCore)
- (void)ac_registerHeaderFooterViewClass:(Class)headerFooterViewClass;
- (void)ac_registerCellClass:(Class)cellClass;

- (void)ac_setTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

- (void)ac_insertRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)ac_reloadVisibleRows;
- (void)ac_reloadRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)ac_deleteRowsAtSection:(NSUInteger)section rangeRows:(NSRange)rangeRows withRowAnimation:(UITableViewRowAnimation)animation;

- (NSString *)ac_registerNibByCellClass:(Class)cellClass;
- (NSString *)ac_registerNibByHeaderFooterClass:(Class)headerFooterClass;
@end
