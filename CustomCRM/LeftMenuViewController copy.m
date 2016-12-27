    //
    //  MenuViewController.m
    //  SlideMenu
    //
    //  Created by Aryan Gh on 4/24/13.
    //  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
    //

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "UIImageView+Letters.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SMXMLDocument.h"
#import "MyAccounts.h"
#import "LoginVC.h"
#import "HomeVC.h"
#import "ContactVC.h"
#import "WebviewVC.h"
#import "CaseVC.h"
#import "OpportunityVC.h"
#import "CallBackTasks.h"
#import "SearchVC.h"
#import "QuotesVC.h"
#import "ShortCutsVC.h"
#import "CalendarVC.h"

@implementation MenuTabCell



- (IBAction)addClicked:(id)sender {
}
@end

@implementation LeftMenuViewController
{
    BOOL isLogout;
}

@synthesize arrMenu,arrImages,arrKey,arrValue,dictLabel,dictPriv;

@synthesize privillageArray,displayLblArray,tblDataArray,arrSortLable;
CGRect frame ;//= cell.btnDetail.frame;

#pragma mark - UIViewController Methods -



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"SlideBarReload"
                                               object:nil];
    SHOWLOADING(@"Wait...")
    addValueArray=[[NSMutableArray alloc]init];
    addValueTmpArray=[[NSMutableArray alloc] init];
    NSDictionary *dic3=@{@"Key":@"Add",@"Value":@"Add"};
    [addValueArray addObject:dic3];
    
    frame = CGRectMake(207,12, 113,32);
//    frame = (origin = (x = 207, y = 11.5), size = (width = 113, height = 32))

    tblDataArray=[[NSMutableArray alloc]init];
    
    privillageArray=[[NSMutableArray alloc]init];
    displayLblArray=[[NSMutableArray alloc]init];
    
        //    [self serviceForCusustomLabels];
        //    [self serviceForPrivilages];
        //    tblDataArray = [[AppDelegate initAppdelegate].allTableLblArray mutableCopy];
    privillageArray = [[AppDelegate initAppdelegate].allPrivillageArray mutableCopy];
    displayLblArray = [[AppDelegate initAppdelegate].allDisplayLblArray mutableCopy];
    [self refreshTableData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForAccountCount:@""];
        [self serviceForCaseCount];
        [self serviceForContactCount];
        [self serviceForOppCount];
        [self serviceForQuoteCount];
        
        STOPLOADING();
    });
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"SlideBarReload"])
        [self.tableView reloadData];
}


    //Service call for all count data

-(void)serviceForAccountCount:(NSString *)company
{
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"company":company}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:SEARCHACCOUNT_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchAccountCountResponse"])
                {
                if([doc valueWithPath:@"SearchAccountCountResult"])
                    {
                    accCount = [[doc valueWithPath:@"SearchAccountCountResult"] intValue];
                    NSLog(@"Account : %d",accCount);
                    }
                }
            }
        
    }];
    
}

-(void)serviceForCaseCount
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"subject":@""}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:CASE_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchCasesCountResponse"])
                {
                if([doc valueWithPath:@"SearchCasesCountResult"])
                    {
                    caseCount = [[doc valueWithPath:@"SearchCasesCountResult"] intValue];
//                    NSLog(@"Case : %d",caseCount);
                    }
                }
            [_tableView reloadData];
            }
        
    }];
    
}

-(void)serviceForContactCount
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"lastname":@""}]];
        //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:CONTACT_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchContactCountResponse"])
                {
                if([doc valueWithPath:@"SearchContactCountResult"])
                    {
                    conCount = [[doc valueWithPath:@"SearchContactCountResult"] intValue];
//                    NSLog(@"Contact : %d",conCount);
                    }
                }
            [_tableView reloadData];
            }
        
    }];
    
}

-(void)serviceForOppCount
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"oppname":@""}]];
        //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:OPP_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchOpportunityCountResponse"])
                {
                if([doc valueWithPath:@"SearchOpportunityCountResult"])
                    {
                    oppCount = [[doc valueWithPath:@"SearchOpportunityCountResult"] intValue];
//                    NSLog(@"Opp : %d",oppCount);
                    }
                }
            [_tableView reloadData];
            }
        
    }];
    
}

-(void)serviceForQuoteCount
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"quotename":@""}]];
        //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:QUOTE_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchQuoteCountResponse"])
                {
                if([doc valueWithPath:@"SearchQuoteCountResult"])
                    {
                    queteCount = [[doc valueWithPath:@"SearchQuoteCountResult"] intValue];
//                    NSLog(@"Quote : %d",queteCount);
                    }
                }
            [_tableView reloadData];
            }
        
    }];
    
}



#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    numberOfSections = tblDataArray.count;
    return tblDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4)
    {
        return addValueArray.count;
    }
    else
    {
        numberOfRowsInLastSection = 1;
        return 1;
    }
        //return tblDataArray.count;
}

    //- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    //{
    //    return 30;
    //}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        
        NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        
//        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, self.tableView.frame.size.width, 30)];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 140, 30)];
        lbl.text = [mDictionary1 objectForKey:@"UserName"];
        lbl.font = SET_FONTS_REGULAR;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        NSArray *arr = [Utility colorWithRGB:[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG]];
        [img setImageWithString:lbl.text color:[UIColor colorWithRed:([arr[0] intValue]/255.0f) green:([arr[1] intValue]/255.0f) blue:([arr[2] intValue]/255.0f) alpha:1.000] circular:YES];
