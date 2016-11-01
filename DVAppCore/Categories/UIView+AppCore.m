//
//  UIView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIView+AppCore.h"

#import "NSObject+AppCore.h"
#import "NSString+AppCore.h"
#import "NSLayoutConstraint+AppCore.h"

#import "ACConstants.h"

@implementation UIView(AppCore)

AC_LOAD_ONCE([self ac_addSwizzlingSelector:@selector(ac_setBackgroundColor:) originalSelector:@selector(setBackgroundColor:)];)

CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(ACShapeType, ac_shapeType, intValue);
- (void)setAc_shapeType:(ACShapeType)ac_shapeType {
    objc_setAssociatedObject(self,
                             @selector(ac_shapeType),
                             [NSNumber numberWithInt:ac_shapeType],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setClipsToBounds:YES];
    
    CGRect frame = self.frame;
    [self sizeToFit];
    
    if (self.frame.size.width == .0 || self.frame.size.height == .0) {
        [self setFrame:frame];
    }
    
    switch (self.ac_shapeType) {
        case ACShapeTypeCircle:{
            self.layer.cornerRadius = ceilf(MIN(self.frame.size.width, self.frame.size.height) / 2.);
            break;
        }
        default:
            break;
    }
}

CATEGORY_PROPERTY_GET_SET(NSDictionary*, ac_userInfo, setAc_userInfo:);

- (UIEdgeInsets)ac_contentOffset {
    return UIEdgeInsetsFromString(objc_getAssociatedObject(self, @selector(ac_contentOffset)));
}

- (void)setAc_contentOffset:(UIEdgeInsets)ac_contentOffset {
    UIEdgeInsets currentContentOffset = self.ac_contentOffset;
    for (UIView *subView in self.subviews) {
        CGRect frame = subView.frame;
        frame.origin.x += (ac_contentOffset.left - currentContentOffset.left);
        frame.origin.x -= (ac_contentOffset.right - currentContentOffset.right);
        frame.origin.y += (ac_contentOffset.top - currentContentOffset.top);
        frame.origin.y -= (ac_contentOffset.bottom - currentContentOffset.bottom);
        [subView setFrame:frame];
    }
    
    objc_setAssociatedObject(self, @selector(ac_contentOffset), NSStringFromUIEdgeInsets(ac_contentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

CATEGORY_PROPERTY_GET(UIColor *, ac_staticBackgroundColor)
- (void)setAc_staticBackgroundColor:(UIColor *)ac_staticBackgroundColor {
    objc_setAssociatedObject(self, @selector(ac_staticBackgroundColor), ac_staticBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundColor:ac_staticBackgroundColor];
}

- (UITableViewCell *)ac_parrentCell {
    id parrent = [self respondsToSelector:@selector(superview)] ? [self superview] : nil;
    while (parrent && [parrent respondsToSelector:@selector(superview)]) {
        if ([parrent isKindOfClass:[UITableViewCell class]]) {
            return parrent;
        }
        parrent = [parrent superview];
    }
    return nil;
}

#pragma mark - Setters
- (void)ac_setBackgroundColor:(UIColor *)backgroundColor {
    [self ac_setBackgroundColor:(self.ac_staticBackgroundColor ? self.ac_staticBackgroundColor : backgroundColor)];
}

- (void)ac_setBackgroundClearColor {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)ac_setBorderWidth:(float)width color:(UIColor *)color {
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}

- (void)ac_setShadowColor:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset {
    if (!color || (opacity == .0) || (radius == .0)) return;
    
    [self setClipsToBounds:NO];
    
    [self.layer setShadowColor:color.CGColor];
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowRadius:radius];
    [self.layer setShadowOffset:offset];
}

- (void)ac_setBackgroundImageByName:(NSString *)imageName {
    if (!ValidStr(imageName)) {
        return;
    }
    
    [self ac_setBackgroundImage:[UIImage imageNamed:imageName]];
}

- (void)ac_setBackgroundImage:(UIImage *)image {
    if (!image) {
        return;
    }
    
    [self.layer setContents:(id)image.CGImage];
}

- (void)ac_setHidden:(BOOL)hidden animate:(BOOL)animate {
    if (animate) {
        [self setAlpha:(hidden ? 1. : .0)];
        
        if (!hidden) {
            [self setHidden:hidden];
        }
        
        [UIView animateWithDuration:AC_ANIMATION_DURATION_DEFAULT
                         animations:^{
                             [self setAlpha:(hidden ? .0 : 1.)];
                         } completion:^(BOOL finished) {
                             if (hidden) {
                                 [self setHidden:hidden];
                                 [self setAlpha:1.];
                             }
                         }];
    } else {
        [self setHidden:hidden];
    }
}

#pragma mark - Layers
- (CALayer *)ac_layerWithName:(NSString *)name {
    if (ValidStr(name)) {
        for (CALayer *layer in [self.layer sublayers]) {
            if ([[layer name] isEqualToString:name]) {
                return layer;
            }
        }
    }
    
    return nil;
}

#define MASK_LAYER_NAME @"mask_layer_name"
- (CALayer *)ac_addMaskWithColor:(UIColor *)color {
    CALayer *mask = [self ac_layerWithName:MASK_LAYER_NAME];
    if (mask) {
        [mask removeFromSuperlayer];
    } else {
        mask = [CALayer layer];
    }
    
    [mask setName:MASK_LAYER_NAME];
    [mask setFrame:self.frame];
    [mask setBackgroundColor:color.CGColor];
    [self.layer insertSublayer:mask atIndex:0];
    
    return mask;
}

#pragma mark - Animations
- (void)ac_rotateWithDuration:(NSTimeInterval)duration angle:(CGFloat)angle {
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformRotate(self.transform, ((angle) / 180.0 * M_PI));
    }];
}

