//
//  OpportunityVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 07/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "OpportunityVC.h"
#import "Static.h"
#import "BaseApplication.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"

@implementation OpportunityCell


@end

@interface OpportunityVC ()

@end

@implementation OpportunityVC
{
    int count1,startIndex,endIndex;
    UIWebView *accWebview;
    BOOL isWeb;
    NSMutableArray *arrDisplayLbl,*arrPhone,*arrCompany,*arrOpportunity,*arrAccManager,*arrOppStage;
    NSMutableArray *arrOppTotal,*arrRecordNo,*arrOppID,*arrKeyValue,*arrlblDictionary,*arrRECNo;

}
@synthesize strOppSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}


-(void)setUpView
{
    isWeb = true;
    arrPhone = [[NSMutableArray alloc]init];
    arrCompany = [[NSMutableArray alloc]init];
    arrOpportunity = [[NSMutableArray alloc]init];
    arrAccManager = [[NSMutableArray alloc]init];
    arrOppStage = [[NSMutableArray alloc]init];
    arrOppTotal = [[NSMutableArray alloc]init];
    arrRecordNo = [[NSMutableArray alloc]init];
    arrRECNo = [[NSMutableArray alloc]init];
    arrOppID = [[NSMutableArray alloc]init];

    arrDisplayLbl = [[NSMutableArray alloc]init];
    arrKeyValue = [[NSMutableArray alloc]init];
    arrlblDictionary = [[NSMutableArray alloc]init];
   
    _txtOppSearch.text = strOppSearch;
    _txtOppSearch.delegate = self;
    
    startIndex = 1;
    endIndex = 15;
    
    SHOWLOADING(@"Wait...");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForCount:strOppSearch];
        [self serviceForOpportunityData:[@(startIndex) stringValue] and:[@(endIndex) stringValue] comp:strOppSearch];
        STOPLOADING();
    });
    
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (accWebview) {
        [accWebview removeFromSuperview];
        
    }
