//
//  RecentItemsVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 15/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "RecentItemsVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BaseApplication.h"
#import "SMXMLDocument.h"
#import "CustomIOSAlertView.h"
#import "MyAccounts.h"
#import "SlideNavigationController.h"

@implementation RecentItemCell


@end

@interface RecentItemsVC (){
    UILabel *messageLabel;
}

@end

@implementation RecentItemsVC
{
    UIWebView *cWebview;
    NSMutableArray *arrKey,*arrValue;
    BOOL isWeb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView
{
    isWeb = true;
    arrKey = [[NSMutableArray alloc] init];
    arrValue = [[NSMutableArray alloc] init];
    
    [self serviceForRecentItems];
    self.navigationController.navigationBar.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:key_Notification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (cWebview) {
        [cWebview removeFromSuperview];
        
    } [self setUpView];
    [self setFonts_Background];
}

-(void)removeView
{
    if (cWebview) {
        [cWebview removeFromSuperview];
        [self setUpView];

    }
}

//call for REcent Items


-(void)serviceForRecentItems{
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP}]];
    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:RECENT_ITEMS arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        
        arrKey = [[NSMutableArray alloc]init];
        arrValue = [[NSMutableArray alloc]init];
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            _tblRecentItems.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
            {
                if([doc valueWithPath:@"Key"])
                    [arrKey addObject:[doc valueWithPath:@"Key"]];
                if([doc valueWithPath:@"Value"])
                    [arrValue addObject:[doc valueWithPath:@"Value"]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_tblRecentItems reloadData];
                STOPLOADING();
            });
            
        }
        
    }];
}


#pragma Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [messageLabel removeFromSuperview];
    messageLabel.hidden = YES;
    if (arrValue.count > 0) {
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
    
    self.tblRecentItems.backgroundView = messageLabel;
    self.tblRecentItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentItemCell *cell = (RecentItemCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[RecentItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblItem.text = [arrValue objectAtIndex:indexPath.row];
    cell.lblItem.font =SET_FONTS_REGULAR;
//    cell.textLabel.text = [arrValue objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    MainUrl + "/mobile_auth.asp?key=" + encp + "&topage=" + 			key;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=%@",MAIN_URL,[BaseApplication getEncryptedKey],[arrKey objectAtIndex:indexPath.row]];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    cWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
    [cWebview loadRequest:urlRequest];
    [self.view addSubview:cWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)RecentItemMenu:(id)sender {
    
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        
    } else {
        [cWebview removeFromSuperview];
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
}

@end
