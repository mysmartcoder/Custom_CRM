//
//  MapPin.m
//  Zaina
//
//  Created by NLS32-MAC on 22/01/16.
//  Copyright © 2016 Kalpit Gajera. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
    }
    return self;
}




@end