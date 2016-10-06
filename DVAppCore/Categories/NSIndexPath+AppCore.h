//
//  NSIndexPath+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 06/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath(AppCore)
+ (NSArray<NSIndexPath *> *)indexPathsForSection:(NSInteger)section rangeRows:(NSRange)rangeRows;
@end
