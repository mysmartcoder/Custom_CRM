//
//  ShortCutsDetailVC.h
//  CustomCRM
//
//  Created by NLS44-PC on 11/4/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ShortCutsDetailCell  : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;
@property (strong, nonatomic) IBOutlet UILabel *lbl7;


@property (strong, nonatomic) IBOutlet UILabel *lblV1;
@property (strong, nonatomic) IBOutlet UILabel *lblV2;
@property (strong, nonatomic) IBOutlet UILabel *lblV3;
@property (strong, nonatomic) IBOutlet UILabel *lblV4;
@property (strong, nonatomic) IBOutlet UILabel *lblV5;
@property (strong, nonatomic) IBOutlet UILabel *lblV6;
@property (strong, nonatomic) IBOutlet UILabel *lblV7;

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnAssign;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) IBOutlet UIView *btnView;


@end


@interface ShortCutsDetailVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblinfo;
@property (strong, nonatomic) IBOutlet UITableView *tblData;
@property (strong, nonatomic) IBOutlet UIView *paginfView;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnPrev;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalRecords;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIWebView *accWebview;

@property (nonatomic,strong)NSString *strSearchId;
@property (nonatomic,strong)NSString *strSearchType;
@property (nonatomic,strong)NSString *strSearchTitle;

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
@property (nonatomic,strong)NSMutableArray *arrPath;

@property (nonatomic,strong)NSMutableArray *arrKeyValue;
@property (nonatomic,strong)NSMutableArray *arrlblDictionary;
@property (nonatomic,strong)NSMutableArray *arrRecid_longPress;



- (IBAction)ShortcutSidebar:(id)sender;
- (IBAction)callNextRecord:(id)sender;
- (IBAction)callPrevRecord:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
