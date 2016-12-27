//
//  ContactVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "ContactVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "MyAccounts.h"
#import "SlideNavigationController.h"
#import "LocationVC.h"


@implementation ContactCell


@end

@interface ContactVC ()
{
    int startIndex,endIndex;
    UIWebView *cWebview;
    int count;
    NSMutableArray *arrDisplaylbl,*arrRecNo,*arrLat,*arrLon,*arrPhone,*arrContactId;
    NSMutableArray *arrlblDictionary,*arrKeyValue,*arrRecid_longPress,*arrPath;
    NSString *data;
    BOOL isLongPressed,isWeb;
}
@end

@implementation ContactVC

@synthesize cLastname;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView
{
    isWeb = true;
    arrDisplaylbl = [[NSMutableArray alloc] init];
    arrRecid_longPress = [[NSMutableArray alloc] init];
    arrPath = [[NSMutableArray alloc] init];

    txtContactSearch.text = cLastname;
    txtContactSearch.delegate = self;
    
    startIndex = 1;
    endIndex = 15;
    
    SHOWLOADING(@"Wait...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForContactCount:cLastname];
        [self serviceForContactData:[@(startIndex) stringValue] and:[@(endIndex) stringValue] lname:cLastname];
        STOPLOADING();
    });
    
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    cLastname = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (cWebview) {
        [cWebview removeFromSuperview];
    }
//    lblTitle.text = getHeaderTitle;
    _btncPrev.hidden = true;
    [self setUpView];
    [self setFonts_Background];
}

-(void)removeView
{
    if (cWebview) {
        [cWebview removeFromSuperview];
        [self setUpView];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }

//call for Contact Data

-(void)serviceForContactData:(NSString *)startIndex1 and:(NSString *)endIndex1 lname:(NSString *)lastName
{
    
    if(!lastName)
        lastName = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"lastname":lastName},@{@"startindex":startIndex1},@{@"endindex":endIndex1}]];
    SHOWLOADING(@"Wait...")
    
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
            arrDisplaylbl = [[NSMutableArray alloc]init];
            arrlblDictionary = [[NSMutableArray alloc]init];
            for (NSDictionary *tmpDicForLbl in [AppDelegate initAppdelegate].allDisplayLblArray)
            {
                NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
                NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                if ([keyStr isEqualToString:@"Entered"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"Company"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                    NSLog(@"AccValue%@",valueStr);
                }
                else if([keyStr isEqualToString:@"Lead_Status"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                }
                else if([keyStr isEqualToString:@"Key Contact"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"Mkt_Program_ID"]&&![valueStr isEqualToString:@""])//Campaign
                    
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"PRI_PHONE"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"EE_REP"]&&![valueStr isEqualToString:@""])//Acct Mgr
                {
                    [arrDisplaylbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                }
                [arrlblDictionary addObject:tmpDataDic];
            }
            
//            NSLog(@"Display lbl  %@::%ld",arrDisplaylbl,(unsigned long)arrDisplaylbl.count);
            

            
            arrKeyValue = [[NSMutableArray alloc]init];
            arrRecNo = [[NSMutableArray alloc]init];
            arrLon = [[NSMutableArray alloc]init];
            arrLat = [[NSMutableArray alloc]init];
            arrPhone = [[NSMutableArray alloc]init];
            arrPhone = [[NSMutableArray alloc]init];
            arrContactId = [[NSMutableArray alloc]init];

            
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Entered"])
                    {
                        if([doc valueWithPath:@"Entered"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Entered"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Company"])
                    {
                        if([doc valueWithPath:@"Company"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Company"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Lead_Status"])
                    {
                        if([doc valueWithPath:@"Lead_Status"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Lead_Status"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    NSString *fn=@"";
                    NSString *ln=@"";
                    if ([[d objectForKey:@"key"]isEqualToString:@"Key Contact"])
                    {
                        if([doc valueWithPath:@"FirstName"]  )
                        {
                            fn = [doc valueWithPath:@"FirstName"];
                        }
                        if ([doc valueWithPath:@"LastName"]) {
                            ln = [doc valueWithPath:@"LastName"];
                        }
                         NSString *str = [NSString stringWithFormat:@"%@ %@",fn,ln];
                            [tmpDataDic setValue:str forKey:[d objectForKey:@"value"]];
                        
//                        else
//                            [tmpDataDic setValue:@"" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Mkt_Program_ID"])
                    {
                        if([doc valueWithPath:@"Mkt_Program_ID"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Mkt_Program_ID"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                    }
                }
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"PRI_PHONE"])
                    {
                        if([doc valueWithPath:@"Phone"])
                        {
                            [tmpDataDic setValue:[doc valueWithPath:@"Phone"] forKey:[d objectForKey:@"value"]];
                            
                        }
                        else
                        {
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                           
                        }
                    }
                }
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"EE_REP"]) //Acct Mgr
                    {
                        if([doc valueWithPath:@"AcctMgr"])
                            [tmpDataDic setValue:[doc valueWithPath:@"AcctMgr"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                    }
                }
                
                
                if([[doc valueWithPath:@"RecordID"] integerValue]==0)
                {
                    tblContacts.hidden = YES;
                    _lblinfo.hidden = NO;
                    [arrRecNo addObject:[doc valueWithPath:@"RecordID"]];
                    
                }
                else
                {
                    tblContacts.hidden = NO;
                    _lblinfo.hidden = YES;
                    [arrRecNo addObject:[doc valueWithPath:@"RecordID"]];

                }
                if([doc valueWithPath:@"Latitude"])
                {
                    [arrLat addObject:[doc valueWithPath:@"Latitude"]];
                    
                }
                if([doc valueWithPath:@"Longitude"])
                {
                    [arrLon addObject:[doc valueWithPath:@"Longitude"]];
                    
                }
                if([doc valueWithPath:@"ContactID"])
                {
                    [arrContactId addObject:[doc valueWithPath:@"ContactID"]];
                    
                }
                if([doc valueWithPath:@"Phone"])
                {
                    [arrPhone addObject:[doc valueWithPath:@"Phone"]];
                    
                }
                else
                {
                    [arrPhone addObject:@"none"];
                }

                [arrKeyValue addObject:tmpDataDic];
                
            }
            
            NSLog(@"%@",arrKeyValue);
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [tblContacts reloadData];
                [txtContactSearch resignFirstResponder];
                
                if((endIndex >= count) || (count <= 15))
                {
                    lblTotalContacts.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count,count];
                    
                }
                else
                {
                    lblTotalContacts.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count];
                    
                }
                if(count == 0)
                {
                    lblTotalContacts.text = @"Record Not Found";
                }
                
                STOPLOADING();
            });
            
        }
        
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [txtContactSearch resignFirstResponder];
//    if (arrKeyValue.count <= 0) {
//        strSearch = @"";
//        [self serviceForCount:@""];
//        //        [self serviceForAccountData:@"1" and:@"15" comp:strSearch];
//        startIndex = 1;
//        endIndex = 15;
//        _btnPrev.hidden = YES;
//        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@""];
//    }
//}

