//
//  LibraryVC.h
//  CustomCRM
//
//  Created by NLS44-PC on 11/3/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LibraryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblItem;
@property (strong, nonatomic) IBOutlet UIButton *btnDownload;
@property (strong, nonatomic) IBOutlet UIButton *btndownload;

@end

@interface LibraryVC : UIViewController  <UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIView *viewLibraryDetail;
@property (strong, nonatomic) IBOutlet UIView *viewLibrary;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UITableView *tblLibraryData;

- (IBAction)slideMenu:(id)sender;
- (IBAction)btnLibrary:(id)sender;
- (IBAction)btnLibraryDown:(id)sender;
- (IBAction)historyTapped:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;

@end
