//
//  UIButton+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 23/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIButton+AppCore.h"

#import <objc/runtime.h>

static char ACButtonBlockKey;

@implementation UIButton(AppCore)

- (void)ac_addAction:(ACButtonActionBlock)action forControlEvents:(UIControlEvents)controlEvents {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    IMP blockImp = imp_implementationWithBlock(action);
//    class_addMethod(UIButton.class, @selector(onButtonTouch:), blockImp, @encode(UIButton *));
//    
//    [self addTarget:self action:@selector(onButtonTouch:) forControlEvents:controlEvents];
//#pragma clang diagnostic pop
    
    objc_setAssociatedObject(self, &ACButtonBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(ac_onButtonTouch:) forControlEvents:controlEvents];
}

#pragma mark - Actions
- (void)ac_onButtonTouch:(UIButton *)sender {
    ACButtonActionBlock block = (ACButtonActionBlock)objc_getAssociatedObject(self, &ACButtonBlockKey);
    if (block) block(self);
}

@end
