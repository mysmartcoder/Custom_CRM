//
//  MapVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "MapVC.h"
#import "QuickSearchVC.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "MKMapView+ZoomLevel.h"
#import <MapKit/MapKit.h>

@interface MapVC ()
{
    UIWebView *accWebview;
    NSMutableArray *arrRecId,*arrLat,*arrLong,*arrDist,*arrAddress;
    float latitude,longitude;
    MKUserLocation *userLoc;
    BOOL isData;
}
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView
{
    _txtAdress.delegate = self;
    _txtDistance.delegate = self;
    
//    _txtAdress.text = @"Chicago,IL 60606";
//    _txtDistance.text = @"500";
    
    userLoc = [[MKUserLocation alloc]init];
    _mapView1.hidden = YES;
    _mapView1.delegate = self;
    _mapView1.showsUserLocation = YES;
    
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (accWebview) {
        [accWebview removeFromSuperview];
    }
    [self setFonts_Background];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)removeView
{
    if (accWebview) {
        [accWebview removeFromSuperview];
        
    }
}





-(void)serviceForQuickSearch:(NSString *)lat and:(NSString *) lon dist:(NSString *) distance{
    
//    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"longitude":@"151.207068"},@{@"latitude":@"-33.867613"},@{@"company_id":WORKGROUP},@{@"Distance":@"5"}]];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"longitude":lon},@{@"latitude":lat},@{@"company_id":WORKGROUP},@{@"Distance":distance}]];

    isData = false;
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GET_GEOLOCATION arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        //        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
        arrRecId = [[NSMutableArray alloc]init];
        arrLat = [[NSMutableArray alloc]init];
        arrLong = [[NSMutableArray alloc]init];
        arrDist = [[NSMutableArray alloc]init];
        arrAddress = [[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            _mapView1.hidden = NO;
            isData = false;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"GeoLocation"])
            {
                isData = true;

                if([doc valueWithPath:@"RecordID"])
                    [arrRecId addObject:[doc valueWithPath:@"RecordID"]];
                
                if([doc valueWithPath:@"Latitude"])
                    [arrLat addObject:[doc valueWithPath:@"Latitude"]];
                
                if([doc valueWithPath:@"Longitude"])
                    [arrLong addObject:[doc valueWithPath:@"Longitude"]];
                else
                    [arrLong addObject:@""];
                
                if([doc valueWithPath:@"Distance"])
                    [arrDist addObject:[doc valueWithPath:@"Distance"]];
                else
                    [arrDist addObject:@"none"];
                
                if([doc valueWithPath:@"MapAddress"])
                    [arrAddress addObject:[doc valueWithPath:@"MapAddress"]];
                else
                    [arrAddress addObject:@"none"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
//                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//                point.coordinate = userLoc.coordinate;
//                //        point.title = @"The Location";
//                //        point.subtitle = @"Sub-title";
//                
//                [self.mapView1 addAnnotation:point];
                [self addAllPins];
                
//                MKMapRect zoomRect = MKMapRectNull;
//                for (id <MKAnnotation> annotation in self.mapView1.annotations)
//                {
//                    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//                    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
//                }
                CLLocationCoordinate2D c;
                c.latitude =  [lat doubleValue];
                c.longitude = [lon doubleValue];

                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(c, 50000, 50000);
                    [_mapView1 setRegion:[_mapView1 regionThatFits:region] animated:YES];
                    region.span.longitudeDelta  = 0.5;
                    region.span.latitudeDelta  = 0.5;
//                    region.center = c;

//                [_mapView1 setVisibleMapRect:zoomRect animated:YES];
                
                _mapView1.hidden = NO;
                STOPLOADING();
                
            });
            
        }
        if(!isData)
        {
            [BaseApplication showAlertWithTitle:@"Result" withMessage:@"You have not any record exist near by this location"];
            return;
        }
        
    }];
    
    
}

//User Location

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // zoom to region containing the user location
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50, 50);
//    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
//    region.span.longitudeDelta  = 0.5;
//    region.span.latitudeDelta  = 0.5;
//    CLLocationCoordinate2D c;
//    c.latitude =  ;
//    c.longitude = -122.1419;
//    region.center = c;
//    [self.mapView1 setCenterCoordinate:userLocation.coordinate zoomLevel:11 animated:YES];
    userLoc = userLocation;
    // add the annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"The Location";
//    point.subtitle = @"Sub-title";
//    [mapView removeAnnotations:mapView.annotations];
//    [self.mapView1 addAnnotation:point];
}

//Annotation in map

-(void)addAllPins
{
    for (id<MKAnnotation> annotation in _mapView1.annotations)
    {
        [_mapView1 removeAnnotation:annotation];
        // change coordinates etc
//        [_mapView1 addAnnotation:annotation];
    }
    
    for(int i = 0; i < arrLat.count; i++)
    {
        NSString *arrCoordinateStr =[NSString stringWithFormat:@"%@, %@",[arrLat objectAtIndex:i],[arrLong objectAtIndex:i]];
        [self addPinWithTitle:[arrAddress objectAtIndex:i] AndCoordinate:arrCoordinateStr];
    }
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = userLoc.coordinate;
////        point.title = @"The Location";
////        point.subtitle = @"Sub-title";
//    
//        [self.mapView1 addAnnotation:point];

}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude1 = [components[0] doubleValue];
    double longitude1 = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude1, longitude1);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    
    [self.mapView1 addAnnotation:mapPin];
}


- (IBAction)searchData:(id)sender {
    
    NSString *dist1 = _txtDistance.text;
    if([dist1 isEqualToString:@""])
        dist1 = @"5";
    if(![_txtAdress.text isEqualToString:@""])
    {
        CLLocationCoordinate2D center = [BaseApplication getLocationFromAddressString:_txtAdress.text];
        latitude = center.latitude ;
        longitude = center.longitude;
    }
    else
    {
        latitude = [AppDelegate initAppdelegate].latitude;
        longitude = [AppDelegate initAppdelegate].longitude;
    }
//    [self serviceForQuickSearch:latitude and:longitude dist:dist];
    [self serviceForQuickSearch:[[NSNumber numberWithFloat:latitude] stringValue] and:[[NSNumber numberWithFloat:longitude] stringValue] dist:dist1];

    
}

#pragma mark - TEXTFIELD DELEGATES METHODS
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (IBAction)mapMenu:(id)sender {
    [[SlideNavigationController sharedInstance]toggleLeftMenu];

}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lblBG.count; i++) {
        UILabel *lbl = [self.lblBG objectAtIndex:i];
        lbl.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_REGULAR;
    }
}

@end
