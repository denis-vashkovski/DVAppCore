//
//  ACLocalizationHelper.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 25/07/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACSingleton.h"

AC_EXTERN_STRING_H(ACUpdateLocalization)

@interface ACLocalizationHelper : NSObject
ACSINGLETON_H_METHOD(sharedLocalizationHelper)

+ (void)initializeLocalizationHelper;

- (NSString *)languageSelectedStringForKey:(NSString *)key;

- (void)setLocale:(NSLocale *)locale;
- (void)reset;
@end

#define ACStringByKey(key) [[ACLocalizationHelper sharedLocalizationHelper] languageSelectedStringForKey:(key)]
