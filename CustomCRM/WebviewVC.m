//
//  WebviewVC.m
//  CustomCRM
//
//  Created by Pinal Panchani on 22/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "WebviewVC.h"
#import "AppDelegate.h"
@interface WebviewVC ()
{
    
}
@end

@implementation WebviewVC
{
    CGRect frame;
}
@synthesize webView,resUrlStr,strPageTitle;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    _lblTitle.text = strPageTitle;
    if ([strPageTitle isEqualToString:@""]) {
        _viewMenu.hidden = NO;
        _lblTitle.hidden = true;
        self.constTitleHeight.constant = 0;
    }
    else
    {
        self.constTitleHeight.constant = 45;
        _viewMenu.hidden = NO;
        webView.frame = frame;
        _lblTitle.hidden = false;
    }
    
    NSString* webStringURL = [resUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    webView.delegate = self;    
    [webView loadRequest:urlRequest];
    [self setFonts_Background];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    SHOWLOADING(@"Wait...");
    NSLog(@"start");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    STOPLOADING();
    NSLog(@"finish");
}
- (IBAction)sideMenu:(id)sender {
//    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    [self.navigationController popViewControllerAnimated:true];
    
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
