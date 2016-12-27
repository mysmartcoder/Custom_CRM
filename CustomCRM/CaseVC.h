//
//  CaseVC.h
//  CustomCRM
//
//  Created by NLS42-MAC on 04/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CaseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;
@property (strong, nonatomic) IBOutlet UILabel *lbl7;
@property (strong, nonatomic) IBOutlet UILabel *lbl8;


@property (strong, nonatomic) IBOutlet UILabel *lblV1;
@property (strong, nonatomic) IBOutlet UILabel *lblV2;
@property (strong, nonatomic) IBOutlet UILabel *lblV3;
@property (strong, nonatomic) IBOutlet UILabel *lblV4;
@property (strong, nonatomic) IBOutlet UILabel *lblV5;
@property (strong, nonatomic) IBOutlet UILabel *lblV6;
@property (strong, nonatomic) IBOutlet UILabel *lblV7;
@property (strong, nonatomic) IBOutlet UILabel *lblv8;

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnAssign;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) IBOutlet UIView *btnView;


@end

@interface CaseVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,
UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic,strong)NSString *strSearch;
@property (strong, nonatomic) IBOutlet UILabel *lblinfo;

@property (nonatomic,strong)NSMutableArray *arrEnter;
@property (nonatomic,strong)NSMutableArray *arrCompany;
@property (nonatomic,strong)NSMutableArray *arrLeadStatus;
@property (nonatomic,strong)NSMutableArray *arrLeadSource;
@property (nonatomic,strong)NSMutableArray *arrCampaign;
@property (nonatomic,strong)NSMutableArray *arrPhone;
@property (nonatomic,strong)NSMutableArray *arrAccManager;
@property (nonatomic,strong)NSMutableArray *arrRecordNo;
@property (nonatomic,strong)NSMutableArray *arrDisplayLbl;
@property (nonatomic,strong)NSMutableArray *arrLat;
@property (nonatomic,strong)NSMutableArray *arrLong;

@property (nonatomic,strong)NSMutableArray *arrCaseID;

@property (nonatomic,strong)NSMutableArray *arrKeyValue;
@property (nonatomic,strong)NSMutableArray *arrlblDictionary;
@property (nonatomic,strong)NSMutableArray *arrRecid_longPress;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;


@property (strong, nonatomic) IBOutlet UITableView *tblAccountData;
@property (strong, nonatomic) IBOutlet UIWebView *accWebview;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearch;
//@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalRecords;
- (IBAction)AccountSidebar:(id)sender;
- (IBAction)callNextRecord:(id)sender;
- (IBAction)callPrevRecord:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)caseSideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPrev;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
