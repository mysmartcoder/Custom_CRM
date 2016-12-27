//
//  CallBackTasks.h
//  CustomCRM
//
//  Created by Pinal Panchani on 08/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBackCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPlus;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnCalender;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lblv1;
@property (strong, nonatomic) IBOutlet UILabel *lblv2;
@property (strong, nonatomic) IBOutlet UILabel *lblv3;
@property (strong, nonatomic) IBOutlet UILabel *lblv4;
@property (strong, nonatomic) IBOutlet UILabel *lblv5;
@property (strong, nonatomic) IBOutlet UIButton *btnv3;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UIButton *btnOpen;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constBtnTop;

@end


@interface CallBackTasks : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblinfo;

- (IBAction)callBackMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *txtCallBackSearch;
@property (strong, nonatomic) IBOutlet UITableView *tblCallBacks;
@property (strong, nonatomic) IBOutlet UIView *pagingView;
- (IBAction)btnNext:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *callBackCount;
- (IBAction)btnPrevious:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIButton *prev;

@property (strong, nonatomic) NSString *strCallback;
    //Status View


- (IBAction)btnOpenTapped:(id)sender;
- (IBAction)btnClosedTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;


@end
