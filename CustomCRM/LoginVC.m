//
//  ViewController.m
//  CustomCRM
//
//  Created by Pinal Panchani on 12/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "DatabaseVC.h"
#import "HomeVC.h"
#import "Toast/UIView+Toast.h"

@interface LoginVC ()

@end


@implementation LoginVC

@synthesize webData;
@synthesize nodeContent;
@synthesize finaldata;
@synthesize responseArrayTmp,responseArrayTmp1,showPassImgView;

BOOL isDatabase;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([LoginStatus isEqualToString:@"Yes"])
    {
        [[AppDelegate initAppdelegate] setUpTab];
        
    }
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"Color: %@",VIEW_BACKGROUND);
    if (VIEW_BACKGROUND == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"09469A" forKey:key_View_BG];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.viewBG.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [self setFonts_Background];
}

-(void)setUpView
{
//    _txtUsername.text = @"chirag.aspdeveloper@gmail.com";
//    _txtPassword.text = @"testchirag";
//    _txtUsername.text = @"alan@gmail.com";
//    _txtPassword.text = @"alan2";
    
//    _txtUsername.text = @"superadmin";
//    _txtPassword.text = @"king4rad";

//    _txtUsername.text = @"AccmgrWonderCity@AccmgrWonderCity.com";
//    _txtPassword.text = @"AccmgrWonderCity";
    
    _txtPassword.delegate = self;
    _txtUsername.delegate = self;
    
    _lblCopyright.lineBreakMode = NSLineBreakByWordWrapping;
    _lblCopyright.numberOfLines = 0;
    _lblCopyright.textAlignment = NSTextAlignmentCenter;
    _lblCopyright.text = @"Copyright © 2016 CustomCRM \n Version 3.0";
    
    
//    [_lblCopyright setFont:SET_FONTS_REGULAR];
    _lblLoginHeading.text = @"Login To CustomCRM";
//    [_lblLoginHeading setFont:SET_FONTS_BIG];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [showPassImgView addGestureRecognizer:tapRecognizer];
    [self setFonts_Background];
}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_BUTTON;
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.txtfield.count; i++) {
        UITextField *txt = [self.txtfield objectAtIndex:i];
        txt.font = SET_FONTS_BOLD;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    if (self.txtPassword.secureTextEntry) {
        self.txtPassword.secureTextEntry = NO;
    }else{
        self.txtPassword.secureTextEntry = YES;
    }
    
}
- (IBAction)userLogin:(id)sender
{
    //[self performSegueWithIdentifier:@"segue" sender:uide];

    if([_txtUsername.text isEqualToString:@"" ])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter username"];
        return;
    }
    if ([_txtPassword.text isEqualToString:@""])
    {
        [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Please enter password"];
        return;
    }
    
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:@[@{@"username":_txtUsername.text},@{@"pwd":_txtPassword.text}]];
    SHOWLOADING(@"Verifying...");
    
    [BaseApplication executeRequestwithService:LOGIN arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
    NSError *err=[[NSError alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
    
    
    NSMutableArray *responseArray=[[NSMutableArray alloc]init];
    SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
       
    
    for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLogonData"])
    {
        NSString *isbn = [doc valueWithPath:@"LogonID"]; // XML attribute
        NSString *title = [doc valueWithPath:@"UserName"]; // child node value
        NSMutableDictionary *responseDataDic=[[NSMutableDictionary alloc]init];
        [responseDataDic setValue:isbn forKey:@"LogonID"];
        [responseDataDic setValue:title forKey:@"UserName"];
        [responseArray  addObject:responseDataDic];
    }
//        NSLog(@"Arr : %@",[responseArray objectAtIndex:0]);
        if(responseArray.count >0){
            
            [[NSUserDefaults standardUserDefaults]setObject:[responseArray objectAtIndex:0] forKey:@"loginID"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseArray objectAtIndex:0] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:_txtPassword.text forKey:Key_PASSWORD];
            [[NSUserDefaults standardUserDefaults]setObject:_txtUsername.text forKey:Key_UserID];
            
            //Main URL
            
//            [[NSUserDefaults standardUserDefaults]setValue:@"{Production_URL}" forKey:key_Main_URL];
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:key_Main_URL])
            {
                NSLog(@"URL : %@",MAIN_URL);
                //    [[NSUserDefaults standardUserDefaults]setValue:@"{Dev_URL}" forKey:key_Main_URL];
                //    [[NSUserDefaults standardUserDefaults]synchronize];
                
            }
            else
            {
//                [[NSUserDefaults standardUserDefaults]setValue:@"https://qa.CustomCRM.com" forKey:key_Main_URL];
//                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults] setValue:@"{Production_URL}" forKey:key_Main_URL];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }

            
            NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
            [[NSUserDefaults standardUserDefaults]setObject:[mDictionary1 objectForKey:@"LogonID"] forKey:key_LOGIN_ID];
            
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
                        
            if ([[NSUserDefaults standardUserDefaults]objectForKey:key_LOGIN_ID])
            {
                if(![[[NSUserDefaults standardUserDefaults]objectForKey:key_LOGIN_ID] isEqualToString:@"0"])
                    
                    [self CheckDbCountService];
                else
                    [BaseApplication showAlertWithTitle:@"CustomCRM" withMessage:@"Incorrect username or password"];
            }else{
                STOPLOADING()
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
        else
        {
            [self.view makeToast:@"No internet connection"
                        duration:3.0
                        position:CSToastPositionCenter];
            STOPLOADING();

        }
        
    }];
}

