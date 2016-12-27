//
//  CalendarVC.h
//  CustomCRM
//
//  Created by NLS44-PC on 11/4/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar/JTCalendar.h"
//#import "MADayView.h"
//#import "MAEventKitDataSource.h"


@interface CalendarCell  : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end


//@interface CalendarVC : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource,MADayViewDataSource,MADayViewDelegate> {
//    MAEventKitDataSource *_eventKitDataSource;
//}
//
//@property (strong, nonatomic) IBOutlet MADayView *viewDay;

@interface CalendarVC : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UIView *viewDay;
@property (strong, nonatomic) IBOutlet UILabel *lblTodayDate;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) IBOutlet UITableView *tblCal;
@property (strong, nonatomic) IBOutlet UIButton *btnMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnWeek;
@property (strong, nonatomic) IBOutlet UIButton *btnDay;

@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) IBOutlet UILabel *lblMonYear;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) IBOutlet UIView *viewMonth;

- (IBAction)btnBack:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
- (IBAction)btnDay:(id)sender;

@end