//        [img setImageWithString:lbl.text color:[UIColor colorWithRed:0.035 green:0.275 blue:0.604 alpha:1.000] circular:YES];
//        UIColor *bgColor = [[UIColor alloc] init];
//        bgColor = VIEW_BACKGROUND;
//        [img setImageWithString:lbl.text color:bgColor circular:YES];
        img.layer.cornerRadius = img.frame.size.width/2;
        
        UIImageView *imgLogout = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame)+10, 15, 30, 30)];
        imgLogout.contentMode = UIViewContentModeCenter;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"A133B5"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp8"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"FC653C"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp1"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"FBA121"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp2"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"545FBB"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp3"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"61BA62"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp4"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"D1E350"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp5"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"EB4649"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp6"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:key_View_BG] isEqualToString:@"E72E72"]) {
            imgLogout.image = [UIImage imageNamed:@"logoutTmp7"];
        }
        else{
            imgLogout.image = [UIImage imageNamed:@"logoutTmp"];
        }
        
        UIButton *control = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame)+2, 5, 45,40)];
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:img];[view addSubview:imgLogout];[view addSubview:control];
        [view addSubview:lbl];
        return view;
    }else{
        return nil;
    }
}

-(void)logout
{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=index_logoff.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    isLogout = true;
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66,WIDTH,HEIGHT)];
    webview.delegate = self;
    SHOWLOADING(@"Wait...");
    //            webview.hidden = YES;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];

