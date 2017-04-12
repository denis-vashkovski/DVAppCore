//
//  ACLocalizationHelper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 25/07/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACLocalizationHelper.h"

#import "NSNotificationCenter+AppCore.h"
#import "NSString+AppCore.h"

@interface ACLocalizationHelper()
@property (nonatomic, strong) NSBundle *languageBundle;
@end

AC_EXTERN_STRING_M(ACUpdateLocalization);
AC_EXTERN_STRING_M_V(NSAppleLanguagesArray, @"AppleLanguages")

@implementation ACLocalizationHelper
ACSINGLETON_M_METHOD(sharedLocalizationHelper)

+ (void)initializeLocalizationHelper {
    [[[self class] sharedLocalizationHelper] initLocalizationHelper];
}

- (void)initLocalizationHelper {
    NSString *currentLanguage = ((NSArray *)[[NSUserDefaults standardUserDefaults] valueForKey:NSAppleLanguagesArray]).firstObject;
    if (ACValidStr(currentLanguage)) {
        _languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]];
    }
}

- (NSString *)languageSelectedStringForKey:(NSString *)key {
    return ((ACValidStr(key) && _languageBundle)
            ? [_languageBundle localizedStringForKey:key value:@"" table:nil]
            : NSLocalizedString(key, nil));
}

- (void)setLocale:(NSLocale *)locale {
    if (!locale || !ACValidStr(locale.localeIdentifier)) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@[ locale.localeIdentifier ] forKey:NSAppleLanguagesArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _languageBundle = nil;
    [self initLocalizationHelper];
    
    [[NSNotificationCenter defaultCenter] ac_postNotificationName:ACUpdateLocalization];
}

- (void)reset {
    [self setLocale:[NSLocale currentLocale]];
}

@end
