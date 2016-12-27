//
//  MapPin.h
//  Zaina
//
//  Created by NLS32-MAC on 22/01/16.
//  Copyright © 2016 Kalpit Gajera. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MapPin : NSObject< MKAnnotation>{
    

CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end