//
//  ACLog.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

void ACLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

#ifdef DEBUG
#define NSLog(message, ...) ACLog(__FILE__, __LINE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__);
#else
#define NSLog(message, ...)
#endif