//    self.lblTitle.text = getHeaderTitle;
     [self setUpView];
    [self setFonts_Background];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)removeView
{
    if (accWebview) {
        [accWebview removeFromSuperview];
        [self setUpView];

    }
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (arrDisplayLbl.count == 1)
//    {
//        return 130;
//    }
//    else if (arrDisplayLbl.count == 2)
//    {
//        return 150;
//    }
//    else if (arrDisplayLbl.count == 3)
//    {
//        return 170;
//        
//    }
//    else if (arrDisplayLbl.count == 4)
//    {
//        return 290;
//        
//    }
//    else if (arrDisplayLbl.count == 5)
//    {
//        return 210;
//        
//    }
//    else if (arrDisplayLbl.count == 6)
//    {
//        return 230;
//    }
    return 270;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrKeyValue.count;
//    return arrDisplayLbl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpportunityCell *cell = (OpportunityCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[OpportunityCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    
    cell.btnMap.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnMap setTitle:@"\uf041" forState:UIControlStateNormal];
    
    cell.btnPhone.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnPhone setTitle:@"\uf095" forState:UIControlStateNormal];
    
    cell.btnSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnSelect setTitle:@"\uf00c" forState:UIControlStateNormal];
    
    //    cell.btnAssign.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    //    [cell.btnAssign setTitle:@"\uf0c0" forState:UIControlStateNormal];
    [cell.btnAssign setBackgroundImage:[UIImage imageNamed:@"assign"] forState:UIControlStateNormal];
    
    cell.btnDelete.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnDelete setTitle:@"\uf014" forState:UIControlStateNormal];
    
    cell.btnSelect.tag = [[arrOppID objectAtIndex:indexPath.row] integerValue];
    
    cell.btnSelect.accessibilityLabel = [NSString stringWithFormat:@"%@",[arrRECNo objectAtIndex:indexPath.row]];
    
    
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnAssign.tag = [[arrOppID objectAtIndex:indexPath.row] integerValue];
    NSString *tmpCaseIDStr=[NSString stringWithFormat:@"%@",[arrRECNo objectAtIndex:indexPath.row]];
    
    cell.btnAssign.accessibilityLabel = tmpCaseIDStr;
    
    
    [cell.btnAssign addTarget:self action:@selector(callForAssign:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.btnDelete.tag = [[arrOppID objectAtIndex:indexPath.row] integerValue];
    cell.btnDelete.accessibilityLabel = tmpCaseIDStr;
    
    [cell.btnDelete addTarget:self action:@selector(callForDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPhone.tag = indexPath.row;
    [cell.btnPhone addTarget:self action:@selector(callForPhonecall:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *dictionary=[arrKeyValue objectAtIndex:indexPath.row];
    if ([dictionary valueForKey:@"Phone"])
    {
        if(![[dictionary valueForKey:@"Phone"] isEqualToString:@"none"])
        {
            cell.btnPhone.hidden = NO;
            cell.btnMap.frame = CGRectMake(CGRectGetMinX(cell.btnPhone.frame)-(7+cell.btnMap.frame.size.width), cell.btnMap.frame.origin.y,cell.btnMap.frame.size.width,cell.btnMap.frame.size.height);
        }
        else
        {
            cell.btnPhone.hidden = YES;
            cell.btnMap.frame = cell.btnPhone.frame;
        }
    }
    else
    {
        cell.btnPhone.hidden = YES;
        
    }
 
    
    if (arrDisplayLbl.count == 1)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];          //[arrDisplayLbl
    }
    if (arrDisplayLbl.count == 2)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.vlbl2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-100,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    }
    if (arrDisplayLbl.count == 3)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.vlbl2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.vlbl3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-80,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
    }
    if (arrDisplayLbl.count == 4)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.vlbl2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.vlbl3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.vlbl4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-60,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
    }
    if (arrDisplayLbl.count == 5)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.vlbl2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.vlbl3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.vlbl4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.vlbl5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-40,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    }
    if (arrDisplayLbl.count == 6)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.vlbl1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.vlbl2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.vlbl3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.vlbl4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.vlbl5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.lbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.vlbl6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-20,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    }

    cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.frame.size.height-cell.btnView.frame.size.height,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    cell.lbl1.font = SET_FONTS_REGULAR;
    cell.lbl2.font = SET_FONTS_REGULAR;
    cell.lbl3.font = SET_FONTS_REGULAR;
    cell.lbl4.font = SET_FONTS_REGULAR;
    cell.lbl5.font = SET_FONTS_REGULAR;
    cell.lbl6.font = SET_FONTS_REGULAR;
    cell.vlbl1.font = SET_FONTS_REGULAR;
    cell.vlbl2.font = SET_FONTS_REGULAR;
    cell.vlbl3.font = SET_FONTS_REGULAR;
    cell.vlbl4.font = SET_FONTS_REGULAR;
    cell.vlbl5.font = SET_FONTS_REGULAR;
    cell.vlbl6.font = SET_FONTS_REGULAR;
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtOppSearch resignFirstResponder];
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;

        [self selectWebview:[[arrRECNo objectAtIndex:indexPath.row] integerValue] caseID:[[arrRECNo objectAtIndex:indexPath.row] integerValue]];
    
}


//Select button method

-(void)callForSelect:(UIButton *)btn
{
    [self selectWebview:btn.tag caseID:[btn.accessibilityLabel integerValue]];
}

-(void)selectWebview:(NSInteger)recID caseID:(NSInteger)caseID
{
//    /MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_opportunity_EditForm.asp&RECDNO=" + 	Record_id + "&CompanyID=" + WGID + 	"&appkeyword=&pagetype=opportunity&oppid=" + Opp_id;
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_opportunity_EditForm.asp&RECDNO=%ld&CompanyID=%@&appkeyword=%@&pagetype=opportunity&oppid=%ld",MAIN_URL,[BaseApplication getEncryptedKey],(long)caseID,WORKGROUP,@"",(long)recID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.width - 113)];
        //        NSLog(@"Landscape");
    } else {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
        //        NSLog(@"Portrait");
    }
    [accWebview loadRequest:urlRequest];
    [self.view addSubview:accWebview];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        accWebview.frame = CGRectMake(0, 65,WIDTH, [UIScreen mainScreen].bounds.size.height - 114);
        //        NSLog(@"Portrait");
    } else {
        accWebview.frame = CGRectMake(0, 65,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 114);
        //        NSLog(@"Landscape");
    }
    
}


//Assign button method

-(void)callForAssign:(UIButton *)btn
{
    
//    MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&	cid=" +WGID + "&RECDNO=" + Record_id + "&appkeyword= 	&pagetype=opportunity";

    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&cid=%@&RECDNO=%ld&appkeyword=&pagetype=case",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP,(unsigned long)[btn.accessibilityLabel integerValue]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [accWebview loadRequest:urlRequest];
    [self.view addSubview:accWebview];
}

//Delete method button
-(void) callForDeleteRecord:(UIButton *)btn
{
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                     message:@"Are you sure want to delete this record?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"OK"];
    
    
    alert.tag = btn.tag;
    [alert show];
    
    
}

