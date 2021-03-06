//
//  NSString+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(AppCore)
+ (BOOL)ac_isValidString:(id)object;

+ (NSString *)ac_fullPathDirectoryByType:(NSSearchPathDirectory)type lastComponent:(NSString *)lastComponent;
+ (NSString *)ac_fullPathDirectoryByType:(NSSearchPathDirectory)type;
+ (NSString *)ac_fullPathDocumentDirectoryWithLastComponent:(NSString *)lastComponent;
+ (NSString *)ac_fullPathLibraryDirectoryWithLastComponent:(NSString *)lastComponent;

- (BOOL)ac_isEmpty;
- (BOOL)ac_isContains:(NSString *)contains;

- (CGFloat)ac_widthForFont:(UIFont *)font andHeight:(CGFloat)height;
- (CGFloat)ac_heightForFont:(UIFont *)font andWidth:(CGFloat)width;

- (NSString *)ac_stringByAddingPercentEscapes;
- (NSString *)ac_trim;

- (UIImage *)ac_decodeBase64ToImage;
- (NSString *)ac_encodeForUrl;
- (NSString *)ac_decodeForUrl;
- (NSString *)ac_removeAllWhitespaceAndNewlineAndTab;

- (NSAttributedString *)ac_htmlAttributedStringWithFont:(UIFont *)font colorHex:(NSString *)colorHex;
- (NSAttributedString *)ac_htmlAttributedString;
- (NSAttributedString *)ac_attributedStringDefaultWithFont:(UIFont *)font;

- (BOOL)ac_isValidRegexp:(NSString *)regexp;
- (BOOL)ac_isValidEmail;
- (BOOL)ac_isValidCreditCardNumber;
- (BOOL)ac_isValidDomain;
- (BOOL)ac_isValidURL;
- (BOOL)ac_isOnlyDigits;
- (BOOL)ac_isOnlyLetters;
- (BOOL)ac_isOnlyLettersAndDigits;

- (NSURL *)ac_asURL;
- (NSURL *)ac_asMailURL;
- (NSURL *)ac_asPhoneURL;
- (NSURL *)ac_asFaceTimeURL;
- (NSURL *)ac_asSMSURL;

- (NSString *)ac_replacingWithPattern:(NSString *)pattern templateString:(NSString *)templateString;
@end

#define ACUnnilStr(str) ( ( str && [str isKindOfClass:[NSString class]] ) ? (str) : @"" )
#define ACValidStr(str) [NSString ac_isValidString:str]
