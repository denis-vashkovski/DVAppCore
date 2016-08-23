//
//  ACContactsHelper.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACContactObject : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray<NSString *> *phones;

- (NSString *)nameFull;
- (NSString *)nameShort;
@end

#import <UIKit/UIKit.h>
@protocol ACContactsHelperDelegate;

@interface ACContactsHelper : NSObject
+ (void)authorizationWithCompletionHandler:(void (^)(BOOL granted))completionHandler;
+ (NSArray<ACContactObject *> *)getAllContacts;
+ (NSArray<ACContactObject *> *)getContactsByName:(NSString *)name;
+ (UIViewController *)contactsViewControllerWithDelegate:(id<ACContactsHelperDelegate>)delegate;
@end

@protocol ACContactsHelperDelegate <NSObject>
@optional
- (void)ac_contactPickerDidCancel;
- (void)ac_contactPickerDidSelectContact:(ACContactObject *)contact;
@end
