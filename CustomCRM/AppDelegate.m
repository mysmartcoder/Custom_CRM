//
//  AppDelegate.m
//  CustomCRM
//
//  Created by Pinal Panchani on 12/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "AppDelegate.h"
#import "Static.h"
#import "HomeVC.h"
#import "DatabaseVC.h"
#import "DashboardVC.h"
#import "ContactVC.h"
#import "ShortCutsVC.h"
#import "SettingsVC.h"
#import "RecentItemsVC.h"
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "MyAccounts.h"
#import "BaseApplication.h"
#import "Static.h"
#import "SMXMLDocument.h"
#import <CoreLocation/CoreLocation.h>
#import "WebviewVC.h"
#import "CaseVC.h"
#import "OpportunityVC.h"
#import "CallBackTasks.h"
#import "SearchVC.h"
#import "QuotesVC.h"
#import "LibraryVC.h"
#import "CalendarVC.h"

@interface AppDelegate ()
{
    CLLocationManager *locationManager;
    
}
@end

@implementation AppDelegate
@synthesize tabbar,allPrivillageArray,allDisplayLblArray,allTableLblArray;
@synthesize latitude,longitude;
@synthesize assignView,lblSelectCounter;

+(AppDelegate *)initAppdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"font"]){
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Helvetica Neue" forKey:@"font"];
        [[NSUserDefaults standardUserDefaults]setObject:@"Helvetica Neue-Bold" forKey:@"font_bold"];
    }
    
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:key_Main_URL])
    {
        NSLog(@"URL : %@",MAIN_URL);
    }
    else
    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"{QA_URL}" forKey:key_Main_URL];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        [[NSUserDefaults standardUserDefaults] setValue:@"{QA_URL}" forKey:key_Main_URL];
//        [[NSUserDefaults standardUserDefaults] setValue:@"{Dev_URL}" forKey:key_Main_URL];
        [[NSUserDefaults standardUserDefaults] setValue:@"{Production_URL}" forKey:key_Main_URL];
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"                                                             bundle: nil];
    
   
    tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabbarController"];
    tabbar.delegate = self;
//    tabbar.tabBar.backgroundColor = [UIColor grayColor];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [self setTabbarBG];
    
    
    HomeVC *vc1=[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeVC"];

    MyAccounts *vc2 = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyAccounts"];
    
    ContactVC *vc3 = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContactVC"];

    
    RecentItemsVC *vc5 = [mainStoryboard instantiateViewControllerWithIdentifier:@"RecentItemsVC"];
    
//    ShortCutsVC *vc6=[mainStoryboard instantiateViewControllerWithIdentifier:@"ShortCutsVC"];
    
    
    SettingsVC *vc7 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
//    SettingsVC *vc8 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchVC"];

    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
   
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
//    UINavigationController *nav6 = [[UINavigationController alloc] initWithRootViewController:vc6];
    UINavigationController *nav7 = [[UINavigationController alloc] initWithRootViewController:vc7];
//    UINavigationController *nav8 = [[UINavigationController alloc] initWithRootViewController:vc8];


    
    NSArray *ctrlArr = @[nav1,nav2,nav3,nav5,nav7];
    [tabbar setViewControllers:ctrlArr];
    
    for(UITabBarItem *item in tabbar.tabBar.items) {
            item.title = @"";
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.imageInsets = UIEdgeInsetsMake(5,  0,  -5,  0);
    }
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    //View for multiple selection
    CGRect frame = CGRectMake(0,0,WIDTH,65);
    assignView = [[UIView alloc] initWithFrame:frame];
    [assignView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 10,30, 30)];
    [btnBack addTarget:self action:@selector(callForBack:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

    
    UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, 10,30, 30)];
    [btnDelete addTarget:self action:@selector(callForDelete:) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setTintColor:[UIColor whiteColor]];
//    [btnDelete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btnDelete setBackgroundImage: [UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    
    UIButton *btnAssign = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnDelete.frame)-50, 10,30, 30)];
    [btnAssign addTarget:self action:@selector(callForAssign:) forControlEvents:UIControlEventTouchUpInside];
    [btnAssign setTintColor:[UIColor whiteColor]];
    [btnAssign setImage:[UIImage imageNamed:@"list_menu_assign"] forState:UIControlStateNormal];
    
    
    lblSelectCounter = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnBack.frame)+15, 10,CGRectGetMinX(btnAssign.frame)-10, 30)];
    lblSelectCounter.textColor = [UIColor whiteColor];
    
    
    [assignView addSubview:btnBack];
    [assignView addSubview:lblSelectCounter];
    [assignView addSubview:btnAssign];
    [assignView addSubview:btnDelete];
    
    return YES;
}

-(void) setTabbarBG{
    if (VIEW_BACKGROUND == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"09469A" forKey:key_View_BG];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    tabbar.tabBar.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [tabbar.tabBar setBarTintColor:[Utility colorWithHexString:VIEW_BACKGROUND]];
}

