//
//  DatabaseVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "DatabaseVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "HomeVC.h"
@interface DatabaseVC ()

@end

@implementation DatabaseVC

@synthesize  arrDB;
@synthesize isDb;

CustomIOSAlertView *alert;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setFonts_Background];
}
-(void)setUpView
{
    alert = [[CustomIOSAlertView alloc]init];
    if (isDb) {
        [_btnDatabase setTitle:@"-- Select Database --" forState:UIControlStateNormal];
    }else{
        [_btnDatabase setTitle:@"-- Select WorkGroup --" forState:UIControlStateNormal];
        _lblDBheading.text = @"Select WorkGroup";
    }
    _lbldbCopyright.lineBreakMode = NSLineBreakByWordWrapping;
    _lbldbCopyright.numberOfLines = 0;
    _lbldbCopyright.textAlignment = NSTextAlignmentCenter;
    _lbldbCopyright.text = @"Copyright © 2016 CustomCRM \n Version 3.0";
    [_lbldbCopyright setFont:SET_FONTS_REGULAR];
    _lblDBheading.text = @"Select Database";
    [_lblDBheading setFont:SET_FONTS_BIG];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDB.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dictionary = [arrDB objectAtIndex:indexPath.row];
       if (cell == nil)
       {
           
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
       }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(isDb)
                cell.textLabel.text = [dictionary objectForKey:@"DatabaseName"];
            else
            {
                cell.textLabel.text = [dictionary objectForKey:@"WorkgroupName"];
            }
        }
    cell.textLabel.font = SET_FONTS_REGULAR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isDb)
    {
        [_btnDatabase setTitle:[[arrDB objectAtIndex:indexPath.row]objectForKey:@"DatabaseName"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults]setObject:[[arrDB objectAtIndex:indexPath.row]objectForKey:@"DatabaseID"] forKey:@"DatabaseID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [alert close];

        [self callService];
    }
    else
    {
        [_btnDatabase setTitle:[[arrDB objectAtIndex:indexPath.row]objectForKey:@"WorkgroupName"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults]setObject:[[arrDB objectAtIndex:indexPath.row]objectForKey:@"WorkgroupID"] forKey:WG_ID];
        [[NSUserDefaults standardUserDefaults]setObject:[[arrDB objectAtIndex:indexPath.row] objectForKey:@"WorkgroupName"] forKey:WG_NAME];
        [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:Key_LoginStatus];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[AppDelegate initAppdelegate] setUpTab];
    }
    [alert close];
}
-(void)callService{
    // Check for DB count
    NSString *mDictionary = [[NSUserDefaults standardUserDefaults]objectForKey:@"DatabaseID"];
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"logon_id":[mDictionary1 objectForKey:@"LogonID"]},@{@"database_id":mDictionary}]];
    SHOWLOADING(@"Verifying...");
    
    [BaseApplication executeRequestwithService:GETWGROUP arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
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
          
            if (responseArrayTmp.count > 1)
            {
                isDb = false;
                arrDB = [responseArrayTmp mutableCopy];
                [_btnDatabase setTitle:@"-- Select WorkGroup --" forState:UIControlStateNormal];
                _lblDBheading.text = @"Select WorkGroup";
                [_tblDB reloadData];
                [alert setContainerView:_tableView];
//                [alert setUseMotionEffects:true];
//                [alert show];
            }else if (responseArrayTmp.count==1) {
                [[NSUserDefaults standardUserDefaults]setObject:[[responseArrayTmp firstObject] objectForKey:@"WorkgroupID"] forKey:WG_ID];
                [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:Key_LoginStatus];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[AppDelegate initAppdelegate] setUpTab];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
        });
        
    }];

    
}

- (IBAction)selectDB:(id)sender
{
    
    [alert setContainerView:_tableView];
    [alert setUseMotionEffects:true];
    [alert show];

}

 #pragma mark - Navigation
//
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
// 
//    
//}

-(void)setFonts_Background
{
    self.viewBG.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_BUTTON;
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
}
@end
