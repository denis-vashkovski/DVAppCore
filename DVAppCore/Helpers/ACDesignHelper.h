//
//  ACDesignHelper.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 19/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSObject+AppCore.h"

@interface ACDesign : NSObject
+ (NSDictionary *)design;
@end

AC_EXTERN_STRING_H(ACUpdateDesign)

/*!
 @class ACDesignHelper
 @discussion Create own class of helper from @b ACDesignHelper and define external keys for styles. Create class the design from @b ACDesign and override @b design method.
 
 @code
 // MyDesignHelper.h
 @interface MyDesignHelper : ACDesignHelper
 + (void)applyDesign:(DesignType)type;
 @end
 EXTERN_STRING_H(MyDesignColorBackgroundVC)
 
 // MyDesignHelper.m
 @implementation MyDesignHelper
 + (void)applyDesign:(DesignType)type {
    switch (type) {
        default:{
            [self setDesignClass:[ACDesign class]];
            break;
        }
    }
 }
 @end
 EXTERN_STRING_M(MyDesignColorBackgroundVC);
 
 // MyDesign.h
 @interface MyDesign : ACDesign
 @end
 
 // MyDesign.m
 @implementation MyDesign
 + (NSDictionary *)design {
    return @{MyDesignColorBackgroundVC: [UIColor white]};
 }
 @end
 
 somewhere: [MyDesignHelper setDesignClass:[MyDesign class]];
 @endcode
 */
@interface ACDesignHelper : NSObject
+ (id)valueByKey:(NSString *)key;
+ (BOOL)setValue:(id)value byKey:(NSString *)key;

/*!
 @abstrac
 @param designClass the sub class of @b ACDesign class
 */
+ (void)setDesignClass:(Class)designClass;
@end

#define ACDesign(key) [ACDesignHelper valueByKey:(key)]
#define ACDesignSet(key, value) [ACDesignHelper setValue:(value) byKey:(key)]

AC_EXTERN_STRING_H(ACDesignColorRefreshControlTVC)
AC_EXTERN_STRING_H(ACDesignColorProgressView)
AC_EXTERN_STRING_H(ACDesignColorProgressActivityIndicator)
AC_EXTERN_STRING_H(ACDesignColorWindowForAlerts)

// global design
AC_EXTERN_STRING_H(ACDesignColorNavigationBarTint)
AC_EXTERN_STRING_H(ACDesignColorNavigationTint)
AC_EXTERN_STRING_H(ACDesignAttributesNavigationTitleText)                  // NSDictionary

AC_EXTERN_STRING_H(ACDesignColorTabBarTint)
AC_EXTERN_STRING_H(ACDesignColorTabTint)
AC_EXTERN_STRING_H(ACDesignAttributesTabItemTitleTextAttributes)           // NSDictionary
AC_EXTERN_STRING_H(ACDesignAttributesTabItemSelectedTitleTextAttributes)   // NSDictionary
AC_EXTERN_STRING_H(ACDesignPositionAdjustmentTabItemTitle)                 // UIOffset

TODO add logic for fonts