//This code is for hide Add section.
//if (addValueArray.count>1) {
//    NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithArray:addValueArray];
//    [tmpArray mutableCopy];
//    [tmpArray removeObjectAtIndex:0];
//    NSUInteger count=1;
//    NSMutableArray *arCells=[NSMutableArray array];
//    for(NSDictionary *dInner in tmpArray) {
//        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:2]];
//        count++;
//    }
//    [addValueArray removeObjectsInArray:tmpArray];
//    [tableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
//}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4&&indexPath.row>0) {
        return 40;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 60;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuTabCell *cell = (MenuTabCell *)[tableView dequeueReusableCellWithIdentifier:@"leftMenuCell" forIndexPath:indexPath];
    if (cell==nil)
        {
        cell = [[MenuTabCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"leftMenuCell"];
        
        }
    NSMutableDictionary *dictionary;
    if (indexPath.section==4) {
        dictionary=[addValueArray objectAtIndex:indexPath.row];
    }else{
        dictionary=[tblDataArray objectAtIndex:indexPath.section];
    }
        // NSDictionary *dictionary=[tblDataArray objectAtIndex:indexPath.row];
    
    
    NSString *lblText=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Value"]];
    NSString *keyText=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Key"]];
    
    cell.lblItem.text=lblText;
    if ([lblText isEqualToString:@"Add"]) {
        cell.lblTop.hidden = NO;
        cell.lblBottom.hidden = NO;
        cell.btnDetail.hidden = NO;
        [cell.btnDetail setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal ];
    }else{
        cell.lblTop.hidden = YES;
        cell.lblBottom.hidden = YES;
        cell.btnDetail.hidden = YES;
        [cell.btnDetail setImage:nil forState:UIControlStateNormal ];

    }
//    CGRect frame = cell.btnDetail.frame;
    if([keyText isEqualToString:@"Events"])
    {
        cell.lblCallback.userInteractionEnabled = YES;
        cell.lblCallback.hidden = NO;
        cell.lblCallback.text = [NSString stringWithFormat:@"%@",lblText];
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(callBack:)];
        [cell.lblCallback addGestureRecognizer:tapGesture];
//        cell.lblCallback.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture =
//        [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                action:@selector(labelTap)];
//        [cell.lblCallback addGestureRecognizer:tapGesture];
//        cell.btnDetail.userInteractionEnabled = YES;
//        if(IS_IPHONE_5 || IS_IPHONE_5)
//        {
//           cell.btnDetail.frame = CGRectMake(CGRectGetMaxX(cell.imgIcon.frame)+90,cell.btnDetail.frame.origin.y,cell.btnDetail.frame.size.width+50, cell.btnDetail.frame.size.height);
//        }
        
    }
    else
    {
        cell.lblCallback.userInteractionEnabled = NO;
        cell.lblCallback.hidden = YES;
//        if(IS_IPHONE_5 || IS_IPHONE_5)
//        {
//            cell.btnDetail.frame = frame;
//        }
        
    }
    /*
     fa_icon_assign => &#xf0c0;
     fa_icon_select => &#xf00c;
     fa_icon_map => &#xf041;
     fa_icon_delete => &#xf1f8;
     fa_icon_call => &#xf095;
     fa_calendar => &#xf073;
     fa_plus => &#xf067;
     fa_edit => &#xf044;
     fa_url => &#xf0ac;
     fa_search => &#xf002;
     fa_assign => &#xf29a;
     fa_settings => &#xf013;
     fa_dashboard => &#xf0e4;
     fa_account => &#xf1ec;
     fa_contact => &#xf007;
     fa_recentitems => &#xf017;
     fa_myshortcut => &#xf122;
     fa_callback => &#xf274;
     fa_home => &#xf015;
     fa_email => &#xf003;
     fa_refresh => &#xf021;
     fa_visible => &#xf06e;
     fa_back => &#xf060;
     
     */
    
    if (indexPath.section==4 && indexPath.row>0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.lblCallback.hidden=true;
        cell.imgIcon.hidden=true;
        cell.lblItem.textColor=[UIColor grayColor];
    }else{
            //        cell.lblImage.hidden=false;
        cell.imgIcon.hidden=false;
        cell.lblItem.textColor=[UIColor whiteColor];
        cell.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];//[UIColor colorWithRed:0.035 green:0.275 blue:0.604 alpha:1.000];
        NSString * iconStr= @"";
        if ([keyText isEqualToString:@"Home"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-home"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAHome];
            cell.imgIcon.image=[UIImage imageNamed:@"home"];
        }else if ([keyText isEqualToString:@"My Calendar"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-dashcube"];
            //  cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"calendar"];
        }else if ([keyText isEqualToString:@"Group Calendar"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-dashcube"];
            //  cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"group_calendar"];
        }
        else if ([keyText isEqualToString:@"Dashboard"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-dashcube"];
                //  cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"dashboard"];
            
        }else if ([keyText isEqualToString:@"Library"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-library"];
            //  cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"library"];
        }else if ([keyText isEqualToString:@"Add"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-plus"];
                //        cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"add"];
            
            cell.btnDetail.hidden = NO;
            [cell.btnDetail setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal ];
            [cell.btnDetail setTitle:@"" forState:UIControlStateNormal];

            
        }else if ([keyText isEqualToString:@"Banner - Accounts"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-account"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"myaccounts"];
            if(accCount > 0)
                {
                [cell.btnDetail setTitle:[NSString stringWithFormat:@"%d",accCount] forState:UIControlStateNormal];
                    cell.btnDetail.hidden = false;
                }else{
                    cell.btnDetail.hidden = true;
                    [cell.btnDetail setImage:nil forState:UIControlStateNormal ];
                }
        }else if ([keyText isEqualToString:@"Banner - Contacts"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-contact"];
                //  cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"contacts"];
            
            if(conCount > 0)
                {
                [cell.btnDetail setTitle:[NSString stringWithFormat:@"%d",conCount] forState:UIControlStateNormal];
                cell.btnDetail.hidden = false;
                }else{
                    cell.btnDetail.hidden = true;
                    [cell.btnDetail setImage:nil forState:UIControlStateNormal ];
                }
        }else if ([keyText isEqualToString:@"Case"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-contact"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"old-fashion-briefcase"];
            if(caseCount > 0)
                {
                [cell.btnDetail setTitle:[NSString stringWithFormat:@"%d",caseCount] forState:UIControlStateNormal];
                cell.btnDetail.hidden = false;
                
                }else{
                    cell.btnDetail.hidden = true;
                    [cell.btnDetail setImage:nil forState:UIControlStateNormal ];
                }
        }
        else if ([keyText isEqualToString:@"Events"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"events"];
            cell.lblItem.text = @"Events";
            cell.lblCallback.userInteractionEnabled = YES;
            cell.lblCallback.text = [NSString stringWithFormat:@"%@",lblText];
            UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(callBack:)];
            [cell.lblCallback addGestureRecognizer:tapGesture];
            
        }else if ([keyText isEqualToString:@"My Searches"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-search"];
                // cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"search"];
            
        }else if ([keyText isEqualToString:@"Opportunity"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-search"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"opportunity"];
            if(oppCount > 0)
                {
                [cell.btnDetail setTitle:[NSString stringWithFormat:@"%d",oppCount] forState:UIControlStateNormal];
                cell.btnDetail.hidden = false;
                
                }else{
                    cell.btnDetail.hidden = true;
                    [cell.btnDetail setImage:nil forState:UIControlStateNormal ];
                }
        }else if ([keyText isEqualToString:@"Quote"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-search"];
                // cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"quote"];
            if(queteCount > 0)
                {
                [cell.btnDetail setTitle:[NSString stringWithFormat:@"%d",queteCount] forState:UIControlStateNormal];
                cell.btnDetail.hidden = false;
                
                }else{
                    cell.btnDetail.hidden = true;
                    [cell.btnDetail setImage:nil forState:UIControlStateNormal ];
                }
        }else if ([keyText isEqualToString:@"Recent Items"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-recentitems"];
                //cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"5"];
            
        }else if ([keyText isEqualToString:@"Shortcuts"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-myshortcut"];
                // cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"shortcuts"];
            
        }else if ([keyText isEqualToString:@"Logout"]) {
            iconStr= [NSString fontAwesomeIconStringForIconIdentifier:@"fa-back"];
                // cell.lblImage.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
            cell.imgIcon.image=[UIImage imageNamed:@"logout"];
            
        }
        cell.lblImage.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];//fa-github
        cell.lblImage.text = [NSString stringWithFormat:@"%@",  iconStr];//[NSString fontAwesomeIconStringForIconIdentifier:@"fa-refresh"];//
    }
    
    cell.lblItem.font = SET_FONTS_REGULAR;
    cell.btnDetail.titleLabel.font = SET_FONTS_REGULAR;
    cell.lblCallback.font = SET_FONTS_REGULAR;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UINavigationController *navcon in [AppDelegate initAppdelegate].tabbar.viewControllers) {
        for (id viewCont in navcon.viewControllers) {
            if ([viewCont isKindOfClass:[WebviewVC class]]) {
                [navcon popToRootViewControllerAnimated:NO];
            }else if ([viewCont isKindOfClass:[CaseVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[OpportunityVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if([viewCont isKindOfClass:[CallBackTasks class]])
            {
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[SearchVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[QuotesVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[ShortCutsVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[MyAccounts class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[ContactVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[LibraryVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
        }
    }
    if (indexPath.section == 4) {
        
        if (indexPath.row==0) {
            
            if (addValueArray.count>1) {
                MenuTabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                cell.btnDetail.imageView.transform = CGAffineTransformMakeRotation(M_PI*2);
                
                NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithArray:addValueArray];
                [tmpArray mutableCopy];
                [tmpArray removeObjectAtIndex:0];
                NSUInteger count = 1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in tmpArray) {
                    NSLog(@"Data: %@",dInner);
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:4]];
                    count++;
                }
                [addValueArray removeObjectsInArray:tmpArray];
                [tableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideBarReload" object:self];
                MenuTabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    //                [cell.btnDetail setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal ];
                    //                cell.btnDetail.imageView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) * 180.0);
                cell.btnDetail.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                
                NSUInteger count=1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in addValueTmpArray) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:4]];
                    count++;
                    [addValueArray addObject:dInner];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationTop];
                
            }
                //  addValueArray
        }
        else{
            NSDictionary *tmpDataDic=[addValueArray objectAtIndex:indexPath.row];
            
            NSString *lblText = [NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Value"]];
            NSLog(@"LeftMenuVC: %@",lblText);
            NSString *keyText = [NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Key"]];
            
            
            if ([keyText isEqualToString:@"Banner - Accounts"]) {
                    //Add Account tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_frmlead.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Record"];
            }else if ([keyText isEqualToString:@"Banner - Contacts"]) {
                    //Add Contact tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_dlgcontact.asp&fromPage=mobile_dlgcontact.asp&add_contact=T&RECDNO=0&contactid=0&CompanyID=%@",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Contact"];
            }else if ([keyText isEqualToString:@"Case"]) {
                    //Add Case tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAddcase.asp&RECDNO=0&id=0&add_Case=T",MAIN_URL,[BaseApplication getEncryptedKey]];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Case"];
            }else if ([keyText isEqualToString:@"Events"]) {
                    //Add Call Back/Events tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_cbEditEvent.asp&add_CallBack=T",MAIN_URL,[BaseApplication getEncryptedKey]];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New CallBack/Events"];
            }else if ([keyText isEqualToString:@"Opportunity"]) {
                    //Add Opportunity tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_opportunity_EditForm.asp&frompage=mobile_opportunity_EditForm.asp&add_Opportunity=T&RECDNO=0&OppID=0",MAIN_URL,[BaseApplication getEncryptedKey]];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Opportunity"];
            }else if ([keyText isEqualToString:@"Quote"]) {
                    //Add Quote tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_quote_EditForm.asp&add_quote=T&CompanyID=%@&ContactID=0&RECDNO=0",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Quote"];
            }else if ([keyText isEqualToString:@"Sales Rep Comments/Notes"]) {
                    //Add Sales Rep Comments/Notes tap
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_AddNote.asp&add_notes=T&CompanyID=%@",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP];
                [self openWebViewMethodForAdd:urlString mTitle:@"Add New Sales Rep"];
            }
            
                //This code is for hide Add section.
            if (addValueArray.count>1) {
                NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithArray:addValueArray];
                [tmpArray mutableCopy];
                [tmpArray removeObjectAtIndex:0];
                NSUInteger count=1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in tmpArray) {
                    NSLog(@"LeftMenuVC: %@",dInner);
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:4]];
                    count++;
                }
                [addValueArray removeObjectsInArray:tmpArray];
                [tableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            }
            
        }
    }
    else
    {
//        NSIndexPath *indexPathTmp = [NSIndexPath indexPathForRow:(numberOfRowsInLastSection - 1) inSection:(numberOfSections - 1)];
        if(indexPath.section == 0)
        {
            [[AppDelegate initAppdelegate].tabbar setSelectedIndex:0];
            [[SlideNavigationController sharedInstance] toggleLeftMenu];
        }
        
        
        if(indexPath.section == 1){
//            [[SlideNavigationController sharedInstance] toggleLeftMenu];
//            CalendarVC *calVC = [[CalendarVC alloc] init];
            [[SlideNavigationController sharedInstance] toggleLeftMenu];
//            [self presentViewController:calVC animated:YES completion:nil];
//            [self.navigationController pushViewController:calVC animated:YES];
            
            UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
            NSArray *viewControlles = navcon.viewControllers;
            BOOL isExist=false;
            for (int i = 0 ; i <viewControlles.count; i++){
                if ([[viewControlles objectAtIndex:i] isKindOfClass:[CalendarVC  class]]) {
                    //Execute your code
                    CalendarVC *calendar=(CalendarVC *)[viewControlles objectAtIndex:i];
                    isExist=true;
                    calendar.fromWhichVC=@"Calander";
                    [navcon popToViewController:calendar animated:false];
                    break;
                }
            }
            if(!isExist){
                CalendarVC *calendar=(CalendarVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
                calendar.fromWhichVC=@"Calander";
                [navcon pushViewController:calendar animated:false];
            }
        }
        if(indexPath.section == 2){
            //            [[SlideNavigationController sharedInstance] toggleLeftMenu];
            //            CalendarVC *calVC = [[CalendarVC alloc] init];
            [[SlideNavigationController sharedInstance] toggleLeftMenu];
            //            [self presentViewController:calVC animated:YES completion:nil];
            //            [self.navigationController pushViewController:calVC animated:YES];
            
            UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
            NSArray *viewControlles = navcon.viewControllers;
            BOOL isExist=false;
            for (int i = 0 ; i <viewControlles.count; i++){
                if ([[viewControlles objectAtIndex:i] isKindOfClass:[CalendarVC  class]]) {
                    //Execute your code
                    CalendarVC *calendar=(CalendarVC *)[viewControlles objectAtIndex:i];
                    isExist=true;
                    calendar.fromWhichVC=@"GroupCalander";
                    [navcon popToViewController:calendar animated:false];
                    break;
                }
            }
            if(!isExist){
                CalendarVC *calendar=(CalendarVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
                calendar.fromWhichVC=@"GroupCalander";
                [navcon pushViewController:calendar animated:false];
            }
        }
        if(indexPath.section == 3)
        {
            [[SlideNavigationController sharedInstance] toggleLeftMenu];
            
            UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
            NSArray *viewControlles = navcon.viewControllers;
            BOOL isExist=false;
            for (int i = 0 ; i <viewControlles.count; i++){
                if ([[viewControlles objectAtIndex:i] isKindOfClass:[WebviewVC  class]]) {
                    //Execute your code
                    WebviewVC *wvc=(WebviewVC *)[viewControlles objectAtIndex:i];
                    isExist=true;
                    [navcon popToViewController:wvc animated:false];
                    //objc=[viewControlles objectAtIndex:i];
                    //objc.objMessage_user=objuser;
                    break;
                }
            }
            if(!isExist){
                WebviewVC *wvc=(WebviewVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"WebviewVC"];
                //            →MainUrl+ "/mobile_auth.asp?key=" + encp +
                //            "&topage=mobile_dashboard.asp&screenwidth="
                NSString *urlString = [NSString stringWithFormat:                                       @"%@/mobile_auth.asp?key=%@&topage=mobile_dashboard.asp&screenwidth=",MAIN_URL,[BaseApplication getEncryptedKey]];
                wvc.resUrlStr=urlString;
                wvc.strPageTitle=@"";
                [navcon pushViewController:wvc animated:false];
            }
        }
        
        
            NSDictionary *dictionary=[tblDataArray objectAtIndex:indexPath.section];
//            NSString *lblText=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Value"]];
            NSString *keyText=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Key"]];
            if ([keyText isEqualToString:@"Home"]){
                [[AppDelegate initAppdelegate].tabbar setSelectedIndex:0];
//                [[SlideNavigationController sharedInstance] toggleLeftMenu];
            }
            else if ([keyText isEqualToString:@"Banner - Accounts"]) {
               [[AppDelegate initAppdelegate].tabbar setSelectedIndex:1];
               [[SlideNavigationController sharedInstance] toggleLeftMenu];
            }else if ([keyText isEqualToString:@"Banner - Contacts"]) {
                [[AppDelegate initAppdelegate].tabbar setSelectedIndex:2];
                [[SlideNavigationController sharedInstance] toggleLeftMenu];

            }else if ([keyText isEqualToString:@"Case"]) {
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[CaseVC  class]]) {
                            //Execute your code
                        CaseVC *wvc=(CaseVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    CaseVC *wvc=(CaseVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CaseVC"];
                    [navcon pushViewController:wvc animated:false];
                }
            }
            else if ([keyText isEqualToString:@"Opportunity"]) {
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[OpportunityVC  class]]) {
                        //Execute your code
                        OpportunityVC *wvc=(OpportunityVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    OpportunityVC *wvc=(OpportunityVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"OpportunityVC"];
                    [navcon pushViewController:wvc animated:false];
                }
            }
            else if ([keyText isEqualToString:@"Events"]) {
                NSString *urlString = [NSString stringWithFormat:@"%@/mobile_auth.asp?key=%@&topage=mobile_calWeek.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
                [self openWebViewMethodForAdd:urlString mTitle:@""];
//                [self callBack];
            }else if ([keyText isEqualToString:@"My Searches"]) {
                
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[SearchVC  class]]) {
                        //Execute your code
                        SearchVC *wvc=(SearchVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    SearchVC *wvc=(SearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
                    [navcon pushViewController:wvc animated:false];
                }

                
            }else if ([keyText isEqualToString:@"Quote"]) {
                
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[QuotesVC  class]]) {
                        //Execute your code
                        QuotesVC *wvc=(QuotesVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    QuotesVC *wvc=(QuotesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"QuotesVC"];
                    [navcon pushViewController:wvc animated:false];
                }

                
            }else if ([keyText isEqualToString:@"Recent Items"]) {
                [[AppDelegate initAppdelegate].tabbar setSelectedIndex:3];
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
            }else if ([keyText isEqualToString:@"Shortcuts"]) {
                
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[ShortCutsVC  class]]) {
                        //Execute your code
                        ShortCutsVC *wvc=(ShortCutsVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    ShortCutsVC *wvc=(ShortCutsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShortCutsVC"];
                    [navcon pushViewController:wvc animated:false];
                }

                
            }else if ([keyText isEqualToString:@"Logout"]) {
               
            }
            else if ([keyText isEqualToString:@"Library"]) {
                
                [[SlideNavigationController sharedInstance] toggleLeftMenu];
                UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
                NSArray *viewControlles = navcon.viewControllers;
                BOOL isExist=false;
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[LibraryVC  class]]) {
                        //Execute your code
                        LibraryVC *wvc=(LibraryVC *)[viewControlles objectAtIndex:i];
                        isExist=true;
                        [navcon popToViewController:wvc animated:false];
                        break;
                    }
                }
                if(!isExist){
                    LibraryVC *wvc=(LibraryVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"LibraryVC"];
                    [navcon pushViewController:wvc animated:false];
                }
                
                
            }
        
            
            // Code for logout
            
//        if(indexPathTmp == indexPath)
//            {
//                //            manager.getMainUrl(MainActivity.this) + "/mobile_auth.asp?key=" + encp + "&topage=index_logoff.asp";
//            [[SlideNavigationController sharedInstance] toggleLeftMenu];
//            
//            NSString *urlString = [NSString stringWithFormat:
//                                   @"%@/mobile_auth.asp?key=%@&topage=index_logoff.asp",MAIN_URL,[BaseApplication getEncryptedKey]];
//            NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *url = [NSURL URLWithString:webStringURL];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            
//            webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66,WIDTH,HEIGHT)];
//            webview.delegate = self;
//            SHOWLOADING(@"Wait...");
//                //            webview.hidden = YES;
//            [webview loadRequest:urlRequest];
//            [self.view addSubview:webview];
//            
//            }
        
            //This code is for hide Add section.
        if (addValueArray.count>1) {
            NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithArray:addValueArray];
            [tmpArray mutableCopy];
            [tmpArray removeObjectAtIndex:0];
            NSUInteger count=1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *dInner in tmpArray) {
                NSLog(@"LeftMenuVC: %@",dInner);
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:4]];
                count++;
            }
            [addValueArray removeObjectsInArray:tmpArray];
            [tableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}

-(void)openWebViewMethodForAdd :(NSString *)urlStr mTitle:(NSString *)title{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    NSArray *viewControlles = navcon.viewControllers;
    BOOL isExist = false;
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
        wvc.resUrlStr = urlStr;
        wvc.strPageTitle = title;
        [navcon pushViewController:wvc animated:false];
    }
}

-(void)refreshTableData
{
    if (privillageArray.count>0&&displayLblArray.count>0) {
        
        NSDictionary *mDict = @{@"Key":@"key",@"Value":@""};
        NSMutableArray *arrValue1 = [[NSMutableArray alloc]init];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        [arrValue1 addObject:mDict];
        
//        NSDictionary *mDict1 = @{@"Key":@"key",@"Value":@""};
        NSMutableArray *arrAddValue = [[NSMutableArray alloc]init];
        
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        [arrAddValue addObject:mDict];
        
        NSDictionary *dic1=@{@"Key":@"Home",@"Value":@"Home"};
        [tblDataArray addObject:dic1];
        [arrValue1 replaceObjectAtIndex:0 withObject:dic1];
        NSDictionary *dicCal=@{@"Key":@"My Calendar",@"Value":@"My Calendar"};
        [tblDataArray addObject:dicCal];
        [arrValue1 replaceObjectAtIndex:1 withObject:dicCal];

        NSDictionary *dicGroupCal=@{@"Key":@"Group Calendar",@"Value":@"Group Calendar"};
        [tblDataArray addObject:dicGroupCal];
        [arrValue1 replaceObjectAtIndex:2 withObject:dicGroupCal];
        
        NSDictionary *dic2=@{@"Key":@"Dashboard",@"Value":@"Dashboard"};
        [tblDataArray addObject:dic2];
        [arrValue1 replaceObjectAtIndex:3 withObject:dic2];
        
        NSDictionary *dic3=@{@"Key":@"Add",@"Value":@"Add"};
        [tblDataArray addObject:dic3];
        [arrValue1 replaceObjectAtIndex:4 withObject:dic3];
       
        for (NSDictionary *tmpDicForLbl in displayLblArray) {
            NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
            NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];
            
            if ([keyStr isEqualToString:@"Events"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:5 withObject:tmpDicForLbl];

                NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                [tmpDataAddDic setValue:@"Add Call Back/Event" forKey:@"Value"];
                [addValueTmpArray addObject:tmpDataAddDic];
                [arrAddValue replaceObjectAtIndex:6 withObject:tmpDataAddDic];
                
            }
            if ([keyStr isEqualToString:@"Shortcuts"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:6 withObject:tmpDicForLbl];

            }
            else if([keyStr isEqualToString:@"Banner - Accounts"]&&![valueStr isEqualToString:@""])
            {
                NSString *statusStr=[NSString stringWithFormat:@"%@",[[privillageArray firstObject] valueForKey:@"AccountLink"]];
                if ([statusStr isEqualToString:@"true"]) {
                    [tblDataArray addObject:tmpDicForLbl];
                    [arrValue1 replaceObjectAtIndex:7 withObject:tmpDicForLbl];
                    NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                    [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                    [tmpDataAddDic setValue:@"Add Record" forKey:@"Value"];
                    [addValueTmpArray addObject:tmpDataAddDic];
                    [arrAddValue replaceObjectAtIndex:0 withObject:tmpDataAddDic];

                }
            }
            else if([keyStr isEqualToString:@"Banner - Contacts"]&&![valueStr isEqualToString:@""]) {
                NSString *statusStr=[NSString stringWithFormat:@"%@",[[privillageArray firstObject] valueForKey:@"ContactLink"]];
                if ([statusStr isEqualToString:@"true"]) {
                    [tblDataArray addObject:tmpDicForLbl];
                    [arrValue1 replaceObjectAtIndex:8 withObject:tmpDicForLbl];
                    
                    NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                    [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                    [tmpDataAddDic setValue:@"Add Contacts" forKey:@"Value"];
                    [addValueTmpArray addObject:tmpDataAddDic];
                    [arrAddValue replaceObjectAtIndex:1 withObject:tmpDataAddDic];

                    
                }
            }else if([keyStr isEqualToString:@"Opportunity"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:9 withObject:tmpDicForLbl];
                
                NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                [tmpDataAddDic setValue:@"Add Opportunity" forKey:@"Value"];
                [addValueTmpArray addObject:tmpDataAddDic];
                [arrAddValue replaceObjectAtIndex:2 withObject:tmpDataAddDic];

                
            }else if([keyStr isEqualToString:@"Quote"]&&![valueStr isEqualToString:@""]) {
                NSString *statusStr=[NSString stringWithFormat:@"%@",[[privillageArray firstObject] valueForKey:@"ShowQuote"]];
                if ([statusStr isEqualToString:@"true"]) {
                    [tblDataArray addObject:tmpDicForLbl];
                    [arrValue1 replaceObjectAtIndex:10 withObject:tmpDicForLbl];
                    
                    NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                    [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                    [tmpDataAddDic setValue:@"Add Quote" forKey:@"Value"];
                    [addValueTmpArray addObject:tmpDataAddDic];
                    [arrAddValue replaceObjectAtIndex:3 withObject:tmpDataAddDic];

                    
                }
            }else if([keyStr isEqualToString:@"Case"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:11 withObject:tmpDicForLbl];
                
                NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                [tmpDataAddDic setValue:[NSString stringWithFormat:@"Add %@",valueStr] forKey:@"Value"];
                [addValueTmpArray addObject:tmpDataAddDic];
                [arrAddValue replaceObjectAtIndex:6 withObject:tmpDataAddDic];

                
            }else if([keyStr isEqualToString:@"My Searches"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:12 withObject:tmpDicForLbl];
            }else if([keyStr isEqualToString:@"Recent Items"]&&![valueStr isEqualToString:@""]) {
                [tblDataArray addObject:tmpDicForLbl];
                [arrValue1 replaceObjectAtIndex:13 withObject:tmpDicForLbl];
            }else if([keyStr isEqualToString:@"Sales Rep Comments/Notes"]&&![valueStr isEqualToString:@""]) {
                    //                [tblDataArray addObject:tmpDicForLbl];
                NSMutableDictionary *tmpDataAddDic=[[NSMutableDictionary alloc]init];
                [tmpDataAddDic setValue:keyStr forKey:@"Key"];
                [tmpDataAddDic setValue:@"Add Sales Rep Comments/Notes" forKey:@"Value"];
                [addValueTmpArray addObject:tmpDataAddDic];
                [arrAddValue replaceObjectAtIndex:4 withObject:tmpDataAddDic];

            }
        }
        arrSortLable = [[NSMutableArray alloc]init];
        NSDictionary *dic5=@{@"Key":@"Library",@"Value":@"Library"};
        [tblDataArray addObject:dic5];
        [arrValue1 replaceObjectAtIndex:14 withObject:dic5];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = [arrValue1 mutableCopy];
        
        NSMutableArray *arrAd = [[NSMutableArray alloc]init];
        arrAd = [arrAddValue mutableCopy];

        
        int i = 0,j = 0;
        [tblDataArray mutableCopy];
        
        NSMutableArray *arrKeyTmp = [[NSMutableArray alloc]init];
        
        for (NSDictionary *d in arr) {
            if([[d objectForKey:@"Key"] isEqualToString:@"key"])
            {
//                if(i < tblDataArray.count)
//                    [arrValue1 removeObjectAtIndex:i];
//                [arrKeyTmp addObject:i];
                
            }
            else
            {
                [arrKeyTmp addObject:d];
            }
            i++;
        }
        tblDataArray = [arrKeyTmp mutableCopy];
        NSMutableArray *arrAddKeyTmp = [[NSMutableArray alloc]init];
        
        for (NSDictionary *d in arrAd) {
            if([[d objectForKey:@"Key"] isEqualToString:@"key"])
            {
//                [arrAddValue removeObjectAtIndex:j];
                
            }
            else
            {
                [arrAddKeyTmp addObject:d];
            }
            j++;
        }
        addValueTmpArray = [arrAddKeyTmp mutableCopy];
        NSLog(@"");
        [_tableView reloadData];
    }
}

-(void)callBack:(UITapGestureRecognizer *)longPress{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    UINavigationController *navcon = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    NSArray *viewControlles = navcon.viewControllers;
    BOOL isExist=false;
    for (int i = 0 ; i <viewControlles.count; i++){
        if ([[viewControlles objectAtIndex:i] isKindOfClass:[CallBackTasks  class]]) {
            //Execute your code
            CallBackTasks *wvc=(CallBackTasks *)[viewControlles objectAtIndex:i];
//            isExist=true;
            [navcon popToViewController:wvc animated:false];
            break;
        }
    }
    if(!isExist){
        CallBackTasks *wvc=(CallBackTasks *)[self.storyboard instantiateViewControllerWithIdentifier:@"CallBackTasks"];
        [navcon pushViewController:wvc animated:false];
    }

}

-(void)serviceForPrivilages
{
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":[mDictionary1 objectForKey:@"LogonID"]},
                                                                    @{@"CompanyID":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]}]];
        //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:LOGONPRIV arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"Documents %@",document);
        
        
        arrMenu = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[document firstChild] firstChild];
        
        if (!rootDoctument)
            {
                //            _tblActivity.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"GetLogonPrivilegesResult"])
                {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                if([doc valueWithPath:@"ReviewAndTakeAct"]){
                    [arrMenu addObject:[doc valueWithPath:@"ReviewAndTakeAct"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ReviewAndTakeAct"] forKey:@"ReviewAndTakeAct"];
                }
                
                if([doc valueWithPath:@"ViewSalesProgress"]){
                    [arrMenu addObject:[doc valueWithPath:@"ViewSalesProgress"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ViewSalesProgress"] forKey:@"ViewSalesProgress"];
                }
                
                if([doc valueWithPath:@"FullEdit"]){
                    [arrMenu addObject:[doc valueWithPath:@"FullEdit"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"FullEdit"] forKey:@"FullEdit"];
                }
                if([doc valueWithPath:@"AssignCallBack"]){
                    [arrMenu addObject:[doc valueWithPath:@"AssignCallBack"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"AssignCallBack"] forKey:@"AssignCallBack"];
                }
                if([doc valueWithPath:@"AccountLink"]){
                    [arrMenu addObject:[doc valueWithPath:@"AccountLink"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"AccountLink"] forKey:@"AccountLink"];
                }
                
                if([doc valueWithPath:@"ContactLink"]){
                    [arrMenu addObject:[doc valueWithPath:@"ContactLink"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ContactLink"] forKey:@"ContactLink"];
                }
                if([doc valueWithPath:@"RecordOnMap"]){
                    [arrMenu addObject:[doc valueWithPath:@"RecordOnMap"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"RecordOnMap"] forKey:@"RecordOnMap"];
                }
                if([doc valueWithPath:@"DefaultPage"]){
                    [arrMenu addObject:[doc valueWithPath:@"DefaultPage"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"DefaultPage"] forKey:@"DefaultPage"];
                }
                if([doc valueWithPath:@"ShowQuote"]){
                    [arrMenu addObject:[doc valueWithPath:@"ShowQuote"]];
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ShowQuote"] forKey:@"ShowQuote"];
                }
                if([doc valueWithPath:@"ISO_Code"]){
                    [arrMenu addObject:[doc valueWithPath:@"ISO_Code"]];
                    [tmpDataDic setValue:[doc valueWithPath:@"ISO_Code"] forKey:@"ISO_Code"];
                }
                [privillageArray addObject:tmpDataDic];
                [AppDelegate initAppdelegate].allPrivillageArray = [privillageArray mutableCopy];
                }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self refreshTableData];
            });
            
            
            }
        
    }];
    
}

-(void)serviceForCusustomLabels
{
    NSString *str = @"Banner - Accounts^Contact^Company^Banner - Contacts^Lead Status^Entered^Campaign^Events^Event Name^Event^Shortcuts^My Searches^Recent Items^Acct Mgr^Opportunity^Case^Sales Rep Comments/Notes^Record^Opportunity Name^Phone^Cases^Banner - Library^Quote^Sales Rep Comments/Notes^Banner - Calendar^Shortcuts^Event Done^Quote Name^Company^First Name^Last Name^Case Date Due^Subject^Case Status^Case Priority^Case Owner^Key Contact^Lead_Source^Event Start Time^Opportunity Sales Stage^List Source^Sales Rep Comments/Notes^Total Opportunity Value";
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":[mDictionary1 objectForKey:@"LogonID"]},
                                                                    @{@"CompanyID":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"LabelName":str}]];
        //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GETCUSTLABELS arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"Documents %@",document);
        
        arrMenu = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
            {
                //            _tblActivity.hidden = true;
            }
        else
            {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
                {
                if([doc valueWithPath:@"Value"])
                    {
                    [arrValue addObject:[doc valueWithPath:@"Value"]];
                    [dictLabel setObject:[doc valueWithPath:@"Value"] forKey:[doc valueWithPath:@"Key"]];
                    
                    NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                    [tmpDataDic setValue:[doc valueWithPath:@"Value"] forKey:@"Value"];
                    [tmpDataDic setValue:[doc valueWithPath:@"Key"] forKey:@"Key"];
                    [displayLblArray addObject:tmpDataDic];
                    }
                
                }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self refreshTableData];
                [AppDelegate initAppdelegate].allDisplayLblArray = [displayLblArray mutableCopy];
                
                displayLblArray=[[NSMutableArray alloc]init];
                
                    //                STOPLOADING();
            });
            }
        
    }];
    
}
/*
 fa_icon_assign => &#xf0c0;
 fa_icon_select => &#xf00c;
 fa_icon_map => &#xf041;
 fa_icon_delete => &#xf1f8;
 fa_icon_call => &#xf095;
 fa_calendar => &#xf073;
 fa_plus => &#xf067;
 fa_edit => &#xf044;
 fa_url => &#xf0ac;
 fa_search => &#xf002;
 fa_assign => &#xf29a;
 fa_settings => &#xf013;
 fa_dashboard => &#xf0e4;
 fa_account => &#xf1ec;
 fa_contact => &#xf007;
 fa_recentitems => &#xf017;
 fa_myshortcut => &#xf122;
 fa_callback => &#xf274;
 fa_home => &#xf015;
 fa_email => &#xf003;
 fa_refresh => &#xf021;
 fa_visible => &#xf06e;
 fa_back => &#xf060;
 
 */


    //WEbview delegate methods

    // Delegate methods
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
  
    NSLog(@"start");
   
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    STOPLOADING();
        //    [webview removeFromSuperview];
    if (isLogout)
    {
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
        isLogout = false;
    
    }
    
    
    NSLog(@"finish");
}

@end
