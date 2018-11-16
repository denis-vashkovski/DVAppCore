//
//  ACAsynchronousOperation.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACAsynchronousOperation.h"

#import "NSObject+AppCore.h"

AC_EXTERN_STRING_M_V(ACAsynchronousOperationExecutingProperty, @"executing")
AC_EXTERN_STRING_M_V(ACAsynchronousOperationFinishedProperty, @"finished")

@implementation NSLock(AppCore)

- (id)withCriticalScope:(id (^)(void))block {
    [self lock];
    id b = block();
    [self unlock];
    return b;
}

@end

@interface ACAsynchronousOperation ()
@property (nonatomic, strong) NSLock *stateLock;
@property (nonatomic) BOOL _executing;
@property (nonatomic) BOOL _finished;
@end

@implementation ACAsynchronousOperation

- (NSLock *)stateLock {
    if (!_stateLock) {
        _stateLock = [NSLock new];
    }
    return _stateLock;
}

- (BOOL)isExecuting {
    return ((NSNumber*)[self.stateLock withCriticalScope:^id{
        return @(self._executing);
    }]).boolValue;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:ACAsynchronousOperationExecutingProperty];
    [self.stateLock withCriticalScope:^id{
        return @(self._executing = executing);
    }];
    [self didChangeValueForKey:ACAsynchronousOperationExecutingProperty];
}

- (BOOL)isFinished {
    return ((NSNumber*)[self.stateLock withCriticalScope:^id{
        return @(self._finished);
    }]).boolValue;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:ACAsynchronousOperationFinishedProperty];
    [self.stateLock withCriticalScope:^id{
        return @(self._finished = finished);
    }];
    [self didChangeValueForKey:ACAsynchronousOperationFinishedProperty];
}

- (void)completeOperation {
    if ([self isExecuting]) {
        self.executing = NO;
    }
    
    if (![self isFinished]) {
        self.finished = YES;
    }
}

- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    [self main];
}

- (void)main {
    NSAssert(NO, @"subclasses must override `main`");
}

@end
