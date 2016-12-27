//
//  CheckForMatch.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "CheckForMatch.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "Toast/UIView+Toast.h"

@implementation MatchCell


@end

@interface CheckForMatch ()
{
    UIWebView *accWebview;
    NSMutableArray *arrRecId,*arrFname,*arrLname,*arrCompany,*arrPhone,*arrDisplayLbl,*arrlblDictionary,*arrKeyValue;
    int count,startIndex,endIndex;
    NSString *name,*acount;
    BOOL isWeb;
}
@end

@implementation CheckForMatch

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView
{
    isWeb = true;
    name=@"";
    acount=@"";
    startIndex = 1;
    endIndex = 15;
    _tblMatch.hidden = YES;
    _btnPrev.hidden = YES;
//    &#xf002
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:30.0];
//    [_btnSearch setTitle:@"\uf021" forState:UIControlStateNormal];
    [_btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (accWebview) {
        [accWebview removeFromSuperview];
    }
    self.pagingView.hidden = YES;
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
        
    }
}



#pragma mark - Table View Delegate Methods

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (arrDisplayLbl.count == 1)
//    {
//        return 130;
//    }
//    else if (arrDisplayLbl.count == 2)
//    {
//        return 150;
//    }
//    
//    return 0.0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrRecId.count;
    //        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchCell *cell = (MatchCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[MatchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    self.pagingView.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnSelect setTitle:@"\uf00c" forState:UIControlStateNormal];
    
    cell.btnSelect.tag = [[arrRecId objectAtIndex:indexPath.row] integerValue];
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnWeb.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnWeb setTitle:@"\uf0ac" forState:UIControlStateNormal];
    
    cell.btnWeb.tag = indexPath.row;
    [cell.btnWeb addTarget:self action:@selector(callForWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPhone.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnPhone setTitle:@"\uf095" forState:UIControlStateNormal];
    
    cell.btnPhone.tag = indexPath.row;
    [cell.btnPhone addTarget:self action:@selector(callForPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[arrPhone objectAtIndex:indexPath.row] isEqualToString:@"none"])
        cell.btnPhone.hidden = YES;
    else
        cell.btnPhone.hidden = NO;


    cell.btnWeb.hidden = NO;
    cell.btnSelect.hidden = NO;

    if(![acount isEqualToString:@""])
    {
        cell.lblAcc.hidden = NO;
        cell.lblAccount.hidden = NO;
    }
    else
    {
        cell.lblAcc.hidden = YES;
        cell.lblAccount.hidden = YES;
    }
    cell.lblAcc.text = acount;
    cell.lblAccount.text = [arrCompany objectAtIndex:indexPath.row];
    
    if(![name isEqualToString:@""])
    {
        cell.lblCon.hidden = NO;
        cell.lblContact.hidden = NO;
    }else{
        cell.lblCon.hidden = YES;
        cell.lblContact.hidden = NO;

    }
    cell.lblCon.text = name;
    NSString *str = [NSString stringWithFormat:@"%@ %@",[arrFname objectAtIndex:indexPath.row],[arrLname objectAtIndex:indexPath.row]];
    cell.lblContact.text = str;
    cell.lblPhone.text = [arrPhone objectAtIndex:indexPath.row];

    
//    NSDictionary *dictionary=[arrKeyValue objectAtIndex:indexPath.row];
//    
//    if (arrDisplayLbl.count == 1)
//    {
//        if(![[dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]] isEqualToString:@"none"])
//        {
//            cell.lblAcc.text = [[dictionary allKeys] objectAtIndex:0];
//            cell.lblAccount.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
//            cell.lblPhone.text = [arrPhone objectAtIndex:indexPath.row];
//            
//            cell.btnWeb.hidden = NO;
//            cell.btnSelect.hidden = NO;
//
//        }
//        
//    }
//    if (arrDisplayLbl.count == 2)
//    {
//        if(![[dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]] isEqualToString:@"none"] &&
//           ![[dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]] isEqualToString:@"none"])
//        {
//            cell.lblAcc.text = [[dictionary allKeys] objectAtIndex:0];
//            cell.lblAccount.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
//            cell.lblCon.text = [[dictionary allKeys] objectAtIndex:1];
//            cell.lblContact.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
//            cell.lblPhone.text = [arrPhone objectAtIndex:indexPath.row];
//           
//            cell.btnWeb.hidden = NO;
//            cell.btnSelect.hidden = NO;
//
//        }
//        
//    }
    cell.lblAcc.font = SET_FONTS_REGULAR;
    cell.lblAccount.font = SET_FONTS_REGULAR;
    cell.lblCon.font = SET_FONTS_REGULAR;
    cell.lblPhone.font = SET_FONTS_REGULAR;
    cell.lblContact.font = SET_FONTS_REGULAR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    [self selectWebview:[[arrRecId objectAtIndex:indexPath.row] integerValue]];
    
}



