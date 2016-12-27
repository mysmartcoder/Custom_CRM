//
//  DatabaseVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatabaseVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (strong, nonatomic) IBOutlet UILabel *lblDBheading;
@property (strong, nonatomic) IBOutlet UIButton *btnDatabase;
@property (strong, nonatomic) IBOutlet UILabel *lbldbCopyright;

@property (strong, nonatomic) IBOutlet UITableView *tblDB;
@property (strong, nonatomic) IBOutlet UIView *tableView;

@property (strong, nonatomic) NSMutableArray *arrDB;
@property BOOL isDb;

- (IBAction)selectDB:(id)sender;

// set background & font style
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
