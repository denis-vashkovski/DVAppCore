//
//  ACContactsHelper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACContactsHelper.h"

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

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
@interface ACContactsHelper()<ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>
@property (nonatomic, weak) id<ACContactsHelperDelegate> delegate;
@end

@implementation ACContactsHelper
ACSINGLETON_M

+ (void)authorizationWithCompletionHandler:(void (^)(BOOL))completionHandler {
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
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
    } else {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
            if (completionHandler) {
                completionHandler(NO);
            }
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            if (completionHandler) {
                completionHandler(YES);
            }
        } else {
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionHandler) {
                        completionHandler(granted);
                    }
                });
            });
        }
    }
}

+ (NSArray *)getAllContacts {
    return [self getContactsByName:nil];
}

+ (NSArray<ACContactObject *> *)getContactsByName:(NSString *)name {
    NSMutableArray<ACContactObject *> *contactList = [[NSMutableArray alloc] init];
    
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
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
    } else {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
        NSArray *allContacts = (ACValidStr(name)
                                ? (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBookRef, (__bridge CFStringRef)name)
                                : (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef));
        
        for (id record in allContacts) {
            [contactList addObject:[self contactObjectFromRecord:record]];
        }
    }
    
    return ACValidArray(contactList) ? [NSArray arrayWithArray:contactList] : nil;
}

+ (UIViewController *)contactsViewControllerWithDelegate:(id<ACContactsHelperDelegate>)delegate {
    ACContactsHelper *_self = [self getInstance];
    [_self setDelegate:delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K.@count > 0", ABPersonPhoneNumbersProperty];
    
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNContactPickerViewController *picker = [CNContactPickerViewController new];
        [picker setPredicateForEnablingContact:predicate];
        [picker setDelegate:_self];
        
        return picker;
    } else {
        ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
        [picker setPredicateForEnablingPerson:predicate];
        [picker setPeoplePickerDelegate:_self];
        
        return picker;
    }
}

// TODO add logic for adding a contact
+ (BOOL)addContact:(ACContactObject *)contactObject {
    if (!contactObject) return NO;
    
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNMutableContact *contact = [CNMutableContact new];
        contact.familyName = contactObject.lastName;
        contact.givenName = contactObject.firstName;
        
        CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:contactObject.phones.firstObject]];
        contact.phoneNumbers = @[homePhone];
        
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        [request addContact:contact toContainerWithIdentifier:nil];
        
        return [[CNContactStore new] executeSaveRequest:request error:nil];
    } else {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABRecordRef person = ABPersonCreate();
        CFErrorRef anError = NULL;
        
        if (ACValidStr(contactObject.firstName)) {
            ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)contactObject.firstName , nil);
        }
        if (ACValidStr(contactObject.lastName)) {
            ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)contactObject.lastName , nil);
        }
        if (ACValidArray(contactObject.phones) || ACValidStr(contactObject.fax)) {
            ABMutableMultiValueRef phoneNumberMultiValue  = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            if (ACValidArray(contactObject.phones)) {
                for (NSString *phone in contactObject.phones) {
                    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)phone, kABPersonPhoneMobileLabel, NULL);
                }
            }
            if (ACValidStr(contactObject.fax)) {
                ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)contactObject.fax, kABPersonPhoneMobileLabel, NULL);
            }
            ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        }
        if (ACValidStr(contactObject.email)) {
            ABMutableMultiValueRef emailMultiValue  = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)contactObject.email, (__bridge CFStringRef)@"Public", NULL);
            ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
        }
        if (ACValidStr(contactObject.link)) {
            ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFTypeRef)contactObject.link, kABPersonHomePageLabel, NULL);
            ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        }
        if (ACValidStr(contactObject.country) || ACValidStr(contactObject.state) || ACValidStr(contactObject.city) || ACValidStr(contactObject.street) || ACValidStr(contactObject.zip)) {
            ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
            CFStringRef keys[5];
            keys[0] = kABPersonAddressStreetKey;
            keys[1] = kABPersonAddressCityKey;
            keys[2] = kABPersonAddressZIPKey;
            keys[3] = kABPersonAddressCountryKey;
            keys[4] = kABPersonAddressStateKey;
            CFStringRef values[5];
            values[0] = (__bridge_retained CFStringRef)ACUnnilStr(contactObject.street);
            values[1] = (__bridge_retained CFStringRef)ACUnnilStr(contactObject.city);
            values[2] = (__bridge_retained CFStringRef)ACUnnilStr(contactObject.zip);
            values[3] = (__bridge_retained CFStringRef)ACUnnilStr(contactObject.country);
            values[4] = (__bridge_retained CFStringRef)ACUnnilStr(contactObject.state);
            
            CFDictionaryRef dicref = CFDictionaryCreate(kCFAllocatorDefault, (void *)keys, (void *)values, 5, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            ABMultiValueIdentifier identifier;
            ABMultiValueAddValueAndLabel(address, dicref, kABHomeLabel, &identifier);
            ABRecordSetValue(person, kABPersonAddressProperty, address,&anError);
        }
        if (ACValidStr(contactObject.note)) {
            ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFTypeRef)contactObject.note, nil);
        }
        
        ABAddressBookAddRecord(addressBook, person, nil);
        
        return ABAddressBookSave(addressBook, &anError);
    }
    
    return YES;
}

