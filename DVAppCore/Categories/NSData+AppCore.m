//
//  NSData+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSData+AppCore.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData(AppCore)

#define CHUNK_SIZE 4096
+ (NSString *)ac_MD5ByFilePath:(NSString *)path {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!handle) return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    while (YES) {
        @autoreleasepool {
            NSData *fileData = [handle readDataOfLength:CHUNK_SIZE];
            CC_MD5_Update(&md5, fileData.bytes, (CC_LONG)fileData.length);
            if ([fileData length] == 0) break;
        }
    }
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md5Buffer, &md5);
    
    return [self stringByChars:md5Buffer];
}

- (NSString *)ac_MD5 {
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, md5Buffer);
    
    return [[self class] stringByChars:md5Buffer];
}

- (id)ac_jsonToCollectionObject {
    id jsonObj = nil;
    return ((jsonObj = [NSJSONSerialization JSONObjectWithData:self options:0 error:NULL])
            && ([jsonObj isKindOfClass:[NSArray class]]
                || [jsonObj isKindOfClass:[NSDictionary class]])) ? jsonObj : nil;
}

#pragma mark - Utils
+ (NSString *)stringByChars:(unsigned char *)chars {
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",chars[i]];
    }
    
    return [[NSString alloc] initWithString:output];
}

@end
