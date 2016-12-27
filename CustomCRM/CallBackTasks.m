//
//  CallBackTasks.m
//  CustomCRM
//
//  Created by Pinal Panchani on 08/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "CallBackTasks.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "UIView+Toast.h"
@implementation CallBackCell



@end

@interface CallBackTasks ()
{
    int count1,startIndex,endIndex;
    NSMutableArray *arrlblDictionary,*arrDisplayLbl,*arrCallBackID ,*arrKeyValue,*arrRECNo,*arrPhone,*arrEStatus;
    UIWebView *accWebview;
    BOOL isWeb;
    NSMutableArray *openView;
    NSString *strSearch;
}

@end

@implementation CallBackTasks

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    openView = [[NSMutableArray alloc] init];
    //    [self.statusView setHidden:YES];
}
-(void)setUpView
{
    isWeb = true;
    startIndex = 1;
    endIndex = 15;
    [self serviceForCount:@"" date:@""];
    [self serviceForCallbackData:@"1" and:@"15" comp:@"" date:@""];
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    strSearch = @"";
    if (accWebview) {
        [accWebview removeFromSuperview];
        
    } [self setUpView];
    [self setFonts_Background];
}
-(void)viewDidDisappear:(BOOL)animated{
    ////self.statusView.hidden=YES;
    
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
    
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrKeyValue.count;
    //        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallBackCell *cell = (CallBackCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[CallBackCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    
    cell.btnEdit.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnEdit setTitle:@"\uf044" forState:UIControlStateNormal];
    
    cell.btnPlus.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnPlus setTitle:@"\uf067" forState:UIControlStateNormal];
    
    cell.btnSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnSelect setTitle:@"\uf00c" forState:UIControlStateNormal];
    
    cell.btnCalender.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnCalender setTitle:@"\uf073" forState:UIControlStateNormal];
    
    cell.btnDelete.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnDelete setTitle:@"\uf014" forState:UIControlStateNormal];
    
    cell.btnSelect.tag = [[arrCallBackID objectAtIndex:indexPath.row] integerValue];
    cell.btnSelect.accessibilityLabel = [NSString stringWithFormat:@"%@",[arrRECNo objectAtIndex:indexPath.row]];
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnEdit.tag = [[arrCallBackID objectAtIndex:indexPath.row] integerValue];
    NSString *tmpCaseIDStr=[NSString stringWithFormat:@"%@",[arrRECNo objectAtIndex:indexPath.row]];
    cell.btnEdit.accessibilityLabel = tmpCaseIDStr;
    [cell.btnEdit addTarget:self action:@selector(callForEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.tag = [[arrCallBackID objectAtIndex:indexPath.row] integerValue];
    cell.btnDelete.accessibilityLabel = tmpCaseIDStr;
    [cell.btnDelete addTarget:self action:@selector(callForDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPlus.tag = indexPath.row;
    [cell.btnPlus addTarget:self action:@selector(callForAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnCalender.tag = indexPath.row;
    [cell.btnCalender addTarget:self action:@selector(callForCalender:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *dictionary=[arrKeyValue objectAtIndex:indexPath.row];
    
    if (arrDisplayLbl.count == 1)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblv1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];          //[arrDisplayLbl
    }
    if (arrDisplayLbl.count == 2)
    {
        
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblv1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblv2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-100,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    }
    if (arrDisplayLbl.count == 3)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblv1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblv2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblv3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        [cell.btnv3 setTitle:[dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]] forState:UIControlStateNormal];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-80,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
    }
    if (arrDisplayLbl.count == 4)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblv1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblv2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblv3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblv4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-60,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
        
    }
    if (arrDisplayLbl.count == 5)
    {
        cell.lbl1.text = [[dictionary allKeys] objectAtIndex:0];
        cell.lblv1.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:0]];
        cell.lbl2.text = [[dictionary allKeys] objectAtIndex:1];
        cell.lblv2.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:1]];
        cell.lbl3.text = [[dictionary allKeys] objectAtIndex:2];
        cell.lblv3.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:2]];
        cell.lbl4.text = [[dictionary allKeys] objectAtIndex:3];
        cell.lblv4.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:3]];
        cell.lbl5.text = [[dictionary allKeys] objectAtIndex:4];
        cell.lblv5.text = [dictionary valueForKey:[[dictionary allKeys] objectAtIndex:4]];
        
        cell.btnView.frame = CGRectMake(cell.btnView.frame.origin.x,cell.btnView.frame.origin.y-40,cell.btnView.frame.size.width,cell.btnView.frame.size.height);
    }
    int count = 0,index = 0;
    for (NSString *str in [dictionary allValues]) {
        
        if ([str isEqualToString:@"Open"]) {
            index = count;
            
        } else if ([str isEqualToString:@"Close"]){
            index = count;
        }
        else
        {
            //            cell.btnv3.hidden=YES;
        }
        count ++;
    }
    
    
    switch (index) {
        case 0:
            cell.btnv3.hidden = NO;
            break;
        case 1:
            cell.btnv3.hidden = NO;
            break;
        case 2:
            cell.btnv3.hidden = NO;
            break;
        case 3:
            cell.btnv3.hidden = NO;
            break;
        case 4:
            cell.btnv3.hidden = NO;
            break;
            
        default:
            cell.btnv3.hidden = YES;
            break;
    }
    cell.constBtnTop.constant = (index * 8) + ((index - 1) * 17);
    cell.btnv3.frame = CGRectMake(cell.btnv3.frame.origin.x, cell.btnv3.frame.origin.y, cell.btnv3.frame.size.width, 17);
    [cell.btnv3 setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
//    cell.btnv3.imageEdgeInsets = UIEdgeInsetsMake(0., cell.btnv3.frame.size.width - (cell.btnv3.imageView.image.size.width + 60), 0., 0.);
    
    cell.statusView.hidden = YES;
    cell.btnv3.userInteractionEnabled=true;
    cell.btnv3.tag=indexPath.row;
    cell.btnOpen.tag = indexPath.row;
    cell.btnClose.tag = indexPath.row;
    cell.btnv3.accessibilityLabel = [NSString stringWithFormat:@"%@",[arrEStatus objectAtIndex:indexPath.row]];
    [cell.btnv3 addTarget:self action:@selector(openCloseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = cell.statusView.frame;
    frame.origin.y = cell.btnv3.frame.size.height + cell.btnv3.frame.origin.y;
    frame.origin.x = cell.btnv3.frame.origin.x;
    frame.size.width = cell.btnv3.frame.size.width;
    cell.statusView.frame = frame;
    
    cell.lbl1.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lbl2.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lbl3.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lbl4.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lbl5.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.btnOpen.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.btnClose.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
    
    cell.lblv1.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lblv2.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lblv3.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lblv4.font = [SET_FONTS_REGULAR fontWithSize:14];
    cell.lblv5.font = [SET_FONTS_REGULAR fontWithSize:14];
    
    return cell;
}

-(void)openCloseBtnTapped : (UIButton *)sender{
    //    if (self.statusView.hidden) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    for (int i = 0; i < openView.count; i++) {
        NSIndexPath *indexPath1 = [openView objectAtIndex:i];
        if (indexPath1.row != indexPath.row) {
            CallBackCell *cell = (CallBackCell *)[_tblCallBacks cellForRowAtIndexPath:indexPath1];
            cell.statusView.hidden = YES;
        }
    }
    [openView removeAllObjects];
    CallBackCell *cell = (CallBackCell *)[_tblCallBacks cellForRowAtIndexPath:indexPath];
    if (cell.statusView.hidden) {
        [openView addObject:indexPath];
        cell.statusView.hidden=NO;
        NSLog(@"%@",sender);
        
        cell.btnOpen.accessibilityLabel = sender.accessibilityLabel;
        cell.btnClose.accessibilityLabel = sender.accessibilityLabel;
        cell.btnOpen.tag=sender.tag;
        cell.btnClose.tag=sender.tag;
        [cell.btnOpen addTarget:self action:@selector(btnOpenTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnClose addTarget:self action:@selector(btnClosedTapped:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.statusView.hidden=YES;
    }
}


- (IBAction)btnOpenTapped:(id)sender {
    // ((UIView*)sender).tag; get index path of cell
    if([((UIView*)sender).accessibilityLabel isEqualToString:@"Open"])
    {
        
    }
    else if([((UIView*)sender).accessibilityLabel isEqualToString:@"Close"])
    {
        [self serviceForOpenClose:@"0" cid:[arrCallBackID objectAtIndex:((UIView*)sender).tag]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self serviceForCallbackData:@"1" and:@"15" comp:@"" date:@""];
            
        });
        [self.view makeToast:@"Event status change sucessfully"
                    duration:3.0
                    position:CSToastPositionCenter];
    }
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    CallBackCell *cell = (CallBackCell *)[_tblCallBacks cellForRowAtIndexPath:indexPath];
    cell.statusView.hidden=YES;
    
}

- (IBAction)btnClosedTapped:(id)sender {
    // ((UIView*)sender).tag; get index path of cell
    if([((UIView*)sender).accessibilityLabel isEqualToString:@"Close"])
    {
        
    }
    else if([((UIView*)sender).accessibilityLabel isEqualToString:@"Open"])
    {
        [self serviceForOpenClose:@"1" cid:[arrCallBackID objectAtIndex:((UIView*)sender).tag]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self serviceForCallbackData:@"1" and:@"15" comp:@"" date:@""];
        });
        
        [self.view makeToast:@"Event status change sucessfully"
                    duration:3.0
                    position:CSToastPositionCenter];
        //        [self serviceForOpenClose:@"1" cid:[arrCallBackID objectAtIndex:((UIView*)sender).tag]];
    }
    
    //    [self serviceForOpenClose:@"1" cid:[arrCallBackID objectAtIndex:((UIView*)sender).tag]];
    
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    CallBackCell *cell = (CallBackCell *)[_tblCallBacks cellForRowAtIndexPath:indexPath];
    cell.statusView.hidden=YES;
    //    ////self.statusView.hidden=YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtCallBackSearch resignFirstResponder];
    CallBackCell *cell = [self.tblCallBacks cellForRowAtIndexPath:indexPath];
    if (cell.statusView.hidden == YES) {
        if (isWeb) {
            [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
        } else {
            [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
        }
        isWeb = false;
        [self selectWebview:[[arrRECNo objectAtIndex:indexPath.row] integerValue] caseID:[[arrCallBackID objectAtIndex:indexPath.row] integerValue]];
    }
    else{
        cell.statusView.hidden = YES;
    }
}


-(void)serviceForCount:(NSString *)company date:(NSString *)mDate
{
    if(!company)
        company = @"";
    if(!mDate)
        mDate = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"eventname":company},@{@"eventdate":mDate}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:CALLBACK_COUNT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchCallBackCountResponse"])
            {
                if([doc valueWithPath:@"SearchCallBackCountResult"])
                {
                    count1 = [[doc valueWithPath:@"SearchCallBackCountResult"] intValue];
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count1] forKey:Key_callback_count];
                    _prev.hidden = YES;
                    _next.hidden = YES;
                    if (count1>15)
                    {
                        _next.hidden = NO;
                    }
                }
            }
        }
        
    }];
}
//call for open-close

