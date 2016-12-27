//
//  QuickSearchVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "QuickSearchVC.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "Toast/UIView+Toast.h"

@implementation QuickSearchCell



@end

@interface QuickSearchVC ()
{
    UIWebView *accWebview;
    NSMutableArray *arrRecId,*arrFname,*arrLname,*arrCompany,*arrOppName;
    NSString *strOppName;
    BOOL isData,isWeb;
}

@end

@implementation QuickSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

-(void)setUpView
{
    isWeb = true;
    strOppName = @"Opportunity";
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (accWebview) {
        [accWebview removeFromSuperview];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrRecId.count;
    //        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickSearchCell *cell = (QuickSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[QuickSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    
    cell.btnSelect.titleLabel.font =[UIFont fontWithName:@"FontAwesome" size:30.0];
    [cell.btnSelect setTitle:@"\uf00c" forState:UIControlStateNormal];
    
    cell.btnSelect.tag = [[arrRecId objectAtIndex:indexPath.row] integerValue];
    [cell.btnSelect addTarget:self action:@selector(callForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strName = [NSString stringWithFormat:@"%@ %@",[arrFname objectAtIndex:indexPath.row],[arrLname objectAtIndex:indexPath.row]];
    
    cell.lbl1.text = [arrCompany objectAtIndex:indexPath.row];
    cell.lbl2.text = strName;
    
    cell.lbl3.text = [NSString stringWithFormat:@"%@ Name: %@",strOppName,[arrOppName objectAtIndex:indexPath.row]];
    
    if([[arrCompany objectAtIndex:indexPath.row] isEqualToString:@"none"] &&
        [strName isEqualToString:@"none"] &&
        [[arrOppName objectAtIndex:indexPath.row] isEqualToString:@"none"])
    {
        cell.lbl1.hidden = YES;
        cell.lbl2.hidden = YES;
        cell.lbl3.hidden = YES;
        
    }
    else
    {
        cell.lbl1.hidden = NO;
        cell.lbl2.hidden = NO;
        cell.lbl3.hidden = NO;
    }
    cell.lbl1.font = SET_FONTS_REGULAR;
    cell.lbl2.font = SET_FONTS_REGULAR;
    cell.lbl3.font = SET_FONTS_REGULAR;
    cell.btnSelect.titleLabel.font = SET_FONTS_REGULAR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtQuickSearch resignFirstResponder];
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    [self selectWebview:[[arrRecId objectAtIndex:indexPath.row] integerValue]];
        
}


//Cell button methods

-(void)callForSelect:(UIButton *)btn
{
    [self selectWebview:btn.tag];
    
}
-(void)selectWebview:(NSInteger)recID
{
//    MainUrl+"/mobile_auth.asp?key=" + encp +"&topage=mobile_RFullEdit.asp&RECDNO=" + RecordId;

    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_RFullEdit.asp&RECDNO=%ld",MAIN_URL,[BaseApplication getEncryptedKey],(long)recID];
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


-(void)serviceForQuickSearch{
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"keyword":_txtQuickSearch.text}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:QUICK_SEARCH arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        //        NSMutableArray *responseArrayTmp=[[NSMutableArray alloc]init];
        arrRecId = [[NSMutableArray alloc]init];
        arrCompany = [[NSMutableArray alloc]init];
        arrFname = [[NSMutableArray alloc]init];
        arrLname = [[NSMutableArray alloc]init];
        arrOppName = [[NSMutableArray alloc]init];
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
//            _tblActivity.hidden = true;
        }
        else
        {
            for (NSDictionary *tmpDicForLbl in [AppDelegate initAppdelegate].allDisplayLblArray)
            {
                NSString *keyStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Key"]];
                NSString *valueStr=[NSString stringWithFormat:@"%@",[tmpDicForLbl valueForKey:@"Value"]];

                
                if([keyStr isEqualToString:@"Opportunity"]&&![valueStr isEqualToString:@""])
                {
                    strOppName = [tmpDicForLbl valueForKey:@"Value"];
                }
            }

            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeLeadData"])
            {
                if(![[doc valueWithPath:@"RecordID"] isEqualToString:@"0"])
                {
                    [arrRecId addObject:[doc valueWithPath:@"RecordID"]];
                    isData = true;
                
                if([doc valueWithPath:@"FirstName"])
                    [arrFname addObject:[doc valueWithPath:@"FirstName"]];
                else
                    [arrFname addObject:@""];
                
                if([doc valueWithPath:@"LastName"])
                    [arrLname addObject:[doc valueWithPath:@"LastName"]];
                else
                    [arrLname addObject:@""];

                if([doc valueWithPath:@"OppName"])
                    [arrOppName addObject:[doc valueWithPath:@"OppName"]];
                else
                    [arrOppName addObject:@"none"];

                if([doc valueWithPath:@"Company"])
                    [arrCompany addObject:[doc valueWithPath:@"Company"]];
                else
                    [arrCompany addObject:@"none"];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               
                _tblQuickSearch.hidden = NO;
                [_tblQuickSearch reloadData];
                if(!isData)
                {
                    [self.view makeToast:@"No data found for this section"
                                duration:3.0
                                position:CSToastPositionCenter];

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
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        _tblQuickSearch.hidden = YES;
        
//        [self serviceForCount:@"" date:@""];
//        startIndex = 1;
//        endIndex = 15;
//        
//        [self serviceForCallbackData:[@(startIndex)stringValue] and:[@(endIndex)stringValue] comp:@"" date:@""];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lead Master"
                                                        message:@"Please enter Keyword"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        _tblQuickSearch.hidden = YES;
        [self serviceForQuickSearch];
        
    }
}


- (IBAction)quickSideMenu:(id)sender {
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
