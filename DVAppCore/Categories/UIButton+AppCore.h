//
//  UIButton+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 23/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ACButtonActionBlock)(UIButton *button);

@interface UIButton(AppCore)
- (void)ac_initWithTitle:(NSString *)title
              titleColor:(UIColor *)titleColor
                    font:(UIFont *)font
                  target:(id)target
                  action:(SEL)action;

- (void)ac_addAction:(ACButtonActionBlock)action forControlEvents:(UIControlEvents)controlEvents;
@end
