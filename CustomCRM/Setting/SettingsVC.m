//
//  SettingsVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "SettingsVC.h"
#import "MyAccounts.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "MyAccounts.h"
#import "SlideNavigationController.h"
#import "LoginVC.h"
#import "UIImageView+Letters.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"


@interface SettingsVC ()

@end

@implementation SettingsVC
{
    CustomIOSAlertView *passwordView;
    BOOL flag1 ;
    UIView *view1;
    NSString *strFonts,*strFontLbl;
    NSMutableArray *contactList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self setFontName];
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    
    self.lblUserName.numberOfLines = 2;
    self.lblUserName.text = [mDictionary1 objectForKey:@"UserName"];
    
    NSArray *arr = [Utility colorWithRGB:[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG]];
    [self.imgUser setImageWithString:self.lblUserName.text color:[UIColor colorWithRed:([arr[0] intValue]/255.0f) green:([arr[1] intValue]/255.0f) blue:([arr[2] intValue]/255.0f) alpha:1.000] circular:YES];
    
    [self viewChangePwd:YES];
    [self viewChangeURL:YES];
    [self viewChangeBG:YES];
    [self viewChangeFont:YES];
    STOPLOADING()
    [self setFonts_Background];
}

- (void)HideKeyboard{
    [self.txtVerifyPass resignFirstResponder];
    [self.txtNewPass resignFirstResponder];
    [self.txtCurPass resignFirstResponder];
    [self.txturl resignFirstResponder];
}

- (void)viewChangePwd:(BOOL)flag{
    [self HideKeyboard];
    if (flag) {
        self.blankView.hidden = YES;
        self.changePasswordView.hidden = YES;
    }
    else{
        self.txtCurPass.text = @"";
        self.txtNewPass.text = @"";
        self.txtVerifyPass.text = @"";
        self.blankView.hidden = NO;
        self.changePasswordView.hidden = NO;
    }
}

- (void)viewChangeURL:(BOOL)flag{
    [self HideKeyboard];
    if (flag) {
        self.blankView.hidden = YES;
        self.ChangeUrlView.hidden = YES;
        self.urlTypesView.hidden = YES;
    }
    else{
        self.lblUrlValue.text = [[NSUserDefaults standardUserDefaults] objectForKey:key_Main_URL];
        self.txturl.text = @"";
        self.txturl.hidden = YES;
        self.urlTypesView.hidden = YES;
        self.blankView.hidden = NO;
        self.ChangeUrlView.hidden = NO;
    }
}

- (void)viewChangeBG:(BOOL)flag{
    [self HideKeyboard];
    if (flag) {
        self.blankView.hidden = YES;
        self.viewChangeBackground.hidden = YES;
    }
    else{
        self.blankView.hidden = NO;
        self.viewChangeBackground.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                         }
                         completion:^(BOOL finished){
        }];
    }
}

- (void)viewChangeFont:(BOOL)flag{
    [self HideKeyboard];
    if (flag) {
        self.blankView.hidden = YES;
        self.fontView.hidden = YES;
        self.fontTypesView.hidden = YES;
    }
    else{
        
        self.blankView.hidden = NO;
        self.fontView.hidden = NO;
    }
}

-(void)setUpView
{
    if(!FONT_LABEL)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - Default" forKey:key_Font_Llb];
    }
    _txturl.hidden = YES;
    _blankView.frame = CGRectMake(0,660, WIDTH, HEIGHT+70);
    flag1 = 0;
    passwordView = [[CustomIOSAlertView alloc]init];
    _txtCurPass.delegate = self;
    _txtNewPass.delegate = self;
    _txtVerifyPass.delegate = self;
    self.navigationController.navigationBar.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (IBAction)settingSideBar:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];

}

- (IBAction)changePassword:(id)sender {
    [self viewChangePwd:NO];
//    [passwordView setContainerView:_changePasswordView];
//    [passwordView setUseMotionEffects:true];
//    [passwordView show];
}

- (IBAction)changeURL:(id)sender {
    [self viewChangeURL:NO];
}

