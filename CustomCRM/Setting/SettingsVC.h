//
//  SettingsVC.h
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "LeftMenuViewController.h"
#import "FeedbackVC.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface SettingsVC : UIViewController <UITextFieldDelegate,UIWebViewDelegate,UIAlertViewDelegate>



@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
- (IBAction)settingSideBar:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)changeURL:(id)sender;
- (IBAction)changeFontStyle:(id)sender;
- (IBAction)btnSyncContact:(id)sender;
- (IBAction)btnLogout:(id)sender;
- (IBAction)btnFeedback:(id)sender;
- (IBAction)btnShare:(id)sender;
- (IBAction)btnRate:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *btnRate;


//Change PAssword

@property (strong, nonatomic) IBOutlet UIView *changePasswordView;
@property (strong, nonatomic) IBOutlet UITextField *txtCurPass;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPass;
@property (strong, nonatomic) IBOutlet UITextField *txtVerifyPass;
- (IBAction)submitPassword:(id)sender;



//Change Font

@property (strong, nonatomic) IBOutlet UILabel *lblFontType;
- (IBAction)saveFonts:(id)sender;
- (IBAction)cancelFonts:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *fontView;
- (IBAction)fontLabelClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveFonts;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelFonts;

//Font Types
@property (strong, nonatomic) IBOutlet UIView *fontTypesView;
- (IBAction)defaultFont:(id)sender;
- (IBAction)OpenFont:(id)sender;
- (IBAction)PTFonts:(id)sender;
- (IBAction)LoraFonts:(id)sender;
- (IBAction)DroidSerifFonts:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbldefaultFonts;
@property (strong, nonatomic) IBOutlet UILabel *lblOpensansFonts;
@property (strong, nonatomic) IBOutlet UILabel *lblPTFonts;
@property (strong, nonatomic) IBOutlet UILabel *lblLoraFonts;
@property (strong, nonatomic) IBOutlet UILabel *lblDroidSerifFonts;
@property (strong, nonatomic) IBOutlet UIView *blankView;

//Change URL
@property (strong, nonatomic) IBOutlet UIView *ChangeUrlView;
@property (strong, nonatomic) IBOutlet UILabel *lblUrlValue;
- (IBAction)urlValueClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txturl;
- (IBAction)SaveURL:(id)sender;
- (IBAction)CancelUrlClicked:(id)sender;

//URL options
@property (strong, nonatomic) IBOutlet UIView *urlTypesView;
@property (strong, nonatomic) IBOutlet UILabel *lblApp;
@property (strong, nonatomic) IBOutlet UILabel *lblDev;
@property (strong, nonatomic) IBOutlet UILabel *lblQa;
@property (strong, nonatomic) IBOutlet UILabel *lblOther;
- (IBAction)urlSelect:(id)sender;



// Change Background
@property (strong, nonatomic) IBOutlet UIView *viewChangeBackground;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewColor;
- (IBAction)btnPickColor:(id)sender;
- (IBAction)btnChangeBG:(id)sender;


// Set Font - Style Object
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelTitle;


// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtBG;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnBG;


@end