-(void)serviceForOpenClose:(NSString *)isdone cid:(NSString *)callbackId
{
    //    if(!company)
    //        company = @"";
    //    if(!mDate)
    //        mDate = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"isdone":isdone},@{@"callbackid":callbackId}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:OPEN_CLOSE_CALLBACK arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"LMUpdateCallBackEventsResponse"])
            {
                if([doc valueWithPath:@"LMUpdateCallBackEventsResult"])
                {
                    NSString *str = [doc valueWithPath:@"LMUpdateCallBackEventsResult"];
                    NSLog(@"CallBackTasks: %@",str);
                }
            }
        }
        
    }];
}


-(void)serviceForCallbackData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company date:(NSString *) mDate
{
    
    if(!company)
        company = @"";
    if(!mDate)
        mDate = @"";
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"eventname":company},@{@"eventdate":mDate}]];
    SHOWLOADING(@"Wait...")
    [BaseApplication executeRequestwithService:SEARCH_CALLBACK_DATA arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            arrlblDictionary= [[NSMutableArray alloc]init ];//WithObjects:@"",@"",@"",@"",@"", nil];
            arrDisplayLbl = [[NSMutableArray alloc]init];//WithObjects:@"",@"",@"",@"",@"", nil];
            for (NSDictionary *tmpDicForLbl in [AppDelegate initAppdelegate].allDisplayLblArray)
            {
                NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
                NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                if ([keyStr isEqualToString:@"Event Name"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    //                    [arrDisplayLbl replaceObjectAtIndex:0 withObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    //                     [arrlblDictionary replaceObjectAtIndex:0 withObject:tmpDataDic];
                    
                }
                else if([keyStr isEqualToString:@"Company"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    //                    [arrDisplayLbl replaceObjectAtIndex:1 withObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    //                    [arrlblDictionary replaceObjectAtIndex:1 withObject:tmpDataDic];
                    
                    //  NSLog(@"AccValue%@",valueStr);
                }
                else if([keyStr isEqualToString:@"Event Done"]&&![valueStr isEqualToString:@""])
                {
                    [arrDisplayLbl addObject:valueStr];
                    //                    [arrDisplayLbl replaceObjectAtIndex:2 withObject:valueStr];
                    [tmpDataDic setValue:valueStr forKey:@"value"];
                    [tmpDataDic setValue:keyStr forKey:@"key"];
                    //                    [arrlblDictionary replaceObjectAtIndex:2 withObject:tmpDataDic];
                    
                }
                [arrlblDictionary addObject:tmpDataDic];
                
            }
            
            NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
            
            [arrDisplayLbl addObject:@"Start Time"];
            [tmpDataDic setValue:@"Start Time" forKey:@"value"];
            [tmpDataDic setValue:@"Start Time" forKey:@"key"];
            [arrlblDictionary addObject:tmpDataDic];
            
            [arrDisplayLbl addObject:@"End time"];
            //            [arrDisplayLbl replaceObjectAtIndex:3 withObject:@"Start Time"];
            //            [arrDisplayLbl replaceObjectAtIndex:4 withObject:@"End time"];
            
            //            [arrlblDictionary replaceObjectAtIndex:3 withObject:tmpDataDic];
            tmpDataDic=[[NSMutableDictionary alloc]init];
            [tmpDataDic setValue:@"End Time" forKey:@"value"];
            [tmpDataDic setValue:@"End Time" forKey:@"key"];
            [arrlblDictionary addObject:tmpDataDic];
            //            [arrlblDictionary replaceObjectAtIndex:4 withObject:tmpDataDic];
            
//            NSLog(@"Display lbl  %@::%ld",arrDisplayLbl,arrDisplayLbl.count);
            arrKeyValue = [[NSMutableArray alloc]init];//WithObjects:@"",@"",@"",@"",@"", nil];
            arrCallBackID = [[NSMutableArray alloc]init];
            arrPhone = [[NSMutableArray alloc]init];
            arrRECNo = [[NSMutableArray alloc]init];
            arrEStatus = [[NSMutableArray alloc]init];
            
            //NSLog(@"111 :%@",arrlblDictionary);
            
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeEventData"])
            {
                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                {
                    NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                    
                    
                    for (NSDictionary *d in arrlblDictionary)
                    {
                        if ([[d objectForKey:@"key"]isEqualToString:@"Event Name"])
                        {
                            if([doc valueWithPath:@"EventName"])
                                [tmpDataDic setValue:[doc valueWithPath:@"EventName"] forKey:[d objectForKey:@"value"]];
                            else
                                [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                            //                        [arrKeyValue replaceObjectAtIndex:0 withObject:tmpDataDic];
                            
                            
                        }
                        
                        if ([[d objectForKey:@"key"]isEqualToString:@"Company"])
                        {
                            if([doc valueWithPath:@"Company"])
                                [tmpDataDic setValue:[doc valueWithPath:@"Company"] forKey:[d objectForKey:@"value"]];
                            else
                                [tmpDataDic setValue:@"none" forKey:[d objectForKey:@"value"]];
                            //                        [arrKeyValue replaceObjectAtIndex:1 withObject:tmpDataDic];
                        }
                        
                        if ([[d objectForKey:@"key"]isEqualToString:@"Start Time"])
                        {
                            if([doc valueWithPath:@"StartTime"])
                                [tmpDataDic setValue:[doc valueWithPath:@"StartTime"] forKey:@"Start Time"];
                            else
                                [tmpDataDic setValue:@"none" forKey:@"Start Time"];
                            //                        [arrKeyValue replaceObjectAtIndex:2 withObject:tmpDataDic];
                            
                        }
                        if ([[d objectForKey:@"key"]isEqualToString:@"End Time"])
                        {
                            if([doc valueWithPath:@"EndTime"])
                                [tmpDataDic setValue:[doc valueWithPath:@"EndTime"] forKey:@"End Time"];
                            else
                                [tmpDataDic setValue:@"none" forKey:@"End Time"];
                            //                        [arrKeyValue replaceObjectAtIndex:3 withObject:tmpDataDic];
                            
                        }
                        
                        
                        if ([[d objectForKey:@"key"]isEqualToString:@"Event Done"])
                        {
                            if([doc valueWithPath:@"EventStatus"])
                            {
                                if ([[doc valueWithPath:@"EventStatus"] integerValue]==0) {
                                    [tmpDataDic setValue:@"Open" forKey:@"Event Done"];
                                    [arrEStatus addObject:@"Open"];
                                }
                                else if ([[doc valueWithPath:@"EventStatus"] integerValue]==1) {
                                    [tmpDataDic setValue:@"Close" forKey:@"Event Done"];
                                    [arrEStatus addObject:@"Close"];
                                }
                                
                            }
                            else
                            {
                                [tmpDataDic setValue:@"none" forKey:@"Event Done"];
                            }
                            //                        [arrKeyValue replaceObjectAtIndex:4 withObject:tmpDataDic];
                        }
                        
                    }
                    
                    //                    if([doc valueWithPath:@"CallBackID"])
                    //                    {
                    //                        [arrCallBackID addObject:[doc valueWithPath:@"CallBackID"]];
                    //
                    //                    }
                    if([[doc valueWithPath:@"CallBackID"] integerValue]==0)
                    {
                        _tblCallBacks.hidden = YES;
                        _lblinfo.hidden = NO;
                        [arrCallBackID addObject:[doc valueWithPath:@"CallBackID"]];
                        
                    }
                    else
                    {
                        _tblCallBacks.hidden = NO;
                        _lblinfo.hidden = YES;
                        [arrCallBackID addObject:[doc valueWithPath:@"CallBackID"]];
                        
                        
                    }
                    
                    if([doc valueWithPath:@"RECDNO"])
                    {
                        [arrRECNo addObject:[doc valueWithPath:@"RECDNO"]];
                        
                    }
                    
                    [arrKeyValue addObject:tmpDataDic];
                    
                }
                else
                {
                    _tblCallBacks.hidden = YES;
                    _lblinfo.hidden = NO;
                    
                }
                
            }
            
            NSLog(@"Keyvalue :%@",arrKeyValue);
            // NSLog(@"11 :%@",arrlblDictionary);
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblCallBacks reloadData];
                [_txtCallBackSearch resignFirstResponder];
                
                
                
                if(([endIndex1 intValue] >= count1) || (count1 <= 15))
                {
                    _callBackCount.text = [NSString stringWithFormat:@"%@ to %d of %d",startIndex1,count1,count1];
                }
                else
                {
                    _callBackCount.text = [NSString stringWithFormat:@"%@ to %@ of %d",startIndex1,endIndex1,count1];
                    
                }
                if(count1 == 0)
                {
                    _callBackCount.text = @"Record Not Found";
                }
                
                STOPLOADING();
            });
            
        }
        
    }];
}


