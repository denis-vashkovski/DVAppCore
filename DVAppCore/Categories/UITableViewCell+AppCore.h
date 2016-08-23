//
//  UITableViewCell+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSObject+AppCore.h"

typedef enum {
    ACSeparatorPositionBottom,
    ACSeparatorPositionTop
} ACSeparatorPosition;

#pragma mark - ACLRInsets
typedef struct ACLRInsets {
    CGFloat left, right;
} ACLRInsets;

static inline ACLRInsets ACLRInsetsMake(CGFloat left, CGFloat right) {
    ACLRInsets insets = {left, right};
    return insets;
}

#pragma mark - ACSeparator
@interface ACSeparator : UIView
STANDART_CREATING_NOT_AVAILABLE(@"initWithCell:")

+ (instancetype)separatorForCell:(UITableViewCell *)cell position:(ACSeparatorPosition)position;
+ (instancetype)separatorForCell:(UITableViewCell *)cell;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) ACLRInsets insets;
@property (nonatomic) CGFloat height;
@property (nonatomic, getter=isHidden) BOOL hidden;

- (void)update;
@end

#pragma mark - UITableViewCell
@interface UITableViewCell(AppCore)
@property (nonatomic, strong, readonly) ACSeparator *ac_separatorTop;
@property (nonatomic, strong, readonly) ACSeparator *ac_separatorBottom;

- (UIView *)ac_addContainerAfterScrollWithColor:(UIColor *)color delegate:(UITableViewController *)delegate indexPath:(NSIndexPath *)indexPath;
- (UITableView *)ac_tableView;
@end
