//
//  ACRouter.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACSingleton.h"

@interface ACRouter : NSObject
ACSINGLETON_H

+ (UIStoryboard *)storyboardByName:(NSString *)storyboardName;
+ (UIViewController *)getVCByName:(NSString *)vcName storyboardName:(NSString *)storyboardName;
+ (UIViewController *)getInitialVCByStoryboardName:(NSString *)storyboardName;
@end

AC_EXTERN_STRING_H(ACRouterStoryboardIPhoneSufix)
AC_EXTERN_STRING_H(ACRouterStoryboardIPadSufix)
