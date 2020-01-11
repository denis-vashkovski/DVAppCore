//
//  ACKeyboardListener.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 11.01.2020.
//  Copyright © 2020 Denis Vashkovski. All rights reserved.
//

#import "ACSingleton.h"

@interface ACKeyboardListener : NSObject
ACSINGLETON_H_METHOD(sharedKeyboardListener)

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@end
