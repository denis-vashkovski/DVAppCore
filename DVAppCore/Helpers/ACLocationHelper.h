//
//  ACLocationHelper.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 05/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACSingleton.h"
#import <CoreLocation/CoreLocation.h>

@protocol ACLocationHelperDelegate;

typedef enum {
    LHAuthTypeWhenInUse,
    LHAuthTypeAlways
} LHAuthType;

@interface ACLocationHelper : NSObject
ACSINGLETON_H

- (BOOL)authorize:(LHAuthType)authType;

@property (readonly, nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (readonly, nonatomic) BOOL isUserLocationDetected;
@property (readonly, nonatomic) CLHeading *currentHeading;

@property (nonatomic, weak) id<ACLocationHelperDelegate> delegate;

- (double)distanceBetween:(CLLocationCoordinate2D)location1 and:(CLLocationCoordinate2D)location2;
- (double)distanceToLocation:(CLLocationCoordinate2D)location;
@end

@protocol ACLocationHelperDelegate <NSObject>
- (void)ac_locationHelper:(ACLocationHelper *)locationHelper didUpdateLocation:(CLLocationCoordinate2D)currentCoordinate;
- (void)ac_locationHelper:(ACLocationHelper *)locationHelper didUpdateHeading:(CLHeading *)newHeading;
@end

EXTERN_STRING_H(ACUpdateCurrentLocation)
EXTERN_STRING_H(ACUpdateCurrentHeading)

BOOL ACLocationsCoordinates2DEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);
