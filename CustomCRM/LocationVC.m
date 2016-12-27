//
//  LocationVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 26/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "LocationVC.h"
#import "MapPin.h"

@interface LocationVC ()
{
    MapPin *pin;
}
@end

@implementation LocationVC

@synthesize mapview,lat_user,long_user;

- (void)viewDidLoad {
    [super viewDidLoad];
    MKCoordinateRegion region;
    
    self.navigationItem.title=@"Offer Details";
    
    NSLog(@"%@, %@",lat_user,long_user);
    region.center.latitude = [self.lat_user floatValue];
    region.center.longitude =[self.long_user floatValue];
    pin = [[MapPin alloc] initWithCoordinates:CLLocationCoordinate2DMake([self.lat_user floatValue], [self.long_user floatValue]) placeName:@"" description:@""];
    
    //    region.span.longitudeDelta = 0.19f;
    //    region.span.latitudeDelta = 0.19f;
    [mapview setRegion:region animated:YES];
    
    [mapview addAnnotation:pin];
    
    // Set two navigation bar buttons
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn1 setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 35.0f)];
//    [btn1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != mapview.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"location_icon"];    //as suggested by Squatch
    }
    else {
        [mapview.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

@end
