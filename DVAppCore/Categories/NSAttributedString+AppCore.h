//
//  NSAttributedString+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString(AppCore)
/*!
 @abstract Height count with the maximum length of
 @param width the max width
 */
- (CGFloat)ac_heightForWidth:(CGFloat)width;

/*!
 @abstract Width count with the maximum length of
 @param maxWidth the max width
 */
- (CGFloat)ac_widthByMaxWidth:(CGFloat)maxWidth;

/*!
 @abstract Width text
 */
- (CGFloat)ac_width;
@end
