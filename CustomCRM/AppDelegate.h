//
//  AppDelegate.h
//  CustomCRM
//
//  Created by Pinal Panchani on 12/09/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TabbarController.h"
#import "Utility.h"

#define SHOWLOADING(strText) [(AppDelegate *)[[UIApplication sharedApplication]delegate]performSelectorOnMainThread:@selector(showCustomProgressViewWithText:) withObject:strText waitUntilDone:NO];
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define STOPLOADING() [(AppDelegate *)[[UIApplication sharedApplication]delegate]performSelector:@selector(hideCustomProgressView) withObject:nil afterDelay:0.5];


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate>
{
    UIView *lightBoxView,*progressView;
    

}
@property (strong, nonatomic) TabbarController *tabbar;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *allPrivillageArray;
@property (nonatomic, strong) NSMutableArray *allDisplayLblArray;
@property (nonatomic, strong) NSMutableArray *allTableLblArray;

@property (nonatomic, strong) UIView *assignView;


@property float latitude;
@property float longitude;


//Block for Assignview

@property (nonatomic, copy) void (^completionBlock)(NSString *strData);
@property (nonatomic, strong) UILabel *lblSelectCounter;


-(void)showCustomProgressViewWithText:(NSString *)strText;
-(void)hideCustomProgressView;
-(void) setUpTab;
-(void)serviceForPrivilages;
-(void)serviceForCusustomLabels;
-(void)showView;
-(void)hideView;
-(void) setTabbarBG;
+(AppDelegate *)initAppdelegate;

@end

