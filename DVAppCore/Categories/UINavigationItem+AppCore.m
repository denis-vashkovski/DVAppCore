//
//  UINavigationItem+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 11.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

#import "UINavigationItem+AppCore.h"

#import "NSArray+AppCore.h"

@implementation UINavigationItem(AppCore)

- (BOOL)ac_isCustomBackButton {
    return (self.leftBarButtonItem
            || ACValidArray(self.leftBarButtonItems)
            || self.backBarButtonItem);
}

@end
