//
//  ShortCutsVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "ShortCutsVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "MyAccounts.h"
#import "SlideNavigationController.h"
#import "FZAccordionTableView.h"
#import "WebviewVC.h"

@implementation ShortcutCell
-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        for (int i = 0 ; i < self.lable.count; i++) {
            UILabel *lbl = [self.lable objectAtIndex:i];
            lbl.font = SET_FONTS_REGULAR;
        }
    }
    return self;
}
@end

@interface ShortCutsVC ()
{
    UIWebView *cWebview;
    NSMutableArray *arrKey,*arrValue,*arrTblData,*arrSection;
    NSMutableArray *arrRecords,*arrOpp,*arrContacts,*arrCase,*arrReports;
    NSMutableArray *arrRecordsVal,*arrOppVal,*arrContactsVal,*arrCaseVal,*arrReportsVal;
    NSMutableArray *tmpArrRecordsVal,*tmpArrOppVal,*tmpArrContactsVal,*tmpArrCaseVal,*tmpArrReportsVal;
     NSString *strSearchId, *strSearchType, *strSearchTitle;
    UILabel *messageLabel;
}
@end

@implementation ShortCutsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}


-(void)setUpView
{
    arrKey = [[NSMutableArray alloc] init];
    arrValue = [[NSMutableArray alloc] init];
    arrValue = [[NSMutableArray alloc] init];
    arrRecords = [[NSMutableArray alloc] init];
    arrOpp = [[NSMutableArray alloc] init];
    arrContacts = [[NSMutableArray alloc] init];
    arrCase = [[NSMutableArray alloc] init];
    arrReports =[[NSMutableArray alloc] init];
    
    arrRecordsVal = [[NSMutableArray alloc] init];
    arrOppVal = [[NSMutableArray alloc] init];
    arrContactsVal = [[NSMutableArray alloc] init];
    arrCaseVal = [[NSMutableArray alloc] init];
    arrReportsVal =[[NSMutableArray alloc] init];
    
    arrSection = [[NSMutableArray alloc] init];
        
    tmpArrRecordsVal = [[NSMutableArray alloc] init];
    tmpArrOppVal = [[NSMutableArray alloc] init];
    tmpArrContactsVal = [[NSMutableArray alloc] init];
    tmpArrCaseVal = [[NSMutableArray alloc] init];
    tmpArrReportsVal =[[NSMutableArray alloc] init];
    
    [arrRecordsVal addObject:@"Records"];
    [arrOppVal addObject:@"Opportunity"];
    [arrContactsVal addObject:@"Contacts"];
    [arrCaseVal addObject:@"Case"];
    [arrReportsVal addObject:@"Reports"];
    
    arrTblData = [[NSMutableArray alloc] init];
    
//    arrTblData = [[NSMutableArray alloc] initWithObjects:@[@"Records"],@[@"Opportunity"],@[@"Contacts"],@[@"Case"],@[@"Reports"],nil];
    
    [self serviceForShortcutItems];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        [self serviceForReportsItems];
        STOPLOADING();
    });
    
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (cWebview) {
        [cWebview removeFromSuperview];
    }
    [self setFonts_Background];
}

-(void)removeView
{
    if (cWebview) {
        [cWebview removeFromSuperview];
    }
}

//call for REcent Items


