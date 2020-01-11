//
//  ACTableViewCell.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 09.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

#import "ACTableViewCell.h"

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

@implementation ACTableViewCell
@synthesize separatorTop = _separatorTop;
@synthesize separatorBottom = _separatorBottom;

- (ACSeparator *)separatorTop {
    if (!_separatorTop) {
        _separatorTop = [ACSeparator separatorForCell:self position:ACSeparatorPositionTop];
    }
    return _separatorTop;
}

- (ACSeparator *)ac_separatorBottom {
    if (!_separatorBottom) {
        _separatorBottom = [ACSeparator separatorForCell:self];
    }
    return _separatorBottom;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.separatorTop update];
    [self.separatorBottom update];
}

@end
