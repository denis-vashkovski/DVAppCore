//
//  UITabBar+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar(AppCore)
- (void)ac_hidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (BOOL)ac_isVisible;
@end
