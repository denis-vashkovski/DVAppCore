//
//  ACDataKeeper.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACSingleton.h"

@interface ACDataKeeperObject : NSObject<NSCoding>
+ (instancetype)getInstance;

- (void)snapshot;
- (void)restore;
@end

@interface ACDataKeeper : NSObject
ACSINGLETON_H

- (BOOL)isSavedDataExist;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forkey:(NSString *)key;

- (BOOL)saveData;
- (BOOL)removeAllData;

- (BOOL)isExistClass:(Class)aClass;
- (id)objectByClass:(Class)aClass;
- (void)addClass:(ACDataKeeperObject *)classObject;

- (void)saveAllClassObjectsWithCompletionHandler:(void (^)(BOOL result))handler;
@end
