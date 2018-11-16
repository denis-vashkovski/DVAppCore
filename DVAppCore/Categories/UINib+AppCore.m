//
//  UINib+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "UINib+AppCore.h"

#import "NSObject+AppCore.h"

AC_EXTERN_STRING_M_V(ACUINibFileType, @"nib")

@implementation UINib(AppCore)

+ (instancetype)ac_nibWithNibClass:(Class)nibClass {
    NSString *nibName = NSStringFromClass(nibClass);
    return ([[NSBundle mainBundle] pathForResource:nibName ofType:ACUINibFileType]
            ? [UINib nibWithNibName:nibName bundle:nil]
            : nil);
}

@end
