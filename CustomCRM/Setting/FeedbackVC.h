//
//  FeedbackVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 10/12/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "Static.h"
#import <MessageUI/MessageUI.h>
#import "Utility.h"


@interface FeedbackVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UIImageView *imgBug;
    IBOutlet UIImageView *imgFeature;
    IBOutlet UIImageView *imgOther;
    IBOutlet UITextView *txtViewDesc;
    
    IBOutlet HCSStarRatingView *rating;
}
- (IBAction)btnBack:(id)sender;
- (IBAction)btnOptionBug:(id)sender;
- (IBAction)btnFeedback:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
- (IBAction)btnRate:(HCSStarRatingView *)sender;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;



@end
