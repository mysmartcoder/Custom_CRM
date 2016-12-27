//
//  QuotesVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 08/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "QuotesVC.h"
#import "Static.h"
#import "BaseApplication.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "UIView+Toast.h"

@implementation QuotesCell


@end

@interface QuotesVC ()
{
    int count1,startIndex,endIndex;
    NSMutableArray *arrRecID,*arrQid,*arrQname,*arrFname,*arrLname,*arrCompany,*arrTotal,*arrDisplayLbl,*arrKeyValue,*arrlblDictionary;
    UIWebView *accWebview;
    BOOL isWeb;
}
@end

@implementation QuotesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

-(void)setUpView
{
    isWeb = true;
    _txtQsearch.delegate = self;
    
    startIndex = 1;
    endIndex = 15;
    
    SHOWLOADING(@"Wait...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self serviceForCount:@""];
        [self serviceForData:[@(startIndex) stringValue] and:[@(endIndex) stringValue] comp:@""];
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
        return 190;
        
    }
    else if (arrDisplayLbl.count == 5)
    {
        return 210;
        
    }
    
    
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrKeyValue.count;
    //    return arrDisplayLbl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuotesCell *cell = (QuotesCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[QuotesCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    
    cell.btnDelete.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnDelete setTitle:@"\uf014" forState:UIControlStateNormal];
    
    cell.btnSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnSelect setTitle:@"\uf00c" forState:UIControlStateNormal];

    cell.btnSelect.tag = [[arrQid objectAtIndex:indexPath.row] integerValue];
    
    cell.btnSelect.accessibilityLabel = [NSString stringWithFormat:@"%@",[arrRecID objectAtIndex:indexPath.row]];
    
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.tag = [[arrQid objectAtIndex:indexPath.row] integerValue];
        
    [cell.btnDelete addTarget:self action:@selector(callForDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *dictionary=[arrKeyValue objectAtIndex:indexPath.row];

    
    if (arrDisplayLbl.count == 1)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = @"Quote Total";
        cell.lblV2.text = [NSString stringWithFormat:@"%@%@",ICODE,[arrTotal objectAtIndex:indexPath.row]];//[arrDisplayLbl
    }
    if (arrDisplayLbl.count == 2)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblV1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblV2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = @"Quote Total";
        cell.lblV3.text = [NSString stringWithFormat:@"%@%@",ICODE,[arrTotal objectAtIndex:indexPath.row]];
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
        cell.lbl4.text = @"Quote Total";
        cell.lblV4.text = [NSString stringWithFormat:@"%@%@",ICODE,[arrTotal objectAtIndex:indexPath.row]];
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
        cell.lbl5.text = @"Quote Total";
        cell.lblV5.text = [NSString stringWithFormat:@"%@%@",ICODE,[arrTotal objectAtIndex:indexPath.row]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-60,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
    }

    cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.frame.size.height-cell.btnView.frame.size.height,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    cell.lbl1.font = SET_FONTS_REGULAR;
    cell.lbl2.font = SET_FONTS_REGULAR;
    cell.lbl3.font = SET_FONTS_REGULAR;
    cell.lbl4.font = SET_FONTS_REGULAR;
    cell.lbl5.font = SET_FONTS_REGULAR;
    cell.lblV1.font = SET_FONTS_REGULAR;
    cell.lblV2.font = SET_FONTS_REGULAR;
    cell.lblV3.font = SET_FONTS_REGULAR;
    cell.lblV4.font = SET_FONTS_REGULAR;
    cell.lblV5.font = SET_FONTS_REGULAR;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtQsearch resignFirstResponder];
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    [self selectWebview:[[arrRecID objectAtIndex:indexPath.row] integerValue] caseID:[[arrRecID objectAtIndex:indexPath.row] integerValue]];
    
    
}

