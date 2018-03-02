//
//  NSCharacterSet+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/11/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet(AppCore)
+ (NSCharacterSet *)ac_cyrillicCharacterSet;
+ (NSCharacterSet *)ac_lowercaseCyrillicCharacterSet;
+ (NSCharacterSet *)ac_uppercaseCyrillicCharacterSet;
@end
