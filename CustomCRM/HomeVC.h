//
//  HomeVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface HomeTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblBy;
@property (strong, nonatomic) IBOutlet UILabel *lblAction;

@property (strong, nonatomic) IBOutlet UILabel *lblEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEventType;

@end

@interface HomeVC : UIViewController <SlideNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>//,UITabBarControllerDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tblSearch;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constTblSearchHeight;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;

@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic) IBOutlet UITableView *tblActivity;
@property (strong, nonatomic) IBOutlet UILabel *lblOptions;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
//@property (strong, nonatomic) IBOutlet UILabel *lblRecentActivity;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (strong, nonatomic) IBOutlet UITableView *tblEvents;
//@property (strong, nonatomic) IBOutlet UILabel *lblNoEvents;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIView *viewActivityMore;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constViewActivityMore;
@property (strong, nonatomic) IBOutlet UIView *viewEventMore;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constViewEventMore;

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

- (IBAction)refreshActivity:(id)sender;
- (IBAction)refreshEvents:(id)sender;
- (IBAction)calenderClicked:(id)sender;
- (IBAction)searchData:(id)sender;

- (IBAction)openOptions:(id)sender;
- (IBAction)sideBar:(id)sender;

//Array for RecentActivity
@property (strong, nonatomic) IBOutlet UIView *activityView;

@property (strong, nonatomic) NSMutableArray *arrRecNo;
@property (strong, nonatomic) NSMutableArray *arrActivityId;
@property (strong, nonatomic) NSMutableArray *arrCompany;
@property (strong, nonatomic) NSMutableArray *arrActivityEdited;
@property (strong, nonatomic) NSMutableArray *arrAction;

//Array For Today's Event

@property (strong, nonatomic) NSMutableArray *arrTRecNo;
@property (strong, nonatomic) NSMutableArray *arrTActivityId;
@property (strong, nonatomic) NSMutableArray *arrTCompany;
@property (strong, nonatomic) NSMutableArray *arrTActivityEdited;
@property (strong, nonatomic) NSMutableArray *arrTAction;


//SearchView
@property (strong, nonatomic) IBOutlet UIView *searchView;

- (IBAction)myAccountsClicked:(id)sender;
- (IBAction)contactsClicked:(id)sender;
- (IBAction)caseClicked:(id)sender;
- (IBAction)opportunityClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnMoreActivity;
@property (strong, nonatomic) IBOutlet UIButton *btnMoreEvent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constActTblHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constEventTblHeight;
- (IBAction)btnMoreActivity:(id)sender;
- (IBAction)btnMoreEvent:(id)sender;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtBG;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnBG;

@end