- (void)ac_addFadeAnimationWithDuration:(NSTimeInterval)duration {
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"kCATransitionFade"];
}

- (UIImage *)ac_toImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Z position
- (void)ac_bringToFront {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)ac_sendToBack {
    if (self.superview) {
        [self.superview sendSubviewToBack:self];
    }
}

#pragma mark - Constraints
- (void)ac_addConstraintsWithVisualFormat:(NSString *)format views:(NSDictionary<NSString *,id> *)views {
    [self addConstraints:[NSLayoutConstraint ac_constraintsWithVisualFormat:format views:views]];
}

- (void)ac_addConstraintsSuperviewWithInsets:(UIEdgeInsets)insets {
    if (!self.superview) {
        return;
    }
    
    NSDictionary *views = @{ @"self": self };
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraints:[NSLayoutConstraint ac_constraintsWithVisualFormat:[NSString stringWithFormat:
                                                                                       @"H:|-%f-[self]-%f-|",
                                                                                       insets.left,
                                                                                       insets.right]
                                                                                views:views]];
    [self.superview addConstraints:[NSLayoutConstraint ac_constraintsWithVisualFormat:[NSString stringWithFormat:
                                                                                       @"V:|-%f-[self]-%f-|",
                                                                                       insets.top,
                                                                                       insets.bottom]
                                                                                views:views]];
    
}

- (void)ac_addConstraintsEqualSuperview {
    [self ac_addConstraintsSuperviewWithInsets:UIEdgeInsetsZero];
}

#pragma mark - viewWithTag
#define VIEW_WITH_TAG(type, name) \
- (type *) name :(NSInteger)tag { \
    UIView *view = [self viewWithTag:tag]; \
    return (view && [view isKindOfClass:[type class]]) ? (type *)view : nil; \
}
VIEW_WITH_TAG(UILabel, labelWithTag)
VIEW_WITH_TAG(UIImageView, imageViewWithTag)
VIEW_WITH_TAG(UIButton, buttonWithTag)
VIEW_WITH_TAG(UITextView, textViewWithTag)
VIEW_WITH_TAG(UITextField, textFieldWithTag)
VIEW_WITH_TAG(UISwitch, switchWithTag)
VIEW_WITH_TAG(UIWebView, webViewWithTag)
VIEW_WITH_TAG(UISlider, sliderWithTag)
VIEW_WITH_TAG(UISegmentedControl, segmentedControlWithTag)
VIEW_WITH_TAG(UIActivityIndicatorView, activityIndicatorViewWithTag)
VIEW_WITH_TAG(UIProgressView, progressViewWithTag)
VIEW_WITH_TAG(UIStepper, stepperWithTag)
VIEW_WITH_TAG(UITableView, tableViewWithTag)
VIEW_WITH_TAG(UIDatePicker, datePickerWithTag)
VIEW_WITH_TAG(UIPickerView, pickerViewWithTag)
VIEW_WITH_TAG(UICollectionView, collectionViewWithTag)

- (void)ac_removeAllSubviews {
    if (!ValidArray(self.subviews)) return;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end

