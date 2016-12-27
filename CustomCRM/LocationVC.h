//
//  LocationVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 26/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationVC : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong,nonatomic)NSString *lat_user,*long_user;


@end
