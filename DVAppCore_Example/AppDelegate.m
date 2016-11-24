//
//  AppDelegate.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "AppDelegate.h"

#import "ACDesignHelper.h"

#import "UIColor+AppCore.h"

#import "TestTVC.h"
#import "ACWebViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self initGlobalDesign];
    
    [self ac_addInterfaceOrientations:UIInterfaceOrientationMaskLandscape forVC:[ACWebViewController class]];
    [self ac_addInterfaceOrientations:UIInterfaceOrientationMaskLandscape forVC:[TestTVC class]];
    
    return YES;
}

- (void)initGlobalDesign {
    ACDesignSet(ACDesignColorNavigationBarTint, ACColorHex(@"ffffff"));
    ACDesignSet(ACDesignColorNavigationTint, ACColorHex(@"4d90fe"));
    ACDesignSet(ACDesignAttributesNavigationTitleText, (@{ NSForegroundColorAttributeName: ACColorHex(@"4d90fe"),
                                                           NSFontAttributeName: [UIFont systemFontOfSize:19.] }));
}

@end
