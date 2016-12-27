//
//  HomeVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "MyAccounts.h"
#import "ContactVC.h"
#import "RecentItemsVC.h"
#import "CaseVC.h"
#import "OpportunityVC.h"


@interface HomeVC ()
{
    BOOL isWeb;
    UILabel *messageLabel;
    UILabel *messageLabel1;
    NSMutableArray *arrSearch;
}

@end
@implementation HomeTableCell


@end

@implementation HomeVC


@synthesize webview;
@synthesize arrRecNo,arrAction,arrCompany,arrActivityId,arrActivityEdited;
@synthesize arrTRecNo,arrTAction,arrTCompany,arrTActivityId,arrTActivityEdited;

CustomIOSAlertView *alert1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self setNeedsStatusBarAppearanceUpdate];
    arrSearch = [[NSMutableArray alloc] init];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setupView
{
    isWeb = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    alert1 = [[CustomIOSAlertView alloc]init];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by My Accounts" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _txtSearch.attributedPlaceholder = str;
    _lblOptions.text = @"My Accounts";
    
    if(IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        _btnSearch.frame = CGRectMake(_btnSearch.frame.origin.x-5, _txtSearch.frame.origin.y, _btnSearch.frame.size.width+5,  _txtSearch.frame.size.height);
    }
    
//    _activityView.layer.masksToBounds = NO;
//    _activityView.layer.shadowOffset = CGSizeMake(0, 10);
//    _activityView.layer.shadowRadius = 5;
//    _activityView.layer.shadowOpacity = 0.3;
//    
//    _optionView.layer.masksToBounds = NO;
//    _optionView.layer.shadowOffset = CGSizeMake(0, 10);
//    _optionView.layer.shadowRadius = 5;
//    _optionView.layer.shadowOpacity = 0.3;
    
    _btnSearch.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:20.0];
    [_btnSearch setTitle:@"\uf002" forState:UIControlStateNormal];
    _txtSearch.delegate = self;
    
    [alert1 close];
    self.navigationController.navigationBar.hidden = true;
    [self serviceForRecentItems];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForTodayEvents];
    });
}



-(void)viewWillAppear:(BOOL)animated
{
    self.viewSearch.hidden = YES;
    if (webview) {
        [webview removeFromSuperview];
    }
    self.txtSearch.font = SET_FONTS_REGULAR;
    self.txtSearch.text = @"";
    [self.txtSearch resignFirstResponder];
    self.constActTblHeight.constant = 90;
    self.constEventTblHeight.constant = 75;
//    [alert1 close];
//    _lblOptions.text = @"My Accounts";
//    _txtSearch.text = @"";
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by My Accounts" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
//    _txtSearch.attributedPlaceholder = str;
    [self setupView];
    [self setFonts_Background];
}