-(void)CheckDbCountService{
    // Check for DB count
    NSMutableDictionary *mDictionary = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":[mDictionary objectForKey:@"LogonID"]}]];
    [BaseApplication executeRequestwithService:GETDB arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        responseArrayTmp=[[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeDataBaseData"])
        {
            NSString *isbn = [doc valueWithPath:@"DatabaseID"]; // XML attribute
            NSString *title = [doc valueWithPath:@"DatabaseName"]; // child node value
            NSMutableDictionary *responseDataDic=[[NSMutableDictionary alloc]init];
            [responseDataDic setValue:isbn forKey:@"DatabaseID"];
            [responseDataDic setValue:title forKey:@"DatabaseName"];
            [responseArrayTmp  addObject:responseDataDic];
        }
        // Delay execution of my block for 10 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            if (responseArrayTmp.count > 1)
            {
                STOPLOADING()
                isDatabase = true;
                DatabaseVC *dbvc=(DatabaseVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"DatabaseVC"];
                dbvc.isDb = isDatabase;
                dbvc.arrDB = [responseArrayTmp mutableCopy];
                [self.navigationController pushViewController:dbvc animated:true];
            }else if (responseArrayTmp.count==1) {
                isDatabase = false;
                [self serviceforWorkgroup];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        });

    }];
}
-(void)serviceforWorkgroup{
    // Check for DB count

    NSString *mDictionary = [[responseArrayTmp firstObject] objectForKey:@"DatabaseID"];
    [[NSUserDefaults standardUserDefaults]setObject:mDictionary forKey:@"DatabaseID"];

    if (!mDictionary) {
        STOPLOADING()
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":[mDictionary1 objectForKey:@"LogonID"]},@{@"database_id":mDictionary}]];
    SHOWLOADING(@"Verifying...");
    
    [BaseApplication executeRequestwithService:GETWGROUP arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        responseArrayTmp=[[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeWorkgroupData"])
        {
            NSString *isbn = [doc valueWithPath:@"WorkgroupID"]; // XML attribute
            NSString *title = [doc valueWithPath:@"WorkgroupName"]; // child node value
            NSMutableDictionary *responseDataDic=[[NSMutableDictionary alloc]init];
            [responseDataDic setValue:isbn forKey:@"WorkgroupID"];
            [responseDataDic setValue:title forKey:@"WorkgroupName"];
            [responseArrayTmp  addObject:responseDataDic];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            STOPLOADING()

            if (responseArrayTmp.count > 1)
            {
                DatabaseVC *dbvc=(DatabaseVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"DatabaseVC"];
                dbvc.isDb = false;
                dbvc.arrDB = [responseArrayTmp mutableCopy];
                [self.navigationController pushViewController:dbvc animated:true];
            }else if (responseArrayTmp.count==1) {
                [[NSUserDefaults standardUserDefaults]setObject:[[responseArrayTmp firstObject] objectForKey:@"WorkgroupID"] forKey:WG_ID];
                [[NSUserDefaults standardUserDefaults]setObject:[[responseArrayTmp firstObject] objectForKey:@"WorkgroupName"] forKey:WG_NAME];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:Key_LoginStatus];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[AppDelegate initAppdelegate] setUpTab];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
        });

    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
