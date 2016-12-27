//
//  QuickSearchVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;

@property (strong, nonatomic) IBOutlet UILabel *lbl1;

@property (strong, nonatomic) IBOutlet UILabel *lbl2;

@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@end


@interface QuickSearchVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

- (IBAction)quickSideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *txtQuickSearch;
@property (strong, nonatomic) IBOutlet UITableView *tblQuickSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;


@end
