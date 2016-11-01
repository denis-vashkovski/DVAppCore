//
//  NSNumber+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 24/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(AppCore)
+ (NSInteger)ac_randomFrom:(NSInteger)from to:(NSInteger)to;
@end

#define AC_RND_INT(minValue, maxValue) [NSNumber ac_randomFrom:minValue to:maxValue]