-(void)serviceForShortcutItems{
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:MY_SEARCH arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        arrKey = [[NSMutableArray alloc]init];
        arrValue = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
//            _tblShortcut1.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
            {
                
                if([doc valueWithPath:@"Key"]&&[doc valueWithPath:@"Value"])
                {
                    NSString *str = [[doc valueWithPath:@"Key"] substringWithRange:NSMakeRange(0, 2)];
                    NSString *strkey = [doc valueWithPath:@"Key"] ;
                    strkey = [strkey stringByReplacingOccurrencesOfString:@"00:" withString:@""];
                    strkey = [strkey stringByReplacingOccurrencesOfString:@"11:" withString:@""];
                    strkey = [strkey stringByReplacingOccurrencesOfString:@"22:" withString:@""];
                    strkey = [strkey stringByReplacingOccurrencesOfString:@"33:" withString:@""];
                    strkey = [strkey stringByReplacingOccurrencesOfString:@"44:" withString:@""];
                    NSString *strVal = [doc valueWithPath:@"Value"];
                    
                    if([str isEqualToString:@"00"])
                    {
                        [arrRecords addObject:strkey];
                        [arrRecordsVal addObject:strVal];
                        [tmpArrRecordsVal addObject:strVal];
                        
                    }
                    else if([str isEqualToString:@"11"])
                    {
                        [arrOpp addObject:strkey];
                        [arrOppVal addObject:strVal];
                        [tmpArrOppVal addObject:strVal];
                                            }
                    
                    else if([str isEqualToString:@"22"])
                    {
                        [arrContacts addObject:strkey];
                        [arrContactsVal addObject:strVal];
                        [tmpArrContactsVal addObject:strVal];
                        
                    }
                    
                    else if([str isEqualToString:@"33"])
                    {
                        [arrCase addObject:strkey];
                        [arrCaseVal addObject:strVal];
                        [tmpArrCaseVal addObject:strVal];
                        
                    }
                    
//                    else
//                    {
//                        [arrReports addObject:strkey];
//                        [arrReportsVal addObject:strVal];
//                        [tmpArrReportsVal addObject:strVal];
//                        
//                    }
//                    
                    
                }
                
            }
            NSLog(@"%ld", (unsigned long)arrTblData.count);
            NSLog(@"%@", arrTblData);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                STOPLOADING();
            });
            
        }
        
    }];
}