-(void)serviceForMatch:(NSString *) startIndex1 end:(NSString *)endIndex1{
    
    NSString *strln,*straddress,*strEmail,*strCompany,*strPhone;
    
    if([_txtLastName.text isEqualToString:@""])
        strln = @"";
    else
        strln = _txtLastName.text;
    if([_txtEmail.text isEqualToString:@""])
        strEmail = @"";
    else
        strEmail = _txtEmail.text;
                 
    if([_txtAdress.text isEqualToString:@""])
        straddress = @"";
     else
         straddress = _txtAdress.text;

    if([_txtCompany.text isEqualToString:@""])
        strCompany = @"";

    else
        strCompany = _txtCompany.text;

    if([_txtPhone.text isEqualToString:@""])
        strPhone = @"";
    else
        strPhone = _txtPhone.text;
    
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"LastName":strln},@{@"Company":strCompany},@{@"Email":strEmail},@{@"Address":straddress},@{@"Phone":strPhone},@{@"startindex":startIndex1},@{@"endindex":endIndex1}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:MATCH_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        //        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
        arrRecId = [[NSMutableArray alloc]init];
        arrCompany = [[NSMutableArray alloc]init];
        arrFname = [[NSMutableArray alloc]init];
        arrLname = [[NSMutableArray alloc]init];
        arrPhone = [[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblActivity.hidden = true;
        }
        else
        {
            arrlblDictionary= [[NSMutableArray alloc]init ];//WithObjects:@"",@"",@"",@"",@"", nil];
            arrDisplayLbl = [[NSMutableArray alloc]init];//WithObjects:@"",@"",@"",@"",@"", nil];
            for (NSDictionary *tmpDicForLbl in [AppDelegate initAppdelegate].allDisplayLblArray)
            {
                NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
                NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                if([keyStr isEqualToString:@"Banner - Accounts"]&&![valueStr isEqualToString:@""])
                {
                    acount = valueStr ;
//                    [arrDisplayLbl addObject:valueStr];
//                    
//                    [tmpDataDic setValue:valueStr forKey:@"value"];
//                    [tmpDataDic setValue:keyStr forKey:@"key"];
                }
                if ([keyStr isEqualToString:@"Banner - Contacts"]&&![valueStr isEqualToString:@""])
                {
                    name = valueStr;
//                    [arrDisplayLbl addObject:valueStr];
//                    
//                    [tmpDataDic setValue:valueStr forKey:@"value"];
//                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    
                }
                [arrlblDictionary addObject:tmpDataDic];

            }
            arrKeyValue = [[NSMutableArray alloc]init];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Banner - Accounts"])
                    {
                        if([doc valueWithPath:@"Company"])
                            [tmpDataDic setValue:[doc valueWithPath:@"Company"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Banner - Contacts"])
                    {
                        if([doc valueWithPath:@"FirstName"] || [doc valueWithPath:@"LastName"])
                        {
                            if([doc valueWithPath:@"FirstName"])
                            {
                                name = [NSString stringWithFormat:@"%@%@",name,[doc valueWithPath:@"FirstName"]];
//                                [tmpDataDic setValue:name forKey:[d objectForKey:@"value"]];
                            }
                            if([doc valueWithPath:@"LastName"])
                            {
                                name = [NSString stringWithFormat:@"%@ %@",name,[doc valueWithPath:@"LastName"]];
//                                [tmpDataDic setValue:name forKey:[d objectForKey:@"value"]];
                                
                            }
                            [tmpDataDic setValue:name forKey:[d objectForKey:@"value"]];
                            
                        }
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                        [arrKeyValue addObject:tmpDataDic];

                    }
                }
                for (NSDictionary *d in arrlblDictionary)
                {
                    if ([[d objectForKey:@"key"]isEqualToString:@"Banner - Contacts"])
                    {
                        if([doc valueWithPath:@"LastName"])
                            [tmpDataDic setValue:[doc valueWithPath:@"LastName"] forKey:[d objectForKey:@"value"]];
                        else
                            [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                        
                    }
                }
                
                if(![[doc valueWithPath:@"RecordID"] isEqualToString:@"0"])
                    [arrRecId addObject:[doc valueWithPath:@"RecordID"]];
                if([doc valueWithPath:@"Phone"])
                    [arrPhone addObject:[doc valueWithPath:@"Phone"]];
                else
                    [arrPhone addObject:@"none"];
                if([doc valueWithPath:@"Company"])
                    [arrCompany addObject:[doc valueWithPath:@"Company"]];
                else
                    [arrCompany addObject:@"none"];


                
                if([doc valueWithPath:@"FirstName"])
                    [arrFname addObject:[doc valueWithPath:@"FirstName"]];
                else
                    [arrFname addObject:@""];
                
                if([doc valueWithPath:@"LastName"])
                    [arrLname addObject:[doc valueWithPath:@"LastName"]];
                else
                    [arrLname addObject:@""];

                [arrKeyValue addObject:tmpDataDic];

            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblMatch reloadData];
                _tblMatch.hidden = NO;
                
                
                
                if(([endIndex1 intValue] >= count) || (count <= 15))
                {
                    _lblCount.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count,count];
                    
                }
                else
                {
                    _lblCount.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count];
                    
                }
                if(count == 0)
                {
                    _lblCount.text = @"Record Not Found";
                    [self.view makeToast:@"No data found for this section"
                                duration:3.0
                                position:CSToastPositionCenter];
                }

                STOPLOADING();
            });
            
        }
        
    }];
}

