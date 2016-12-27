//
//  SearchVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController <UISearchBarDelegate>

- (IBAction)openForMatch:(id)sender;

- (IBAction)openAdvanceSearch:(id)sender;

- (IBAction)openMap:(id)sender;

- (IBAction)openQuickSearch:(id)sender;

- (IBAction)searchMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;

@property (strong, nonatomic) IBOutlet UIView *pagingView;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
