//
//  ACHeightable.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

@class ACViewDescriber;

@protocol ACHeightable <NSObject>
+ (CGFloat)heightWithViewDescriber:(ACViewDescriber *)viewDescriber;
@end