+ (UIViewController *)viewControllerWithAddContact:(CNMutableContact *)contact delegate:(id<ACContactsHelperDelegate>)delegate {
    if (!contact) return nil;
    
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNContactStore *store = [[CNContactStore alloc] init];
        
        CNContactViewController *controller = [CNContactViewController viewControllerForUnknownContact:contact];
        controller.contactStore = store;
//        controller.delegate = self;
        
        return controller;
    } else {
        ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
//        controller.displayedPerson = person;
        controller.allowsAddingToAddressBook = YES;
        
        return controller;
    }
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

#pragma mark ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_contactPickerDidCancel)]) {
        [self.delegate ac_contactPickerDidCancel];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_contactPickerDidSelectContact:)]) {
        [self.delegate ac_contactPickerDidSelectContact:[ACContactsHelper contactObjectFromRecord:(__bridge id)(person)]];
    }
}

#pragma mark Utils
+ (ACContactObject *)contactObjectFromRecord:(id)record {
    ACContactObject *contactObject = [ACContactObject new];
    
    if (record) {
        if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            CNContact *contact = (CNContact *)record;
            
            [contactObject setFirstName:contact.givenName];
            [contactObject setLastName:contact.familyName];
            [contactObject setEmail:contact.emailAddresses.firstObject.value];
            [contactObject setPhones:@[contact.phoneNumbers.firstObject.value.stringValue]];
        } else {
            ABRecordRef thisContact = (__bridge ABRecordRef)record;
            
            [contactObject setFirstName:(__bridge NSString *)ABRecordCopyValue(thisContact, kABPersonFirstNameProperty)];
            [contactObject setLastName:(__bridge NSString *)ABRecordCopyValue(thisContact, kABPersonLastNameProperty)];
            
            ABMutableMultiValueRef eMail = ABRecordCopyValue(thisContact, kABPersonEmailProperty);
            if (ABMultiValueGetCount(eMail) > 0) {
                [contactObject setEmail:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0)];
            }
            
            ABMultiValueRef phones = (__bridge ABMultiValueRef)((__bridge NSString *)ABRecordCopyValue(thisContact, kABPersonPhoneProperty));
            NSString *mobileLabel = nil;
            
            for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
                mobileLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, j);
                if (!ACValidStr(mobileLabel)
                    || [mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]
                    || [mobileLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]) {
                    [contactObject setPhones:@[(__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, j)]];
                }
            }
        }
    }
    
    return contactObject;
}

@end