-(void)removeView
{
    if (webview) {
        [webview removeFromSuperview];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblActivity){
        if (self.btnMoreActivity.tag == 0) {
            self.constActTblHeight.constant = 90;
            messageLabel.hidden = YES;
            if (arrRecNo.count > 0) {
                return 1;
            }
            messageLabel.hidden = NO;
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"No data available for this section.";
            messageLabel.textColor = [Utility colorWithHexString:VIEW_BACKGROUND];
            
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = SET_FONTS_REGULAR;
            [messageLabel sizeToFit];
            
            self.tblActivity.backgroundView = messageLabel;
            self.tblActivity.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        else{
            self.constActTblHeight.constant = (arrRecNo.count * 90);
            return arrRecNo.count;
        }
    }
    if(tableView == self.tblEvents)
    {
        if (self.btnMoreEvent.tag == 0) {
            self.constEventTblHeight.constant = 75;
            messageLabel1.hidden = YES;
            if (self.viewEventMore.hidden == NO){
                return 1;
            }
            messageLabel1.hidden = NO;
            messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel1.text = @"No data available for this section.";
            messageLabel1.textColor = [Utility colorWithHexString:VIEW_BACKGROUND];
            
            messageLabel1.numberOfLines = 0;
            messageLabel1.textAlignment = NSTextAlignmentCenter;
            messageLabel1.font = SET_FONTS_REGULAR;
            [messageLabel1 sizeToFit];
            
            self.tblEvents.backgroundView = messageLabel1;
            self.tblEvents.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        else{
            self.constEventTblHeight.constant = (arrTCompany.count * 75);
            return arrTCompany.count;
        }
    }
    if (tableView == self.tblSearch) {
        return arrSearch.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tblActivity) {
        return 90;
    }
    if (tableView == self.tblSearch) {
        return 40;
    }
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    HomeTableCell *cell;
    if(tableView == self.tblActivity)
    {
        cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[HomeTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        }
        [cell.lblCompany setTextColor:[UIColor colorWithRed:0.247 green:0.592 blue:0.780 alpha:1.000]];
        [cell.lblAction setTextColor:[UIColor grayColor]];
        [cell.lblBy setTextColor:[UIColor colorWithRed:0.247 green:0.592 blue:0.780 alpha:1.000]];
        if ([arrActivityEdited count]>0) {
            if (arrActivityEdited.count > indexPath.row) {
                NSString *s = [NSString stringWithFormat:@"by %@",[arrActivityEdited objectAtIndex:indexPath.row]];
                cell.lblBy.text = s;
            }
        }
        if ([arrCompany count]>0)
        {
            if (arrCompany.count > indexPath.row) {
                if(![[arrCompany objectAtIndex:indexPath.row] isEqualToString:@"none"])
                    cell.lblCompany.text = [arrCompany objectAtIndex:indexPath.row];
                else
                    cell.lblCompany.text = @"";
            }
        }
        else
            cell.lblCompany.text = @"";
        if ([arrAction count]>0)
        {
            if (arrAction.count > indexPath.row) {
                cell.lblAction.text = [arrAction objectAtIndex:indexPath.row];
            }
        }
        else
            cell.lblAction.text = @"";
        cell.lblCompany.font = SET_FONTS_BIG;
        cell.lblAction.font = [SET_FONTS_REGULAR fontWithSize:15];
        cell.lblBy.font = [SET_FONTS_REGULAR fontWithSize:12];
        
        return cell;
    }
    else if (tableView == self.tblEvents)
    {
        cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[HomeTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
            
        }
        [cell.lblEvent setTextColor:[UIColor colorWithRed:0.247 green:0.592 blue:0.780 alpha:1.000]];
        [cell.lblTime setTextColor:[UIColor grayColor]];
        [cell.lblEventType setTextColor:[UIColor grayColor]];
        if([arrTCompany count]>0)
            cell.lblEvent.text = [arrTCompany objectAtIndex:indexPath.row];
        if([arrTActivityEdited count]>0)
        {
            NSString *time = [NSString stringWithFormat:@"at %@",[arrTActivityEdited objectAtIndex:indexPath.row]];
            cell.lblTime.text =  time;
        }
        
        if([arrTAction count]>0)
            cell.lblEventType.text = [arrTAction objectAtIndex:indexPath.row];
        cell.lblTime.font = SET_FONTS_REGULAR;
        cell.lblEvent.font = SET_FONTS_REGULAR;
        cell.lblEventType.font = SET_FONTS_REGULAR;
        cell.lblEvent.font = SET_FONTS_BIG;
        cell.lblEventType.font = [SET_FONTS_REGULAR fontWithSize:15];
        cell.lblTime.font = [SET_FONTS_REGULAR fontWithSize:12];
        return cell;

    }//eventCell
    if (tableView == self.tblSearch) {
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = [arrSearch objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblSearch) {
        _txtSearch.text = [arrSearch objectAtIndex:indexPath.row];
        self.viewSearch.hidden = YES;
    }
    else{
        if (isWeb) {
            [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
        } else {
            [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
        }
        isWeb = false;
        if(tableView == self.tblActivity)
        {
            
            NSString *urlString = [NSString stringWithFormat:
                                   @"%@/mobile_auth.asp?key=%@&topage=%@&RECDNO=%@&CompanyID=%@&appkeyword=&pagetype=account",MAIN_URL,[BaseApplication getEncryptedKey],DPAGE,[arrRecNo objectAtIndex:indexPath.row],WORKGROUP];
            NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:webStringURL];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
            [webview loadRequest:urlRequest];
            [self.view addSubview:webview];
            
        }
        else if (tableView == self.tblEvents)
        {
            
            NSString *urlString = [NSString stringWithFormat:
                                   @"%@/mobile_auth.asp?key=%@&topage=mobile_cbViewEvent.asp&RECDNO=%@&CompanyID=%@&CallBackID=%@&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey],[arrTRecNo objectAtIndex:indexPath.row],WORKGROUP,[arrTActivityId objectAtIndex:indexPath.row]];
            NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:webStringURL];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
            [webview loadRequest:urlRequest];
            [self.view addSubview:webview];
            
        }
        [alert1 close];
    }
}


- (IBAction)refreshActivity:(id)sender
{
    [self serviceForRecentItems];
    [alert1 close];
}

- (IBAction)refreshEvents:(id)sender {
    [self serviceForTodayEvents];
    [alert1 close];
}

- (IBAction)calenderClicked:(id)sender
{
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    //MainUrl+"/mobile_auth.asp?key=" + encp + 					"&topage=mobile_calWeek.asp"
    NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_calWeek.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];
[alert1 close];
    
    }

- (IBAction)searchData:(id)sender
{
    [self.txtSearch resignFirstResponder];
    if([_lblOptions.text isEqualToString:@"My Accounts"])
    {
        MyAccounts *myAcc=(MyAccounts *)[self.storyboard instantiateViewControllerWithIdentifier:@"MyAccounts"];
        myAcc.strSearch = _txtSearch.text;
        [self.navigationController pushViewController:myAcc animated:true];
    }
    else if([_lblOptions.text isEqualToString:@"Contacts"])
    {
        ContactVC *myCon=(ContactVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
        myCon.cLastname = _txtSearch.text;
        [self.navigationController pushViewController:myCon animated:true];
    }
    else if([_lblOptions.text isEqualToString:@"Case"])
    {
        CaseVC *myCon=(CaseVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CaseVC"];
        myCon.strSearch = _txtSearch.text;
        [self.navigationController pushViewController:myCon animated:true];
    }
    else if([_lblOptions.text isEqualToString:@"Opportunity"])
    {
        OpportunityVC *myCon=(OpportunityVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"OpportunityVC"];
        myCon.strOppSearch = _txtSearch.text;
        [self.navigationController pushViewController:myCon animated:true];
    }
    [alert1 close];
}

- (IBAction)openOptions:(id)sender
{
    self.viewSearch.hidden = YES;
    [alert1 setContainerView:_searchView];
    [alert1 setUseMotionEffects:true];
    [alert1 show];
}
- (IBAction)myAccountsClicked:(id)sender
{
    _txtSearch.text = @"";
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by My Accounts" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _txtSearch.attributedPlaceholder = str;

     _lblOptions.text = @"My Accounts";
    [_lblOptions setFont:SET_FONTS_REGULAR];
    [alert1 close];
}

- (IBAction)contactsClicked:(id)sender {
    _txtSearch.text = @"";
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by Contacts" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _txtSearch.attributedPlaceholder = str;

     _lblOptions.text = @"Contacts";
    [_lblOptions setFont:SET_FONTS_REGULAR];
    [alert1 close];

}

- (IBAction)caseClicked:(id)sender {
    _txtSearch.text = @"";
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by Case" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _txtSearch.attributedPlaceholder = str;

    
    _lblOptions.text = @"Case";
    [_lblOptions setFont:SET_FONTS_REGULAR];
    [alert1 close];

}

- (IBAction)opportunityClicked:(id)sender {
    _txtSearch.text = @"";
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search by Opportunity" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _txtSearch.attributedPlaceholder = str;
    

    _lblOptions.text = @"Opportunity";
    [_lblOptions setFont:SET_FONTS_REGULAR];
    [alert1 close];
}

- (IBAction)btnMoreActivity:(id)sender {
    if (self.btnMoreActivity.tag == 0) {
        [self.btnMoreActivity setTitle:@"CLOSE..." forState:UIControlStateNormal];
        self.btnMoreActivity.tag = 1;
    }
    else{
        [self.btnMoreActivity setTitle:@"MORE>>>" forState:UIControlStateNormal];
        self.btnMoreActivity.tag = 0;
    }
    [self.tblActivity reloadData];
}

- (IBAction)btnMoreEvent:(id)sender {
    if (self.btnMoreEvent.tag == 0) {
        [self.btnMoreEvent setTitle:@"CLOSE..." forState:UIControlStateNormal];
        self.btnMoreEvent.tag = 1;
    }
    else{
        [self.btnMoreEvent setTitle:@"MORE>>>" forState:UIControlStateNormal];
        self.btnMoreEvent.tag = 0;
    }
    [self.tblEvents reloadData];
}

- (IBAction)sideBar:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideBarReload" object:self];
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance] toggleLeftMenu];
        
    } else {
        
        [webview removeFromSuperview];
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    
    [alert1 close];
}

-(void)serviceForRecentItems{
  
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GETACTIVITY arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
//        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
        arrActivityId = [[NSMutableArray alloc]init];
        arrCompany = [[NSMutableArray alloc]init];
        arrActivityEdited = [[NSMutableArray alloc]init];
        arrAction = [[NSMutableArray alloc]init];
        arrRecNo = [[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            _tblActivity.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeActivityData"])
            {
                if([doc valueWithPath:@"ActivityID"])
                    [arrActivityId addObject:[doc valueWithPath:@"ActivityID"]];
                if([doc valueWithPath:@"ActivityEditedBy"])
                    [arrActivityEdited addObject:[doc valueWithPath:@"ActivityEditedBy"]];
                else
                    [arrActivityEdited addObject:@"none"];
                if([doc valueWithPath:@"LastAction"])
                    [arrAction addObject:[doc valueWithPath:@"LastAction"]];
                else
                    [arrAction addObject:@"none"];
                if(![[doc valueWithPath:@"RECDNO"] isEqualToString:@"0"])
                    [arrRecNo addObject:[doc valueWithPath:@"RECDNO"]];
                if([doc valueWithPath:@"Company"])
                    [arrCompany addObject:[doc valueWithPath:@"Company"]];
                else
                    [arrCompany addObject:@"none"];
            }
            if (arrRecNo.count <= 1) {
                _viewActivityMore.hidden = YES;
                self.constViewActivityMore.constant = 0;
            }
            else{
                self.viewActivityMore.hidden = NO;
                self.constViewActivityMore.constant = 40;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_tblActivity reloadData];
             STOPLOADING();
            });
            
//            NSMutableDictionary *responseDataDic=[[NSMutableDictionary alloc]init];
//            [responseDataDic setValue:isbn forKey:@"DatabaseID"];
//            [responseDataDic setValue:title forKey:@"DatabaseName"];
//            [responseArrayTmp  addObject:responseDataDic];
         
        }
        
    }];
}