- (IBAction)submitPassword:(id)sender {
    
    if([_txtCurPass.text isEqualToString:@""])
    {
      [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter current password"];
        return;
    }
    if([_txtNewPass.text isEqualToString:@""])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter new password"];
        return;
    }
    if([_txtVerifyPass.text isEqualToString:@""])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter verify password"];
        return;
    }
    
    if(![_txtCurPass.text isEqualToString:PWD])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Your current password is wrong"];
        return;
    }
    
    if(![_txtNewPass.text isEqualToString:_txtVerifyPass.text])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Your new password and verify password are not identical"];
        return;
    }
    
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"password":_txtNewPass.text},@{@"LogonID":LOGIN_ID}]];
    
    
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:CHANGE_PASSWORD arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild]  ;
//        doc = [rootDoctument childrenNamed:@"ChangePasswordResponse"]
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"ChangePasswordResponse"])
            {
              if ([[doc valueWithPath:@"ChangePasswordResult"] intValue]>0)
              {
                    flag1 = 1;
              }
              else
              {
                  flag1 = 0;

              }
            }
            if(flag1 > 0)
            {
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                                 message:@"Password has been changed successfully"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                
                
                [alert show];

                
            }

        }
    }];
    
     [passwordView close];
}

- (IBAction)changeFontStyle:(id)sender {

//    if(!FONT_LABEL)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - Default" forKey:key_Font_Llb];
//    }
//    [self setFonts];
//    [_ChangeUrlView removeFromSuperview];
//    _fontView.center = self.view.center;
//    [_blankView addSubview:_fontView];
//
//    [UIView animateWithDuration:0.3
//                          delay:0.1
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         self.blankView.frame = CGRectMake(0, 0, WIDTH,HEIGHT+70);
//                     }
//                     completion:^(BOOL finished){
//                     }];
//    
//        [self.view.window addSubview:_blankView];
    [self setFontName];
    [self viewChangeFont:NO];
}

- (void)setFontName{
    strFonts = [[NSUserDefaults standardUserDefaults] objectForKey:@"font"];
    if ([strFonts isEqualToString:@"Droid Serif"]) {
        strFontLbl = @"CustomCRM - DroidSerif-Regular";
        _lblFontType.text = strFontLbl;
    }
    else if ([strFonts isEqualToString:@"Open Sans"]) {
        strFontLbl = @"CustomCRM - Open-Sans";
        _lblFontType.text = strFontLbl;
    }
    else if ([strFonts isEqualToString:@"PT Sans Narrow"]) {
        strFontLbl = @"CustomCRM - PT-sans";
        _lblFontType.text = strFontLbl;
    }
    else if ([strFonts isEqualToString:@"Lora"]) {
        strFontLbl = @"CustomCRM - Lora-Regular";
        _lblFontType.text = strFontLbl;
    }
    else {
        strFontLbl = @"CustomCRM - Default";
        _lblFontType.text = strFontLbl;
        strFonts = @"Helvetica Neue";
    }
}

- (IBAction)btnSyncContact:(id)sender {
//    [self alert];
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
                    [self contactSync];
                else
                    [self getContactsWithAddressBook:addressBookRef];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:TRUE completion:nil];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
            [self contactSync];
        else
            [self getContactsWithAddressBook:addressBookRef];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
    }
}

