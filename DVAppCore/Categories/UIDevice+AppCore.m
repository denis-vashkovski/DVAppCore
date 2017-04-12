//
//  UIDevice+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 04/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIDevice+AppCore.h"

#import "ACConstants.h"

@implementation UIDevice(AppCore)

- (void)ac_setOrientation:(UIDeviceOrientation)orientation {
    [self setValue:@(orientation) forKey:@"orientation"];
}

#define SCREEN_MAX_LENGTH MAX(AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT)
#define SCREEN_MIN_LENGTH MIN(AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT)
- (ACDeviceModel)ac_deviceModel {
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:{
            if (SCREEN_MAX_LENGTH < 568.) {
                return ACDeviceModelIPhone4OrLess;
            } else if (SCREEN_MAX_LENGTH == 568.) {
                return ACDeviceModelIPhone5;
            } else if (SCREEN_MAX_LENGTH == 667.) {
                return ACDeviceModelIPhone6;
            } else if (SCREEN_MAX_LENGTH == 736.) {
                return ACDeviceModelIPhone6p;
            }
            
            break;
        }
        case UIUserInterfaceIdiomPad:{
            if (SCREEN_MAX_LENGTH == 1366.) {
                return ACDeviceModelIPadPro;
            }
            
            break;
        }
        default: break;
    }
    
    return ACDeviceModelUnknown;
}

@end