#pragma mark - Searchbar delegate methods

//Searchbar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //self.statusView.hidden=YES;
    
    _strCallback = @"";
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        strSearch = @"";
        [self serviceForCount:@"" date:@""];
        startIndex = 1;
        endIndex = 15;
        _prev.hidden = true;
        [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@"" date:@""];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter callback/event name"
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
        _prev.hidden = true;
        strSearch = searchBar.text;
        [self serviceForCount:strSearch date:@""];
        [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearch date:@""];
        
    }
}



- (IBAction)callBackMenu:(id)sender {
    ////self.statusView.hidden=YES;
    
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
- (IBAction)btnNext:(id)sender {
    ////self.statusView.hidden=YES;
    
    _prev.hidden = NO;
    
    startIndex = startIndex+15;
    endIndex = endIndex+15;
    
    NSString *strSearchText = strSearch;
    
    if(endIndex < count1)
    {
        [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText date:@""];
    }
    else
    {
        [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(count1)stringValue] comp:strSearchText date:@""];
        _next.hidden = true;
    }
    
}
- (IBAction)btnPrevious:(id)sender {
    ////self.statusView.hidden=YES;
    
    startIndex = startIndex-15;
    endIndex = endIndex-15;
    NSString *strSearchText = strSearch;
    
    [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText date:@""];
    
    
    if (endIndex<=15) {
        _prev.hidden = YES;
        _next.hidden = NO;
        
    }else{
        if (endIndex < count1) {
            _next.hidden = NO;
        }
    }
    
}

