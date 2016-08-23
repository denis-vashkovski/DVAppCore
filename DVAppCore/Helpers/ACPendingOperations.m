//
//  ACPendingOperations.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACPendingOperations.h"

#import "NSArray+AppCore.h"
#import "NSString+AppCore.h"

#import "ACLog.h"

@interface ACPendingOperations()
@property (nonatomic, strong) NSMutableDictionary *operationsInProgress;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ACPendingOperations

- (instancetype)initWithName:(NSString *)name maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount {
    if (self = [super init]) {
        _operationQueue = [NSOperationQueue new];
        [_operationQueue setName:name];
        [_operationQueue setMaxConcurrentOperationCount:maxConcurrentOperationCount];
        
        _operationsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)suspendAll {
    [self.operationQueue setSuspended:YES];
}

- (void)resumeAll {
    [self.operationQueue setSuspended:NO];
}

- (void)stopAll {
    [self.operationQueue cancelAllOperations];
    NSLog(@"Removed operations by key: %@", self.operationsInProgress.allKeys);
    [self.operationsInProgress removeAllObjects];
}

- (void)removeOperationByName:(NSString *)nameOperation {
    if (!ValidStr(nameOperation)) {
        return;
    }
    
    [self.operationsInProgress removeObjectForKey:nameOperation];
    NSLog(@"Removed operation by key: %@", nameOperation);
}

- (void)addOperation:(NSOperation *)operation withKey:(NSString *)key {
    if (!operation || !ValidStr(key)) {
        return;
    }
    
    if (![self.operationsInProgress.allKeys containsObject:key]) {
        [self.operationsInProgress setObject:operation forKey:key];
        [self.operationQueue addOperation:operation];
        NSLog(@"Added operation by key: %@", key);
    } else {
        NSLog(@"Operation with this key:%@ already exist", key);
    }
}

- (BOOL)isExistOperationsInProgress {
    return !self.operationsInProgress.allKeys.ac_isEmpty;
}

@end

