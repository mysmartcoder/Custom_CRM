//
//  RecentItemsVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblItem;

@end

@interface RecentItemsVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
- (IBAction)RecentItemMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblRecentItems;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;

@end