- (void)contactSync{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusNotDetermined) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactPhoneNumbersKey,CNContactOrganizationNameKey,CNContactEmailAddressesKey,CNContactUrlAddressesKey, CNContactPostalAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone = @"";
                NSString *firstName = @"";
                NSString *lastName = @"";
                NSString *cell_phone = @"",*phone1 = @"";
                NSString *email = @"";
                NSString *company = @"";
                NSString *website = @"";
                CNPostalAddress *postalAddress;
                
                NSMutableArray *contactsArray = [[NSMutableArray alloc] init];
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    company = contact.organizationName;
                    int flag = 0;
                    
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            if (flag == 0) {
                                phone1 = phone;
                                flag++;
                            }
                            else{
                                cell_phone = phone;
                                break;
                            }
                        }
                    }
                    for (CNLabeledValue *label in contact.emailAddresses) {
                        email = [NSString stringWithFormat:@"%@",label.value];
                        if ([email length] > 0) {
                            break;
                        }
                    }
                    for (CNLabeledValue *label in contact.urlAddresses) {
                        website = [NSString stringWithFormat:@"%@",label.value];
                        if ([website length] > 0) {
                            break;
                        }
                    }
                    
                    for (CNLabeledValue *label in contact.postalAddresses) {
                        postalAddress = label.value;
                    }
                    
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: firstName,@"FirstName",lastName,@"LastName",phone1,@"Phone",cell_phone,@"Cell_Phone",email,@"Email",website,@"Website",company,@"Company",postalAddress.street,@"Address",postalAddress.city,@"City",postalAddress.state,@"State",postalAddress.postalCode,@"Zip",postalAddress.country,@"Country", nil];
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:personDict,@"TypeLeadData", nil];
                    [contactsArray addObject:dict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":LOGIN_ID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"LeadData":contactsArray}]];
                    
                    SHOWLOADING(@"Wait...")
                    
                    [BaseApplication executeRequestwithService:ADD_LEAD arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
                        NSError *err=[[NSError alloc] init];
                        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
                        
                        
                        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
                        
                        if (!rootDoctument)
                        {
                            //  _tblEvents.hidden = true;
                        }
                        else
                        {
                            int count = 0;
                            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeRECDNO"])
                            {
                                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                                {
                                    count++;
                                    flag1 = 1;
                                }
                                else
                                {
                                    flag1 = 0;
                                    
                                }
                            }
                            if(flag1 > 0)
                            {
                                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""                                                                                                 message:[NSString stringWithFormat:@"%d contact synchronous successfully",count]                                                                                                delegate:nil                                                                                       cancelButtonTitle:@"OK"                                                                                       otherButtonTitles: nil];
                                
                                [alert show];
                            }
                        }
                    }];
                    
                });
            }
        }
    }];
}

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName, company;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        company = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"FirstName"];
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:@"LastName"];
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", company] forKey:@"Company"];
        if (company == nil) {
            [dOfPerson setObject:@"" forKey:@"Company"];
        }
        if (firstName == nil) {
            [dOfPerson setObject:@"" forKey:@"FirstName"];
        }
        if (lastName == nil) {
            [dOfPerson setObject:@"" forKey:@"LastName"];
        }
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"Email"];
        }
        else
            [dOfPerson setObject:@"" forKey:@"Email"];
        
        //For Website
        ABMutableMultiValueRef website  = ABRecordCopyValue(ref, kABPersonURLProperty);
        if(ABMultiValueGetCount(website) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(website, 0) forKey:@"Website"];
        }
        else
            [dOfPerson setObject:@"" forKey:@"Website"];
        
        //For Phone number
        NSString* mobileLabel;
        int flag = 0;
        NSString *key = @"Phone";
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if (flag == 0) {
                key = @"Phone";
            }
            else{
                key = @"Cell_Phone";
            }
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key];
                flag++;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key];
                flag++;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneHomeFAXLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key];
                flag++;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneWorkFAXLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key];
                flag++;
            }
            if (flag > 2) {
                break;
            }
        }
        if (flag == 0) {
            [dOfPerson setObject:@"" forKey:@"Phone"];
            [dOfPerson setObject:@"" forKey:@"Cell_Phone"];
        }
        if (flag == 1) {
            [dOfPerson setObject:@"" forKey:@"Cell_Phone"];
        }
        
        ABMultiValueRef address =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonAddressProperty));
        for(CFIndex i = 0; i < ABMultiValueGetCount(address); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, i);
            if ([mobileLabel isEqualToString:(NSString*)kABPersonAddressStreetKey])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(address, i) forKey:@"Address"];
            }
            else
                [dOfPerson setObject:@"" forKey:@"Address"];
            if ([mobileLabel isEqualToString:(NSString*)kABPersonAddressZIPKey])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(address, i) forKey:@"Zip"];
            }
            else
                [dOfPerson setObject:@"" forKey:@"Zip"];
            
            if ([mobileLabel isEqualToString:(NSString*)kABPersonAddressCityKey])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(address, i) forKey:@"City"];
            }
            else
                [dOfPerson setObject:@"" forKey:@"City"];
            
            if ([mobileLabel isEqualToString:(NSString*)kABPersonAddressStateKey])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(address, i) forKey:@"State"];
            }
            else
                [dOfPerson setObject:@"" forKey:@"State"];
            
            if ([mobileLabel isEqualToString:(NSString*)kABPersonAddressCountryKey])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(address, i) forKey:@"Country"];
            }
            else
                [dOfPerson setObject:@"" forKey:@"Country"];
        }
        
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:dOfPerson,@"TypeLeadData", nil];
        [contactList addObject:dict];
    }
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":LOGIN_ID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"LeadData":contactList}]];
    
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:ADD_LEAD arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //  _tblEvents.hidden = true;
        }
        else
        {
            int count = 0;
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeRECDNO"])
            {
                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                {
                    count++;
                    flag1 = 1;
                }
                else
                {
                    flag1 = 0;
                    
                }
            }
            if(flag1 > 0)
            {
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""                                                                                                 message:[NSString stringWithFormat:@"%d contact synchronous successfully",count]                                                                                                delegate:nil                                                                                       cancelButtonTitle:@"OK"                                                                                       otherButtonTitles: nil];
                
                [alert show];
            }
        }
    }];

    NSLog(@"Contacts = %@",contactList);
   
}

