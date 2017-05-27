//
//  UITableViewCell+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableViewCell+AppCore.h"

#import "ACConstants.h"

#import "NSObject+AppCore.h"
#import "UIColor+AppCore.h"

#pragma mark - ACSeparator
@implementation ACSeparator{
    ACSeparatorPosition _position;
    UIView *_view;
}

#define DEFAULT_SEPARATOR_COLOR ACColorHex(@"#ebebeb")
#define DEFAULT_SEPARATOR_HEIGHT (1 / [UIScreen mainScreen].scale)
- (instancetype)initWithCell:(UITableViewCell *)cell position:(ACSeparatorPosition)position {
    if ((self = [super init]) && cell) {
        _view = [UIView new];
        [cell addSubview:_view];
        [cell bringSubviewToFront:_view];
        
        [self setHidden:YES];
        [self setColor:DEFAULT_SEPARATOR_COLOR];
        
        _height = DEFAULT_SEPARATOR_HEIGHT;
        _position = position;
    }
    return self;
}

+ (instancetype)separatorForCell:(UITableViewCell *)cell position:(ACSeparatorPosition)position {
    return [[super alloc] initWithCell:cell position:position];
}

+ (instancetype)separatorForCell:(UITableViewCell *)cell {
    return [self separatorForCell:cell position:ACSeparatorPositionBottom];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [_view setBackgroundColor:color];
}

- (void)setInsets:(ACLRInsets)insets {
    _insets = insets;
    [self update];
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    [self update];
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    [_view setHidden:_hidden];
}

#pragma mark Utils
- (void)update {
    CGRect frame = _view.frame;
    frame.origin.x = self.insets.left;
    frame.origin.y = (_position == ACSeparatorPositionTop) ? .0 : (CGRectGetHeight(_view.superview.frame) - _height);
    frame.size.width = CGRectGetWidth(_view.superview.frame) - (self.insets.left + self.insets.right);
    frame.size.height = self.height;
    
    [_view setFrame:frame];
}
@end

@interface UITableViewCell(AppCore_Private)
@property (nonatomic, strong) UIView *separatorTopView;
@property (nonatomic, strong) UIView *separatorBottomView;
@end
@implementation UITableViewCell(AppCore_Private)
AC_CATEGORY_PROPERTY_GET_SET(UIView*, separatorTopView, setSeparatorTopView:);
AC_CATEGORY_PROPERTY_GET_SET(UIView*, separatorBottomView, setSeparatorBottomView:);
@end

@implementation UITableViewCell(AppCore)

- (ACSeparator *)ac_separatorTop {
    if (!objc_getAssociatedObject(self, @selector(ac_separatorTop))) {
        objc_setAssociatedObject(self,
                                 @selector(ac_separatorTop),
                                 [ACSeparator separatorForCell:self position:ACSeparatorPositionTop],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @selector(ac_separatorTop));
}

- (ACSeparator *)ac_separatorBottom {
    if (!objc_getAssociatedObject(self, @selector(ac_separatorBottom))) {
        objc_setAssociatedObject(self,
                                 @selector(ac_separatorBottom),
                                 [ACSeparator separatorForCell:self],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @selector(ac_separatorBottom));
}

AC_LOAD_ONCE([self ac_addSwizzlingSelector:@selector(ac_layoutSubviews) originalSelector:@selector(layoutSubviews)];)

- (void)ac_layoutSubviews {
    [self ac_layoutSubviews];
    
    [self.ac_separatorTop update];
    [self.ac_separatorBottom update];
}

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
