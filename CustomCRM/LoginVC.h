//
//  ViewController.h
//  CustomCRM
//
//  Created by Pinal Panchani on 12/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <NSXMLParserDelegate,NSURLConnectionDelegate,UITextFieldDelegate>

@property (retain, nonatomic) NSMutableData *webData;
@property (retain, nonatomic) NSXMLParser *xmlParser;
@property (retain, nonatomic) NSMutableString *nodeContent;
@property (retain, nonatomic) NSString *finaldata;
@property (retain, nonatomic) NSMutableArray *responseArrayTmp;
@property (retain, nonatomic) NSMutableArray *responseArrayTmp1;

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblLoginHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblCopyright;

- (IBAction)userLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *showPassImgView;


// Background & text style
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtfield;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;


@end

