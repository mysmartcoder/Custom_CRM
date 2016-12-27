//
//  ContactVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *clbl1;
@property (strong, nonatomic) IBOutlet UILabel *clbl2;
@property (strong, nonatomic) IBOutlet UILabel *clbl3;
@property (strong, nonatomic) IBOutlet UILabel *clbl4;
@property (strong, nonatomic) IBOutlet UILabel *clbl5;
@property (strong, nonatomic) IBOutlet UILabel *clbl6;
@property (strong, nonatomic) IBOutlet UILabel *clbl7;

@property (strong, nonatomic) IBOutlet UILabel *clblV1;
@property (strong, nonatomic) IBOutlet UILabel *clblV2;
@property (strong, nonatomic) IBOutlet UILabel *clblV3;
@property (strong, nonatomic) IBOutlet UILabel *clblV4;
@property (strong, nonatomic) IBOutlet UILabel *clblV5;
@property (strong, nonatomic) IBOutlet UILabel *clblV6;
@property (strong, nonatomic) IBOutlet UILabel *clblV7;

@property (strong, nonatomic) IBOutlet UIButton *btncMap;
@property (strong, nonatomic) IBOutlet UIButton *btncPhone;
@property (strong, nonatomic) IBOutlet UIButton *btncSelect;
@property (strong, nonatomic) IBOutlet UIButton *btncAssign;
@property (strong, nonatomic) IBOutlet UIButton *btncDelete;

@property (strong, nonatomic) IBOutlet UIView *btncView;

@end

@interface ContactVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,
UIAlertViewDelegate>
{
    IBOutlet UIView *paginview;
    IBOutlet UILabel *lblTotalContacts;
    IBOutlet UISearchBar *txtContactSearch;
    IBOutlet UITableView *tblContacts;
    IBOutlet UILabel *lblTitle;
}
@property (strong, nonatomic) IBOutlet UILabel *lblinfo;
@property (strong, nonatomic) IBOutlet UIButton *btncPrev;
@property (strong, nonatomic) IBOutlet UIButton *btncNext;
@property (strong,nonatomic) NSString *cLastname;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

- (IBAction)contactSideBar:(id)sender;
- (IBAction)preContact:(id)sender;
- (IBAction)nextContact:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;


@end
