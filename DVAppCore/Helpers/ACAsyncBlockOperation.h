//
//  ACAsyncBlockOperation.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACAsynchronousOperation.h"

@interface ACAsyncBlockOperation : ACAsynchronousOperation
- (instancetype)initWithBlock:(void(^)(void))block;
@end
