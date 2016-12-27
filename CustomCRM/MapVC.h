//
//  MapVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVC : UIViewController <UITextViewDelegate,UITextFieldDelegate,MKMapViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *txtAdress;
@property (strong, nonatomic) IBOutlet UITextField *txtDistance;
- (IBAction)searchData:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView1;
- (IBAction)mapMenu:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
