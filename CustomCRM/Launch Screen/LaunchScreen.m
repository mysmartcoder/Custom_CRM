//
//  LaunchScreen.m
//  CustomCRM
//
//  Created by Pinal Panchani on 29/11/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "LaunchScreen.h"
#import "Static.h"
#import "Utility.h"

@interface LaunchScreen ()

@end

@implementation LaunchScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
