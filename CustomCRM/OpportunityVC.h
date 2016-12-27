//
//  OpportunityVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 07/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpportunityCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;

@property (strong, nonatomic) IBOutlet UILabel *vlbl3;
@property (strong, nonatomic) IBOutlet UILabel *vlbl2;
@property (strong, nonatomic) IBOutlet UILabel *vlbl1;
@property (strong, nonatomic) IBOutlet UILabel *vlbl4;
@property (strong, nonatomic) IBOutlet UILabel *vlbl5;
@property (strong, nonatomic) IBOutlet UILabel *vlbl6;
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnAssign;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@end

@interface OpportunityVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,
UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UISearchBar *txtOppSearch;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UILabel *lblinfo;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

@property (strong, nonatomic) IBOutlet UITableView *tblOpportunity;
- (IBAction)oppSideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong,nonatomic) NSString *strOppSearch;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