-(void)serviceForCount
{
    NSString *strln,*straddress,*strEmail,*strCompany,*strPhone;
    
    if([_txtLastName.text isEqualToString:@""])
        strln = @"";
    else
        strln = _txtLastName.text;
    if([_txtEmail.text isEqualToString:@""])
        strEmail = @"";
    else
        strEmail = _txtEmail.text;
    
    if([_txtAdress.text isEqualToString:@""])
        straddress = @"";
    else
        straddress = _txtAdress.text;
    
    if([_txtCompany.text isEqualToString:@""])
        strCompany = @"";
    
    else
        strCompany = _txtCompany.text;
    
    if([_txtPhone.text isEqualToString:@""])
        strPhone = @"";
    else
        strPhone = _txtPhone.text;
    
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"LastName":strln},@{@"Company":strCompany},@{@"Email":strEmail},@{@"Address":straddress},@{@"Phone":strPhone}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:MATCH_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        SMXMLElement *rootDoctument = [document firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"CheckForMatchCountResponse"])
            {
                if([doc valueWithPath:@"CheckForMatchCountResult"])
                {
                    count = [[doc valueWithPath:@"CheckForMatchCountResult"] intValue];
                    _btnPrev.hidden = YES;
                    _btnNext.hidden = YES;
                    if (count>15)
                    {
                        _btnNext.hidden = NO;
                    }
                    if(count == 0)
                    {
                        _btnPrev.hidden = YES;
                    }
                }
            }
        }
        
    }];
    
}



//Cell button methods

-(void)callForSelect:(UIButton *)btn
{
    [self selectWebview:btn.tag];
    
}
-(void)selectWebview:(NSInteger)recID
{
    //   MainUrl + "/mobile_auth.asp?key=" + encp + "&topage=mobile_frmSalesProgress.asp?RECDNO=" + RecordId;
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_frmSalesProgress.asp&RECDNO=%ld",MAIN_URL,[BaseApplication getEncryptedKey],(long)recID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.width - 113)];        //        NSLog(@"Landscape");
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


//call for Phonecall
-(void)callForPhone:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@",[arrPhone objectAtIndex:btn.tag]];
    
    if(![str isEqualToString:@"none"])
    {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:str];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    
}

//call for Web

-(void)callForWeb:(UIButton *)btn
{
    
    NSString* stringURL = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", [arrCompany objectAtIndex:btn.tag]];
    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)previous:(id)sender {
    
    _btnNext.hidden = false;
    NSLog(@"%d",startIndex);
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    [self serviceForMatch:[@(startIndex)stringValue] end:[@(endIndex)stringValue]];

    if (endIndex<=15) {
        _btnPrev.hidden = YES;
        _btnNext.hidden = NO;
        
    }else{
        if (endIndex < count) {
            _btnNext.hidden = NO;
        }
    }


}

- (IBAction)next:(id)sender {
    _btnPrev.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    if(endIndex < count)
    {
        [self serviceForMatch:[@(startIndex)stringValue] end:[@(endIndex)stringValue] ];
    }
    else
    {
        [self serviceForMatch:[@(startIndex)stringValue] end:[@(count)stringValue] ];
        _btnNext.hidden = true;
    }

}

- (IBAction)matchMenu:(id)sender {
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

- (IBAction)searchData:(id)sender {
    [self serviceForCount];
    [self serviceForMatch:@"1" end:@"15" ];
    [self.view endEditing:YES];
}

#pragma TextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
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
}

@end
