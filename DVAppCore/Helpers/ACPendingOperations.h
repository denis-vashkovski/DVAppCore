//
//  ACPendingOperations.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACPendingOperations : NSObject
+ (instancetype) new __attribute__((unavailable("new not available, call [[ACPendingOperations alloc] initWithName:maxConcurrentOperationCount:]instead")));
- (instancetype) init __attribute__((unavailable("init not available, call initWithName:maxConcurrentOperationCount: instead")));
- (instancetype)initWithName:(NSString *)name maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount;

- (void)suspendAll;
- (void)resumeAll;
- (void)stopAll;

- (void)removeOperationByName:(NSString *)nameOperation;
- (void)addOperation:(NSOperation *)operation withKey:(NSString *)key;

- (BOOL)isExistOperationsInProgress;
@end
