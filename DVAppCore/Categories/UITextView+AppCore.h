//
//  UITextView+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ACContentVerticalAlignmentTop,
    ACContentVerticalAlignmentCenter,
    ACContentVerticalAlignmentBottom
} ACContentVerticalAlignment;

@interface UITextView(AppCore)
@property (nonatomic) ACContentVerticalAlignment ac_contentVerticalAlignment;

@property (nonatomic, strong) NSAttributedString *ac_placeholder;
@property (nonatomic) UIEdgeInsets ac_placeholderInsets;

- (void)ac_setText:(NSString *)text animationDuration:(NSTimeInterval)duration;
- (void)ac_setAttributedText:(NSAttributedString *)attributedText animationDuration:(NSTimeInterval)duration;

- (void)ac_removeTextPadding;
- (void)ac_scrollToBottom;
@end