- (void)alert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"In Pending" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnLogout:(id)sender {
    [self logout];
}

- (IBAction)btnFeedback:(id)sender {
    FeedbackVC *feedbackVC=(FeedbackVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackVC"];
    UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    [navcon pushViewController:feedbackVC animated:YES];
}

- (IBAction)btnShare:(id)sender {
    
    NSString *textToShare = @"Let me recommend you CustomCRM iPhone application:\n http://itunes.apple.com/us/app/apple-store/id827064038?mt=8";
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare,[NSURL URLWithString:@"http://itunes.apple.com/us/app/apple-store/id827064038?mt=8"]] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop]; //Exclude whichever aren't relevant
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)btnRate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=827064038&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"Button Index =%ld(long)",buttonIndex);
    
    if (buttonIndex == 0)
    {
        [self logout];
    }
}

- (void)logout{
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=index_logoff.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    webview.delegate = self;
    SHOWLOADING(@"Wait...");
    //            webview.hidden = YES;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];

}

-(void)webViewDidStartLoad:(UIWebView *)webView {
   // [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Your password has been changed successfully"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView removeFromSuperview];
    STOPLOADING();
    NSString *mainURL = MAIN_URL;
    NSString *color = VIEW_BACKGROUND;
    NSString *fontRegular = FONT_REGULAR;
    NSString *fontBold = FONT_BOLD;
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] setObject:fontBold forKey:@"font_bold"];
    [[NSUserDefaults standardUserDefaults] setObject:fontRegular forKey:@"font"];
    [[NSUserDefaults standardUserDefaults] setObject:color forKey:key_View_BG];
    
    [[NSUserDefaults standardUserDefaults]setValue:mainURL forKey:key_Main_URL];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    LoginVC *login=(LoginVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    //    [self.navigationController pushViewController:login animated:true];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [nav.navigationBar setHidden:YES];
    //    [(MyAppDelegate *)[[UIApplication sharedApplication] delegate] window]
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
    NSLog(@"finish");
}

