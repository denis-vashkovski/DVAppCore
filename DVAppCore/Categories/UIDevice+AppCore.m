//
//  UIDevice+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 04/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIDevice+AppCore.h"

@implementation UIDevice(AppCore)

- (void)setOrientation:(UIDeviceOrientation)orientation {
    [self setValue:@(orientation) forKey:@"orientation"];
}

@end