//call for Phonecall
-(void)callForPhonecall:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@",[arrPhone objectAtIndex:btn.tag]];
    
    if(![str isEqualToString:@"none"])
    {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:str];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}
- (IBAction)AccountSidebar:(id)sender
{
    [[SlideNavigationController sharedInstance]toggleLeftMenu];
    
}


#pragma mark - AlertView method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    NSString *serviceType;
    NSMutableArray *tArray;
    NSString *responseTag;
    NSString *childTag;
    
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        //  if (alertView.tag) {
       NSString *data = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
        serviceType = DELETE_OPP;
        responseTag = @"DeleteOppResponse";
        childTag = @"DeleteOppResult";
        tArray=[[NSMutableArray alloc] initWithArray:@[@{@"oppID":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
        
        SHOWLOADING(@"Wait...")
        
        [BaseApplication executeRequestwithService:serviceType arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
            NSError *err=[[NSError alloc] init];
            SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
            
            NSLog(@"document :: %@",document);
            
            SMXMLElement *rootDoctument = [document firstChild];
            
            if (!rootDoctument)
            {
                //            _tblEvents.hidden = true;
            }
            else
            {
                for (SMXMLElement *doc in [rootDoctument childrenNamed:responseTag])
                {
                    if([doc valueWithPath:childTag])
                    {
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                                         message:@"Record deleted successfully"
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles: nil];
                        [alert show];
                        strOppSearch = @"";
                        _txtOppSearch.text=@"";
                        [self serviceForCount:strOppSearch];
                        [self serviceForOpportunityData:@"1" and:@"15" comp:strOppSearch];
                    }
                }
            }
                        
        }];
        
    }
    
    
    
}

-(void)serviceForCount:(NSString *)company
{
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"oppname":company}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:OPP_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"document :: %@",document);
        
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
                    count1 = [[doc valueWithPath:@"SearchOpportunityCountResult"] intValue];
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count1] forKey:Key_Acc_count];
                    _btnPrevious.hidden = YES;
                    _btnNext.hidden = YES;
                    if (count1>15)
                    {
                        _btnNext.hidden = NO;
                    }
                    
                }
            }
        }
        
    }];
    
}


-(void)serviceForOpportunityData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"company_id":WORKGROUP},@{@"oppname":company}]];
    SHOWLOADING(@"Wait...")
    [BaseApplication executeRequestwithService:SEARCH_OPPORTUNITY_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"tArray1 :: %@",tArray1);
        
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
            
        {
            arrlblDictionary= [[NSMutableArray alloc]init];
            arrDisplayLbl = [[NSMutableArray alloc]init];
            for (NSDictionary *tmpDicForLbl in [AppDelegate initAppdelegate].allDisplayLblArray)
            {
                NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
                NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                if ([keyStr isEqualToString:@"OppName"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"Company"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                    //  NSLog(@"AccValue%@",valueStr);
                }
                else if([keyStr isEqualToString:@"Opportunity Sales Stage"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"Opportunity"]&&![valueStr isEqualToString:@""])
                    
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"EE_REP"]&&![valueStr isEqualToString:@""])//Acct Mgr
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"PRI_PHONE"]&&![valueStr isEqualToString:@""])//Acct Mgr
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                }
                [arrlblDictionary addObject:tmpDataDic];
                
            }
