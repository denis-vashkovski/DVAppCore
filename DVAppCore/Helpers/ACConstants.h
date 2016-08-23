//
//  ACConstants.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#ifndef ACConstants_h
#define ACConstants_h

#define SCREEN_WIDTH                                [ [ UIScreen mainScreen ] bounds ].size.width
#define SCREEN_HEIGHT                               [ [ UIScreen mainScreen ] bounds ].size.height

#define SYSTEM_VERSION                              [ [ UIDevice currentDevice ] systemVersion ]
#define SYSTEM_VERSION_COMPARE_TO(v)                ( [ SYSTEM_VERSION compare:(v) options:NSNumericSearch ] )
#define SYSTEM_VERSION_EQUAL_TO(v)                  ( SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedSame )
#define SYSTEM_VERSION_GREATER_THAN(v)              ( SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedDescending )
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ( SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedAscending )
#define SYSTEM_VERSION_LESS_THAN(v)                 ( SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedAscending )
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ( SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedDescending )

#define USER_DEFINED_BY_KEY(key)                    [ [ [ NSBundle mainBundle ] infoDictionary ] valueForKey:(key) ]

#define BUNDLE_ID                                   [ [ NSBundle mainBundle ] bundleIdentifier ]

// https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
#define APP_VERSION                                 [ [ NSBundle mainBundle ] objectForInfoDictionaryKey:@"CFBundleShortVersionString" ]
#define APP_BUILD                                   [ [ NSBundle mainBundle ] objectForInfoDictionaryKey:@"CFBundleVersion" ]

#define AC_ANIMATION_DURATION_DEFAULT .3

#endif /* ACConstants_h */
