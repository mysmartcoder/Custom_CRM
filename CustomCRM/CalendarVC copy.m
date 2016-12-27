//
//  CalendarVC.m
//  CustomCRM
//
//  Created by NLS44-PC on 11/4/16.
//  Copyright © 2016 Nexuslink. All rights reserved.
//

#import "CalendarVC.h"
#import "Utility.h"
#import "BaseApplication.h"
#import "Static.h"
#import "AppDelegate.h"
#import "SMXMLDocument.h"
//#import "MAEvent.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation CalendarCell


@end

@interface CalendarVC (){
    NSMutableDictionary *_eventsByDate;
    NSMutableArray *arrEvent, *selectEvent;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;    
    NSDate *_dateSelected;
    UIWebView *accWebview;
    NSDateFormatter *dateFormatter;
    int count1;
    BOOL isWeb;
    UILabel *messageLabel;
}

//@property (readonly) MAEvent *event;
//@property (readonly) MAEventKitDataSource *eventKitDataSource;


@end

//@interface CalendarVC(PrivateMethods)
//@end


@implementation CalendarVC
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    arrEvent = [[NSMutableArray alloc] init];
    selectEvent = [[NSMutableArray alloc] init];
    
    // Calendar JTCalendar for Month
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
   
    self.calendarContentViewHeight.constant = 270;
    
    // Day & Week Chart
//    MADayView *dayView = (MADayView *) self.viewDay;
//    /* The default is not to autoscroll, so let's override the default here */
//    dayView.autoScrollToFirstEvent = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [dateFormatter setDateFormat:@"dd"];
    self.lblTodayDate.text = [dateFormatter stringFromDate:[NSDate date]];
    self.lblTodayDate.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [self setButtonBack_Font:2];
    [self setViewDisplay:2];
    [self setFonts_Background];
    [self getCalendarEventData:@"" date:@""];
}

