//
//  UILabel+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel(AppCore)
@property (nonatomic) UIEdgeInsets ac_textInsets;

- (void)ac_setText:(NSString *)text animationDuration:(NSTimeInterval)duration;
- (void)ac_setAttributedText:(NSAttributedString *)attributedText animationDuration:(NSTimeInterval)duration;
@end