//            NSLog(@"Display lbl  %@::%ld",arrDisplayLbl,arrDisplayLbl.count);
            arrKeyValue = [[NSMutableArray alloc]init];
            arrRecordNo = [[NSMutableArray alloc]init];
            arrPhone = [[NSMutableArray alloc]init];
            arrRECNo = [[NSMutableArray alloc]init];
            
            
           
            //NSLog(@"111 :%@",arrlblDictionary);
            
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeOpportunityData"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"OppName"])
                    {
                        if([doc valueWithPath:@"OppName"])
                            [tmpDataDic setValue:[doc valueWithPath:@"OppName"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                    
                    if ([[d objectForKey:@"key"]isEqualToString:@"Company"])
                    {
                        if([doc valueWithPath:@"Company"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Company"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                    }
                    if ([[d objectForKey:@"key"]isEqualToString:@"Opportunity Sales Stage"])
                    {
                        if([doc valueWithPath:@"SalesStage"])
                            [tmpDataDic setValue:[doc valueWithPath:@"SalesStage"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                    if ([[d objectForKey:@"key"]isEqualToString:@"Opportunity"])
                    {
                        if([doc valueWithPath:@"OppTotal"])
                            [tmpDataDic setValue:[doc valueWithPath:@"OppTotal"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                    
                    if ([[d objectForKey:@"key"]isEqualToString:@"EE_REP"])
                    {
                        if([doc valueWithPath:@"AcctMgr"])
                        {
                            [tmpDataDic setValue:[doc valueWithPath:@"AcctMgr"] forKey:[d objectForKey:@"value"]];
                            
                        }
                        else
                        {
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        }
                    }
                    
                    if ([[d objectForKey:@"key"]isEqualToString:@"PRI_PHONE"]) //Acct Mgr
                    {
                        if([doc valueWithPath:@"Phone"]){
                            [tmpDataDic setValue:[doc valueWithPath:@"Phone"] forKey:[d objectForKey:@"value"]];
                            [arrPhone addObject:[doc valueWithPath:@"Phone"]];
                        }
                        else{
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                            [arrPhone addObject:@"none"];
                            
                        }
                    }
                    
                }
                
                if([doc valueWithPath:@"RecordID"])
                {
                    [arrRecordNo addObject:[doc valueWithPath:@"RecordID"]];
                    
                }
                if([[doc valueWithPath:@"RECDNO"] integerValue]==0)
                {
                    _tblOpportunity.hidden = YES;
                    _lblinfo.hidden = NO;
                    [arrRECNo addObject:[doc valueWithPath:@"RECDNO"]];
                    
                }
                else
                {
                    _tblOpportunity.hidden = NO;
                    _lblinfo.hidden = YES;
                    [arrRECNo addObject:[doc valueWithPath:@"RECDNO"]];

                    
                }
                
                if([doc valueWithPath:@"OPPID"])
                {
                    [arrOppID addObject:[doc valueWithPath:@"OPPID"]];
                    
                }
//                if([doc valueWithPath:@"RECDNO"])
//                {
//                    [arrRECNo addObject:[doc valueWithPath:@"RECDNO"]];
//                    
//                }

                [arrKeyValue addObject:tmpDataDic];
            }
            
            // NSLog(@"12 :%@",arrKeyValue);
            // NSLog(@"11 :%@",arrlblDictionary);
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblOpportunity reloadData];
                [_txtOppSearch resignFirstResponder];
                
                if(([endIndex1 intValue] >= count1) || (count1 <= 15))
                {
                    _lblCount.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count1,count1];
                    
                }
                else
                {
                    _lblCount.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count1];
                    
                }
                if(count1 == 0)
                {
                    _lblCount.text = @"Record Not Found";
                }
                
                STOPLOADING();
            });
            
        }
        
    }];
}



- (IBAction)oppSideMenu:(id)sender {
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    } else {
        _txtOppSearch.text = strOppSearch;
        [accWebview removeFromSuperview];
        //        isWeb = false;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
}
- (IBAction)next:(id)sender {
    _btnPrevious.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    
    
    if(endIndex < count1)
    {
        [self serviceForOpportunityData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strOppSearch];
    }
    else
    {
        [self serviceForOpportunityData:[@(startIndex)stringValue] and:[@(count1)stringValue] comp:strOppSearch];
        _btnNext.hidden = true;
    }
}

- (IBAction)previous:(id)sender {
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    
    
    [self serviceForOpportunityData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strOppSearch];
    
    
    if (endIndex<=15) {
        _btnPrevious.hidden = YES; 
        _btnNext.hidden = NO;
        
    }else{
        if (endIndex < count1) {
            _btnNext.hidden = NO;
        }
    }

}

#pragma mark - Searchbar delegate methods

//Searchbar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    strOppSearch = @"";
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        //        [arrOffer removeAllObjects];
        //        arrOffer = [arrOffer1 mutableCopy];
        //
        //        [tblOffer reloadData];
        strOppSearch = @"";
        [self serviceForCount:@""];
        //        [self serviceForAccountData:@"1" and:@"15" comp:strSearch];
        _btnPrevious.hidden = YES;
        startIndex = 1;
        endIndex = 15;
        
        [self serviceForOpportunityData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@""];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter opportunity name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [arrKeyValue removeAllObjects];
        [arrDisplayLbl removeAllObjects];
        
        startIndex = 1;
        endIndex = 15;
        strOppSearch = searchBar.text;
        [self serviceForCount:strOppSearch];
        [self serviceForOpportunityData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strOppSearch];
    }
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
    self.lblTitle.font = [SET_FONTS_REGULAR fontWithSize:FONT_Size_Header];
}


@end
