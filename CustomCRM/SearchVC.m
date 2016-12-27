//
//  SearchVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 13/10/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "SearchVC.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "SMXMLDocument.h"
#import "QuickSearchVC.h"
#import "CheckForMatch.h"
#import "MapVC.h"


@interface SearchVC ()
{
    UIWebView *accWebview;
    BOOL isWeb;
}
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView
{
    isWeb = true;
//    [self serviceForCount:@"" date:@""];
//    [self serviceForCallbackData:@"1" and:@"15" comp:@"" date:@""];
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


- (IBAction)openForMatch:(id)sender {
    
    CheckForMatch *search=(CheckForMatch *)[self.storyboard instantiateViewControllerWithIdentifier:@"CheckForMatch"];
    
    [self.navigationController pushViewController:search animated:true];

}

- (IBAction)openAdvanceSearch:(id)sender {
    
    //    MainUrl + "/mobile_auth.asp?key=" + encp + 		"&topage=mobile_calWeek.asp";
    
//    MainUrl + "/mobile_auth.asp?key=" + encp + "&topage=mobile_SearchForm.asp";

    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_SearchForm.asp" ,MAIN_URL,[BaseApplication getEncryptedKey]];
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

- (IBAction)openMap:(id)sender {
    
    MapVC *search=(MapVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    
    [self.navigationController pushViewController:search animated:true];

}

- (IBAction)openQuickSearch:(id)sender {
    
    QuickSearchVC *search=(QuickSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"QuickSearchVC"];
    
    [self.navigationController pushViewController:search animated:true];
}

- (IBAction)searchMenu:(id)sender {
    if (isWeb)
    {
        [[SlideNavigationController sharedInstance] toggleLeftMenu];
        
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
