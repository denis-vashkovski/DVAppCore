//
//  ACViewDescriber.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACViewDescriber.h"

#import "ACHeightable.h"
#import "ACDescribable.h"

@implementation ACViewDescriber

- (instancetype)initWithDataModel:(ACDataModel *)dataModel
                      layoutModel:(ACLayoutModel *)layoutModel
                        viewClass:(Class)viewClass {
    NSAssert([viewClass conformsToProtocol:@protocol(ACDescribable)],
             @"'%@' must conform to the protocol '%@'",
             NSStringFromClass(viewClass),
             NSStringFromProtocol(@protocol(ACDescribable)));
    
    if (self = [super init]) {
        _dataModel = dataModel;
        _layoutModel = layoutModel;
        _viewClass = viewClass;
        
        [self recalculateHeight];
    }
    return self;
}

- (void)recalculateHeight {
    if (![viewClass conformsToProtocol:@protocol(ACHeightable)]) return;
    
    _height = [viewClass heightWithViewDescriber:self];
}

@end
