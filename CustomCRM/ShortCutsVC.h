//
//  ShortCutsVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZAccordionTableView.h"
#import "ShortCutsDetailVC.h"

@interface ShortcutCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblItem;
@property (strong, nonatomic) IBOutlet UIButton *btnDown;

// Background & text style

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@end

@interface ShortCutsVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
- (IBAction)shortcutMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblShortcut1;


// Background & text style

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelBG;
@end
