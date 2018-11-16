//
//  ACViewDescriber.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class ACDataModel, ACLayoutModel;

@interface ACViewDescriber : NSObject
- (instancetype)initWithDataModel:(ACDataModel *)dataModel
                      layoutModel:(ACLayoutModel *)layoutModel
                        viewClass:(Class)viewClass;

@property (nonatomic, strong, readonly) ACDataModel *dataModel;
@property (nonatomic, strong, readonly) ACLayoutModel *layoutModel;
@property (nonatomic, strong, readonly) Class viewClass;

@property (nonatomic, readonly) CGFloat height;
@end
