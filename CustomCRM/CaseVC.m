    //
    //  MyAccounts.m
    //  CustomCRM
    //
    //  Created by Pinal Panchani on 20/09/16.
    //  Copyright © 2016 Nexuslink. All rights reserved.
    //

#import "CaseVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "SlideNavigationController.h"
#import "LocationVC.h"


@implementation CaseCell

@end

@interface CaseVC ()
{
    int startIndex,endIndex;
    long lat,lon;
    BOOL isLongPressed,isWeb;
    NSString *data;
}

@end

@implementation CaseVC

@synthesize  strSearch,arrlblDictionary,accWebview;
@synthesize  arrEnter,arrPhone,arrCompany,arrCampaign,arrAccManager,arrLat,arrLong;
@synthesize  arrLeadSource,arrLeadStatus,arrRecordNo,arrDisplayLbl,arrKeyValue,arrRecid_longPress,arrCaseID;


int count1;

#pragma  mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView
{
    isWeb = true;
    arrEnter = [[NSMutableArray alloc]init];
    arrPhone = [[NSMutableArray alloc]init];
    arrCompany = [[NSMutableArray alloc]init];
    arrCampaign = [[NSMutableArray alloc]init];
    arrAccManager = [[NSMutableArray alloc]init];
    arrLeadSource = [[NSMutableArray alloc]init];
    arrLeadStatus = [[NSMutableArray alloc]init];
    arrRecordNo = [[NSMutableArray alloc]init];
    arrCaseID = [[NSMutableArray alloc]init];

    arrDisplayLbl = [[NSMutableArray alloc]init];
    arrLong = [[NSMutableArray alloc]init];
    arrLat = [[NSMutableArray alloc]init];
    arrKeyValue = [[NSMutableArray alloc]init];
    arrlblDictionary = [[NSMutableArray alloc]init];
    arrRecid_longPress = [[NSMutableArray alloc]init];
    
    _txtSearch.text = strSearch;
    _txtSearch.delegate = self;
    
    startIndex = 1;
    endIndex = 15;
    
    SHOWLOADING(@"Wait...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForCount:strSearch];
        [self serviceForAccountData:[@(startIndex) stringValue] and:[@(endIndex) stringValue] comp:strSearch];
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
    if (arrDisplayLbl.count == 1)
        {
        return 130;
        }
    else if (arrDisplayLbl.count == 2)
        {
        return 150;
        }
    else if (arrDisplayLbl.count == 3)
        {
        return 170;
        
        }
    else if (arrDisplayLbl.count == 4)
        {
        return 290;
        
        }
    else if (arrDisplayLbl.count == 5)
        {
        return 210;
        
        }
    else if (arrDisplayLbl.count == 6)
        {
        return 230;
        }
    else if (arrDisplayLbl.count == 7)
        {
        return 250;
        
        }
    else if (arrDisplayLbl.count == 8)
        {
        return 301;
        
        }
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrKeyValue.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseCell *cell = (CaseCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
        {
        cell = [[CaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        }
    
    BOOL flag = false;
        //
        //    for (id value in arrRecid_longPress)
        //    {
        //        if(value == indexPath)
        //        {
        //            flag = YES;
        //            break;
        //        }
        //
        //    }
    
    for (NSString *value in arrRecid_longPress)
        {
        if([value isEqualToString:[arrRecordNo objectAtIndex:indexPath.row]])
            {
            flag = YES;
            break;
            }
        
        }
        //    if(!flag)
        //    {
        //        [arrRecid_longPress addObject:indexPath];
        //        UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:indexPath];
        //        cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        //    }
        //
        //    else
        //    {
        //        [self tableView:_tblAccountData didDeselectRowAtIndexPath:indexPath];
        //        UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:indexPath];
        //        cell.contentView.backgroundColor = [UIColor clearColor];
        //    }
    
    if(!flag)
        cell.contentView.backgroundColor = [UIColor clearColor];
    else
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [cell addGestureRecognizer:lpgr];
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    cell.btnSelect.tag = [[arrRecordNo objectAtIndex:indexPath.row] integerValue];
    
    cell.btnSelect.accessibilityLabel = [NSString stringWithFormat:@"%@",[arrCaseID objectAtIndex:indexPath.row]];

    
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnAssign.tag = [[arrRecordNo objectAtIndex:indexPath.row] integerValue];
    NSString *tmpCaseIDStr=[NSString stringWithFormat:@"%@",[arrCaseID objectAtIndex:indexPath.row]];
    
    cell.btnAssign.accessibilityLabel = tmpCaseIDStr;

    
    [cell.btnAssign addTarget:self action:@selector(callForAssign:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.tag = [[arrRecordNo objectAtIndex:indexPath.row] integerValue];
    cell.btnDelete.accessibilityLabel = tmpCaseIDStr;

    [cell.btnDelete addTarget:self action:@selector(callForDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPhone.tag = indexPath.row;
    [cell.btnPhone addTarget:self action:@selector(callForPhonecall:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnMap.tag = indexPath.row;
    [cell.btnMap addTarget:self action:@selector(callForMapview:) forControlEvents:UIControlEventTouchUpInside];
   
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
        cell.btnMap.frame = CGRectMake(CGRectGetMinX(cell.btnPhone.frame)-(5+cell.btnMap.frame.size.width), cell.btnMap.frame.origin.y,cell.btnMap.frame.size.width,cell.btnMap.frame.size.height);
        }
    float latitude = [[arrLat objectAtIndex:indexPath.row ]floatValue];
    float longitude = [[arrLong objectAtIndex:indexPath.row ]floatValue];
    
    
    if (latitude != 0 && longitude != 0) {
        cell.btnMap.hidden = NO;
    } else {
        cell.btnMap.hidden = YES;
    }
    
    
    if (arrDisplayLbl.count == 1)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];          //[arrDisplayLbl
        }
    if (arrDisplayLbl.count == 2)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-100,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        }
    if (arrDisplayLbl.count == 3)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-80,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
        }
    if (arrDisplayLbl.count == 4)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-60,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
        }
    if (arrDisplayLbl.count == 5)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.lblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-40,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        }
    if (arrDisplayLbl.count == 6)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.lblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.lbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.lblV6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-20,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        }
    if (arrDisplayLbl.count == 7)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.lblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.lbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.lblV6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.lbl7.text = [[dictionary allKeys] objectAtIndex:6];
        cell.lblV7.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:6]];
        
        }
    if (arrDisplayLbl.count == 8)
        {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.lblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.lbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.lblV6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.lbl7.text = [[dictionary allKeys] objectAtIndex:6];
        cell.lblV7.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:6]];
        
        cell.lbl8.text = [[dictionary allKeys] objectAtIndex:7];
        cell.lblv8.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:7]];
        
        }
    cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.frame.size.height-cell.btnView.frame.size.height,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    cell.lbl1.font = SET_FONTS_REGULAR;
    cell.lbl2.font = SET_FONTS_REGULAR;
    cell.lbl3.font = SET_FONTS_REGULAR;
    cell.lbl4.font = SET_FONTS_REGULAR;
    cell.lbl5.font = SET_FONTS_REGULAR;
    cell.lbl6.font = SET_FONTS_REGULAR;
    cell.lbl7.font = SET_FONTS_REGULAR;
    cell.lbl8.font = SET_FONTS_REGULAR;
    cell.lblV1.font = SET_FONTS_REGULAR;
    cell.lblV2.font = SET_FONTS_REGULAR;
    cell.lblV3.font = SET_FONTS_REGULAR;
    cell.lblV4.font = SET_FONTS_REGULAR;
    cell.lblV5.font = SET_FONTS_REGULAR;
    cell.lblV6.font = SET_FONTS_REGULAR;
    cell.lblV7.font = SET_FONTS_REGULAR;
    cell.lblv8.font = SET_FONTS_REGULAR;
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtSearch resignFirstResponder];
    if(isLongPressed)
        {
        
        NSMutableArray *arrRecid_longPress1 = [arrRecid_longPress mutableCopy];
        BOOL flag = false;
        for (NSString *value in arrRecid_longPress1)
            {
            if([value isEqualToString:[arrRecordNo objectAtIndex:indexPath.row]])
                {
                flag = YES;
                break;
                }
            
            }
        if(!flag)
            {
            [arrRecid_longPress addObject:[arrRecordNo objectAtIndex:indexPath.row]];
            UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
            }
        
        else
            {
            [self tableView:_tblAccountData didDeselectRowAtIndexPath:indexPath];
            UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor clearColor];
            }
        
        [AppDelegate initAppdelegate].lblSelectCounter.text = [NSString stringWithFormat:@"%ld  Selected",(unsigned long)arrRecid_longPress.count];
        
        }
    else
        {
            if (isWeb) {
                [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
            } else {
                [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
            }
            isWeb = false;
        [self selectWebview:[[arrRecordNo objectAtIndex:indexPath.row] integerValue] caseID:[[arrCaseID objectAtIndex:indexPath.row] integerValue]];
        }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if(isLongPressed)
        {
        NSMutableArray *arrRecid_longPress1 = [arrRecid_longPress mutableCopy];
            //        for (id value in arrRecid_longPress1)
            //        {
            //            if(value == indexPath)
            //            {
            //                [arrRecid_longPress removeObject:value];
            //            }
            //
            //        }
        
        for (NSString *str in arrRecid_longPress1)
            {
            if([str isEqualToString:[arrRecordNo objectAtIndex:indexPath.row]])
                {
                [arrRecid_longPress removeObject:str];
                }
            
            }
        
        
        if(arrRecid_longPress.count>0)
            [AppDelegate initAppdelegate].lblSelectCounter.text = [NSString stringWithFormat:@"%ld  Selected",(unsigned long)arrRecid_longPress.count];
        else
            [[AppDelegate initAppdelegate]hideView];
        UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        }
}

#pragma mark - Custome methods
-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
//    NSLog(@"%d",longPress.view.tag);
    NSIndexPath *path = [NSIndexPath indexPathForRow:longPress.view.tag inSection:0];
    
    
    
    [[AppDelegate initAppdelegate]showView];
    
    [AppDelegate initAppdelegate].completionBlock=^(NSString *str){
        
        NSMutableArray *myArray = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *value in arrRecid_longPress)
            {
            [myArray addObject:[arrRecordNo objectAtIndex:value.row]];
            UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:value];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            }
        
        data = [myArray componentsJoinedByString:@","];
        [arrRecid_longPress removeAllObjects];
        
        if([str isEqualToString:@"assign"])
            {
            NSLog(@"Assign");
            NSString *urlString = [NSString stringWithFormat:
                                   @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&cid=%@&RECDNO=%@&appkeyword=&pagetype=account",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP,data];
            NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:webStringURL];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
                
            [accWebview loadRequest:urlRequest];
            [self.view addSubview:accWebview];
            data=@"";
            
            }
        else if([str isEqualToString:@"delete"])
            {
            NSLog(@"delete");
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                             message:@"Are you sure want to delete selected record(s)?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles: nil];
            [alert addButtonWithTitle:@"OK"];
            
            [alert show];
            
            }
        [[AppDelegate initAppdelegate]hideView];
        
    };
    
    if (!isLongPressed)
        {
            //        for (NSString *str in arrRecordNo) {
            //
            //            [];
            //        }
        
        [arrRecid_longPress addObject:[arrRecordNo objectAtIndex:path.row]];
        
            //         [arrRecid_longPress addObject:path];
        [AppDelegate initAppdelegate].lblSelectCounter.text = [NSString stringWithFormat:@"%ld  Selected",(unsigned long)arrRecid_longPress.count];
        isLongPressed = YES;
        
        UITableViewCell *cell = [_tblAccountData cellForRowAtIndexPath:path];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        
        }
    
}


