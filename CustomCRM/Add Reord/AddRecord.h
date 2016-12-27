//
//  AddRecord.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/12/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Static.h"
#import "Utility.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "AppDelegate.h"


@interface AddRecord : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UILabel *lblScreenTitle;
    IBOutlet UIScrollView *sclView;
    IBOutlet UIPickerView *pickerList;
    IBOutlet UIView *viewPicker;
    IBOutlet UILabel *lblPickerTitle;
    
    IBOutlet UITableView *tblSearch;
    IBOutlet UIView *viewSearch;
    IBOutlet NSLayoutConstraint *constSearchViewHeight;
}

@property (strong, nonatomic) NSString *lblTitle;
@property (strong, nonatomic) NSString *strRecord;



// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

- (IBAction)btnPickerDone:(id)sender;

- (IBAction)btnBack:(id)sender;

@end
