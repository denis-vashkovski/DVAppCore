//
//  ACLog.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACLog.h"

void ACLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...) {
    va_list ap;
    va_start (ap, format);
    
    if (![format hasSuffix:@"\n"]) {
        format = [format stringByAppendingString:@"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    va_end (ap);
    
    fprintf(stderr,
            "(%s:%d) %s",
            [[[NSString stringWithUTF8String:file] lastPathComponent] UTF8String],
            lineNumber,
            [body UTF8String]);
    
//    fprintf(stderr,
//            "(%s) (%s:%d) %s",
//            functionName,
//            [[[NSString stringWithUTF8String:file] lastPathComponent] UTF8String],
//            lineNumber,
//            [body UTF8String]);
}
