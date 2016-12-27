//
//  WebviewVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 22/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@interface WebviewVC : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic)  NSString *resUrlStr;
@property (strong, nonatomic)  NSString *strPageTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)sideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constTitleHeight;
@property (strong, nonatomic) IBOutlet UIControl *viewMenu;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;

@end
