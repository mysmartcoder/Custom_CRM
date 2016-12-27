//
//  QuotesVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 08/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuotesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;

@property (strong, nonatomic) IBOutlet UILabel *lblV1;
@property (strong, nonatomic) IBOutlet UILabel *lblV2;
@property (strong, nonatomic) IBOutlet UILabel *lblV3;
@property (strong, nonatomic) IBOutlet UILabel *lblV4;
@property (strong, nonatomic) IBOutlet UILabel *lblV5;
@property (strong, nonatomic) IBOutlet UIView *btnView;

@property (strong, nonatomic) IBOutlet UIButton *btnSelect;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@end

@interface QuotesVC : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)quoteSideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *txtQsearch;
@property (strong, nonatomic) IBOutlet UITableView *tblQuotes;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

@property (strong, nonatomic) IBOutlet UIView *pagingView;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnPrev;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
- (IBAction)next:(id)sender;
- (IBAction)previouse:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblinfo;


@property (strong, nonatomic)  NSString *strQname;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
@end
