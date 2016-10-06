//
//  NSString+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSString+AppCore.h"

#import "ACConstants.h"

@implementation NSString(AppCore)

+ (BOOL)ac_isValidString:(id)object {
    return (object && [object isKindOfClass:[NSString class]] && !((NSString *)object).ac_isEmpty);
}

+ (NSString *)ac_fullPathLibraryDirectoryWithLastComponent:(NSString *)lastComponent {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *plistDirectory = [paths objectAtIndex:0];
    NSString *fullPath = plistDirectory;
    if (lastComponent && !lastComponent.ac_isEmpty) {
        fullPath = [fullPath stringByAppendingPathComponent:lastComponent];
    }
    
    return fullPath;
}

- (BOOL)ac_isEmpty {
    return self.length == 0;
}

- (BOOL)ac_isContains:(NSString *)contains {
    return contains && [self.lowercaseString rangeOfString:contains.lowercaseString].location != NSNotFound;
}

#pragma mark - Size
- (CGRect)stringFrameBySize:(CGSize)size font:(UIFont *)font {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName: font }
                              context:nil];
}

- (CGFloat)ac_widthForFont:(UIFont *)font andHeight:(CGFloat)height {
    return (!self.ac_isEmpty && font) ? CGRectGetWidth([self stringFrameBySize:CGSizeMake(CGFLOAT_MAX, height) font:font]) : .0;
}

- (CGFloat)ac_heightForFont:(UIFont *)font andWidth:(CGFloat)width {
    return (!self.ac_isEmpty && font) ? CGRectGetHeight([self stringFrameBySize:CGSizeMake(width, CGFLOAT_MAX) font:font]) : .0;
}

#pragma mark - Encode / Decode
#define CHARACTERS_TO_BE_ESCAPED @"!*'();:@&=+$,/?%#[]"
- (NSString *)ac_stringByAddingPercentEscapes {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                     NULL,
                                                                                     (CFStringRef)self,
                                                                                     NULL,
                                                                                     (CFStringRef)CHARACTERS_TO_BE_ESCAPED,
                                                                                     kCFStringEncodingUTF8));
    }
}

- (NSString *)ac_trim {
    return [[self copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (UIImage *)ac_decodeBase64ToImage {
    return [UIImage imageWithData:
            [[NSData alloc]initWithBase64EncodedString:self
                                               options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

- (NSString *)ac_encodeForUrl {
    const char *input_c = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString new];
    for (NSInteger i = 0, len = strlen(input_c); i < len; i++) {
        unsigned char c = input_c[i];
        if (
            (c >= '0' && c <= '9')
            || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z')
            || c == '-' || c == '.' || c == '_' || c == '~'
            ) {
            [result appendFormat:@"%c", c];
        } else {
            [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}

#pragma mark - HTML
#define HTML_FONT_DEFAULT [UIFont systemFontOfSize:17.]
#define HTML_COLOR_HEX_DEFAULT @"000000"
- (NSAttributedString *)ac_htmlAttributedStringWithFont:(UIFont *)font colorHex:(NSString *)colorHex {
    if (!ValidStr(self)) {
        return nil;
    }
    
    if (!font) {
        font = HTML_FONT_DEFAULT;
    }
    if (!ValidStr(colorHex)) {
        colorHex = HTML_COLOR_HEX_DEFAULT;
    }
    
    NSString *preparedFaqContents = [NSString stringWithFormat:
                                     @"<span style=\"font-family: %@; font-size: %d; color: %@\">%@</span>",
                                     font.fontName,
                                     (int)font.pointSize,
                                     UnnilStr(colorHex),
                                     [self stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[preparedFaqContents dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:nil
                                                                                   error:nil];
    
    return [[NSAttributedString alloc] initWithAttributedString:attrStr];
}

- (NSAttributedString *)ac_htmlAttributedString {
    return [self ac_htmlAttributedStringWithFont:HTML_FONT_DEFAULT colorHex:HTML_COLOR_HEX_DEFAULT];
}

#pragma mark - Regexp
- (BOOL)ac_isValidRegexp:(NSString *)regexp {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", UnnilStr(regexp)] evaluateWithObject:self];
}

#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
- (BOOL)ac_isValidEmail {
    return (ValidStr(self) && [self ac_isValidRegexp:EMAIL_REGEX]);
}

#define CREDIT_CARD_NUMBER_REGEX @"[0-9]{13,16}"
- (BOOL)ac_isValidCreditCardNumber {
    return (ValidStr(self) && [self ac_isValidRegexp:CREDIT_CARD_NUMBER_REGEX]);
}

#define DOMAIN_REGEX @"^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$"
- (BOOL)ac_isValidDomain {
    return (ValidStr(self) && [self ac_isValidRegexp:DOMAIN_REGEX]);
}

#define URL_REGEXP @"^(https?://)?([\\da-z.-]+).([a-z.]{2,6})([/\\w .-]*)*/?$"
- (BOOL)ac_isValidURL {
    return (ValidStr(self) && [self ac_isValidRegexp:URL_REGEXP]);
}

#define ONLY_DIGITS_REGEX @"^[0-9]+$"
- (BOOL)ac_isOnlyDigits {
    return (ValidStr(self) && [self ac_isValidRegexp:ONLY_DIGITS_REGEX]);
}

#define ONLY_LETTERS_REGEX @"^[a-zA-Z]+$"
- (BOOL)ac_isOnlyLetters {
    return (ValidStr(self) && [self ac_isValidRegexp:ONLY_LETTERS_REGEX]);
}

#define ONLY_LETTERS_AND_DIGITS @"^[a-zA-Z0-9]+$"
- (BOOL)ac_isOnlyLettersAndDigits {
    return (ValidStr(self) && [self ac_isValidRegexp:ONLY_LETTERS_AND_DIGITS]);
}

- (NSURL *)ac_asURL {
    return ValidStr(self) ? [NSURL URLWithString:self] : nil;
}

@end
