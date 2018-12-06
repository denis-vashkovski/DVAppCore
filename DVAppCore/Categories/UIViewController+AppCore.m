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
#import "UIView+AppCore.h"

#import "ACConstants.h"
#import "ACTemplateAppDelegate.h"
#import "ACDesignHelper.h"
#import "ACRouter.h"

@interface UIViewController(AppCore_Private)
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL viewAppearNotFirstTime;
@end
@implementation UIViewController(AppCore_Private)
AC_CATEGORY_PROPERTY_GET_SET_BOOL(visible, setVisible:);
AC_CATEGORY_PROPERTY_GET_SET_BOOL(viewAppearNotFirstTime, setViewAppearNotFirstTime:);
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
    } else if (vc && ACValidArray(vc.childViewControllers)) {
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

+ (instancetype)ac_newInstance {
    return [self new];
}

#pragma mark - Swizzling methods
- (void)ac_viewDidLoad {
    [self ac_viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ac_hideKeyboard)];
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

- (void)ac_initBackButtonIfNeeded {
    if (!self.navigationController) return;
    
    if ((self.navigationController.viewControllers.count > 1)) {
        UIBarButtonItem *backButton = [self ac_backButton];
        if (backButton) {
            [self.navigationItem setLeftBarButtonItem:backButton];
        }
    } else {
        [self ac_removeBackButton];
    }
}

- (BOOL)ac_isVisible {
    return self.visible;
}

- (BOOL)ac_isViewAppearNotFirstTime {
    return self.viewAppearNotFirstTime;
}

- (UIBarButtonItem *)ac_backButton {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_back"]
                                            style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(ac_onBackButtonTouch:)];
}

- (void)ac_onBackButtonTouch:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
                       : (AC_SCREEN_HEIGHT - y)));
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
        progressViewBackground = [UIView new];
        [progressViewBackground setBackgroundColor:ACDesign(ACDesignColorProgressView)];
        [progressViewBackground addSubview:self.activityIndicator];
        
        [self.activityIndicator ac_addConstraintsCenterSuperview];
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
        UIWindow *subWindow = ((ACTemplateAppDelegate *)[UIApplication sharedApplication].delegate).ac_subWindow;
        
        if (subWindow.isHidden) {
            [subWindow addSubview:self.progressViewBackground];
            [self.progressViewBackground ac_addConstraintsEqualSuperview];
            [subWindow setHidden:NO];
        }
    }
}

- (void)removeProgressView {
    if (!self.progressViewBackground) return;
    
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

Class ACVCClassFromParentVCClass(Class parentVCClass) {
    NSString *viewControllerClassName = NSStringFromClass(parentVCClass);
    NSString *suffix = nil;
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:
            suffix = ACRouterStoryboardIPhoneSufix;
            break;
        case UIUserInterfaceIdiomPad:
            suffix = ACRouterStoryboardIPadSufix;
            break;
        default: break;
    }
    
    if (ACValidStr(suffix)) {
        viewControllerClassName = [NSString stringWithFormat:@"%@_%@", viewControllerClassName, suffix];
    }
    
    return NSClassFromString(viewControllerClassName);
}
