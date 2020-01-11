//
//  ACTableViewCell.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 09.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

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
AC_STANDART_CREATING_NOT_AVAILABLE(@"initWithCell:")

+ (instancetype)separatorForCell:(UITableViewCell *)cell position:(ACSeparatorPosition)position;
+ (instancetype)separatorForCell:(UITableViewCell *)cell;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) ACLRInsets insets;
@property (nonatomic) CGFloat height;
@property (nonatomic, getter=isHidden) BOOL hidden;

- (void)update;
@end

@interface ACTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) ACSeparator *separatorTop;
@property (nonatomic, strong, readonly) ACSeparator *separatorBottom;
@end
