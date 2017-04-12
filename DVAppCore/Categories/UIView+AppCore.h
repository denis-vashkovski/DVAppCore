//
//  UIView+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

IB_DESIGNABLE

typedef enum {
    ACShapeTypeDefault,
    ACShapeTypeCircle
} ACShapeType;

@interface UIView(AppCore)
+ (instancetype)ac_newInstanceFromNib;

@property (nonatomic) ACShapeType ac_shapeType;
@property (nonatomic, strong) NSDictionary *ac_userInfo;
@property (nonatomic) UIEdgeInsets ac_contentOffset;
@property (nonatomic, copy) IBInspectable UIColor *ac_staticBackgroundColor;

- (UITableViewCell *)ac_parrentCell;

- (void)ac_setBackgroundClearColor;
- (void)ac_setBorderWidth:(float)width color:(UIColor *)color;
- (void)ac_setShadowColor:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;
- (void)ac_setBackgroundImageByName:(NSString *)imageName;
- (void)ac_setBackgroundImage:(UIImage *)image;
- (void)ac_setHidden:(BOOL)hidden animate:(BOOL)animate;

- (CALayer *)ac_layerWithName:(NSString *)name;
- (CALayer *)ac_addMaskWithColor:(UIColor *)color;
- (CAGradientLayer *)ac_addGradientWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray<UIColor *> *)colors;

- (void)ac_rotateWithDuration:(NSTimeInterval)duration angle:(CGFloat)angle;
- (void)ac_addFadeAnimationWithDuration:(NSTimeInterval)duration;

- (UIImage *)ac_toImage;

- (void)ac_bringToFront;
- (void)ac_sendToBack;

- (void)ac_addConstraintsWithVisualFormat:(NSString *)format views:(NSDictionary<NSString *, id> *)views;
- (void)ac_addConstraintsSuperviewWithInsets:(UIEdgeInsets)insets;
- (void)ac_addConstraintsEqualSuperview;
- (void)ac_addConstraintsCenterSuperview;

- (UILabel *)ac_labelWithTag:(NSInteger)tag;
- (UIImageView *)ac_imageViewWithTag:(NSInteger)tag;
- (UIButton *)ac_buttonWithTag:(NSInteger)tag;
- (UITextView *)ac_textViewWithTag:(NSInteger)tag;
- (UITextField *)ac_textFieldWithTag:(NSInteger)tag;
- (UISwitch *)ac_switchWithTag:(NSInteger)tag;
- (UIWebView *)ac_webViewWithTag:(NSInteger)tag;
- (UISlider *)ac_sliderWithTag:(NSInteger)tag;
- (UISegmentedControl *)ac_segmentedControlWithTag:(NSInteger)tag;
- (UIActivityIndicatorView *)ac_activityIndicatorViewWithTag:(NSInteger)tag;
- (UIProgressView *)ac_progressViewWithTag:(NSInteger)tag;
- (UIStepper *)ac_stepperWithTag:(NSInteger)tag;
- (UITableView *)ac_tableViewWithTag:(NSInteger)tag;
- (UIDatePicker *)ac_datePickerWithTag:(NSInteger)tag;
- (UIPickerView *)ac_pickerViewWithTag:(NSInteger)tag;
- (UICollectionView *)ac_collectionViewWithTag:(NSInteger)tag;

- (void)ac_removeAllSubviews;
- (void)ac_removeAllGestureRecognizers;

- (CGRect)ac_offsetDx:(CGFloat)dx dy:(CGFloat)dy;
- (CGRect)ac_repositionX:(CGFloat)x y:(CGFloat)y;
- (CGRect)ac_resizeWidth:(CGFloat)width height:(CGFloat)height;
@end

// UITableViewCell base tags
#define AC_CONTAINER_TAG 1
#define AC_TITLE_LABEL_TAG 101
#define AC_SUBTITLE_LABEL_TAG 102
#define AC_IMAGE_VIEW_TAG 111
