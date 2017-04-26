//
//  UIFont+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 18/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont(AppCore)

@end

#define ACFont(nameFont, sizeFont) [UIFont fontWithName:nameFont size:sizeFont]
#define ACFontSystem(sizeFont) [UIFont systemFontOfSize:sizeFont]