-(void)serviceForTodayEvents
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"eventname":@""},@{@"startindex":@"1"},@{@"endindex":@"10"}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:TODAYEVENTS arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        //        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
        arrTActivityId = [[NSMutableArray alloc]init];
        arrTCompany = [[NSMutableArray alloc]init];
        arrTActivityEdited = [[NSMutableArray alloc]init];
        arrTAction = [[NSMutableArray alloc]init];
        arrTRecNo = [[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            _tblEvents.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeEventData"])
            {
                if([doc valueWithPath:@"CallBackID"])
                    [arrTActivityId addObject:[doc valueWithPath:@"CallBackID"]];
                if([doc valueWithPath:@"StartTime"])
                    [arrTActivityEdited addObject:[doc valueWithPath:@"StartTime"]];
                if([doc valueWithPath:@"EventType"])
                    [arrTAction addObject:[doc valueWithPath:@"EventType"]];
                if([doc valueWithPath:@"RECDNO"])
                {
                    [arrTRecNo addObject:[doc valueWithPath:@"RECDNO"]];
                    if( [[doc valueWithPath:@"RECDNO"] integerValue] == 0)
                    {
                        self.viewEventMore.hidden = YES;
                        self.constViewEventMore.constant = 0;
//                        _lblNoEvents.hidden = NO;
                    }
                    else
                    {
//                        _tblEvents.hidden = NO;
//                        _lblNoEvents.hidden = YES;
                        self.viewEventMore.hidden = NO;
                        self.constViewEventMore.constant = 40;
                    }
                }
                if([doc valueWithPath:@"Company"])
                    [arrTCompany addObject:[doc valueWithPath:@"Company"]];
                [self.tblEvents reloadData];
            }
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblEvents reloadData];
                STOPLOADING();
             });
                
            //            NSMutableDictionary *responseDataDic=[[NSMutableDictionary alloc]init];
            //            [responseDataDic setValue:isbn forKey:@"DatabaseID"];
            //            [responseDataDic setValue:title forKey:@"DatabaseName"];
            //            [responseArrayTmp  addObject:responseDataDic];
           
        }
        
    }];
}