-(void)serviceForReportsItems{
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:MY_SHORTCUT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        arrKey = [[NSMutableArray alloc]init];
        arrValue = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
//            _tblShortcut1.hidden = true;
        }
        else
        {
            
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
            {
                
                if([doc valueWithPath:@"Key"]&&[doc valueWithPath:@"Value"])
                {
                    NSArray *substrings = [[doc valueWithPath:@"Key"] componentsSeparatedByString:@" "];
                    NSString *str = [substrings objectAtIndex:0];
                    NSString *strkey = [doc valueWithPath:@"Value"];
                    NSString *strVal = [doc valueWithPath:@"Key"];
                    
                    if([str isEqualToString:@"Records"])
                    {
                        [arrRecords addObject:strkey];
                        [arrRecordsVal addObject:strVal];
                        [tmpArrRecordsVal addObject:strVal];
                        
                    }
                    else if([str isEqualToString:@"Opportunity"])
                    {
                        [arrOpp addObject:strkey];
                        [arrOppVal addObject:strVal];
                        [tmpArrOppVal addObject:strVal];
                    }
                    
                    else if([str isEqualToString:@"Contacts"])
                    {
                        [arrContacts addObject:strkey];
                        [arrContactsVal addObject:strVal];
                        [tmpArrContactsVal addObject:strVal];
                        
                    }
                    
                    else if([str isEqualToString:@"Case"])
                    {
                        [arrCase addObject:strkey];
                        [arrCaseVal addObject:strVal];
                        [tmpArrCaseVal addObject:strVal];
                        
                    }
                    
                    else
                    {
                        [arrReports addObject:strkey];
                        [arrReportsVal addObject:strVal];
                        [tmpArrReportsVal addObject:strVal];
                        
                    }
                    
                }
                
            }
            NSLog(@"%ld", (unsigned long)arrTblData.count);
            NSLog(@"%@", arrTblData);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
//                arrTblData = [[NSMutableArray alloc] initWithObjects:@[@"Records"],@[@"Opportunity"],@[@"Contacts"],@[@"Case"],@[@"Reports"],nil];
                
                if(tmpArrRecordsVal.count > 1)
                {
                    [arrTblData addObject:@[@"Records"]];
                }
                if(tmpArrOppVal.count > 1)
                {
                    [arrTblData addObject:@[@"Opportunity"]];
                }
                if(tmpArrContactsVal.count > 1)
                {
                    [arrTblData addObject:@[@"Contacts"]];
                }
                if(tmpArrCaseVal.count > 1)
                {
                    [arrTblData addObject:@[@"Case"]];
                }
                if(tmpArrReportsVal.count > 1)
                {
                    [arrTblData addObject:@[@"Reports"]];
                }
                [_tblShortcut1 reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self tableView:_tblShortcut1 didSelectRowAtIndexPath:indexPath];
                STOPLOADING();
            });
            
        }
        
    }];
}

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    numberOfSections = tblDataArray.count;
    messageLabel.hidden = YES;
    if (arrTblData.count > 0) {
        return arrTblData.count;
    }
    messageLabel.hidden = NO;
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = @"No data available for this section.";
    messageLabel.textColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = SET_FONTS_REGULAR;
    [messageLabel sizeToFit];
    
    self.tblShortcut1.backgroundView = messageLabel;
    self.tblShortcut1.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 0;

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = [arrTblData objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShortcutCell *cell = (ShortcutCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[ShortcutCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = [arrTblData objectAtIndex:indexPath.section];
    cell.lblItem.text = [arr objectAtIndex:indexPath.row];
    
//    cell.btnDown.tag = [[arrRecNo objectAtIndex:indexPath.row] integerValue];
//    [cell.btnDown addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
//
    cell.lblItem.font = SET_FONTS_REGULAR;
    if (indexPath.row==0) {

        cell.lblItem.textColor=[UIColor whiteColor];
        cell.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [cell.btnDown setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];
        [cell.btnDown setTitle:@"" forState:UIControlStateNormal];
        cell.btnDown.hidden = NO;
        cell.btnDown.userInteractionEnabled = NO;
        
    }else{
        if ([[arr firstObject] isEqualToString:@"Records"]) {
            
            cell.btnDown.tag = 1;
            cell.btnDown.accessibilityLabel = [arrRecords objectAtIndex:indexPath.row-1];
            [cell.btnDown addTarget:self action:@selector(callForMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[arr firstObject] isEqualToString:@"Opportunity"]) {
            
            cell.btnDown.tag = 2;
            cell.btnDown.accessibilityLabel = [arrOpp objectAtIndex:indexPath.row-1];
            [cell.btnDown addTarget:self action:@selector(callForMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[arr firstObject] isEqualToString:@"Contacts"]) {
            
            cell.btnDown.tag =  3;
            cell.btnDown.accessibilityLabel = [arrContacts objectAtIndex:indexPath.row-1];
            [cell.btnDown addTarget:self action:@selector(callForMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[arr firstObject] isEqualToString:@"Case"]) {
            
            cell.btnDown.tag = 4;
            cell.btnDown.accessibilityLabel = [arrCase objectAtIndex:indexPath.row-1] ;;
            [cell.btnDown addTarget:self action:@selector(callForMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.btnDown.userInteractionEnabled = YES;
        
        if([[arr firstObject] isEqualToString:@"Reports"])
        {
            cell.btnDown.hidden = YES;
        }
        else
        {
            cell.btnDown.hidden = NO;
        }
        [cell.btnDown setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cell.btnDown.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
        [cell.btnDown setTitle:@"\uf041" forState:UIControlStateNormal];

        cell.backgroundColor = [UIColor whiteColor];
        cell.lblItem.textColor=[UIColor grayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrTblData.count > indexPath.row) {
        if(indexPath.row == 0)
        {
            NSMutableArray *arr = [arrTblData objectAtIndex:indexPath.section];
            NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
            NSMutableArray *tmpArrForDown = [[NSMutableArray alloc]init];
            
            if ([[arr firstObject] isEqualToString:@"Records"]) {
                tmpArr=[arrRecordsVal mutableCopy];
                tmpArrForDown=[tmpArrRecordsVal mutableCopy];
            }
            else if([[arr firstObject] isEqualToString:@"Opportunity"])
            {
                tmpArr=[arrOppVal mutableCopy];
                tmpArrForDown=[tmpArrOppVal mutableCopy];
            }
            else if([[arr firstObject] isEqualToString:@"Contacts"])
            {
                tmpArr=[arrContactsVal mutableCopy];
                tmpArrForDown=[tmpArrContactsVal mutableCopy];
            }
            else if([[arr firstObject] isEqualToString:@"Case"])
            {
                tmpArr=[arrCaseVal mutableCopy];
                tmpArrForDown=[tmpArrCaseVal mutableCopy];
            }
            else if([[arr firstObject] isEqualToString:@"Reports"])
            {
                tmpArr=[arrReportsVal mutableCopy];
                tmpArrForDown=[tmpArrReportsVal mutableCopy];
            }
            if (arr.count>1) {
                ShortcutCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.btnDown.imageView.transform = CGAffineTransformMakeRotation(M_PI*2);
                NSUInteger count=1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in tmpArrForDown) {
                    NSLog(@"ShortCust: %@",dInner);
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:indexPath.section]];
                    count++;
                }
                NSArray *array=@[[tmpArr firstObject]];
                [arrTblData replaceObjectAtIndex:indexPath.section withObject:array];
                [arrTblData mutableCopy];
                [tableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            }else{
                ShortcutCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                cell.btnDown.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                
                NSUInteger count=0;
                NSMutableArray *arCells=[NSMutableArray array];
                NSMutableArray *localStoreDataArray=[NSMutableArray array];
                
                for(NSDictionary *dInner in tmpArr) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:indexPath.section]];
                    count++;
                    [localStoreDataArray addObject:dInner];
                }
                [arCells removeObjectAtIndex:0];
                [arrTblData replaceObjectAtIndex:indexPath.section withObject:localStoreDataArray];
                [arrTblData mutableCopy];
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        else{
            
            //        MainUrl + "/mobile_auth.asp?key=" + encp + 						"&topage=search_Engine.asp&savedsearch=T&mobile_search=T&SearchID="+Key().substring(3);
            
            
            NSMutableArray *arr = [arrTblData objectAtIndex:indexPath.section];
            
            strSearchTitle = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
            if ([[arr firstObject] isEqualToString:@"Records"]) {
                strSearchType = @"record";
                strSearchId = [arrRecords objectAtIndex:indexPath.row-1];
                [self performSegueWithIdentifier:@"shortcutDetail" sender:nil];
                //            NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=search_Engine.asp&savedsearch=T&mobile_search=T&SearchID=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrRecords objectAtIndex:indexPath.row-1]];
                //            [self openWebViewMethodForAdd:urlString];
            }
            else if([[arr firstObject] isEqualToString:@"Opportunity"])
            {
                strSearchType = @"opp";
                strSearchId = [arrOpp objectAtIndex:indexPath.row-1];
                [self performSegueWithIdentifier:@"shortcutDetail" sender:nil];
                
                //            NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=search_Engineopp.asp&savedsearch=T&mobile_search=T&SearchID=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrOpp objectAtIndex:indexPath.row-1]];
                //            [self openWebViewMethodForAdd:urlString];
                
            }
            else if([[arr firstObject] isEqualToString:@"Contacts"])
            {
                strSearchType = @"contact";
                strSearchId = [arrContacts objectAtIndex:indexPath.row-1];
                [self performSegueWithIdentifier:@"shortcutDetail" sender:nil];
                //            NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=search_Contact.asp&savedsearch=T&mobile_search=T&SearchID=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrContacts objectAtIndex:indexPath.row-1]];
                //            [self openWebViewMethodForAdd:urlString];
                
            }
            else if([[arr firstObject] isEqualToString:@"Case"])
            {
                strSearchType = @"case";
                strSearchId = [arrCase objectAtIndex:indexPath.row-1];
                [self performSegueWithIdentifier:@"shortcutDetail" sender:nil];
                //            NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=search_EngineCase.asp&savedsearch=T&mobile_search=T&SearchID=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrCase objectAtIndex:indexPath.row-1]];
                //            [self openWebViewMethodForAdd:urlString];
            }
            else if([[arr firstObject] isEqualToString:@"Reports"])
            {
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=search_Engine.asp&savedsearch=T&mobile_search=T&SearchID=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrReports objectAtIndex:indexPath.row-1]];
                [self openWebViewMethodForAdd:urlString];
                
            }
            
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ShortCutsDetailVC *destVC = [[ShortCutsDetailVC alloc] init];
    destVC = segue.destinationViewController;
    destVC.strSearchId = strSearchId;
    destVC.strSearchType = strSearchType;
    destVC.strSearchTitle = strSearchTitle;
    
    
}



-(void)openWebViewMethodForAdd :(NSString *)urlStr{
    
    UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    NSArray *viewControlles = navcon.viewControllers;
//    NSString* webStringURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL* url = [NSURL URLWithString:webStringURL];
//     [[UIApplication sharedApplication]openURL:url];
    
    BOOL isExist=false;
    for (int i = 0 ; i <viewControlles.count; i++){
        if ([[viewControlles objectAtIndex:i] isKindOfClass:[WebviewVC  class]]) {
            //Execute your code
            WebviewVC *wvc=(WebviewVC *)[viewControlles objectAtIndex:i];
            isExist=true;
            [navcon popToViewController:wvc animated:false];
            break;
        }
    }
    if(!isExist){
        WebviewVC *wvc=(WebviewVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"WebviewVC"];
        wvc.resUrlStr=urlStr;
        [navcon pushViewController:wvc animated:false];
    }
}

-(void)callForMap :(UIButton *)btn{
    
//    MainUrl + "/mobile_auth.asp?key=" + encp +  "&topage=mobile_searchmap.asp&searchid="+ searchID +  "&pagetype="  + pagetype+"&LogonID="+UserId;
    
    UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    NSArray *viewControlles = navcon.viewControllers;
    
    NSString *strVal = btn.accessibilityLabel;
    strVal = [strVal stringByReplacingOccurrencesOfString:@"?" withString:@"&"];

    NSString *pagetype=@"";
    
    if(btn.tag == 1)
        pagetype = @"record";
    if(btn.tag == 2)
        pagetype = @"opp";
    if(btn.tag == 3)
        pagetype = @"contact";
    if(btn.tag == 4)
        pagetype = @"case";
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_searchmap.asp&searchid=%@&pagetype=%@&LogonID=%@",MAIN_URL,[BaseApplication getEncryptedKey],strVal,pagetype,LOGIN_ID];
    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
    
    BOOL isExist=false;
    for (int i = 0 ; i <viewControlles.count; i++){
        if ([[viewControlles objectAtIndex:i] isKindOfClass:[WebviewVC  class]]) {
            //Execute your code
            WebviewVC *wvc=(WebviewVC *)[viewControlles objectAtIndex:i];
            isExist=true;
            [navcon popToViewController:wvc animated:false];
            break;
        }
    }
    if(!isExist){
        WebviewVC *wvc=(WebviewVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"WebviewVC"];
        wvc.resUrlStr=urlString;
        [navcon pushViewController:wvc animated:false];
    }
}


- (IBAction)shortcutMenu:(id)sender {
    [[SlideNavigationController sharedInstance]toggleLeftMenu];

}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.labelBG.count; i++) {
        UILabel *lbl = [self.labelBG objectAtIndex:i];
        lbl.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
}

@end
