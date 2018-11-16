//
//  ACSectionDescriber.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACSectionDescriber.h"

@interface ACSectionDescriber()
@property (nonatomic, readwrite) NSInteger numberOfCells;
@property (nonatomic, strong) ACViewDescriber *(^blockCell)(NSInteger);
@end

@implementation ACSectionDescriber

- (instancetype)initWithHeader:(ACViewDescriber *)header
                 numberOfCells:(NSInteger)numberOfCells
                     blockCell:(ACViewDescriber *(^)(NSInteger))blockCell
                        footer:(ACViewDescriber *)footer {
    NSAssert((header || numberOfCells || footer), @"Section can't be totally empty");
    
    if (self = [super init]) {
        _header = header;
        _numberOfCells = numberOfCells;
        _blockCell = blockCell;
        _footer = footer;
    }
    return self;
}

- (instancetype)initWithHeader:(ACViewDescriber *)header
                         cells:(NSArray<ACViewDescriber *> *)cells
                        footer:(ACViewDescriber *)footer {
    return ([self initWithHeader:header
                   numberOfCells:cells.count
                       blockCell:^ACViewDescriber *(NSInteger index) {
                           return cells[index];
                       }
                          footer:footer]);
}

- (instancetype)initWithCells:(NSArray<ACViewDescriber *> *)cells {
    return [self initWithHeader:nil cells:cells footer:nil];
}

- (instancetype)initWithSectionDescriber:(ACSectionDescriber *)sectionDescriber {
    return [self initWithHeader:sectionDescriber.header
                  numberOfCells:sectionDescriber.numberOfCells
                      blockCell:sectionDescriber.blockCell
                         footer:sectionDescriber.footer];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    return [[ACSectionDescriber allocWithZone:zone] initWithSectionDescriber:self];
}

#pragma mark - NSMutableCopying
- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[ACMutableSectionDescriber allocWithZone:zone] initWithSectionDescriber:self];
}

#pragma mark - Public
- (ACViewDescriber *)cellDescriberForIndex:(NSInteger)index {
    return self.blockCell(index);
}

@end

@implementation ACMutableSectionDescriber
@dynamic numberOfCells;
@end