-(void)serviceForPrivilages
{
    
}

//Search TextView
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([str length] > 1) {
        if([_lblOptions.text isEqualToString:@"My Accounts"])
        {
            [self serviceForAccountData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
        }
        else if([_lblOptions.text isEqualToString:@"Contacts"])
        {
            [self serviceForContactData:[@(0)stringValue] and:[@(10)stringValue] lname:str];
        }
        else if([_lblOptions.text isEqualToString:@"Case"])
        {
            [self serviceForCaseData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
        }
        else if([_lblOptions.text isEqualToString:@"Opportunity"])
        {
            [self serviceForOpportunityData:[@(0)stringValue] and:[@(10)stringValue] comp:str];
        }
    }
    else{
        self.viewSearch.hidden = YES;
    }
    return  YES;
}

-(void)serviceForAccountData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"company":company},@{@"startindex":startIndex1},@{@"endindex":endIndex1}]];
    
    [BaseApplication executeRequestwithService:SEARCHACCDATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
            
        {
            [arrSearch removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                if([doc valueWithPath:@"Company"])
                    [arrSearch addObject:[doc valueWithPath:@"Company"]];
            }
            if (arrSearch.count > 1) {
                [self.tblSearch reloadData];
                float height = arrSearch.count * 40;
                if (height > ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100)) {
                    height = ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100);
                }
                self.constTblSearchHeight.constant = height;
                self.viewSearch.hidden = NO;
            }
            else{
                self.viewSearch.hidden = YES;
            }
        }
    }];
}

