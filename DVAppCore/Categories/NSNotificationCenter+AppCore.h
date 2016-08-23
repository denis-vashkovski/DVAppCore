//
//  NSNotificationCenter+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter(AppCore)
- (void)ac_postNotificationName:(NSString *)aName;
- (void)ac_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (void)ac_removeObserver:(id)observer name:(NSString *)aName;
@end
