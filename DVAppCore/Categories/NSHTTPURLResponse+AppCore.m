//
//  NSHTTPURLResponse+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSHTTPURLResponse+AppCore.h"

@implementation NSHTTPURLResponse(AppCore)

- (BOOL)ac_isStatusCorrect {
    return [self statusCode] >= STATUS_CODE_OK && [self statusCode] < STATUS_CODE_MULTIPLE_CHOICES;
}

@end
