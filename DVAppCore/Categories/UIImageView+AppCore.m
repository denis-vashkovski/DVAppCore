//
//  UIImageView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIImageView+AppCore.h"

@implementation UIImageView(AppCore)

- (void)ac_setDefaultImage {
    [self setImage:[UIImage imageNamed:@"default"]];
}

- (void)ac_setImage:(UIImage *)image animation:(BOOL)animation {
    [self setImage:image];
    
    if (animation) {
        self.alpha = .0f;
        
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 1.0f;
        }];
    }
}

@end
