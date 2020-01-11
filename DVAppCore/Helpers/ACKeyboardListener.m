//
//  ACKeyboardListener.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 11.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

#import "ACKeyboardListener.h"

#import "NSNotificationCenter+AppCore.h"

@implementation ACKeyboardListener
ACSINGLETON_M_METHOD_INIT(sharedKeyboardListener, initKeyboardListener)

- (void)initKeyboardListener {
    [[NSNotificationCenter defaultCenter] ac_addObserver:self
                                                selector:@selector(keyboardDidShown:)
                                                    name:UIKeyboardDidShowNotification];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self
                                                selector:@selector(keyboardDidHide:)
                                                    name:UIKeyboardDidHideNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:UIKeyboardDidHideNotification];
}

- (void)keyboardDidShown:(NSNotification *)notification {
    _visible = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _visible = NO;
}

@end
