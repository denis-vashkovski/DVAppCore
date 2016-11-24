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

#pragma mark - ACTemplateAppDelegate
@interface ACTemplateAppDelegate()
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSNumber *> *ac_interfaceOrientations;
@end

@implementation ACTemplateAppDelegate

- (UIWindow *)windowForAlerts {
    if (!_windowForAlerts) {
        _windowForAlerts = [[UIWindow alloc] initWithFrame:CGRectMake(.0, .0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _windowForAlerts.backgroundColor = ACDesign(ACDesignColorWindowForAlerts);
        _windowForAlerts.windowLevel = UIWindowLevelStatusBar + 1;
        _windowForAlerts.hidden = YES;
    }
    
    return _windowForAlerts;
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
    return interfaceOrientationsData ? interfaceOrientationsData.integerValue : [[self ac_appDelegate] ac_interfaceOrientationsDefault];
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
