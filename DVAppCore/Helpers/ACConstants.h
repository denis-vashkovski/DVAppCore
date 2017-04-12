//
//  ACConstants.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#ifndef ACConstants_h
#define ACConstants_h

#define AC_SCREEN_WIDTH                                [ [ UIScreen mainScreen ] bounds ].size.width
#define AC_SCREEN_HEIGHT                               [ [ UIScreen mainScreen ] bounds ].size.height

#define AC_SYSTEM_VERSION                              [ [ UIDevice currentDevice ] systemVersion ]
#define AC_SYSTEM_VERSION_COMPARE_TO(v)                ( [ AC_SYSTEM_VERSION compare:(v) options:NSNumericSearch ] )
#define AC_SYSTEM_VERSION_EQUAL_TO(v)                  ( AC_SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedSame )
#define AC_SYSTEM_VERSION_GREATER_THAN(v)              ( AC_SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedDescending )
#define AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ( AC_SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedAscending )
#define AC_SYSTEM_VERSION_LESS_THAN(v)                 ( AC_SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedAscending )
#define AC_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ( AC_SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedDescending )

#define AC_USER_DEFINED_BY_KEY(key)                    [ [ [ NSBundle mainBundle ] infoDictionary ] valueForKey:(key) ]

#define AC_BUNDLE_ID                                   [ [ NSBundle mainBundle ] bundleIdentifier ]

// https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
#define AC_APP_VERSION                                 [ [ NSBundle mainBundle ] objectForInfoDictionaryKey:@"CFBundleShortVersionString" ]
#define AC_APP_BUILD                                   [ [ NSBundle mainBundle ] objectForInfoDictionaryKey:@"CFBundleVersion" ]

#define AC_ANIMATION_DURATION_DEFAULT .3

#endif /* ACConstants_h */