-(void)serviceForContactCount:(NSString *)lastName
{
    if(!lastName)
        lastName = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"lastname":lastName}]];
    SHOWLOADING(@"Wait...")
    
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
                    count = [[doc valueWithPath:@"SearchContactCountResult"] intValue];
//                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count] forKey:Key_Acc_count];
                    _btncPrev.hidden = YES;
                    _btncNext.hidden = YES;
                    if (count>15)
                    {
                        _btncNext.hidden = NO;
                    }
                    if(count == 0)
                    {
                        _btncPrev.hidden = YES;
                    }
                }
            }
        }
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrDisplaylbl.count == 1)
    {
        return 130;
    }
    else if (arrDisplaylbl.count == 2)
    {
        return 150;
    }
    else if (arrDisplaylbl.count == 3)
    {
        return 170;
        
    }
    else if (arrDisplaylbl.count == 4)
    {
        return 290;
        
    }
    else if (arrDisplaylbl.count == 5)
    {
        return 210;
        
    }
    else if (arrDisplaylbl.count == 6)
    {
        return 230;
    }
    else if (arrDisplaylbl.count == 7)
    {
        return 250;
        
    }
    
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrKeyValue.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
 
    BOOL flag = false;
    
    
    for (NSString *value in arrRecid_longPress)
    {
        if([value isEqualToString:[arrRecNo objectAtIndex:indexPath.row]])
        {
            flag = YES;
            break;
        }
        
    }
    
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

    
    cell.btncMap.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btncMap setTitle:@"\uf041" forState:UIControlStateNormal];
    
    cell.btncPhone.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btncPhone setTitle:@"\uf095" forState:UIControlStateNormal];
    
    cell.btncSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btncSelect setTitle:@"\uf00c" forState:UIControlStateNormal];
    
    //    cell.btnAssign.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    //    [cell.btnAssign setTitle:@"\uf0c0" forState:UIControlStateNormal];
    [cell.btncAssign setBackgroundImage:[UIImage imageNamed:@"assign"] forState:UIControlStateNormal];
    
    cell.accessibilityLabel = [arrContactId objectAtIndex:indexPath.row];
    
    cell.btncDelete.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btncDelete setTitle:@"\uf014" forState:UIControlStateNormal];
    
    cell.btncSelect.tag = [[arrRecNo objectAtIndex:indexPath.row] integerValue];
    [cell.btncSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btncAssign.tag = [[arrRecNo objectAtIndex:indexPath.row] integerValue];
    [cell.btncAssign addTarget:self action:@selector(callForAssign:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btncDelete.tag = [[arrRecNo objectAtIndex:indexPath.row] integerValue];
    [cell.btncDelete addTarget:self action:@selector(callForDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btncPhone.tag = indexPath.row;
    [cell.btncPhone addTarget:self action:@selector(callForPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btncMap.tag = indexPath.row;
    [cell.btncMap addTarget:self action:@selector(callForMap:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dictionary=[arrKeyValue objectAtIndex:indexPath.row];
    
    if ([dictionary valueForKey:@"Phone"])
    {
        if(![[dictionary valueForKey:@"Phone"] isEqualToString:@"none"])
        {
            cell.btncPhone.hidden = NO;
            cell.btncMap.frame = CGRectMake(CGRectGetMinX(cell.btncPhone.frame)-(7+cell.btncMap.frame.size.width), cell.btncMap.frame.origin.y,cell.btncMap.frame.size.width,cell.btncMap.frame.size.height);
        }
        else
        {
            cell.btncPhone.hidden = YES;
            cell.btncMap.frame = cell.btncPhone.frame;
        }
    }
    else
    {
        cell.btncPhone.hidden = YES;
        cell.btncMap.frame = CGRectMake(CGRectGetMinX(cell.btncPhone.frame)-(5+cell.btncMap.frame.size.width), cell.btncMap.frame.origin.y,cell.btncMap.frame.size.width,cell.btncMap.frame.size.height);
    }
    float latitude = [[arrLat objectAtIndex:indexPath.row ]floatValue];
    float longitude = [[arrLon objectAtIndex:indexPath.row ]floatValue];
    
    
    if (latitude != 0 && longitude != 0) {
        cell.btncMap.hidden = NO;
    } else {
        cell.btncMap.hidden = YES;
    }


    if (arrDisplaylbl.count == 1)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];          //[arrDisplayLbl
    }
    if (arrDisplaylbl.count == 2)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        
        cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.btncView.frame.origin.y-100,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
    }
    if (arrDisplaylbl.count == 3)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.clbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.clblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.btncView.frame.origin.y-80,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
        
    }
    if (arrDisplaylbl.count == 4)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.clbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.clblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.clbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.clblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
       

        cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.btncView.frame.origin.y-60,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
        
    }
    if (arrDisplaylbl.count == 5)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.clbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.clblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.clbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.clblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.clbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.clblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        
        cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.btncView.frame.origin.y-40,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
    }
    if (arrDisplaylbl.count == 6)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.clbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.clblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.clbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.clblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.clbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.clblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.clbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.clblV6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.btncView.frame.origin.y-20,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
    }
    if (arrDisplaylbl.count == 7)
    {
        cell.clbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.clblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.clbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.clblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.clbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.clblV3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.clbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.clblV4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.clbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.clblV5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        cell.clbl6.text = [[dictionary allKeys] objectAtIndex:5];
        cell.clblV6.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:5]];
        cell.clbl7.text = [[dictionary allKeys] objectAtIndex:6];
        cell.clblV7.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:6]];
        
    }
    
    cell.btncView.frame = CGRectMake(cell.btncView.frame.origin.x,cell.frame.size.height-cell.btncView.frame.size.height,cell.btncView.frame.size.width,cell.btncView.frame.size.height);
    cell.clbl1.font = SET_FONTS_REGULAR;
    cell.clbl2.font = SET_FONTS_REGULAR;
    cell.clbl3.font = SET_FONTS_REGULAR;
    cell.clbl4.font = SET_FONTS_REGULAR;
    cell.clbl5.font = SET_FONTS_REGULAR;
    cell.clbl6.font = SET_FONTS_REGULAR;
    cell.clbl7.font = SET_FONTS_REGULAR;
    cell.clblV1.font = SET_FONTS_REGULAR;
    cell.clblV2.font = SET_FONTS_REGULAR;
    cell.clblV3.font = SET_FONTS_REGULAR;
    cell.clblV4.font = SET_FONTS_REGULAR;
    cell.clblV5.font = SET_FONTS_REGULAR;
    cell.clblV6.font = SET_FONTS_REGULAR;
    cell.clblV7.font = SET_FONTS_REGULAR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [txtContactSearch resignFirstResponder];
    if(isLongPressed)
    {
        
        NSMutableArray *arrRecid_longPress1 = [arrRecid_longPress mutableCopy];
        BOOL flag = false;
        for (NSString *value in arrRecid_longPress1)
        {
            if([value isEqualToString:[arrRecNo objectAtIndex:indexPath.row]])
            {
                flag = YES;
                break;
            }
            
        }
        if(!flag)
        {
            [arrRecid_longPress addObject:[arrRecNo objectAtIndex:indexPath.row]];
            [arrPath addObject:indexPath];
            UITableViewCell *cell = [tblContacts cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        }
        
        else
        {
            [self tableView:tblContacts didDeselectRowAtIndexPath:indexPath];
            UITableViewCell *cell = [tblContacts cellForRowAtIndexPath:indexPath];
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

      [self selectWebview:[[arrRecNo objectAtIndex:indexPath.row] intValue]cID:[arrContactId objectAtIndex:indexPath.row]];

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if(isLongPressed)
    {
        NSMutableArray *arrRecid_longPress1 = [arrRecid_longPress mutableCopy];
        
        for (NSString *str in arrRecid_longPress1)
        {
            if([str isEqualToString:[arrRecNo objectAtIndex:indexPath.row]])
            {
                [arrRecid_longPress removeObject:str];
            }
            
        }
        
        if(arrRecid_longPress.count>0)
            [AppDelegate initAppdelegate].lblSelectCounter.text = [NSString stringWithFormat:@"%ld  Selected",(unsigned long)arrRecid_longPress.count];
        else
            [[AppDelegate initAppdelegate]hideView];
        UITableViewCell *cell = [tblContacts cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}

//LongPress Event

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
//    NSLog(%d",longPress.view.tag);
    NSIndexPath *path = [NSIndexPath indexPathForRow:longPress.view.tag inSection:0];
    
    
    
    [[AppDelegate initAppdelegate]showView];
    
    [AppDelegate initAppdelegate].completionBlock=^(NSString *str){
        
    isLongPressed = false;
        for (NSIndexPath *value in arrPath)
        {

            UITableViewCell *cell = [tblContacts cellForRowAtIndexPath:value];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
        }
        
        data = [arrRecid_longPress componentsJoinedByString:@","];
        [arrRecid_longPress removeAllObjects];
        [arrPath removeAllObjects];
        
        if([str isEqualToString:@"assign"])
        {
            NSLog(@"Assign");
            NSString *urlString = [NSString stringWithFormat:
                                   @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&cid=%@&RECDNO=%@&appkeyword=&pagetype=contact",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP,data];
            NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:webStringURL];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            cWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
            [cWebview loadRequest:urlRequest];
            [self.view addSubview:cWebview];
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
         [arrRecid_longPress addObject:[arrRecNo objectAtIndex:path.row]];
        [arrPath addObject:path];
                
         [AppDelegate initAppdelegate].lblSelectCounter.text = [NSString stringWithFormat:@"%ld  Selected",(unsigned long)arrRecid_longPress.count];
        isLongPressed = YES;
        
        UITableViewCell *cell = [tblContacts cellForRowAtIndexPath:path];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        
    }
    
}


//Cell button methods

-(void)callForSelect:(UIButton *)btn
{
    [self selectWebview:btn.tag cID:btn.accessibilityLabel];

}
-(void)selectWebview:(NSInteger)recID cID:(NSString *)contactID
{
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=%@&RECDNO=%ld&CompanyID=%@&appkeyword=&pagetype=contact&contactid=%@",MAIN_URL,[BaseApplication getEncryptedKey],DPAGE,(long)recID,WORKGROUP,contactID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    cWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [cWebview loadRequest:urlRequest];
    [self.view addSubview:cWebview];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        cWebview.frame = CGRectMake(0, 65,WIDTH, [UIScreen mainScreen].bounds.size.height - 114);
        //        NSLog(@"Portrait");
    } else {
        cWebview.frame = CGRectMake(0, 65,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 114);
        //        NSLog(@"Landscape");
    }
    
}

-(void)callForAssign:(UIButton *)btn
{
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_dlgAssign.asp&frompage=mobile_RFullEdit.asp&cid=%@&RECDNO=%ld&appkeyword=&pagetype=contact",MAIN_URL,[BaseApplication getEncryptedKey],WORKGROUP,(long)btn.tag];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    cWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [cWebview loadRequest:urlRequest];
    [self.view addSubview:cWebview];
}

-(void)callForPhone:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@",[arrPhone objectAtIndex:btn.tag]];
    if(![str isEqualToString:@"none"])
    {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:str];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}
-(void)callForMap:(UIButton *)btn
{
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",[AppDelegate initAppdelegate].latitude,[AppDelegate initAppdelegate].longitude,[[arrLat objectAtIndex:btn.tag] floatValue],[[arrLon objectAtIndex:btn.tag] floatValue]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
-(void)callForDelete:(UIButton *)btn
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
        if (alertView.tag) {
            data = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
            serviceType = DELETE_RECORD;
            responseTag = @"DeleteRecordResponse";
            childTag = @"DeleteRecordResult";
            tArray=[[NSMutableArray alloc] initWithArray:@[@{@"RecordID":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
        }
        else
        {
            serviceType = DELETE_RECORDS;
            responseTag = @"DeleteRecordsResponse";
            childTag = @"DeleteRecordsResult";
            tArray=[[NSMutableArray alloc] initWithArray:@[@{@"RecordIDs":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
        }
        
        
        SHOWLOADING(@"Wait...")
        
        [BaseApplication executeRequestwithService:serviceType arrPerameter:tArray withBlock:^(NSData *dictresponce, NSError *error){
            NSError *err=[[NSError alloc] init];
            SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
            
            
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
                        cLastname = @"";
                        txtContactSearch.text=@"";
                        [self serviceForContactCount:cLastname];
                        [self serviceForContactData:@"1" and:@"15" lname:cLastname];
                    }
                }
            }
            data = @"";
            
        }];
        
    }
    
}


- (IBAction)contactSideBar:(id)sender {
    
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    } else {
        txtContactSearch.text = cLastname;
        [cWebview removeFromSuperview];
        //        isWeb = false;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
}

- (IBAction)preContact:(id)sender {
    NSLog(@"%d",startIndex);
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    NSString *strSearchText = cLastname;
    
    [self serviceForContactData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] lname:strSearchText];
    
    if (endIndex<=15) {
        _btncPrev.hidden = YES;
        _btncNext.hidden = NO;
        
    }else{
        if (endIndex < count) {
            _btncNext.hidden = NO;
        }
    }
}



- (IBAction)nextContact:(id)sender {
    _btncPrev.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    NSString *strSearchText = cLastname;
    
    if(endIndex < count)
    {
        [self serviceForContactData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] lname:strSearchText];
    }
    else
    {
        [self serviceForContactData:[@(startIndex)stringValue] and:[@(count)stringValue] lname:strSearchText];
        _btncNext.hidden = true;
    }
}

//Searchbar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    txtContactSearch.text = @"";
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        cLastname = @"";
        [self serviceForContactCount:@""];
        startIndex = 1;
        endIndex = 15;
        _btncPrev.hidden = YES;
        [self serviceForContactData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] lname:@""];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter lastname"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [arrKeyValue removeAllObjects];
        [arrDisplaylbl removeAllObjects];
        cLastname = searchBar.text;
        [self serviceForContactCount:cLastname];
        startIndex = 1;
        endIndex = 15;
        [self serviceForContactData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] lname:cLastname];
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
    lblTitle.font = [SET_FONTS_REGULAR fontWithSize:FONT_Size_Header];
}


@end