//- (IBAction)callNextRecord:(id)sender {
//    _btnPrev.hidden = NO;
//
//    startIndex = startIndex+15;
//    endIndex = endIndex+15;
//
//    NSString *strSearchText = _txtSearch.text;
//
//    if(endIndex < count)
//    {
//        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
//    }
//    else
//    {
//        [self serviceForAccountData:[@(startIndex)stringValue] and:[@(count)stringValue] comp:strSearchText];
//        _btnNext.hidden = true;
//    }
//
//}
//
//- (IBAction)callPrevRecord:(id)sender {
//
//    _btnNext.hidden = false;
//    NSLog(@"%d",startIndex);
//    startIndex = startIndex-15;
//    endIndex = endIndex-15;
//    NSString *strSearchText = _txtSearch.text;
//
//    [self serviceForAccountData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:strSearchText];
//
//
//    if (endIndex<=15) {
//        _btnPrev.hidden = YES;
//        _btnNext.hidden = NO;
//
//    }else{
//        if (endIndex < count) {
//            _btnNext.hidden = NO;
//        }
//    }
//}


// Button methods

//Select button method

-(void)callForSelect:(UIButton *)btn
{
    ////self.statusView.hidden=YES;
    
    [self selectWebview:btn.tag caseID:[btn.accessibilityLabel integerValue]];
    //     [self selectWebview:btn.tag caseID:btn.tag];
}