-(void)serviceForContactData:(NSString *)startIndex1 and:(NSString *)endIndex1 lname:(NSString *)lastName
{
    
    if(!lastName)
        lastName = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"lastname":lastName},@{@"startindex":startIndex1},@{@"endindex":endIndex1}]];
    
    [BaseApplication executeRequestwithService:SEARCH_CONTACT_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
        {
            [arrSearch removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                if([doc valueWithPath:@"LastName"])
                    [arrSearch addObject:[doc valueWithPath:@"LastName"]];
            }
            if (arrSearch.count > 1) {
                [self.tblSearch reloadData];
                float height = arrSearch.count * 40;
                if (height > ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100)) {
                    height = ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100);
                }
                self.constTblSearchHeight.constant = height;
                self.viewSearch.hidden = NO;
            }
            else{
                self.viewSearch.hidden = YES;
            }
        }
    }];
}

-(void)serviceForOpportunityData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"company_id":WORKGROUP},@{@"oppname":company}]];
    [BaseApplication executeRequestwithService:SEARCH_OPPORTUNITY_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else            
        {
            [arrSearch removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeOpportunityData"])
            {
                
                if([doc valueWithPath:@"OppName"])
                    [arrSearch addObject:[doc valueWithPath:@"OppName"]];
            }
            if (arrSearch.count > 1) {
                [self.tblSearch reloadData];
                float height = arrSearch.count * 40;
                if (height > ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100)) {
                    height = ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100);
                }
                self.constTblSearchHeight.constant = height;
                self.viewSearch.hidden = NO;
            }
            else{
                self.viewSearch.hidden = YES;
            }
        }
        
    }];
}

-(void)serviceForCaseData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"subject":company}]];
    
    [BaseApplication executeRequestwithService:SEARCHCASEDATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
        {
            [arrSearch removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeCaseData"])
            {
                if([doc valueWithPath:@"Subject"])
                    [arrSearch addObject:[doc valueWithPath:@"Subject"]];
            }
            if (arrSearch.count > 1) {
                [self.tblSearch reloadData];
                float height = arrSearch.count * 40;
                if (height > ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100)) {
                    height = ([UIScreen mainScreen].bounds.size.height - self.viewSearch.frame.origin.y - 100);
                }
                self.constTblSearchHeight.constant = height;
                self.viewSearch.hidden = NO;
            }
            else{
                self.viewSearch.hidden = YES;
            }
        }
    }];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)setFonts_Background
{
    for (int i = 0 ; i < self.viewBG.count; i++) {
        UIView *view = [self.viewBG objectAtIndex:i];
        view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lblBG.count; i++) {
        UILabel *lbl = [self.lblBG objectAtIndex:i];
        lbl.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    }
    for (int i = 0 ; i < self.lable.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_REGULAR;
    }
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = SET_FONTS_REGULAR;
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

@end