-(void)setUpTab
{
    
    [self serviceForPrivilages];
    [self serviceForCusustomLabels];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
     UINavigationController *navcon1 = [[AppDelegate initAppdelegate].tabbar.viewControllers objectAtIndex:[AppDelegate initAppdelegate].tabbar.selectedIndex];
    if ([navcon1 isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navcon = (UINavigationController *)navcon1;
        for (id viewCont in navcon.viewControllers) {
            if ([viewCont isKindOfClass:[WebviewVC class]]) {
                [navcon popToRootViewControllerAnimated:NO];
            }else if ([viewCont isKindOfClass:[CaseVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[OpportunityVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[CallBackTasks class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[SearchVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[QuotesVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[ShortCutsVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[LibraryVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
        }
    }
   
//    NSArray *viewControlles = navcon.viewControllers;
    
    [tabbar setSelectedIndex:0];
    SlideNavigationController *nav1 = [[SlideNavigationController alloc] initWithRootViewController:tabbar];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    [nav1.navigationBar setHidden:YES];
    
        self.window.rootViewController = nav1;
        [self.window makeKeyAndVisible];
    
}
//Assignview Methods

-(void)callForAssign:(UIButton *)btn
{
    self.completionBlock(@"assign");
}
-(void)callForDelete:(UIButton *)btn
{
    self.completionBlock(@"delete");
}
-(void)callForBack:(UIButton *)btn
{
    [self hideView];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navcon = (UINavigationController *)viewController;
        for (id viewCont in navcon.viewControllers) {
            if ([viewCont isKindOfClass:[WebviewVC class]]) {
                [navcon popToRootViewControllerAnimated:NO];
            }else if ([viewCont isKindOfClass:[CaseVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[OpportunityVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[CallBackTasks class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[SearchVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[QuotesVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[ShortCutsVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
            else if ([viewCont isKindOfClass:[LibraryVC class]]){
                [navcon popToRootViewControllerAnimated:NO];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:key_Notification object:self];
}
//- (void)tabBarController:(UITabBarController *)tabBarController
// didSelectViewController:(UIViewController *)viewController
//{
//    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
//    NSLog(@"controller title: %@", viewController.title);
//    
//    if (viewController == tabBarController.moreNavigationController)
//        {
//        tabBarController.moreNavigationController.delegate = self;
//        }
//}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {        
        latitude = currentLocation.coordinate.latitude;
        longitude = currentLocation.coordinate.longitude;
    }
}

-(void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:assignView];
}

-(void)hideView
{
    [assignView removeFromSuperview];
}

-(void)serviceForPrivilages
{
    allPrivillageArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":[mDictionary1 objectForKey:@"LogonID"]},
                                                                    @{@"CompanyID":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]}]];
    //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:LOGONPRIV arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"Documents %@",document);
        
        
        SMXMLElement *rootDoctument = [[document firstChild] firstChild];
        
        if (!rootDoctument)
        {
            
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"GetLogonPrivilegesResult"])
            {
                NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                
                if([doc valueWithPath:@"ReviewAndTakeAct"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ReviewAndTakeAct"] forKey:@"ReviewAndTakeAct"];
                }
                
                if([doc valueWithPath:@"ViewSalesProgress"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ViewSalesProgress"] forKey:@"ViewSalesProgress"];
                }
                
                if([doc valueWithPath:@"FullEdit"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"FullEdit"] forKey:@"FullEdit"];
                }
                if([doc valueWithPath:@"AssignCallBack"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"AssignCallBack"] forKey:@"AssignCallBack"];
                }
                if([doc valueWithPath:@"AccountLink"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"AccountLink"] forKey:@"AccountLink"];
                }
                
                if([doc valueWithPath:@"ContactLink"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ContactLink"] forKey:@"ContactLink"];
                }
                if([doc valueWithPath:@"RecordOnMap"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"RecordOnMap"] forKey:@"RecordOnMap"];
                }
                if([doc valueWithPath:@"DefaultPage"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"DefaultPage"] forKey:@"DefaultPage"];
                    [[NSUserDefaults standardUserDefaults]setValue:[doc valueWithPath:@"DefaultPage"] forKey:key_DPage];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                if([doc valueWithPath:@"ShowQuote"]){
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ShowQuote"] forKey:@"ShowQuote"];
                }
                if([doc valueWithPath:@"ISO_Code"])
                {
                    NSString *s = [doc valueWithPath:@"ISO_Code"];
                    NSString *value=@"";
                    
                    if([s isEqualToString:@"GBP"])
                    {
                        value = @"£";
                    }
                    else if([s isEqualToString:@"EUR"])
                    {
                        value = @"€";
                    }
                    else if([s isEqualToString:@"JPY"])
                    {
                        value = @"¥";
                    }
                    else if([s isEqualToString:@"CHF"])
                    {
                        value = @"CHF";
                    }
                    else if([s isEqualToString:@"USD"])
                    {
                        value = @"$";
                    }
                    
                    [tmpDataDic setValue:[doc valueWithPath:@"ISO_Code"] forKey:@"ISO_Code"];
                    [[NSUserDefaults standardUserDefaults]setValue:value forKey:key_ISO_CODE];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                }
                
                if([doc valueWithPath:@"MyCalendar"]){
                    [tmpDataDic setValue:[doc valueWithPath:@"MyCalendar"] forKey:@"MyCalendar"];
                }
                
                if([doc valueWithPath:@"GroupCalendar"]){
                    [tmpDataDic setValue:[doc valueWithPath:@"GroupCalendar"] forKey:@"GroupCalendar"];
                }
                
                
                [allPrivillageArray addObject:tmpDataDic];
                 NSLog(@"TmpDict %@", tmpDataDic);
//                [AppDelegate initAppdelegate].allPrivillageArray = [privillageArray mutableCopy];
            }
            NSLog(@"Priv %lu", (unsigned long)allPrivillageArray.count);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                [self refreshTableData];
//            });
            
            
        }
        
    }];
    
}

-(void)serviceForCusustomLabels
{
    allDisplayLblArray = [[NSMutableArray alloc]init];

    NSString *str = @"Banner - Accounts^Contact^Company^Banner - Contacts^Lead Status^Entered^Campaign^Events^Event Name^Event^Shortcuts^My Searches^Recent Items^Acct Mgr^Opportunity^Case^Sales Rep Comments/Notes^Record^Opportunity Name^Phone^Cases^Banner - Library^Quote^Sales Rep Comments/Notes^Banner - Calendar^Shortcuts^Event Done^Quote Name^Company^First Name^Last Name^Case Date Due^Subject^Case Status^Case Priority^Case Owner^Key Contact^Lead_Source^Event Start Time^Opportunity Sales Stage^List Source^Sales Rep Comments/Notes^Total Opportunity Value";
    NSMutableDictionary *mDictionary1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginID"];
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":[mDictionary1 objectForKey:@"LogonID"]},
                                                                    @{@"CompanyID":[[NSUserDefaults standardUserDefaults]objectForKey:WG_ID]},@{@"LabelName":str}]];
    //    SHOWLOADING(@"Wait...")
    
    [BaseApplication executeRequestwithService:GETCUSTLABELS arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"Documents %@",document);
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblActivity.hidden = true;
        }
        else
        {
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeKeyValue"])
            {
                if([doc valueWithPath:@"Value"])
                {
//                    [arrValue addObject:[doc valueWithPath:@"Value"]];
//                    [dictLabel setObject:[doc valueWithPath:@"Value"] forKey:[doc valueWithPath:@"Key"]];
                    
                    NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                    [tmpDataDic setValue:[doc valueWithPath:@"Value"] forKey:@"Value"];
                    [tmpDataDic setValue:[doc valueWithPath:@"Key"] forKey:@"Key"];
                    [allDisplayLblArray addObject:tmpDataDic];
                }
                
            }
            NSLog(@"display %lu", (unsigned long)allDisplayLblArray.count);

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                [self refreshTableData];
//                [AppDelegate initAppdelegate].allDisplayLblArray = [displayLblArray mutableCopy];
//                
//                displayLblArray=[[NSMutableArray alloc]init];
//                
//                //                STOPLOADING();
//            });
        }
    }];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

-(void)showCustomProgressViewWithText:(NSString *)strText{
    
    CGRect frame;
    if (!lightBoxView) {
        lightBoxView = [[UIView alloc ]init];
        if(IS_IPAD==TRUE){
            [lightBoxView setFrame:CGRectMake(0, 0, WIDTH,HEIGHT)];
            frame = CGRectMake( (WIDTH/2-60) ,(HEIGHT/2-60),120,120);
        }
        else{
            [lightBoxView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            frame = CGRectMake( (WIDTH/2)-60 ,(HEIGHT/2)-60 ,120,120);
        }
        [lightBoxView setAlpha:0.6];
        [lightBoxView setBackgroundColor:[UIColor blackColor]];
        progressView=[[UIView alloc]initWithFrame:frame];
        [progressView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        [progressView setUserInteractionEnabled:FALSE];
//        [progressView.layer setBorderColor:NAVBARCLOLOR.CGColor];
        [progressView.layer setBorderWidth:1.0];
        [progressView.layer setCornerRadius:10];
        UILabel *lblLoading=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 100, 40)];
        [lblLoading setText:strText];
        [lblLoading setBackgroundColor:[UIColor clearColor]];
        [lblLoading setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
        [lblLoading setTextColor:[UIColor whiteColor]];
        [lblLoading setTextAlignment:NSTextAlignmentCenter];
        [progressView addSubview:lblLoading];
        UIActivityIndicatorView *activityIndicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setCenter:CGPointMake(60,50)];
        
        [activityIndicatorView startAnimating];
        [progressView addSubview:activityIndicatorView];
        [progressView setFrame:frame];
        [self.window.rootViewController.view setUserInteractionEnabled:TRUE];
        
    }
    [self.window addSubview:lightBoxView];
    [self.window addSubview:progressView];
}
-(void)hideCustomProgressView
{
    [progressView removeFromSuperview];
    [lightBoxView removeFromSuperview];
    lightBoxView=nil;
    progressView=nil;
}


@end
