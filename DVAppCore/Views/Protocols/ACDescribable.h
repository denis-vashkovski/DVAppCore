//
//  ACDescribable.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

@class ACViewDescriber;

@protocol ACDescribable <NSObject>
- (void)configureWithViewDescriber:(ACViewDescriber *)viewDescriber;
@end