//TextView

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveFonts:(id)sender {
//     [_fontView removeFromSuperview];
//    [UIView animateWithDuration:0.3
//                          delay:0.1
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         self.blankView.frame = CGRectMake(0, 660, WIDTH, HEIGHT+65);
//                     }
//                     completion:^(BOOL finished){
//                         if (finished)
//                             [self.blankView removeFromSuperview];
//                     }];
    [self viewChangeFont:YES];
    [[NSUserDefaults standardUserDefaults]setObject:strFonts forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"PT Sans Narrow-Bold" forKey:@"font_bold"];
    [[NSUserDefaults standardUserDefaults]setObject:strFontLbl forKey:key_Font_Llb];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideBarReload" object:self];
    [self setFonts_Background];

}

- (IBAction)cancelFonts:(id)sender {
    [self viewChangeFont:YES];
//    [UIView animateWithDuration:0.3
//                          delay:0.1
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         self.blankView.frame = CGRectMake(0, 660, WIDTH, HEIGHT+65);
//                     }
//                     completion:^(BOOL finished){
//                         if (finished)
//                             [self.blankView removeFromSuperview];
//                     }];
}

- (IBAction)fontLabelClicked:(id)sender {
    self.fontTypesView.hidden = NO;
//    [passwordView setContainerView:_fontTypesView];
//    [passwordView setUseMotionEffects:true];
//    [passwordView show];
    
}
- (IBAction)defaultFont:(id)sender {
//    [passwordView close];
    
//    [self viewChangeFont:YES];
    self.fontTypesView.hidden = YES;
    
    strFontLbl = @"CustomCRM - Default";
    strFonts = @"Helvetica Neue";
    _lblFontType.text = strFontLbl;
    _lblFontType.font = [UIFont fontWithName:strFonts size:FONT_Size_LABEL];
//    [[NSUserDefaults standardUserDefaults]setObject:@"Helvetica Neue" forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"Helvetica Neue-Bold" forKey:@"font_bold"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - Default" forKey:key_Font_Llb];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    [self setFonts];
    
}
- (IBAction)OpenFont:(id)sender {
//    [passwordView close];
//    [self viewChangeFont:YES];
    self.fontTypesView.hidden = YES;
//    [[NSUserDefaults standardUserDefaults]setObject:@"Open Sans" forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"Open Sans-Bold" forKey:@"font_bold"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self setFonts];

    strFontLbl = @"CustomCRM - Open-Sans";
    strFonts = @"Open Sans";
    _lblFontType.text = strFontLbl;
    _lblFontType.font = [UIFont fontWithName:strFonts size:FONT_Size_LABEL];
}

- (IBAction)LoraFonts:(id)sender {
//    [passwordView close];
//    [self viewChangeFont:YES];
    self.fontTypesView.hidden = YES;
//    [[NSUserDefaults standardUserDefaults]setObject:@"Lora" forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"Lora-Bold" forKey:@"font_bold"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - Lora-Regular" forKey:key_Font_Llb];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self setFonts];
    
    strFontLbl = @"CustomCRM - Lora-Regular";
    strFonts = @"Lora";
    _lblFontType.text = strFontLbl;
    _lblFontType.font = [UIFont fontWithName:strFonts size:FONT_Size_LABEL];
}

- (IBAction)PTFonts:(id)sender {
//    [passwordView close];
//    [self viewChangeFont:YES];
    self.fontTypesView.hidden = YES;
//    [[NSUserDefaults standardUserDefaults]setObject:@"PT Sans Narrow" forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"PT Sans Narrow-Bold" forKey:@"font_bold"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - PT-sans" forKey:key_Font_Llb];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self setFonts];

    strFontLbl = @"CustomCRM - PT-sans";
    strFonts = @"PT Sans Narrow";
    _lblFontType.text = strFontLbl;
    _lblFontType.font = [UIFont fontWithName:strFonts size:FONT_Size_LABEL];
}
- (IBAction)DroidSerifFonts:(id)sender {
//    [passwordView close];
//    [self viewChangeFont:YES];
    self.fontTypesView.hidden = YES;
//    [[NSUserDefaults standardUserDefaults]setObject:@"PT Sans Narrow" forKey:@"font"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"PT Sans Narrow-Bold" forKey:@"font_bold"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"CustomCRM - DroidSerif-Regular" forKey:key_Font_Llb];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self setFonts];

    strFontLbl = @"CustomCRM - DroidSerif-Regular";
    strFonts = @"Droid Serif";
    _lblFontType.text = strFontLbl;
    _lblFontType.font = [UIFont fontWithName:strFonts size:FONT_Size_LABEL];
}

