//
//  ACContactsHelper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACContactsHelper.h"

#import <ContactsUI/ContactsUI.h>

#import "NSArray+AppCore.h"
#import "NSString+AppCore.h"

#import "ACLog.h"
#import "ACConstants.h"
#import "ACSingleton.h"

#pragma mark - ACContactObject
@implementation ACContactObject
- (NSString *)nameFull {
    NSString *fullName = ACUnnilStr(self.firstName).lowercaseString.capitalizedString;
    if (ACValidStr(self.lastName)) {
        if (!fullName.ac_isEmpty) {
            fullName = [fullName stringByAppendingString:@" "];
        }
        fullName = [fullName stringByAppendingString:ACUnnilStr(self.lastName).lowercaseString.capitalizedString];
    }
    return fullName.ac_isEmpty ? nil : fullName;
}

- (NSString *)nameShort {
    NSString *shortName = ACUnnilStr(self.firstName).lowercaseString.capitalizedString;
    if (ACValidStr(self.lastName)) {
        if (!shortName.ac_isEmpty) {
            shortName = [shortName stringByAppendingString:@" "];
            shortName = [shortName stringByAppendingString:[self.lastName substringToIndex:1].uppercaseString];
            shortName = [shortName stringByAppendingString:@"."];
        } else {
            shortName = self.lastName.lowercaseString.capitalizedString;
        }
    }
    return shortName.ac_isEmpty ? nil : shortName;
}
@end

#pragma mark - ACContactsHelper
@interface ACContactsHelper()<CNContactPickerDelegate>
@property (nonatomic, weak) id<ACContactsHelperDelegate> delegate;
@end

@implementation ACContactsHelper
ACSINGLETON_M

+ (void)authorizationWithCompletionHandler:(void (^)(BOOL))completionHandler {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (authorizationStatus == CNAuthorizationStatusDenied || authorizationStatus == CNAuthorizationStatusRestricted) {
        if (completionHandler) {
            completionHandler(NO);
        }
    } else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        if (completionHandler) {
            completionHandler(YES);
        }
    } else {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(granted);
                }
            });
        }];
    }
}

+ (NSArray *)getAllContacts {
    return [self getContactsByName:nil];
}

+ (NSArray<ACContactObject *> *)getContactsByName:(NSString *)name {
    NSMutableArray<ACContactObject *> *contactList = [[NSMutableArray alloc] init];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    NSArray *keys = @[ CNContactFamilyNameKey,
                       CNContactGivenNameKey,
                       CNContactPhoneNumbersKey,
                       CNContactEmailAddressesKey ];
    
    NSPredicate *predicate = (ACValidStr(name)
                              ? [CNContact predicateForContactsMatchingName:name]
                              : [CNContact predicateForContactsInContainerWithIdentifier:store.defaultContainerIdentifier]);
    
    NSError *error = nil;
    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    
    if (error) {
        NSLog(@"error fetching contacts %@", error);
    } else {
        for (CNContact *contact in cnContacts) {
            [contactList addObject:[self contactObjectFromRecord:contact]];
        }
    }
    
    return ACValidArray(contactList) ? [NSArray arrayWithArray:contactList] : nil;
}

+ (UIViewController *)contactsViewControllerWithDelegate:(id<ACContactsHelperDelegate>)delegate {
    ACContactsHelper *_self = [self getInstance];
    [_self setDelegate:delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    
    CNContactPickerViewController *picker = [CNContactPickerViewController new];
    [picker setPredicateForEnablingContact:predicate];
    [picker setDelegate:_self];
    
    return picker;
}

// TODO add logic for adding a contact
+ (BOOL)addContact:(ACContactObject *)contactObject {
    if (!contactObject) return NO;
    
    CNMutableContact *contact = [CNMutableContact new];
    contact.familyName = contactObject.lastName;
    contact.givenName = contactObject.firstName;
    
    CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome
                                                                value:[CNPhoneNumber phoneNumberWithStringValue:contactObject.phones.firstObject]];
    contact.phoneNumbers = @[homePhone];
    
    CNSaveRequest *request = [[CNSaveRequest alloc] init];
    [request addContact:contact toContainerWithIdentifier:nil];
    
    return [[CNContactStore new] executeSaveRequest:request error:nil];
}

+ (UIViewController *)viewControllerWithAddContact:(CNMutableContact *)contact delegate:(id<ACContactsHelperDelegate>)delegate {
    if (!contact) return nil;
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNContactViewController *controller = [CNContactViewController viewControllerForUnknownContact:contact];
    controller.contactStore = store;
//    controller.delegate = self;
    
    return controller;
}

#pragma mark CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_contactPickerDidCancel)]) {
        [self.delegate ac_contactPickerDidCancel];
    }
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_contactPickerDidSelectContact:)]) {
        [self.delegate ac_contactPickerDidSelectContact:[ACContactsHelper contactObjectFromRecord:contact]];
    }
}

#pragma mark Utils
+ (ACContactObject *)contactObjectFromRecord:(id)record {
    ACContactObject *contactObject = [ACContactObject new];
    
    if (record) {
        CNContact *contact = (CNContact *)record;
        
        [contactObject setFirstName:contact.givenName];
        [contactObject setLastName:contact.familyName];
        [contactObject setEmail:contact.emailAddresses.firstObject.value];
        [contactObject setPhones:@[contact.phoneNumbers.firstObject.value.stringValue]];
    }
    
    return contactObject;
}

@end
