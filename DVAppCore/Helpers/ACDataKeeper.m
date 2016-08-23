//
//  ACDataKeeper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACDataKeeper.h"

#import "NSString+AppCore.h"
#import "NSArray+AppCore.h"

#import "ACLog.h"

@implementation ACDataKeeperObject

+ (instancetype)getInstance {
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    id instance = [[ACDataKeeper getInstance] objectByClass:self.class];
    if ((instance && (self = instance)) || (self = [super init])) {
        [[ACDataKeeper getInstance] addClass:self];
    }
    
    return self;
}

- (void)snapshot {
    [[ACDataKeeper getInstance] saveAllClassObjectsWithCompletionHandler:^(BOOL result) {
        NSLog(@"Snapshot: %@", NSStringFromClass([self class]));
    }];
}

- (void)restore {
    [[ACDataKeeper getInstance] objectByClass:self.class];
    NSLog(@"Restore: %@", NSStringFromClass([self class]));
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [[ACDataKeeper getInstance] isExistClass:[self class]] ? [[self class] getInstance] : [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {}

@end

@interface ACDataKeeper()
@property (nonatomic, strong) NSString *fullPathDataFile;
@property (nonatomic, strong) NSMutableDictionary *userData;
@property (nonatomic, strong) NSMutableArray *classList;
@end

static NSString * const USER_DATA_FILE_NAME = @"app_user_data_file";

@implementation ACDataKeeper
ACSINGLETON_M_INIT(initInstanceWith)

- (void)initInstanceWith {
    _fullPathDataFile = [NSString ac_fullPathLibraryDirectoryWithLastComponent:USER_DATA_FILE_NAME];
    _userData = self.isSavedDataExist ? [NSKeyedUnarchiver unarchiveObjectWithFile:_fullPathDataFile] : [NSMutableDictionary dictionary];
    _classList = [NSMutableArray array];
}

- (BOOL)isSavedDataExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.fullPathDataFile];
}

- (id)objectForKey:(NSString *)key {
    if (!ValidStr(key)) {
        return nil;
    }
    
    return [self.userData objectForKey:key];
}

- (void)setObject:(id)object forkey:(nullable NSString *)key {
    if (!ValidStr(key)) {
        return;
    }
    [self.userData setObject:object forKey:key];
}

- (BOOL)saveData {
    return [NSKeyedArchiver archiveRootObject:self.userData toFile:self.fullPathDataFile];
}

- (BOOL)removeAllData {
    if (!self.isSavedDataExist) {
        return NO;
    }
    
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.fullPathDataFile
                                                             error:&error];
    
    if (result) {
        NSLog(@"Removed all data");
    }
    
    return result;
}

- (BOOL)isExistClass:(Class)aClass {
    for (NSObject *object in self.classList) {
        if ([NSStringFromClass([object class]) isEqualToString:NSStringFromClass(aClass)]) {
            return YES;
        }
    }
    return NO;
}

- (id)objectByClass:(Class)aClass {
    NSData *data = [self objectForKey:NSStringFromClass(aClass)];
    return data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
}

- (void)addClass:(ACDataKeeperObject *)classObject {
    if (!classObject || [self.classList containsObject:classObject]) {
        return;
    }
    [self.classList addObject:classObject];
}

- (void)saveAllClassObjectsWithCompletionHandler:(void (^)(BOOL))handler {
    if (self.classList.ac_isEmpty) {
        handler(NO);
        return;
    }
    
    dispatch_async(dispatch_queue_create("Save all class objects", NULL), ^{
        for (NSObject *classObject in self.classList) {
            [self setObject:[NSKeyedArchiver archivedDataWithRootObject:classObject]
                     forkey:NSStringFromClass(classObject.class)];
        }
        
        BOOL result = [self saveData];
        NSLog(@"Saved all data");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(result);
            }
        });
    });
}

@end
