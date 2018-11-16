//
//  NSOperationQueue+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "NSOperationQueue+AppCore.h"

@implementation NSOperationQueue(AppCore)

- (void)addAsyncOperationWithBlock:(void (^)(ACAsyncBlockOperation *))block {
    __block ACAsyncBlockOperation *asyncBlockOperation = [[ACAsyncBlockOperation alloc] initWithBlock:^{
        block(asyncBlockOperation);
    }];
    [self addOperation:asyncBlockOperation];
}

@end
