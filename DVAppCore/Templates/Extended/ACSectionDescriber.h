//
//  ACSectionDescriber.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACViewDescriber;

@interface ACSectionDescriber : NSObject<NSCopying, NSMutableCopying>
- (instancetype)initWithHeader:(ACViewDescriber *)header
                 numberOfCells:(NSInteger)numberOfCells
                     blockCell:(ACViewDescriber *(^)(NSInteger index))blockCell
                        footer:(ACViewDescriber *)footer;

- (instancetype)initWithHeader:(ACViewDescriber *)header
                         cells:(NSArray<ACViewDescriber *> *)cells
                        footer:(ACViewDescriber *)footer;

- (instancetype)initWithCells:(NSArray<ACViewDescriber *> *)cells;

@property (nonatomic, strong, readonly) ACViewDescriber *header;
@property (nonatomic, strong, readonly) ACViewDescriber *footer;
@property (nonatomic, readonly) NSInteger numberOfCells;

- (ACViewDescriber *)cellDescriberForIndex:(NSInteger)index;
@end

@interface ACMutableSectionDescriber : ACSectionDescriber
@property (nonatomic, readwrite) NSInteger numberOfCells;
@end
