//
//  CheckForMatch.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;

@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;

@property (strong, nonatomic) IBOutlet UIButton *btnWeb;
@property (strong, nonatomic) IBOutlet UILabel *lblAcc;
@property (strong, nonatomic) IBOutlet UILabel *lblCon;


@end


@interface CheckForMatch : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
- (IBAction)searchData:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

@property (strong, nonatomic) IBOutlet UITextView *txtCompany;
@property (strong, nonatomic) IBOutlet UITextView *txtEmail;
@property (strong, nonatomic) IBOutlet UITextView *txtLastName;
@property (strong, nonatomic) IBOutlet UITextView *txtAdress;
@property (strong, nonatomic) IBOutlet UIView *pagingView;
- (IBAction)previous:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIButton *btnPrev;
- (IBAction)next:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)matchMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITableView *tblMatch;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
