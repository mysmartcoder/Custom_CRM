//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LibraryVC.h"
#import "AddRecord.h"

@interface MenuTabCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblImage;
@property (strong, nonatomic) IBOutlet UILabel *lblCallback;

@property (strong, nonatomic) IBOutlet UILabel *lblItem;
@property (strong, nonatomic) IBOutlet UILabel *lblTop;
@property (strong, nonatomic) IBOutlet UILabel *lblBottom;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnDetail;
- (IBAction)addClicked:(id)sender;

@end


@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SlideNavigationControllerDelegate, UIWebViewDelegate>{
    NSMutableArray *addValueArray;
    
    NSMutableArray *addValueTmpArray;
    int accCount,caseCount,oppCount,conCount,queteCount;
    NSInteger numberOfRowsInLastSection,numberOfSections;
    UIWebView *webview;
    
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@property (nonatomic, strong) NSMutableArray *arrMenu;
@property (nonatomic, strong) NSMutableArray *arrImages;
@property (nonatomic, strong) NSMutableArray *arrKey;
@property (nonatomic, strong) NSMutableArray *arrValue;
@property (nonatomic, strong) NSMutableDictionary *dictLabel;
@property (nonatomic, strong) NSMutableDictionary *dictPriv;

@property (nonatomic, strong) NSMutableArray *arrSortLable;



@property (nonatomic, strong) NSMutableArray *privillageArray;
@property (nonatomic, strong) NSMutableArray *displayLblArray;

@property (nonatomic, strong) NSMutableArray *tblDataArray;

@end