-(void)serviceForCount:(NSString *)company
{
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"quotename":company}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:QUOTE_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchQuoteCountResponse"])
            {
                if([doc valueWithPath:@"SearchQuoteCountResult"])
                {
                    count1 = [[doc valueWithPath:@"SearchQuoteCountResult"] intValue];
                    _btnPrev.hidden = YES;
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


-(void)serviceForData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company
{
    
    if(!company)
        company = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"company_id":WORKGROUP},@{@"quotename":company}]];
    SHOWLOADING(@"Wait...")
    [BaseApplication executeRequestwithService:SEARCH_QUOTE_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
                
                if ([keyStr isEqualToString:@"Quote Name"]&&![valueStr isEqualToString:@""])
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
                else if([keyStr isEqualToString:@"CONTACT_FIRST_NAME"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                else if([keyStr isEqualToString:@"CONTACT_LAST_NAME"]&&![valueStr isEqualToString:@""])
                    
                {
                    [arrDisplayLbl addObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                [arrlblDictionary addObject:tmpDataDic];
                
            }
//            NSLog(@"Display lbl  %@::%ld",arrDisplayLbl,arrDisplayLbl.count);
            arrKeyValue = [[NSMutableArray alloc]init];
            
            arrQid = [[NSMutableArray alloc]init];
            arrCompany = [[NSMutableArray alloc]init];
            arrFname = [[NSMutableArray alloc]init];
            arrLname = [[NSMutableArray alloc]init];
            arrQname = [[NSMutableArray alloc]init];
            arrTotal = [[NSMutableArray alloc]init];
            arrRecID = [[NSMutableArray alloc]init];
            
            //NSLog(@"111 :%@",arrlblDictionary);
            
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeQuoteData"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Quote Name"])
                    {
                        if([doc valueWithPath:@"QuoteName"])
                            [tmpDataDic setValue:[doc valueWithPath:@"QuoteName"] forKey:[d objectForKey:@"value"]];
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
                    if ([[d objectForKey:@"key"]isEqualToString:@"CONTACT_FIRST_NAME"])
                    {
                        if([doc valueWithPath:@"FirstName"])
                            [tmpDataDic setValue:[doc valueWithPath:@"FirstName"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                    if ([[d objectForKey:@"key"]isEqualToString:@"CONTACT_LAST_NAME"])
                    {
                        if([doc valueWithPath:@"LastName"])
                            [tmpDataDic setValue:[doc valueWithPath:@"LastName"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                    
//                    if ([[d objectForKey:@"key"]isEqualToString:@"EE_REP"])
                    {
//                        if([doc valueWithPath:@"QuoteTotal"])
//                        {
//                            [tmpDataDic setValue:[doc valueWithPath:@"QuoteTotal"] forKey:[d objectForKey:@"value"]];
//                            [arrTotal addObject:[doc valueWithPath:@"QuoteTotal"]];
//                        }
//                        else
//                        {
//                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
//                            [arrTotal addObject:@"0.0"];
//
//                        }
                    }
                    if([doc valueWithPath:@"QuoteTotal"])
                    {
                       
                        [arrTotal addObject:[doc valueWithPath:@"QuoteTotal"]];
                    }
                    else
                    {
                        [arrTotal addObject:@"0.0"];
                        
                    }
                    
                if([doc valueWithPath:@"QuoteID"])
                {
                    [arrQid addObject:[doc valueWithPath:@"QuoteID"]];
                    
                }
                if([[doc valueWithPath:@"RECDNO"] integerValue]==0)
                {
                    _tblQuotes.hidden = YES;
                    _lblinfo.hidden = NO;
                    [arrRecID addObject:[doc valueWithPath:@"RECDNO"]];
                    
                }
                else
                {
                    _tblQuotes.hidden = NO;
                    _lblinfo.hidden = YES;
                    [arrRecID addObject:[doc valueWithPath:@"RECDNO"]];

                    
                }
                
            }
                
                [arrKeyValue addObject:tmpDataDic];
            }
            
            // NSLog(@"12 :%@",arrKeyValue);
            // NSLog(@"11 :%@",arrlblDictionary);
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblQuotes reloadData];
                [_txtQsearch resignFirstResponder];
                
                if(([endIndex1 intValue] >= count1) || (count1 <= 15))
                {
                    _lblTotal.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count1,count1];
                    
                }
                else
                {
                    _lblTotal.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count1];
                    
                }
                if(count1 == 0)
                {
                    _lblTotal.text = @"Record Not Found";
                }
                
                STOPLOADING();
            });
            
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
    //    /MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_opportunity_EditForm.asp&RECDNO=" + 	Record_id + "&CompanyID=" + WGID + 	"&appkeyword=&pagetype=opportunity&oppid=" + Opp_id;
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_quote_EditForm.asp&RECDNO=%ld&QuoteID=%ld&CompanyID=%@&sid=%@&appkeyword=&pagetype=quote",MAIN_URL,[BaseApplication getEncryptedKey],(long)recID,(long)caseID,
                           WORKGROUP,LOGIN_ID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [accWebview loadRequest:urlRequest];
//    [self.view addSubview:accWebview];
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


//Delete method button
-(void) callForDeleteRecord:(UIButton *)btn
{
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                     message:@"Are you sure want to delete this record?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"OK"];
    NSString *tmpCaseIDStr=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    alert.tag = [tmpCaseIDStr integerValue];
    [alert show];
    
    
}


#pragma mark - AlertView method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"Button Index =%ld",buttonIndex);
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
        serviceType =  DELETE_QUOTES;
        responseTag = @"DeleteQuotesResponse";
        childTag = @"DeleteQuotesResult";
        tArray=[[NSMutableArray alloc] initWithArray:@[@{@"QuoteIDs":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
        
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
                        [self.view makeToast:@"Record deleted successfully"
                                    duration:3.0
                                    position:CSToastPositionCenter];

//                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
//                                                                         message:@"Record deleted successfully"
//                                                                        delegate:self
//                                                               cancelButtonTitle:@"OK"
//                                                               otherButtonTitles: nil];
//                        [alert show];
                        _strQname = @"";
                        _txtQsearch.text=@"";
                        [self serviceForCount:@""];
                        [self serviceForData:@"1" and:@"15" comp:_strQname];
                    }
                }
            }
            
        }];
        
    }
}


- (IBAction)quoteSideMenu:(id)sender {
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    } else {
        [accWebview removeFromSuperview];
        //        isWeb = false;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }

    
}
- (IBAction)next:(id)sender {

    _btnPrev.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    NSString *strSearchText = _strQname;
    
    if(endIndex < count1)
    {
        [self serviceForData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
    }
    else
    {
        [self serviceForData:[@(startIndex)stringValue] and:[@(count1)stringValue] comp:strSearchText];
        _btnNext.hidden = true;
    }


}

- (IBAction)previouse:(id)sender {
    
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    NSString *strSearchText = _strQname;
    
    [self serviceForData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
    
    
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
    _strQname = @"";
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        
        [self serviceForCount:@""];
        _strQname = @"";
        startIndex = 1;
        endIndex = 15;
        _btnPrev.hidden = YES;
        [self serviceForData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@""];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter Quote name"
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
        _strQname = searchBar.text;
        [self serviceForCount:_strQname];
        [self serviceForData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:_strQname];
        
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
