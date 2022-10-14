//
//  ACTemplateAppDelegate.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateAppDelegate.h"

#import "UIColor+AppCore.h"

#import "ACConstants.h"
#import "ACDesignHelper.h"
#import "ACLocalizationHelper.h"

@interface ACAlertVC : UIViewController
@end
@implementation ACAlertVC
@end

#pragma mark - ACTemplateAppDelegate
@interface ACTemplateAppDelegate()
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSNumber *> *ac_interfaceOrientations;
@end

@implementation ACTemplateAppDelegate
@synthesize ac_subWindow = _ac_subWindow;

- (UIWindow *)ac_subWindow {
    if (!_ac_subWindow) {
        _ac_subWindow = [[UIWindow alloc] initWithFrame:CGRectMake(.0, .0, AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT)];
        _ac_subWindow.backgroundColor = ACDesign(ACDesignColorWindowForAlerts);
        _ac_subWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _ac_subWindow.hidden = YES;
        
        [_ac_subWindow setRootViewController:[ACAlertVC new]];
        [self ac_addInterfaceOrientations:UIInterfaceOrientationMaskAll forVC:[_ac_subWindow.rootViewController class]];
    }
    
    return _ac_subWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ACLocalizationHelper initializeLocalizationHelper];
    [self prepareDefaultDesign];
    
    return YES;
}

- (void)prepareDefaultDesign {
    ACDesignSet(ACDesignColorRefreshControlTVC, ACColorHex(@"#ffffff"));
    ACDesignSet(ACDesignColorProgressView, ACColorHexA(@"#000000", .55));
    ACDesignSet(ACDesignColorProgressActivityIndicator, ACColorHex(@"#ffffff"));
    ACDesignSet(ACDesignColorWindowForAlerts, ACColorHexA(@"#000000", .0));
}

- (UIInterfaceOrientationMask)ac_interfaceOrientationsDefault {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)ac_addInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientations forVC:(Class)vc {
    if (!self.ac_interfaceOrientations) {
        self.ac_interfaceOrientations = [NSMutableDictionary new];
    }
    
    [self.ac_interfaceOrientations setObject:@(interfaceOrientations) forKey:NSStringFromClass(vc)];
}

@end

#pragma mark - UIViewController(ACOrientation)
@implementation UIViewController(orientationFix)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSNumber *interfaceOrientationsData = [self ac_interfaceOrientationsData];
    if (interfaceOrientationsData) {
        return interfaceOrientationsData.integerValue;
    } else {
        if ([[self ac_appDelegate] respondsToSelector:@selector(ac_interfaceOrientationsDefault)]) {
            return [[self ac_appDelegate] ac_interfaceOrientationsDefault];
        }
        return UIInterfaceOrientationMaskPortrait;
    };
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    NSNumber *interfaceOrientationsData = [self ac_interfaceOrientationsData];
    return [self interfaceOrientationByMask:(interfaceOrientationsData
                                             ? interfaceOrientationsData.integerValue
                                             : [[self ac_appDelegate] ac_interfaceOrientationsDefault])];
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark Utils
- (ACTemplateAppDelegate *)ac_appDelegate {
    return (ACTemplateAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSNumber *)ac_interfaceOrientationsData {
    if (![[self ac_appDelegate] respondsToSelector:@selector(ac_interfaceOrientations)]) {
        return nil;
    }
    
    NSNumber *interfaceOrientationsData = [self ac_appDelegate].ac_interfaceOrientations[NSStringFromClass([self class])];

    if (!interfaceOrientationsData) {
        if ([self isKindOfClass:[UINavigationController class]]) {
            UIViewController *visibleVC = ((UINavigationController *)self).visibleViewController;
            interfaceOrientationsData = [self ac_appDelegate].ac_interfaceOrientations[NSStringFromClass([visibleVC class])];
        }
    }

    return interfaceOrientationsData;
}

- (UIInterfaceOrientation)interfaceOrientationByMask:(UIInterfaceOrientationMask)interfaceOrientationMask {
    UIInterfaceOrientation interfaceOrientation = 0;
    
    if (interfaceOrientationMask & UIInterfaceOrientationMaskAll) {
        interfaceOrientation = (UIInterfaceOrientationPortrait |
                                UIInterfaceOrientationLandscapeLeft |
                                UIInterfaceOrientationLandscapeRight |
                                UIInterfaceOrientationPortraitUpsideDown);
    } else if (interfaceOrientationMask & UIInterfaceOrientationMaskLandscape) {
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
    } else {
        if (interfaceOrientationMask & UIInterfaceOrientationMaskPortrait) {
            interfaceOrientation |= UIInterfaceOrientationPortrait;
        }
        if (interfaceOrientationMask & UIInterfaceOrientationMaskLandscapeLeft) {
            interfaceOrientation |= UIInterfaceOrientationLandscapeLeft;
        }
        if (interfaceOrientationMask & UIInterfaceOrientationMaskLandscapeRight) {
            interfaceOrientation |= UIInterfaceOrientationLandscapeRight;
        }
        if (interfaceOrientationMask & UIInterfaceOrientationMaskPortraitUpsideDown) {
            interfaceOrientation |= UIInterfaceOrientationPortraitUpsideDown;
        }
    }
    
    return interfaceOrientation;
}
@end
