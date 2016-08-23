//
//  NSMutableURLRequest+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 14/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest(AppCore)
- (void)ac_appendData:(NSArray<NSData *> *)data;
@end
