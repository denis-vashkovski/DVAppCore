//
//  NSObject+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSObject+AppCore.h"

#import "NSString+AppCore.h"

@implementation NSObject(AppCore)

+ (void)ac_addSwizzlingSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    if (class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSString *)getTypeAttributePropertyByName:(NSString *)propertyName {
    if (ACValidStr(propertyName)) {
        Class observedClass = self.class;
        while (observedClass) {
            objc_property_t propTitle = class_getProperty(observedClass, [propertyName UTF8String]);
            if (propTitle) {
                const char *type = property_getAttributes(propTitle);
                NSString *typeString = [NSString stringWithUTF8String:type];
                NSArray *attributes = [typeString componentsSeparatedByString:@","];
                
                return [attributes objectAtIndex:0];
            }
            
            observedClass = [observedClass superclass];
        }
    }
    
    return nil;
}

- (Class)ac_getTypeClassOfPropertyByName:(NSString *)propertyName {
    NSString *typeAttribute = [self getTypeAttributePropertyByName:propertyName];
    if (typeAttribute && [typeAttribute hasPrefix:@"T@"]) {
        NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
        return NSClassFromString(typeClassName);
    }
    
    return nil;
}

- (BOOL)ac_hasPropertyByName:(NSString *)propertyName {
    if (propertyName && (propertyName.length > 0)) {
        Class observedClass = self.class;
        while (observedClass) {
            unsigned int count;
            objc_property_t *props = class_copyPropertyList(observedClass, &count);
            for (int i = 0; i < count; i++) {
                if (strcmp(propertyName.UTF8String, property_getName(props[i])) == 0) {
                    free(props);
                    return YES;
                }
            }
            free(props);
            
            observedClass = [observedClass superclass];
        }
    }
    
    return NO;
}

- (void)ac_setValue:(id)value forPropertyName:(NSString *)propertyName {
    if (![self ac_hasPropertyByName:propertyName]) {
        return;
    }
    
    id valuePrepared = value;
    Class propertyClass = [self ac_getTypeClassOfPropertyByName:propertyName];
    
    if (propertyClass && valuePrepared && ![valuePrepared isKindOfClass:propertyClass]) {
        if ([valuePrepared isKindOfClass:[NSArray class]]) {
            valuePrepared = ((NSArray *)valuePrepared).firstObject;
        } else if (propertyClass == [NSArray class]) {
            valuePrepared = @[valuePrepared];
        }
    } else if (!propertyClass) {
        NSString *typeAttribute = [self getTypeAttributePropertyByName:propertyName];
        
        if (typeAttribute) {
            NSString *propertyType = [typeAttribute substringFromIndex:1];
            const char * rawPropertyType = [propertyType UTF8String];
            
            if (strcmp(rawPropertyType, @encode(float)) == 0) {
                valuePrepared = @([valuePrepared floatValue]);
            } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
                valuePrepared = @([valuePrepared intValue]);
            } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
                valuePrepared = @([valuePrepared longLongValue]);
            } else if (strcmp(rawPropertyType, @encode(unsigned long)) == 0) {
                valuePrepared = @([valuePrepared unsignedLongLongValue]);
            } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
                valuePrepared = @([valuePrepared doubleValue]);
            } else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
                valuePrepared = @([valuePrepared boolValue]);
            } else if (strcmp(rawPropertyType, @encode(unsigned int)) == 0) {
                valuePrepared = @([valuePrepared unsignedIntValue]);
            } else if (strcmp(rawPropertyType, @encode(short)) == 0) {
                valuePrepared = @([valuePrepared shortValue]);
            } else if (strcmp(rawPropertyType, @encode(char)) == 0) {
                valuePrepared = @([valuePrepared charValue]);
            }
        }
    }
    
    [self setValue:valuePrepared forKey:propertyName];
}

- (BOOL)ac_saveObjectToAppDocumets:(id)object byName:(NSString *)name {
    if (!ACValidStr(name)) {
        return NO;
    }
    
    NSString *fullPath = [NSString ac_fullPathDocumentDirectoryWithLastComponent:name];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    return [data writeToFile:fullPath atomically:YES];
}

- (id)ac_objectFromAppDocumentsByName:(NSString *)name {
    if (!ACValidStr(name)) {
        return nil;
    }
    
    NSString *fullPath = [NSString ac_fullPathDocumentDirectoryWithLastComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    return data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
}

- (BOOL)ac_removeAppDocumentByName:(NSString *)name {
    if (!ACValidStr(name)) {
        return NO;
    }
    
    NSString *fullPath = [NSString ac_fullPathDocumentDirectoryWithLastComponent:name];
    return ([[NSFileManager defaultManager] fileExistsAtPath:fullPath] &&
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil]);
}

@end
