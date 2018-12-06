//
//  ACTemplateRouter.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 06/12/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateRouter.h"

#import <UIKit/UIKit.h>

@interface ACTemplateRouter()
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation ACTemplateRouter
@synthesize viewController = _viewController;

- (void)setViewController:(UIViewController *)viewController {
    NSAssert(!_viewController, @"Had already set 'UIViewController'");
    _viewController = viewController;
}

- (UIViewController *)viewController {
    NSAssert(_viewController, @"'UIViewController' can't be nil");
    return _viewController;
}

@end
