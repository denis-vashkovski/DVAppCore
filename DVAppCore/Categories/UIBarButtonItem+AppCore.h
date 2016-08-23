//
//  UIBarButtonItem+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 08/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIBarButtonItem(AppCore)
@property(nonatomic, getter=ac_isHidden) IBInspectable BOOL ac_hidden;
- (void)ac_setHidden:(BOOL)hidden animate:(BOOL)animate;
@end