-(void)selectWebview:(NSInteger)recID caseID:(NSInteger)caseID
{
    //    MainUrl + "/mobile_auth.asp?key=" + encp + "&topage = 	mobile_cbViewEvent.asp&RECDNO=" + Callback_Id + "&CompanyID=" 	+ WGID + "&CallBackID=" + Callback_Id + "&appkeyword=  	&pagetype= callback";
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_cbViewEvent.asp&RECDNO=%ld&CompanyID=%@&CallBackID=%ld&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey],(long)caseID,WORKGROUP,(long)recID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 113)];
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


//Add button method

-(void)callForAdd:(UIButton *)btn
{
    ////self.statusView.hidden=YES;
    
    //    MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_cbEditEvent.asp&add_CallBack=T" + 	"&appkeyword=&pagetype=callback";
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_cbEditEvent.asp&&add_CallBack=T&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [accWebview loadRequest:urlRequest];
    [self.view addSubview:accWebview];
}

//edit button method

-(void)callForEdit:(UIButton *)btn
{
    ////self.statusView.hidden=YES;
    
    //    MainUrl + "/mobile_auth.asp?key=" + encp + 	"&topage=mobile_cbEditEvent.asp&frompage=mobile_RFullEdit.asp&	RECDNO=" + Rcd_Id + "&CompanyID=7639" + WGID + "&CallBackId=" 	+ Callback_Id + "&appkeyword=&pagetype=callback";
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_cbEditEvent.asp&frompage=mobile_RFullEdit.asp&RECDNO=%ld&CompanyID=%@&CallBackId=%ld&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey],(long)[btn.accessibilityLabel integerValue],WORKGROUP,(long)btn.tag];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    
    [accWebview loadRequest:urlRequest];
    [self.view addSubview:accWebview];
}

//calender button method

-(void)callForCalender:(UIButton *)btn
{
    
    
    //    MainUrl + "/mobile_auth.asp?key=" + encp + 		"&topage=mobile_calWeek.asp";
    
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_calWeek.asp" ,MAIN_URL,[BaseApplication getEncryptedKey]];
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
    ////self.statusView.hidden=YES;
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                     message:@"Are you sure want to delete this record?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"OK"];
    
    
    alert.tag = btn.tag;
    [alert show];
    
    
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
        NSString *data = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
        serviceType = DELETE_CALLBACK;
        responseTag = @"DeleteCallBacksResponse";
        childTag = @"DeleteCallBacksResult";
        tArray=[[NSMutableArray alloc] initWithArray:@[@{@"CallBackIDs":data},@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
        
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
                        _strCallback = @"";
                        _txtCallBackSearch.text=@"";
                        [self serviceForCount:_strCallback date:@""];
                        [self serviceForCallbackData:@"1" and:@"15" comp:_strCallback date:@""];
                    }
                }
            }
            
        }];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    self.statusView.hidden=true;
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