- (void)setButtonBack_Font:(int)index{
    self.btnDay.backgroundColor = [UIColor whiteColor];
    [self.btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnWeek.backgroundColor = [UIColor whiteColor];
    [self.btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnMonth.backgroundColor = [UIColor whiteColor];
    [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (index == 0) {
        self.btnDay.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (index == 1){
        self.btnWeek.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        self.btnMonth.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)getCalendarEventData:(NSString *)company date:(NSString *)mDate{
    
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
                    [self serviceForCallbackData:@"1" and:[NSString stringWithFormat:@"%d",count1] comp:@"" date:@""];
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
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            //            _tblEvents.hidden = true;
        }
        else
        {
            [arrEvent removeAllObjects];
            [selectEvent removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeEventData"])
            {
                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                {
                    NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                    if([doc valueWithPath:@"EventType"])
                        [tmpDataDic setValue:[doc valueWithPath:@"EventType"] forKey:@"EventName"];
                    if([doc valueWithPath:@"StartTime"])
                        [tmpDataDic setValue:[doc valueWithPath:@"StartTime"] forKey:@"StartTime"];
                    if([doc valueWithPath:@"EndTime"])
                        [tmpDataDic setValue:[doc valueWithPath:@"EndTime"] forKey:@"EndTime"];
                    if([doc valueWithPath:@"RECDNO"])
                        [tmpDataDic setValue:[doc valueWithPath:@"RECDNO"] forKey:@"RECDNO"];
                    if([doc valueWithPath:@"CallBackID"])
                        [tmpDataDic setValue:[doc valueWithPath:@"CallBackID"] forKey:@"CallBackID"];
                    [arrEvent addObject:tmpDataDic];
                    [selectEvent addObject:tmpDataDic];
                    
                    NSString *dateString = [doc valueWithPath:@"StartTime"];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                    NSDate *date = [dateFormatter dateFromString:dateString];
                    
                    NSString *key = [[self dateFormatter] stringFromDate:date];
                    
                    if(!_eventsByDate[key]){
                        _eventsByDate[key] = [NSMutableArray new];
                    }
                    
                    [_eventsByDate[key] addObject:date];
                }
            }
            [self createMinAndMaxDate];
            _calendarManager.settings.pageViewNumberOfWeeks = 0;
            [_calendarManager setMenuView:_calendarMenuView];
            [_calendarManager setContentView:_calendarContentView];
            [_calendarManager setDate:_todayDate];
//            self.viewDay.delegate = self;
//            self.viewDay.dataSource = self;
            
            [self.tblCal reloadData];
        }
        
    }];
}
     
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (selectEvent.count > 0) {
        [messageLabel removeFromSuperview];
        return 1;
    }
    else {
        // Display a message when the table is empty
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No any event available";
        messageLabel.textColor = [UIColor redColor];
        
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = SET_FONTS_REGULAR;
        [messageLabel sizeToFit];
        
        self.tblCal.backgroundView = messageLabel;
        self.tblCal.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return selectEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dic = [selectEvent objectAtIndex:indexPath.row];
    cell.lblTitle.text = [dic objectForKey:@"EventName"];

    NSString *dateString = [dic objectForKey:@"StartTime"];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"dd, MMM"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    cell.lblDate.text = newDateString;
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *newTime = [dateFormatter stringFromDate:date];
    cell.lblTime.text = newTime;
    cell.lblTitle.font = [SET_FONTS_REGULAR fontWithSize:18];
    cell.lblDate.font = [SET_FONTS_REGULAR fontWithSize:15];
    cell.lblTime.font = [SET_FONTS_REGULAR fontWithSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CallBackCell *cell = [self.tblCallBacks cellForRowAtIndexPath:indexPath];
//    if (cell.statusView.hidden == YES) {
//        if (isWeb) {
//            [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
//        } else {
//            [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
//        }
//        isWeb = false;
        [self selectWebview:[[[selectEvent objectAtIndex:indexPath.row] objectForKey:@"RECDNO"] integerValue] caseID:[[[selectEvent objectAtIndex:indexPath.row] objectForKey:@"CallBackID"] integerValue]];
//    }
//    else{
//        cell.statusView.hidden = YES;
//    }
}

-(void)selectWebview:(NSInteger)recID caseID:(NSInteger)caseID
{
    isWeb = true;
    if (isWeb) {
        [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    } else {
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
    isWeb = false;
    
    [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/mobile_auth.asp?key=%@&topage=mobile_cbViewEvent.asp&RECDNO=%ld&CompanyID=%@&CallBackID=%ld&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey],(long)caseID,WORKGROUP,(long)recID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //    accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66,WIDTH,CGRectGetMinY(_pagingView.frame))];
    //    [accWebview loadRequest:urlRequest];
    //    [self.view addSubview:accWebview];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 114)];
        //        NSLog(@"Landscape");
    } else {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65,WIDTH,[UIScreen mainScreen].bounds.size.height - 114)];
        //        NSLog(@"Portrait");
    }
    [accWebview loadRequest:urlRequest];
    [self.view addSubview:accWebview];
    
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    // Today
    dayView.textLabel.font = SET_FONTS_REGULAR;
    dayView.circleView.backgroundColor = [UIColor clearColor];
    dayView.dotView.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        if ([_dateSelected isEqual:dayView.date]) {
            dayView.circleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            dayView.circleView.layer.borderWidth = 1;
            dayView.circleView.layer.cornerRadius = dayView.circleView.frame.size.height / 2;
            dayView.clipsToBounds = YES;
        }
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        dayView.circleView.layer.borderWidth = 1;
        dayView.circleView.layer.cornerRadius = dayView.circleView.frame.size.height / 2;
        dayView.clipsToBounds = YES;
        dayView.textLabel.textColor = [Utility colorWithHexString:VIEW_BACKGROUND];
//        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];

    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];//[UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];//[UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    [selectEvent removeAllObjects];
    for (int i = 0; i < arrEvent.count; i++) {
        NSDictionary *dic = [arrEvent objectAtIndex:i];
        NSString *dateString = [dic objectForKey:@"StartTime"];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if ([[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:_dateSelected ]]) {
            [selectEvent addObject:[arrEvent objectAtIndex:i]];
        }
    }
    [self.tblCal reloadData];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter1;
    if(!dateFormatter1){
        dateFormatter1 = [NSDateFormatter new];
        dateFormatter1.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter1;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFonts_Background
{
    self.lblMonYear.font = [SET_FONTS_REGULAR fontWithSize:14];
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
        btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack:(id)sender {
    if (isWeb)
    {
//        [[SlideNavigationController sharedInstance]toggleLeftMenu];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [accWebview removeFromSuperview];
        //        isWeb = false;
        isWeb = true;
        [_btnMenu setImage:[UIImage imageNamed:@"sidemenui"] forState:UIControlStateNormal];
    }
}


// Set Day & Week

//static NSDate *date = nil;
//int counter = 0;
//
//#ifdef USE_EVENTKIT_DATA_SOURCE
//
//- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
//    return [self.eventKitDataSource dayView:dayView eventsForDate:startDate];
//}
//
//#else
//- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
//    date = startDate;
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    counter = 0;
//    
//    for (int i = 0; i < arrEvent.count; i++) {
//        counter = i;
//        if ([[[self dateFormatter] stringFromDate:date] isEqualToString:[[self dateFormatter] stringFromDate:[[arrEvent objectAtIndex:i] objectForKey:@"StartTime"]]]) {
//            [arr addObject:self.event];
//        }
//    }
////    NSArray *arr = [NSArray arrayWithObjects: self.event, self.event, self.event,
////                    self.event, self.event, self.event, self.event,  self.event, self.event, nil];
//    static size_t generateAllDayEvents;    
//    generateAllDayEvents++;
//    if (generateAllDayEvents % 4 == 0) {
//        ((MAEvent *) [arr objectAtIndex:0]).title = @"All-day events test";
//        ((MAEvent *) [arr objectAtIndex:0]).allDay = YES;
//        
//        ((MAEvent *) [arr objectAtIndex:1]).title = @"All-day events test";
//        ((MAEvent *) [arr objectAtIndex:1]).allDay = YES;
//    }
//    return arr;
//}
//#endif
//
//- (MAEvent *)event{
////    static int counter;
//    static BOOL flag;
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    
////    [dict setObject:[NSString stringWithFormat:@"number %i", counter++] forKey:@"test"];
//    
////    unsigned int r = arc4random() % 24;
////    int rr = arc4random() % 3;
//    
//    MAEvent *event = [[MAEvent alloc] init];
//    event.backgroundColor = ((flag = !flag) ? [UIColor purpleColor] : [UIColor brownColor]);
//    event.textColor = [UIColor whiteColor];
//    event.allDay = NO;
//    event.userInfo = dict;
//    
//    NSDictionary *dic = [arrEvent objectAtIndex:counter];
//    event.title = [dic objectForKey:@"EventName"];
//    
//    
//    NSString *dateString = [dic objectForKey:@"StartTime"];
//    
//    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//    NSDate *startDate = [dateFormatter dateFromString:dateString];
//
////    if (rr == 0) {
////        event.title = @"Event lorem ipsum es dolor test. This a long text, which should clip the event view bounds.";
////    } else if (rr == 1) {
////        event.title = @"Foobar.";
////    } else {
////        event.title = @"Dolor test.";
////    }
//    
//    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
//    [dateFormatter setDateFormat:@"hh"];
//    [components setHour:[[dateFormatter stringFromDate:startDate] integerValue]];
//    [dateFormatter setDateFormat:@"mm"];
//    [components setMinute:[[dateFormatter stringFromDate:startDate] integerValue]];
//    [dateFormatter setDateFormat:@"ss"];
//    [components setSecond:[[dateFormatter stringFromDate:startDate] integerValue]];
//    
//    event.start = [CURRENT_CALENDAR dateFromComponents:components];
//    
////    [components setHour:r+rr];
////    [components setMinute:0];
//    NSDate *endDate = [dateFormatter dateFromString:[dic objectForKey:@"EndTime"]];
//    event.end = endDate;
//    
//    return event;
//}
//
//- (MAEventKitDataSource *)eventKitDataSource {
//    if (!_eventKitDataSource) {
//        _eventKitDataSource = [[MAEventKitDataSource alloc] init];
//    }
//    return _eventKitDataSource;
//}
//
///* Implementation for the MADayViewDelegate protocol */
//
//- (void)dayView:(MADayView *)dayView eventTapped:(MAEvent *)event {
//    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
//    NSString *eventInfo = [NSString stringWithFormat:@"Hour %li. Userinfo: %@", (long)[components hour], [event.userInfo objectForKey:@"test"]];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
//                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//}






- (IBAction)btnDay:(id)sender {
//    UIButton *btn = (UIButton *)sender;
//    if (btn.tag == 0) {
//        [self setViewDisplay:btn.tag];
//    }
//    else if (btn.tag == 1){
//        
//    }
//    else{
//        
//    }
    [self setViewDisplay:[sender tag]];
    [self setButtonBack_Font:(int)[sender tag]];
}

- (void)setViewDisplay:(NSInteger)index{
    if (index == 0) {
        self.viewDay.hidden = NO;
        self.viewMonth.hidden = YES;
    }
    else if (index == 1){
        self.viewDay.hidden = YES;
        self.viewMonth.hidden = YES;
    }
    else{
        self.viewDay.hidden = YES;
        self.viewMonth.hidden = NO;
    }
}
@end
