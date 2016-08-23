//
//  UIImageView+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView(AppCore)
- (void)ac_setDefaultImage;
- (void)ac_setImage:(UIImage *)image animation:(BOOL)animation;
@end
