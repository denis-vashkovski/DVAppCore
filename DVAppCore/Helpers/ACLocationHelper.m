//
//  ACLocationHelper.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 05/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACLocationHelper.h"

#import "ACLog.h"
#import "NSNotificationCenter+AppCore.h"

#import <MapKit/MapKit.h>

NSInteger const kCLAuthorizationStatusDisabled = -1;

@interface ACLocationHelper()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ACLocationHelper
ACSINGLETON_M

- (BOOL)authorize:(LHAuthType)authType {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        switch (authType) {
            case LHAuthTypeWhenInUse:
                [_locationManager requestWhenInUseAuthorization];
                break;
            case LHAuthTypeAlways:
                [_locationManager requestAlwaysAuthorization];
                break;
            default:
                break;
        }
        
        [_locationManager startUpdatingLocation];
        
        _authorizationStatus = [CLLocationManager authorizationStatus];
        return ((self.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) ||
                (self.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse));
    } else {
        _authorizationStatus = kCLAuthorizationStatusDisabled;
        return NO;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_locationHelper:didFailWithError:)]) {
        [self.delegate ac_locationHelper:self didFailWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    _authorizationStatus = status;
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            break;
        default:
            [_locationManager startUpdatingLocation];
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_locationHelper:didChangeAuthorizationStatus:)]) {
        [self.delegate ac_locationHelper:self didChangeAuthorizationStatus:status];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = locations.lastObject;
    if (currentLocation != nil) {
        _currentCoordinate = currentLocation.coordinate;
        _isUserLocationDetected = YES;
        
        [[NSNotificationCenter defaultCenter] ac_postNotificationName:ACUpdateCurrentLocation];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ac_locationHelper:didUpdateLocation:)]) {
            [self.delegate ac_locationHelper:self didUpdateLocation:self.currentCoordinate];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    _currentHeading = newHeading;
    
    [[NSNotificationCenter defaultCenter] ac_postNotificationName:ACUpdateCurrentHeading];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ac_locationHelper:didUpdateHeading:)]) {
        [self.delegate ac_locationHelper:self didUpdateHeading:self.currentHeading];
    }
}

#pragma mark - Utils
#define RADIUS_EARTH_IN_METERS 6378137.
#define ONE_DEGREE_IN_RADIAN ( M_PI / 180. )
// http://www.movable-type.co.uk/scripts/latlong.html
- (double)distanceBetween:(CLLocationCoordinate2D)location1 and:(CLLocationCoordinate2D)location2 {
    double lat1 = location1.latitude * ONE_DEGREE_IN_RADIAN;
    double lat2 = location2.latitude * ONE_DEGREE_IN_RADIAN;
    double dLat = (location2.latitude - location1.latitude) * ONE_DEGREE_IN_RADIAN;
    double dLon = (location2.longitude - location1.longitude) * ONE_DEGREE_IN_RADIAN;
    
    double a = pow(sin(dLat / 2.), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2.), 2);
    
    return RADIUS_EARTH_IN_METERS * 2. * atan2(sqrt(a), sqrt(1. - a));
}

- (double)distanceToLocation:(CLLocationCoordinate2D)location {
    return [self distanceBetween:self.currentCoordinate and:location];
}

- (double)radiusTo:(NSArray *)annotations annotationsVisibleCountMin:(NSUInteger)annotationsVisibleCountMin {
    double radius = .0;
    
    if (ACValidArray(annotations) && (annotationsVisibleCountMin > 0)) {
        NSMutableArray<NSNumber *> *distanceList = [NSMutableArray new];
        for (id<MKAnnotation> annotation in annotations) {
            [distanceList addObject:@([self distanceToLocation:annotation.coordinate])];
        }
        
        [distanceList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
        radius = [distanceList[(distanceList.count < annotationsVisibleCountMin)
                               ? (distanceList.count - 1)
                               : (annotationsVisibleCountMin - 1)] doubleValue];
    }
    
    return radius;
}

@end

AC_EXTERN_STRING_M(ACUpdateCurrentLocation)
AC_EXTERN_STRING_M(ACUpdateCurrentHeading)

BOOL ACLocationsCoordinates2DEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
    return (coordinate1.latitude == coordinate2.latitude) && (coordinate1.longitude == coordinate2.longitude);
}