-(void)serviceForAccountData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"subject":company}]];
    NSLog(@"Url Data: %@ %@",SEARCHCASEDATA,tArray1);
    SHOWLOADING(@"Wait...")
    [BaseApplication executeRequestwithService:SEARCHCASEDATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
                
                if ([keyStr isEqualToString:@"DateDue"]&&![valueStr isEqualToString:@""])
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
                else if([keyStr isEqualToString:@"Subject"]&&![valueStr isEqualToString:@""])
                    {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                    }
                else if([keyStr isEqualToString:@"Status"]&&![valueStr isEqualToString:@""])//Campaign
                    
                    {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                    }
                else if([keyStr isEqualToString:@"Priority"]&&![valueStr isEqualToString:@""])
                    {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                    }
                else if([keyStr isEqualToString:@"Case Owner"]&&![valueStr isEqualToString:@""])//Acct Mgr
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
                else if([keyStr isEqualToString:@"Entered"]&&![valueStr isEqualToString:@""])
                    {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    }
                [arrlblDictionary addObject:tmpDataDic];
            }
                //NSLog(@"Display lbl  %@::%ld",arrDisplayLbl,arrDisplayLbl.count);
            arrKeyValue = [[NSMutableArray alloc]init];
            arrRecordNo = [[NSMutableArray alloc]init];
            
            arrCaseID = [[NSMutableArray alloc]init];

            
            arrLong = [[NSMutableArray alloc]init];
            arrLat = [[NSMutableArray alloc]init];
                //NSLog(@"111 :%@",arrlblDictionary);

            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeCaseData"])
                {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                for (NSDictionary *d in arrlblDictionary)
                    {
                    if ([[d objectForKey:@"key"]isEqualToString:@"DateDue"])
                        {
                        if([doc valueWithPath:@"DateDue"])
                            [tmpDataDic setValue:[doc valueWithPath:@"DateDue"] forKey:[d objectForKey:@"value"]];
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
                    if ([[d objectForKey:@"key"]isEqualToString:@"Status"])
                        {
                        if([doc valueWithPath:@"Status"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Status"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                        }
                    if ([[d objectForKey:@"key"]isEqualToString:@"Subject"])
                        {
                        if([doc valueWithPath:@"Subject"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Subject"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                        }
                    
                    if ([[d objectForKey:@"key"]isEqualToString:@"Priority"])
                        {
                        if([doc valueWithPath:@"Priority"])
                            {
                            [tmpDataDic setValue:[doc valueWithPath:@"Priority"] forKey:[d objectForKey:@"value"]];
                            
                            }
                        else
                            {
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                            }
                        }
                    if ([[d objectForKey:@"key"]isEqualToString:@"Case Owner"]) //Acct Mgr
                        {
                        if([doc valueWithPath:@"Case Owner"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Case Owner"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        }
                    
                    if ([[d objectForKey:@"key"]isEqualToString:@"PRI_PHONE"]) //Acct Mgr
                        {
                        if([doc valueWithPath:@"PRI_PHONE"]){
                            [tmpDataDic setValue:[doc valueWithPath:@"PRI_PHONE"] forKey:[d objectForKey:@"value"]];
                            [arrPhone addObject:[doc valueWithPath:@"PRI_PHONE"]];
                        }
                        else{
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                            [arrPhone addObject:@"none"];
                            
                        }
                        }
                    if ([[d objectForKey:@"key"]isEqualToString:@"Entered"]) //Acct Mgr
                        {
                        if([doc valueWithPath:@"Entered"]){
                            [tmpDataDic setValue:[doc valueWithPath:@"Entered"] forKey:[d objectForKey:@"value"]];
                        }
                        else{
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        }
                        }
                    }
                
//                if([doc valueWithPath:@"RecordID"])
//                    {
//                    [arrRecordNo addObject:[doc valueWithPath:@"RecordID"]];
//                    
//                    }
                    if([[doc valueWithPath:@"RecordID"] integerValue]==0)
                    {
                        _tblAccountData.hidden = YES;
                        _lblinfo.hidden = NO;
                        [arrRecordNo addObject:[doc valueWithPath:@"RecordID"]];
                        
                    }
                    else
                    {
                        _tblAccountData.hidden = NO;
                        _lblinfo.hidden = YES;
                         [arrRecordNo addObject:[doc valueWithPath:@"RecordID"]];
                        
                    }
                
                if([doc valueWithPath:@"CaseID"])
                    {
                    [arrCaseID addObject:[doc valueWithPath:@"CaseID"]];
                    
                    }
                if([doc valueWithPath:@"Latitude"])
                    {
                    [arrLat addObject:[doc valueWithPath:@"Latitude"]];
                    
                    }
                if([doc valueWithPath:@"Longitude"])
                    {
                    [arrLong addObject:[doc valueWithPath:@"Longitude"]];
                    
                    }
                [arrKeyValue addObject:tmpDataDic];
                }
            
                // NSLog(@"12 :%@",arrKeyValue);
                // NSLog(@"11 :%@",arrlblDictionary);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblAccountData reloadData];
                [_txtSearch resignFirstResponder];
                
                if((endIndex >= count1) || (count1 <= 15))
                    {
                    _lblTotalRecords.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count1,count1];
                    
                    }
                else
                    {
                    _lblTotalRecords.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count1];
                    
                    }
                if(count1 == 0)
                {
                    _lblTotalRecords.text = @"Record Not Found";
                }
//                if (arrRecordNo.count <= 15) {
//                    _btnNext.hidden = YES;
//                    _btnPrev.hidden = YES;
//                    _lblTotalRecords.text = [NSString stringWithFormat:@"1 to %lu of %lu",(unsigned long)arrRecordNo.count,(unsigned long)arrRecordNo.count];
//                }
//                if (arrRecordNo.count <= 1) {
//                    _lblTotalRecords.text = @"Case Not Found";
//                }
                STOPLOADING();
            });
            
            }
        
    }];
}

-(void)serviceForCount:(NSString *)company
{
    if(!company)
        company = @"";
      NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"subject":_txtSearch.text}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:CASE_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchCasesCountResponse"])
            {
                if([doc valueWithPath:@"SearchCasesCountResult"])
                {
                    count1 = [[doc valueWithPath:@"SearchCasesCountResult"] intValue];
                    _btnPrev.hidden = YES;
                    _btnNext.hidden = YES;
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count1] forKey:Key_Acc_count];
                    if (count1>15)
                    {
                        _btnNext.hidden = NO;
                    }
                }
            }
        }
        
    }];
    
}

    //Select button method

