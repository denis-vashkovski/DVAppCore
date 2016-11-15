//
//  UIViewController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIViewController+AppCore.h"

#import "NSArray+AppCore.h"
#import "NSObject+AppCore.h"

#import "UIColor+AppCore.h"

#import "ACConstants.h"
#import "ACTemplateAppDelegate.h"
#import "ACDesignHelper.h"

@interface UIViewController(AppCore_Private)
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL viewAppearNotFirstTime;
@end
@implementation UIViewController(AppCore_Private)
CATEGORY_PROPERTY_GET_SET_BOOL(visible, setVisible:);
CATEGORY_PROPERTY_GET_SET_BOOL(viewAppearNotFirstTime, setViewAppearNotFirstTime:);
@end

@interface UIViewController()<UIGestureRecognizerDelegate>
@end
@implementation UIViewController(AppCore)

AC_LOAD_ONCE([self ac_addSwizzlingSelector:@selector(ac_viewDidLoad) originalSelector:@selector(viewDidLoad)];
             [self ac_addSwizzlingSelector:@selector(ac_viewWillAppear:) originalSelector:@selector(viewWillAppear:)];
             [self ac_addSwizzlingSelector:@selector(ac_viewWillDisappear:) originalSelector:@selector(viewWillDisappear:)];)

+ (UIViewController *)ac_findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [UIViewController ac_findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController ac_findBestViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController ac_findBestViewController:svc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController ac_findBestViewController:svc.selectedViewController];
        } else {
            return vc;
        }
    } else if (vc && ValidArray(vc.childViewControllers)) {
        for (UIViewController *childVC in vc.childViewControllers) {
            if (childVC.view.superview && (childVC.view.superview == vc.view)) {
                return [UIViewController ac_findBestViewController:childVC];
            }
        }
        return vc;
    } else {
        return vc;
    }
}

+ (UIViewController *)ac_currentViewController {
    return [UIViewController ac_findBestViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (instancetype)newInstance {
    return [self new];
}

#pragma mark - Swizzling methods
- (void)ac_viewDidLoad {
    [self ac_viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(ac_hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)ac_viewWillAppear:(BOOL)animated {
    [self ac_viewWillAppear:animated];
    [self setVisible:YES];
    [self setViewAppearNotFirstTime:YES];
}

- (void)ac_viewWillDisappear:(BOOL)animated {
    [self ac_viewWillDisappear:animated];
    [self setVisible:NO];
}

- (BOOL)ac_isVisible {
    return self.visible;
}

- (BOOL)ac_isViewAppearNotFirstTime {
    return self.viewAppearNotFirstTime;
}

- (void)ac_removeBackButton {
    [self.navigationItem setLeftBarButtonItems:nil];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[UIView new]]];
}

- (CGRect)ac_visibleFrame {
    CGFloat y = self.navigationController ? (self.navigationController.navigationBar.frame.origin.y
                                             + self.navigationController.navigationBar.frame.size.height) : .0;
    
    return CGRectMake(.0,
                      y,
                      CGRectGetWidth(self.view.frame),
                      ((self.tabBarController && !self.hidesBottomBarWhenPushed && !self.tabBarController.tabBar.hidden)
                       ? (self.tabBarController.tabBar.frame.origin.y - y)
                       : (SCREEN_HEIGHT - y)));
}

#pragma mark - Loading process
- (void)ac_startLoadingProcess {
    if (self.ac_isNowLoading) {
        return;
    }
    
    [self addProgressView];
    [self.activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
}

- (void)ac_stopLoadingProcess {
    [self removeProgressView];
    if (self.activityIndicator) {
        [self.activityIndicator stopAnimating];
    }
    [self.view setUserInteractionEnabled:YES];
}

- (BOOL)ac_isNowLoading {
    return self.progressViewBackground.superview != nil;
}

- (UIView *)progressViewBackground {
    static UIView *progressViewBackground = nil;
    if (!progressViewBackground) {
        progressViewBackground = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [progressViewBackground setBackgroundColor:ACDesign(ACDesignColorProgressView)];
        
        self.activityIndicator.center = progressViewBackground.center;
        [progressViewBackground addSubview:self.activityIndicator];
    }
    return progressViewBackground;
}

- (UIActivityIndicatorView *)activityIndicator {
    static UIActivityIndicatorView *activityIndicator = nil;
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setColor:ACDesign(ACDesignColorProgressActivityIndicator)];
        activityIndicator.hidesWhenStopped = YES;
    }
    return activityIndicator;
}

- (void)addProgressView {
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate isKindOfClass:[ACTemplateAppDelegate class]]) {
        UIWindow *windowForAlert = ((ACTemplateAppDelegate *)[UIApplication sharedApplication].delegate).windowForAlerts;
        
        if (windowForAlert.isHidden) {
            [windowForAlert addSubview:self.progressViewBackground];
            [windowForAlert setHidden:NO];
        }
    }
}

- (void)removeProgressView {
    if (!self.progressViewBackground) {
        return;
    }
    
    [self.progressViewBackground.superview setHidden:YES];
    [self.progressViewBackground removeFromSuperview];
}

- (void)ac_hideKeyboard {
    [self.view endEditing:NO];
}

- (UINavigationController *)ac_embedInNavigationController {
    if (self.navigationController) return self.navigationController;
    
    return [[UINavigationController alloc] initWithRootViewController:self];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isKindOfClass:[UIControl class]];
}

@end
