//
//  UIDevice+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 04/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ACDeviceModelUnknown,
    
    // iPhone
    ACDeviceModelIPhone4OrLess,
    ACDeviceModelIPhone5,
    ACDeviceModelIPhone6,
    ACDeviceModelIPhone6p,
    
    // iPad
    ACDeviceModelIPadPro
} ACDeviceModel;

@interface UIDevice(AppCore)
- (void)ac_setOrientation:(UIDeviceOrientation)orientation;
- (ACDeviceModel)ac_deviceModel;
@end