-(void)callForSelect:(UIButton *)btn
{
    [self selectWebview:btn.tag caseID:[btn.accessibilityLabel integerValue]];
}

-(void)selectWebview:(NSInteger)recID caseID:(NSInteger)caseID
{
//    MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_dlgAddCase.asp&RECDNO=" + RecordId + 	"&CompanyID=" + WGID + "&appkeyword= &pagetype=case&id=" + 	CaseId;
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAddCase.asp&RECDNO=%ld&CompanyID=%@&appkeyword=%@&pagetype=case&id=%ld",MAIN_URL,[BaseApplication getEncryptedKey],(long)recID,WORKGROUP,@"",(long)caseID];
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
    
//    MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&ci	d=" + WGID + "&RECDNO=" + RecordId + 	"&appkeyword=&pagetype=case";
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&cid=%@&RECDNO=%ld&appkeyword=&pagetype=case",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP,(long)btn.tag];
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
    NSString *tmpCaseIDStr=[NSString stringWithFormat:@"%@",btn.accessibilityLabel];
    
    alert.tag = [tmpCaseIDStr integerValue];
    [alert show];
    
    
}

    //Map button mathod

-(void)callForMapview:(UIButton *)btn
{
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",[AppDelegate initAppdelegate].latitude,[AppDelegate initAppdelegate].longitude,[[arrLat objectAtIndex:btn.tag] floatValue],[[arrLong objectAtIndex:btn.tag] floatValue]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}


    //call for Phonecall
-(void)callForPhonecall:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@",[arrPhone objectAtIndex:btn.tag]];//[NSString stringWithFormat:@"%ld",btn.tag];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)AccountSidebar:(id)sender
{
    [[SlideNavigationController sharedInstance]toggleLeftMenu];
    
}


#pragma mark - AlertView method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"Button Index =%ld",(long)buttonIndex);
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
            data = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
            serviceType = DELETE_CASE;
            responseTag = @"DeleteCaseResponse";
            childTag = @"DeleteCaseResult";
            tArray=[[NSMutableArray alloc] initWithArray:@[@{@"CaseID":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
//        }
//        else
//            {
//            serviceType = DELETE_RECORDS;
//            responseTag = @"DeleteRecordsResponse";
//            childTag = @"DeleteRecordsResult";
//            tArray=[[NSMutableArray alloc] initWithArray:@[@{@"RecordIDs":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
//            }
        
        
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
                                                                         message:@"Record(s) deleted successfully"
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles: nil];
                        [alert show];
                        strSearch = @"";
                        _txtSearch.text=@"";
                        [self serviceForCount:strSearch];
                        [self serviceForAccountData:@"1" and:@"15" comp:strSearch];
                        }
                    }
                }
            data = @"";
            
        }];
        
        }
    
    
    
}
#pragma mark - Next previous method
- (IBAction)callNextRecord:(id)sender {
    _btnPrev.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    NSString *strSearchText = strSearch;
    
    if(endIndex < count1)
        {
        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
        }
    else
        {
        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(count1)stringValue] comp:strSearchText];
        _btnNext.hidden = true;
        }
    
}

- (IBAction)callPrevRecord:(id)sender {
    
        // NSLog(@"%d",startIndex);
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    NSString *strSearchText = strSearch;
    
    [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
    
    
    if (endIndex<=15) {
        _btnPrev.hidden = YES;
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
    strSearch = @"";
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
        {
            //        [arrOffer removeAllObjects];
            //        arrOffer = [arrOffer1 mutableCopy];
            //
            //        [tblOffer reloadData];
        [self serviceForCount:@""];
            //        [self serviceForAccountData:@"1" and:@"15" comp:strSearch];
        startIndex = 1;
        endIndex = 15;
        strSearch = @"";
        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@""];
        }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter company name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        }
    else
        {
        [arrKeyValue removeAllObjects];
        [arrDisplayLbl removeAllObjects];
            strSearch = searchBar.text;
        [self serviceForCount:searchBar.text];
            startIndex = 1;
            endIndex = 15;
        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:searchBar.text];
        }
}


- (IBAction)caseSideMenu:(id)sender {
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    } else {
        _txtSearch.text = strSearch;
        [accWebview removeFromSuperview];
        //        isWeb = false;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
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