-(void)setFonts_Background
{
    [[AppDelegate initAppdelegate] setTabbarBG];
    _lblFontType.text = FONT_LABEL;
    _lblFontType.font = SET_FONTS_REGULAR;
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_BUTTON;
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.labelTitle.count; i++) {
        UILabel *lbl = [self.labelTitle objectAtIndex:i];
        lbl.font = [SET_FONTS_REGULAR fontWithSize:20];
    }
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lblBG.count; i++) {
        UILabel *lbl = [self.lblBG objectAtIndex:i];
        lbl.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.btnBG.count; i++) {
        UIButton *btn = [self.btnBG objectAtIndex:i];
        btn.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.txtBG.count; i++) {
        UITextField *txt = [self.txtBG objectAtIndex:i];
        txt.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }

}

- (IBAction)urlValueClicked:(id)sender {
    _lblApp.text = @"{Production_URL}";
    self.urlTypesView.hidden = NO;
    self.txturl.hidden = YES;
}

- (IBAction)SaveURL:(id)sender {
    [_txturl resignFirstResponder];
    NSString *str;
    if ([_lblUrlValue.text isEqualToString:@"Other"]) {
        str = _txturl.text;
    } else {
        str = _lblUrlValue.text;
    }
    [[NSUserDefaults standardUserDefaults]setValue:str forKey:key_Main_URL];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self viewChangeURL:YES];
}

- (IBAction)CancelUrlClicked:(id)sender {
    [self viewChangeURL:YES];
}

- (IBAction)btnPickColor:(id)sender {
    SHOWLOADING(@"wait...");
    NSString *hashColor;
    if ([sender tag] == 8) {
        hashColor = @"A133B5";
    }
    else if ([sender tag] == 1) {
        hashColor = @"FC653C";
    }
    else if ([sender tag] == 2) {
        hashColor = @"FBA121";
    }
    else if ([sender tag] == 3) {
        hashColor = @"545FBB";
    }
    else if ([sender tag] == 4) {
        hashColor = @"61BA62";
    }
    else if ([sender tag] == 5) {
        hashColor = @"D1E350";
    }
    else if ([sender tag] == 6) {
        hashColor = @"EB4649";
    }
    else if ([sender tag] == 7) {
        hashColor = @"E72E72";
    }
    else{
        hashColor = @"09469A";
    }
    [[NSUserDefaults standardUserDefaults] setObject:hashColor forKey:key_View_BG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideBarReload" object:self];
    [self viewChangeBG:YES];
    [self viewWillAppear:YES];
}

- (IBAction)btnChangeBG:(id)sender {
    [self viewChangeBG:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch ;
    touch = [[event allTouches] anyObject];
    if ([touch view] == _blankView  )
    {
        [self HideKeyboard];
        [self viewChangePwd:YES];
        [self viewChangeURL:YES];
        [self viewChangeBG:YES];
        [self viewChangeFont:YES];
    }
}
- (IBAction)urlSelect:(id)sender {
    int flag = 0;
    
    if ([sender tag] == 0) {
//        app
        _lblApp.text = @"{Production_URL}";
        flag = 1;
    }
    else if ([sender tag] == 1) {
        //        dev
        _lblApp.text = @"{Dev_URL}";
        flag = 1;
    }
    else if ([sender tag] == 2) {
        //        qr
        _lblApp.text = @"{QA_URL}";
        flag = 1;
    }
    else if ([sender tag] == 3) {
        //        other
        _lblUrlValue.text = @"Other";
        _txturl.hidden = NO;
    }
    if (flag) {
        _lblUrlValue.text = _lblApp.text;
        _txturl.hidden = YES;
    }
    self.urlTypesView.hidden = YES;
}


@end
