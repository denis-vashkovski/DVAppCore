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

@end
