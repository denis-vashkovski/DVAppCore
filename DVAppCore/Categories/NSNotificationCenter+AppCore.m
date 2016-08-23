//
//  NSNotificationCenter+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSNotificationCenter+AppCore.h"

@implementation NSNotificationCenter(AppCore)

- (void)ac_postNotificationName:(NSString *)aName {
    [self postNotificationName:aName object:nil];
}

- (void)ac_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    [self addObserver:observer selector:aSelector name:aName object:nil];
}

- (void)ac_removeObserver:(id)observer name:(NSString *)aName {
    [self removeObserver:observer name:aName object:nil];
}

@end
