//
//  ACAsyncBlockOperation.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACAsyncBlockOperation.h"

@interface ACAsyncBlockOperation ()
@property (strong, nonatomic) void(^block)(void);
@end

@implementation ACAsyncBlockOperation

- (instancetype)initWithBlock:(void (^)(void))block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)main {
    self.block();
}

@end
