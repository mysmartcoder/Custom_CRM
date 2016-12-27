//
//  CalendarVC.h
//  CustomCRM
//
//  Created by NLS44-PC on 11/4/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar/JTCalendar.h"



@protocol FFCalendarViewControllerProtocol <NSObject>
@required
- (void)arrayUpdatedWithAllEvents:(NSMutableArray *)arrayUpdated;
@end


@interface CalendarCell  : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end

@interface CalendarDayCell  : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UIView *viewEvent;


@end

@interface CalendarWeekCell  : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIView *viewWeek1;
@property (strong, nonatomic) IBOutlet UIView *viewWeek2;
@property (strong, nonatomic) IBOutlet UIView *viewWeek3;
@property (strong, nonatomic) IBOutlet UIView *viewWeek4;
@property (strong, nonatomic) IBOutlet UIView *viewWeek5;
@property (strong, nonatomic) IBOutlet UIView *viewWeek6;
@property (strong, nonatomic) IBOutlet UIView *viewWeek7;

@end


//@interface CalendarVC : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource,MADayViewDataSource,MADayViewDelegate> {
//    MAEventKitDataSource *_eventKitDataSource;
//}
//
//@property (strong, nonatomic) IBOutlet MADayView *viewDay;

@interface CalendarVC : UIViewController<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) id <FFCalendarViewControllerProtocol> protocol;
@property (nonatomic, strong) NSMutableArray *arrayWithEvents;



@property (strong, nonatomic) IBOutlet UIView *viewDay;
@property (strong, nonatomic) IBOutlet UIView *viewWeek;
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


// Week View
@property (strong, nonatomic) IBOutlet UILabel *lblWeek1;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek2;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek3;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek4;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek5;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek6;
@property (strong, nonatomic) IBOutlet UILabel *lblWeek7;
@property (strong, nonatomic) IBOutlet UITableView *tblWeek;



- (IBAction)btnGroupCal:(id)sender;

// Background & text style
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBG;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lable;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn;
- (IBAction)btnDay:(id)sender;

- (IBAction)btnNext:(id)sender;

- (IBAction)btnPrev:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *groupCalBtn;
@property (strong, nonatomic) NSString *fromWhichVC;


// set group button popup
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblBold;
@property (strong, nonatomic) IBOutlet UIView *viewBlue;
@property (strong, nonatomic) IBOutlet UIView *viewPopup;
@property (strong, nonatomic) IBOutlet UILabel *lblSession;
@property (strong, nonatomic) IBOutlet UIView *viewSession;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constSessionViewHeight;
@property (strong, nonatomic) IBOutlet UIView *viewPopupList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constViewPopupTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constTblListHeight;

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UIButton *btnCalView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelUser;
@property (strong, nonatomic) IBOutlet UIButton *btnSelSession;
@property (strong, nonatomic) IBOutlet UIButton *btnFirst;
@property (strong, nonatomic) IBOutlet UIButton *btnSecond;
@property (strong, nonatomic) IBOutlet UIButton *btnThird;
@property (strong, nonatomic) IBOutlet UIView *viewCalSel;
@property (strong, nonatomic) IBOutlet UIView *viewSelUser;



- (IBAction)btnCalView:(id)sender;
- (IBAction)btnSelUser:(id)sender;
- (IBAction)btnSelSession:(id)sender;
- (IBAction)btnPopup:(id)sender;


@end
