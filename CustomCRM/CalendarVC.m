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


@implementation CalendarCell


@end

@implementation CalendarDayCell


@end

@implementation CalendarWeekCell


@end

@interface CalendarVC ()
{
    NSMutableDictionary *_eventsByDate;
    NSMutableArray *arrEvent, *selectEvent, *arrList, *arrSession;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;    
    NSDate *_dateSelected;
    UIWebView *accWebview;
    NSDateFormatter *dateFormatter;
    NSInteger eventIndex;
    int count1;
    BOOL isWeb;
    UILabel *messageLabel;
    IBOutlet UILabel *lblDayDate;
    IBOutlet UITableView *tblDay;
    NSArray *arrTime;
    float rowHeight;
    UIView *lightBoxView,*progressView;
    NSString *calView, *selUser, *selSession;
}

@property (nonatomic) BOOL boolDidLoad;
@property (nonatomic) BOOL boolYearViewIsShowing;
@property (nonatomic, strong) NSMutableDictionary *dictEvents;
@property (nonatomic, strong) UILabel *labelWithMonthAndYear;
@property (nonatomic, strong) NSArray *arrayButtons;
//@property (nonatomic, strong) NSArray *arrayCalendars;
//@property (readonly) MAEvent *event;
//@property (readonly) MAEventKitDataSource *eventKitDataSource;


@end

//@interface CalendarVC(PrivateMethods)
//@end


@implementation CalendarVC

@synthesize boolDidLoad;
@synthesize boolYearViewIsShowing;
@synthesize protocol;
@synthesize arrayWithEvents;
@synthesize dictEvents;
@synthesize labelWithMonthAndYear;
@synthesize arrayButtons,fromWhichVC,groupCalBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _todayDate = [NSDate date];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    arrEvent = [[NSMutableArray alloc] init];
    selectEvent = [[NSMutableArray alloc] init];
    arrList = [[NSMutableArray alloc] init];
    arrSession = [[NSMutableArray alloc] init];
    
    // Calendar JTCalendar for Month
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    
    self.calendarContentViewHeight.constant = 270;
    
    
    if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
        messageLabel.text = @"Please select user...";
        groupCalBtn.hidden=NO;
        [self setViewDisplay:2];
        [self createMinAndMaxDate];
        [self.tblCal reloadData];
    }else{
        messageLabel.text = @"No any event available";
        groupCalBtn.hidden=YES;
        [self setViewDisplay:3];
        [self showCustomProgressViewWithText:@"Wait..."];
        [self getCalendarEventData:@"" date:_todayDate];
    }
    [self DayWeekEnable:YES];
    // Day & Week Chart
    arrTime = @[@"12 AM",@"01 AM",@"02 AM",@"03 AM",@"04 AM",@"05 AM",@"06 AM",@"07 AM",@"08 AM",@"09 AM",@"10 AM",@"11 AM",@"00 PM",@"01 PM",@"02 PM",@"03 PM",@"04 PM",@"05 PM",@"06 PM",@"07 PM",@"08 PM",@"09 PM",@"10 PM",@"11 PM"];
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [tblDay addGestureRecognizer:swipeLeftRecognizer];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [tblDay addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft1:)];
    swipeLeftRecognizer1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tblWeek addGestureRecognizer:swipeLeftRecognizer1];
    UISwipeGestureRecognizer *swipeRightRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight1:)];
    swipeRightRecognizer1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tblWeek addGestureRecognizer:swipeRightRecognizer1];

}

- (void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)recognizer {
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.day++;
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [calendar dateFromComponents:components];
    [self setDayChart];
}

- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)recognizer {
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.day--;
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [calendar dateFromComponents:components];
    [self setDayChart];
}

- (void)handleSwipeFromLeft1:(UISwipeGestureRecognizer *)recognizer {
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.day = components.day + 7;
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    _todayDate = [calendar dateFromComponents:components];
    [self setWeekChart];
}

- (void)handleSwipeFromRight1:(UISwipeGestureRecognizer *)recognizer {
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.day = components.day - 7;
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    _todayDate = [calendar dateFromComponents:components];
    [self setWeekChart];
}

//issue event view doesn’t perfect display in day view
- (void)viewWillAppear:(BOOL)animated{
    self.viewPopupList.hidden = YES;
    NSString *title= @"Select View:";
    [self.btnCalView setTitle:title forState:UIControlStateNormal];
    [self showPopup:NO];
    _todayDate = [NSDate date];
    _viewMonth.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [dateFormatter setDateFormat:@"dd"];
    self.lblTodayDate.text = [dateFormatter stringFromDate:[NSDate date]];
    self.lblTodayDate.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
    [self setButtonBack_Font:2];
    
    [self setFonts_Background];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:[NSDate date]];
    
}

- (void)setButtonBack_Font:(int)index{
    self.btnDay.backgroundColor = [UIColor whiteColor];
    self.btnWeek.backgroundColor = [UIColor whiteColor];
    self.btnMonth.backgroundColor = [UIColor whiteColor];
    if (index == 0) {
        calView = @"day";
        self.btnDay.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (index == 1){
        calView = @"week";
        self.btnWeek.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        calView = @"month";
        self.btnMonth.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
        [self.btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)getCalendarEventData:(NSString *)company date:(NSDate *)mDate{
    
    if(!company)
        company = @"";
    NSString *strDate = @"";
    if (mDate) {
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        strDate = [dateFormatter stringFromDate:mDate];
    }
    
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"eventname":company},@{@"eventdate":strDate}]];
    
    [self showCustomProgressViewWithText:@"Wait..."];
    
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
            bool flag = true;
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"SearchCallBackCountResponse"])
            {
                if([doc valueWithPath:@"SearchCallBackCountResult"])
                {
                    flag = false;
                    count1 = [[doc valueWithPath:@"SearchCallBackCountResult"] intValue];
                    [self serviceForCallbackData:@"1" and:[NSString stringWithFormat:@"%d",count1] comp:@"" date:_todayDate];
                }
            }
            [self hideCustomProgressView];
            if (flag) {
                [self showCustomProgressViewWithText:@"Wait..."];
                [self serviceForCallbackData:@"1" and:@"15" comp:@"" date:_todayDate];
            }
        }
        
    }];
    
}

-(void)serviceForCallbackData:(NSString *)startIndex1 and:(NSString *)endIndex1 comp:(NSString *)company date:(NSDate *) mDate
{
    
    if(!company)
        company = @"";
    
    NSString *strDate = @"";
    if (mDate) {
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        strDate = [dateFormatter stringFromDate:mDate];
    }
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"username":UID},@{@"pwd":PWD},@{@"company_id":WORKGROUP},@{@"startindex":startIndex1},@{@"endindex":endIndex1},@{@"eventname":company},@{@"eventdate":strDate}]];
    
    [self showCustomProgressViewWithText:@"Wait..."];
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
            if (arrEvent.count <= 0) {
                [self DayWeekEnable:YES];
            }
            else{
                [self DayWeekEnable:NO];
            }
            [self createMinAndMaxDate];
            [self.tblCal reloadData];
            [self setViewDisplay:2];
        }
        [self hideCustomProgressView];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblDay || tableView == self.tblWeek) {
        return 24;
    }
    else if (tableView == self.tblList){
        if (tableView.tag == 0) {
            return 3;
        }
        else if (tableView.tag == 1)
            return arrList.count;
        else
            return arrSession.count;
    }
    else{
        messageLabel.hidden = YES;
        if (selectEvent.count > 0) {
            return selectEvent.count;
        }
        else {
            
            // Display a message when the table is empty
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            messageLabel.hidden = NO;
            messageLabel.textColor = [UIColor redColor];
            if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"selSession"])
                    messageLabel.text = @"No any event available";
                else
                    messageLabel.text = @"Please select user...";
            }else{
                messageLabel.text = @"No any event available";
            }
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = SET_FONTS_REGULAR;
            [messageLabel sizeToFit];
            
            self.tblCal.backgroundView = messageLabel;
            self.tblCal.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblDay) {
        if (indexPath.row == eventIndex) {
            return rowHeight;
        }
        return 100;
    }
    if (tableView == self.tblWeek) {
        if (indexPath.row == eventIndex) {
            return rowHeight;
        }
        return 100;
    }
    else
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblDay) {
        CalendarDayCell *cell = (CalendarDayCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[CalendarDayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        cell.lblDay.font = [SET_FONTS_REGULAR fontWithSize:10];
        cell.lblDay.text = [arrTime objectAtIndex:indexPath.row];
        [[cell.viewEvent subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        float size = 0.0f;
        for (int i = 0; i < selectEvent.count; i++) {
            NSDictionary *dic = [selectEvent objectAtIndex:i];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"StartTime"]];
            [dateFormatter setDateFormat:@"hh a"];
            if ([[dateFormatter stringFromDate:date] isEqualToString:cell.lblDay.text]) {
                eventIndex = indexPath.row;
                [dateFormatter setDateFormat:@"hh:mm a"];
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, size, cell.viewEvent.frame.size.width, 15)];
                [btn setTitle:[NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"EventName"],[dateFormatter stringFromDate:date]] forState:UIControlStateNormal];
                btn.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(btnWebServiceCallDay:) forControlEvents:UIControlEventTouchUpInside];
                btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:10];
                size = size + 16;
                [cell.viewEvent addSubview:btn];
            }
        }
        
        eventIndex = -1;
        if (size > 100) {
            rowHeight = size;
            eventIndex = indexPath.row;
        }
        return cell;
    }
    else if (tableView == self.tblWeek) {
        CalendarWeekCell *cell = (CalendarWeekCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[CalendarWeekCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.lblTime.font = [SET_FONTS_REGULAR fontWithSize:10];
        cell.lblTime.text = [arrTime objectAtIndex:indexPath.row];
        [[cell.viewWeek1 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek4 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek5 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek6 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[cell.viewWeek7 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        
        eventIndex = -1;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekdayOrdinal fromDate:_todayDate];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd-mm-yyyy"];
        float height = 0.0f;
        float maxHeight = 0.0f;
        for (int j = 0;  j < 7; j++) {
            height = 0.0f;
            for (int i = 0; i < selectEvent.count; i++) {
                NSDictionary *dic = [selectEvent objectAtIndex:i];
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                NSDate *event_date = [dateFormatter dateFromString:[dic objectForKey:@"StartTime"]];
                [dateFormatter setDateFormat:@"hh a"];
                NSDate *curDate = [calendar dateFromComponents:components];
                if ([[dateformatter stringFromDate:curDate] isEqualToString:[dateformatter stringFromDate:event_date]]) {
                    if ([[dateFormatter stringFromDate:event_date] isEqualToString:cell.lblTime.text]) {
                        [dateFormatter setDateFormat:@"hh:mm a"];
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (i * 15) +2, cell.viewWeek1.frame.size.width, 15)];
                        btn.tag = i;
                        [btn addTarget:self action:@selector(btnWebServiceCallDay:) forControlEvents:UIControlEventTouchUpInside];
                        UILabel *lblEvent = [[UILabel alloc] initWithFrame:CGRectMake(0, height, cell.viewWeek1.frame.size.width, 15)];
                        lblEvent.font = [SET_FONTS_REGULAR fontWithSize:10];
                        lblEvent.text = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"EventName"],[dateFormatter stringFromDate:event_date]];
                        CGSize constraint = CGSizeMake(lblEvent.frame.size.width, CGFLOAT_MAX);
                        CGSize size;
                        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
                        CGSize boundingBox = [lblEvent.text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:lblEvent.font}
                                                    context:context].size;
                        
                        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
                        CGRect frame = lblEvent.frame;
                        frame.size.height = size.height;
                        lblEvent.frame = frame;
                        lblEvent.numberOfLines = 21;
                        lblEvent.textColor = [UIColor whiteColor];
                        height = height + size.height;
                        lblEvent.backgroundColor = [Utility colorWithHexString:VIEW_BACKGROUND];
                        btn.frame = lblEvent.frame;
                        if (j == 0){
                            [cell.viewWeek1 addSubview:lblEvent];
                            [cell.viewWeek1 addSubview:btn];
                        }
                        else if(j == 1){
                            [cell.viewWeek2 addSubview:lblEvent];
                            [cell.viewWeek2 addSubview:btn];
                        }
                        else if(j == 2){
                            [cell.viewWeek3 addSubview:lblEvent];
                            [cell.viewWeek3 addSubview:btn];
                        }
                        else if(j == 3){
                            [cell.viewWeek4 addSubview:lblEvent];
                            [cell.viewWeek4 addSubview:btn];
                        }
                        else if(j == 4){
                            [cell.viewWeek5 addSubview:lblEvent];
                            [cell.viewWeek5 addSubview:btn];
                        }
                        else if(j == 5){
                            [cell.viewWeek6 addSubview:lblEvent];
                            [cell.viewWeek6 addSubview:btn];
                        }
                        else if(j == 6){
                            [cell.viewWeek7 addSubview:lblEvent];
                            [cell.viewWeek7 addSubview:btn];
                        }
                        height++;
                    }
                }
            }
            if (height > maxHeight) {
                maxHeight = height;
            }
            components.day++;
        }
        eventIndex = -1;
        if (maxHeight > 100) {
            rowHeight = maxHeight;
            eventIndex = indexPath.row;
        }

        return cell;
    }
    else if (tableView == self.tblList){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.font = SET_FONTS_REGULAR;
        if (tableView.tag == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Day";
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"Week";
            }
            else if (indexPath.row == 2) {
                cell.textLabel.text = @"Month";
            }
        }
        else if (tableView.tag == 1) {
            NSDictionary *dic = [arrList objectAtIndex:indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"FullName"];
        }
        else if (tableView.tag == 2) {
            cell.textLabel.text = [arrSession objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else{
        CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (selectEvent.count > indexPath.row) {
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
        }
        return cell;
    }
}

- (IBAction)btnWebServiceCallDay:(id)sender{
    [self selectWebview:[[[selectEvent objectAtIndex:[sender tag]] objectForKey:@"RECDNO"] integerValue] caseID:[[[selectEvent objectAtIndex:[sender tag]] objectForKey:@"CallBackID"] integerValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDay || tableView == self.tblWeek){
        
    }
    else if (tableView == self.tblList){
        self.viewPopupList.hidden = YES;
        if (tableView.tag == 0) {
            NSString *title= @"Select View:";
            if (indexPath.row == 0) {
                title = @"Day";
                calView = @"day";
            }
            else if (indexPath.row == 1) {
                title = @"Week";
                calView = @"week";
            }
            else if (indexPath.row == 2) {
                title = @"Month";
                calView = @"month";
            }
            
            [self.btnCalView setTitle:title forState:UIControlStateNormal];
            self.btnThird.hidden = NO;
            self.lblSession.hidden = NO;
            self.viewSession.hidden = NO;
            self.constSessionViewHeight.constant = 40;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:[NSDate date]];
            
            [arrSession removeAllObjects];
            
            if (indexPath.row == 0) {
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
                selSession = [dateFormatter stringFromDate:[NSDate date]];
                components.day -= 3;
                for (int i = 0; i < 7; i++) {
                    components.day++;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
                }
            }
            else if (indexPath.row == 1){
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                NSDate *date = [NSDate date];
                NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit                                                     fromDate:date];
                NSDate *startOfDay = [calendar dateFromComponents:comp];
                NSInteger diff = (NSInteger)[calendar firstWeekday] - (NSInteger)[comp weekday];
                if (diff > 0)
                    diff -= 7;
                NSDateComponents *subtract = [[NSDateComponents alloc] init];
                [subtract setDay:diff];
                NSDate *startOfWeek = [calendar dateByAddingComponents:subtract toDate:startOfDay options:0];
                components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:startOfWeek];
                [self.btnSelSession setTitle:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:startOfWeek]] forState:UIControlStateNormal];
                selSession = [dateFormatter stringFromDate:startOfWeek];
                components.day -= 28;
                for (int i = 0; i < 7; i++) {
                    components.day += 7;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:currentDatePlus1Month]]];
                }
            }
            else if (indexPath.row == 2){
                [dateFormatter setDateFormat:@"MMMM"];
                [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:[NSDate date]];
                [dateFormatter setDateFormat:@"MMMM"];
                components.month -=2;
                for (int i = 0; i < 3; i++) {
                    components.month++;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
                }
            }
            [self.btnThird setTitle:@"Cancel" forState:UIControlStateNormal];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"selSession"])
                [self.btnSecond setTitle:@"Save" forState:UIControlStateNormal];
        }
        if (tableView.tag == 1) {
            NSDictionary *dic = [arrList objectAtIndex:indexPath.row];
            selUser = [dic objectForKey:@"LogonID"];
            [self.btnSelUser setTitle:[dic objectForKey:@"FullName"] forState:UIControlStateNormal];
//            self.btnThird.hidden = NO;
//            self.lblSession.hidden = NO;
//            self.viewSession.hidden = NO;
//            self.constSessionViewHeight.constant = 40;
//            if (indexPath.row == 0) {
//                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//                [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
//            }
//            else if (indexPath.row == 1){
//                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//                [self.btnSelSession setTitle:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
//            }
//            else if (indexPath.row == 2){
//                [dateFormatter setDateFormat:@"MMMM"];
//                [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
//            }
//            [self.btnThird setTitle:@"Cancel" forState:UIControlStateNormal];
//            [self.btnSecond setTitle:@"Save" forState:UIControlStateNormal];
        }
        if (tableView.tag == 2) {
            if ([calView isEqualToString:@"day"]) {
                selSession = [arrSession objectAtIndex:indexPath.row];
            }
            else if ([calView isEqualToString:@"week"]) {
                NSArray *arr = [[arrSession objectAtIndex:indexPath.row] componentsSeparatedByString:@"Week of "];
                selSession = arr[1];
            }
            if ([calView isEqualToString:@"month"]) {
                [dateFormatter setDateFormat:@"MMMM"];
                NSDate *date = [dateFormatter dateFromString:[arrSession objectAtIndex:indexPath.row]];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:[NSDate date]];
                components.day = 1;
                [dateFormatter setDateFormat:@"MM"];
                components.month = [[dateFormatter stringFromDate:date] integerValue];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
            }
            
            [self.btnSelSession setTitle:[arrSession objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
    }
    else{
        [self selectWebview:[[[selectEvent objectAtIndex:indexPath.row] objectForKey:@"RECDNO"] integerValue] caseID:[[[selectEvent objectAtIndex:indexPath.row] objectForKey:@"CallBackID"] integerValue]];
    }
}

-(void)selectWebview:(NSInteger)recID caseID:(NSInteger)caseID
{
    isWeb = true;
    
    [_btnMenu setImage:[UIImage imageNamed:@"back_arrwow"] forState:UIControlStateNormal];
    
    NSString *urlString = [NSString stringWithFormat:                           @"%@/mobile_auth.asp?key=%@&topage=mobile_cbViewEvent.asp&RECDNO=%ld&CompanyID=%@&CallBackID=%ld&appkeyword=&pagetype=callback",MAIN_URL,[BaseApplication getEncryptedKey],(long)caseID,WORKGROUP,(long)recID];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 113)];
        //        NSLog(@"Landscape");
    } else {
        accWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,WIDTH,[UIScreen mainScreen].bounds.size.height - 113)];
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
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.month++;
    [dateFormatter setDateFormat:@"dd"];
    components.day = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [[NSCalendar currentCalendar] dateFromComponents:components];
//    [self createMinAndMaxDate];
//    [_calendarManager setDate:_todayDate];

}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:_todayDate];
    components.month--;
    [dateFormatter setDateFormat:@"dd"];
    components.day = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    //    [self createMinAndMaxDate];
//    [_calendarManager setDate:_todayDate];
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
    _calendarManager.settings.pageViewNumberOfWeeks = 0;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];

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
        lbl.font = [SET_FONTS_REGULAR fontWithSize:10];
    }
    for (int i = 0 ; i < self.btn.count; i++) {
        UIButton *btn = [self.btn objectAtIndex:i];
        btn.titleLabel.font = [SET_FONTS_REGULAR fontWithSize:14];
    }
    for (int i = 0 ; i < self.lblBold.count; i++) {
        UILabel *lbl = [self.lable objectAtIndex:i];
        lbl.font = SET_FONTS_BOLD;
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
    if (isWeb) {
        [accWebview removeFromSuperview];
        isWeb = false;
    } else {
        [[AppDelegate initAppdelegate].tabbar setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// Set Day & Week


- (IBAction)btnDay:(id)sender {
//    UIButton *btn = (UIButton *)sender;
    if ([sender tag] == 0) {
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            [self showCustomProgressViewWithText:@"Wait..."];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:_todayDate];
            calView = @"day";
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }
    }
    else if ([sender tag] == 1){
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            [self showCustomProgressViewWithText:@"Wait..."];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:_todayDate];
            calView = @"week";
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }
    }
    else if ([sender tag] == 2){
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            [self showCustomProgressViewWithText:@"Wait..."];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:_todayDate];
            calView = @"month";
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }
    }
//    if ([sender tag] == 0) {
        [self.btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//    else if ([sender tag] == ) {
//        [self.btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//    else if ([sender tag] == 0) {
//        [self.btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
    
    [self setViewDisplay:[sender tag]];
    [self setButtonBack_Font:(int)[sender tag]];
}

- (void)setDayChart{
    [dateFormatter setDateFormat:@"dd MMM"];
    lblDayDate.text = [dateFormatter stringFromDate:_todayDate];
            eventIndex = -1;
        [selectEvent removeAllObjects];
        for (int i = 0; i < arrEvent.count; i++) {
            NSDictionary *dic = [arrEvent objectAtIndex:i];
            NSString *dateString = [dic objectForKey:@"StartTime"];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            if ([[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:_todayDate ]]) {
                [selectEvent addObject:[arrEvent objectAtIndex:i]];
            }
        }
        [tblDay reloadData];
   
}

- (void)setWeekChart{
    [dateFormatter setDateFormat:@"dd MMM"];
    lblDayDate.text = [dateFormatter stringFromDate:_todayDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekdayOrdinal fromDate:_todayDate];
//    NSLog(@"Date: %@ %ld %ld",[calendar dateFromComponents:components],(long)components.weekOfYear,components.weekday);
    
    self.lblWeek1.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date2 = [calendar dateFromComponents:components];
    self.lblWeek2.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date3 = [calendar dateFromComponents:components];
    self.lblWeek3.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date4 = [calendar dateFromComponents:components];
    self.lblWeek4.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date5 = [calendar dateFromComponents:components];
    self.lblWeek5.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date6 = [calendar dateFromComponents:components];
    self.lblWeek6.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    components.day++;
    NSDate *date7 = [calendar dateFromComponents:components];
    self.lblWeek7.text = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    eventIndex = -1;
    [selectEvent removeAllObjects];
    for (int i = 0; i < arrEvent.count; i++) {
        NSDictionary *dic = [arrEvent objectAtIndex:i];
        NSString *dateString = [dic objectForKey:@"StartTime"];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if ([[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:_todayDate]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date2]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date3]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date4]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date5]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date6]] || [[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:date7]]) {
            [selectEvent addObject:[arrEvent objectAtIndex:i]];
        }
    }
    [self.tblWeek reloadData];
}

- (IBAction)btnNext:(id)sender {
    [dateFormatter setDateFormat:@"MMM yyyy"];
//    NSDate *date = [dateFormatter dateFromString:self.lblMonYear.text];
    NSDate *date = _todayDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:date];
    if (self.viewMonth.hidden == NO) {
        components.month++;
    }
    if (self.viewWeek.hidden == NO) {
        components.day += 7;
    }
    if (self.viewDay.hidden == NO) {
        components.day++;
    }
    
//    [dateFormatter setDateFormat:@"dd"];
//    components.day = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [calendar dateFromComponents:components];
    [dateFormatter setDateFormat:@"MM"];
    if (![[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:_todayDate]]) {
        [self showCustomProgressViewWithText:@"Wait..."];
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:_todayDate];
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }else{
            [self getCalendarEventData:@"" date:_todayDate];
        }
    }
    else{
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            if ([calView isEqualToString:@"day"]) {
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"day";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
            }
            else if ([calView isEqualToString:@"week"]){
                
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"week";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
                
            }
            else if ([calView isEqualToString:@"month"]){
                
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"month";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
                
            }
        }
        else{
            [self setDayChart];
            [self setWeekChart];
            [self createMinAndMaxDate];
            [_calendarManager setDate:_todayDate];
        }
    }
    
}

- (IBAction)btnPrev:(id)sender {
    
    [dateFormatter setDateFormat:@"MMM yyyy"];
//    NSDate *date = [dateFormatter dateFromString:self.lblMonYear.text];
    NSDate *date = _todayDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:date];
    if (self.viewMonth.hidden == NO) {
        components.month--;
    }
    if (self.viewWeek.hidden == NO) {
        components.day -= 7;
    }
    if (self.viewDay.hidden == NO) {
        components.day--;
    }
//    [dateFormatter setDateFormat:@"dd"];
//    components.day = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:currentDatePlus1Month];
    
    [dateFormatter setDateFormat:@"dd"];
    _todayDate = [calendar dateFromComponents:components];
    [dateFormatter setDateFormat:@"MM"];
    if (![[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:_todayDate]]) {
        [self showCustomProgressViewWithText:@"Wait..."];
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:_todayDate];
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }else{
            [self getCalendarEventData:@"" date:_todayDate];
        }
    }
    else{
        if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
            if ([calView isEqualToString:@"day"]) {
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"day";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
            }
            else if ([calView isEqualToString:@"week"]){
                
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"week";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
                
            }
            else if ([calView isEqualToString:@"month"]){
                
                [self showCustomProgressViewWithText:@"Wait..."];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:_todayDate];
                calView = @"month";
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
                
            }
        }
        else{
            [self setDayChart];
            [self setWeekChart];
            [self createMinAndMaxDate];
            [_calendarManager setDate:_todayDate];
        }
    }
}

- (void)setViewDisplay:(NSInteger)index{
    if (index == 0) {
        [self setDayChart];
        self.viewDay.hidden = NO;
        self.viewMonth.hidden = YES;
        self.viewWeek.hidden = YES;
    }
    else if (index == 1){
        [self setWeekChart];
        self.viewWeek.hidden = NO;
        self.viewDay.hidden = YES;
        self.viewMonth.hidden = YES;
    }
    else if (index == 2){
        self.viewWeek.hidden = YES;
        self.viewDay.hidden = YES;
        self.viewMonth.hidden = NO;
    }
    else{
        self.viewWeek.hidden = YES;
        self.viewDay.hidden = YES;
        self.viewMonth.hidden = YES;
    }
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
        [self.view setUserInteractionEnabled:TRUE];
        
    }
    [self.view addSubview:lightBoxView];
    [self.view addSubview:progressView];
}
-(void)hideCustomProgressView
{
    [progressView removeFromSuperview];
    [lightBoxView removeFromSuperview];
    lightBoxView=nil;
    progressView=nil;
}


- (void)showPopup:(BOOL)flag{
    self.viewPopupList.hidden = YES;
    if (flag) {
        self.viewBlue.hidden = NO;
        self.viewPopup.hidden = NO;
        [self setPopupTitle];
    }
    else{
        self.viewBlue.hidden = YES;
        self.viewPopup.hidden = YES;
    }
}

- (void)setPopupTitle{
    self.btnFirst.hidden = YES;
    self.btnThird.hidden = YES;
    self.lblSession.hidden = YES;
    self.viewSession.hidden = YES;
    self.constSessionViewHeight.constant = 0;
    
    if ([fromWhichVC isEqualToString:@"GroupCalander"]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"selSession"]) {
            self.btnFirst.hidden = NO;
            self.btnThird.hidden = NO;
            self.lblSession.hidden = NO;
            self.viewSession.hidden = NO;
            self.constSessionViewHeight.constant = 40;
            if ([calView length] <= 0) {
                calView = @"month";
            }
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:[NSDate date]];
            
            [arrSession removeAllObjects];

            [self.btnCalView setTitle:[calView capitalizedString] forState:UIControlStateNormal];
            if ([calView isEqualToString:@"day"]) {
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                [self.btnSelSession setTitle:[dateFormatter stringFromDate:_todayDate] forState:UIControlStateNormal];
                selSession = [dateFormatter stringFromDate:_todayDate];
                components.day -= 3;
                for (int i = 0; i < 7; i++) {
                    components.day++;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
                }
            }
            else if ([calView isEqualToString:@"week"]){
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                NSDate *date = [NSDate date];
                NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit                                                     fromDate:date];
                NSDate *startOfDay = [calendar dateFromComponents:comp];
                NSInteger diff = (NSInteger)[calendar firstWeekday] - (NSInteger)[comp weekday];
                if (diff > 0)
                    diff -= 7;
                NSDateComponents *subtract = [[NSDateComponents alloc] init];
                [subtract setDay:diff];
                NSDate *startOfWeek = [calendar dateByAddingComponents:subtract toDate:startOfDay options:0];
                components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:startOfWeek];
                [self.btnSelSession setTitle:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:startOfWeek]] forState:UIControlStateNormal];
                selSession = [dateFormatter stringFromDate:startOfWeek];
                components.day -= 28;
                for (int i = 0; i < 7; i++) {
                    components.day += 7;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:currentDatePlus1Month]]];
                }
            }
            else if ([calView isEqualToString:@"month"]){
                [dateFormatter setDateFormat:@"MMMM"];
                [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                selSession = [dateFormatter stringFromDate:[NSDate date]];
                [dateFormatter setDateFormat:@"MMMM"];
                components.month -=2;
                for (int i = 0; i < 3; i++) {
                    components.month++;
                    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
                }
            }
            [self.btnFirst setTitle:@"Save" forState:UIControlStateNormal];
            [self.btnSecond setTitle:@"Clear" forState:UIControlStateNormal];
            [self.btnThird setTitle:@"Cancel" forState:UIControlStateNormal];
        }
        else{
            [self.btnCalView setTitle:@"Select View :" forState:UIControlStateNormal];
            [self.btnSecond setTitle:@"Cancel" forState:UIControlStateNormal];
        }
    }
}


- (IBAction)btnGroupCal:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"In Pending" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    if (arrList.count <= 0) {
        [self webServiceGetUserList];
    }
    [self showPopup:YES];
}

- (IBAction)btnCalView:(id)sender {
    if (self.viewPopupList.hidden == NO && self.tblList.tag == 0) {
        self.viewPopupList.hidden = YES;
        return;
    }
    self.viewPopupList.hidden = NO;
    self.tblList.tag = 0;
    float y = self.viewCalSel.frame.origin.y + 40;
    self.constViewPopupTop.constant = y;
    float size = 3 * 50;
    if (size > ([UIScreen mainScreen].bounds.size.height - y - 50)) {
        size = [UIScreen mainScreen].bounds.size.height - y - 50;
    }
    self.constTblListHeight.constant = size;
    [self.tblList reloadData];
}

- (IBAction)btnSelUser:(id)sender {
    if (self.viewPopupList.hidden == NO && self.tblList.tag == 1) {
        self.viewPopupList.hidden = YES;
        return;
    }
    if (arrList.count > 0) {
        self.viewPopupList.hidden = NO;
        self.tblList.tag = 1;
        float y = self.viewSelUser.frame.origin.y + 40;
        self.constViewPopupTop.constant = y;
        float size = arrList.count * 50;
        if (size > ([UIScreen mainScreen].bounds.size.height - y - 50 - self.viewPopup.frame.origin.y)) {
            size = [UIScreen mainScreen].bounds.size.height - y - 50 - self.viewPopup.frame.origin.y;
        }
        self.constTblListHeight.constant = size;
        [self.tblList reloadData];
    }
}

- (IBAction)btnSelSession:(id)sender {
    if (self.viewPopupList.hidden == NO && self.tblList.tag == 2) {
        self.viewPopupList.hidden = YES;
        return;
    }
    
    if (![[calView capitalizedString] isEqualToString:self.btnCalView.titleLabel.text]) {
        [arrSession removeAllObjects];
    }
    if (arrSession.count <= 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:[NSDate date]];
        if ([self.btnCalView.titleLabel.text isEqualToString:@"Day"]) {
            calView = @"day";
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
            selSession = [dateFormatter stringFromDate:[NSDate date]];
            components.day -= 3;
            for (int i = 0; i < 7; i++) {
                components.day++;
                NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
            }
        }
        else if ([self.btnCalView.titleLabel.text isEqualToString:@"Week"]){
            calView = @"week";
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *date = [NSDate date];
            NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit                                                     fromDate:date];
            NSDate *startOfDay = [calendar dateFromComponents:comp];
            NSInteger diff = (NSInteger)[calendar firstWeekday] - (NSInteger)[comp weekday];
            if (diff > 0)
                diff -= 7;
            NSDateComponents *subtract = [[NSDateComponents alloc] init];
            [subtract setDay:diff];
            NSDate *startOfWeek = [calendar dateByAddingComponents:subtract toDate:startOfDay options:0];
            components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear) fromDate:startOfWeek];
            [self.btnSelSession setTitle:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:startOfWeek]] forState:UIControlStateNormal];
            selSession = [dateFormatter stringFromDate:startOfWeek];
            components.day -= 28;
            for (int i = 0; i < 7; i++) {
                components.day += 7;
                NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                [arrSession addObject:[NSString stringWithFormat:@"Week of %@",[dateFormatter stringFromDate:currentDatePlus1Month]]];
            }
        }
        else if ([self.btnCalView.titleLabel.text isEqualToString:@"Month"]){
            calView = @"month";
            [dateFormatter setDateFormat:@"MMMM"];
            [self.btnSelSession setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            selSession = [dateFormatter stringFromDate:[NSDate date]];
            [dateFormatter setDateFormat:@"MMMM"];
            components.month -=2;
            for (int i = 0; i < 3; i++) {
                components.month++;
                NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateFromComponents:components];
                [arrSession addObject:[dateFormatter stringFromDate:currentDatePlus1Month]];
            }
        }
    }
    
    if (arrSession.count > 0) {
        self.viewPopupList.hidden = NO;
        self.tblList.tag = 2;
        float y = self.viewSession.frame.origin.y + 40;
        self.constViewPopupTop.constant = y;
        float size = arrSession.count * 50;
        if (size > ([UIScreen mainScreen].bounds.size.height - y - 50 -  self.viewPopup.frame.origin.y)) {
            size = [UIScreen mainScreen].bounds.size.height - y - 50 - self.viewPopup.frame.origin.y;
        }
        self.constTblListHeight.constant = size;
        [self.tblList reloadData];
    }
    
    
}

- (IBAction)btnPopup:(id)sender {
    if (self.btnThird.hidden == YES) {
        [self showPopup:NO];
    }
    else{
        if ([sender tag] == 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"selSession"];
            [[NSUserDefaults standardUserDefaults] setObject:selUser forKey:@"selUser"];
            [[NSUserDefaults standardUserDefaults] setObject:calView forKey:@"calView"];
            [[NSUserDefaults standardUserDefaults] setObject:selSession forKey:@"selSessionData"];
            [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
        }
        else if ([sender tag] == 1){
            [[NSUserDefaults standardUserDefaults] setObject:selUser forKey:@"selUser"];
            [[NSUserDefaults standardUserDefaults] setObject:calView forKey:@"calView"];
            [[NSUserDefaults standardUserDefaults] setObject:selSession forKey:@"selSessionData"];
            if (self.btnFirst.hidden == NO) {
                if (arrList.count > 0) {
                    NSDictionary *dic = [arrList objectAtIndex:0];
                    selUser = [dic objectForKey:@"LogonID"];
                    [self.btnSelUser setTitle:[dic objectForKey:@"FullName"] forState:UIControlStateNormal];
                }
                [_eventsByDate removeAllObjects];
                [self DayWeekEnable:YES];
                [self createMinAndMaxDate];
                [self setButtonBack_Font:2];
                [self setViewDisplay:2];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"selSession"];
                [arrEvent removeAllObjects];
                [selectEvent removeAllObjects];
                [self.tblCal reloadData];
                [self showPopup:NO];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"selSession"];
                [self serviceForGroupCalendarEvent:selUser and:calView and:selSession];
            }
        }
        else{
            [self showPopup:NO];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)DayWeekEnable:(BOOL)flag{
    if (flag) {
        [_btnDay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnWeek setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnDay.enabled = NO;
        _btnWeek.enabled = NO;
    }
    else{
        [_btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnDay.enabled = YES;
        _btnWeek.enabled = YES;
    }
}

-(void)webServiceGetUserList
{
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":LOGIN_ID},@{@"CompanyID":WORKGROUP}]];
    
    [self showCustomProgressViewWithText:@"Wait..."];
    
    [BaseApplication executeRequestwithService:GET_GROUP_CALENDAR_USER_DETAIL arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
        NSError *err=[[NSError alloc] init];
        SMXMLDocument *document = [SMXMLDocument documentWithData:dictresponce error:&err];
        
        NSLog(@"Documents %@",document);
        
        
        SMXMLElement *rootDoctument = [[[document firstChild] firstChild] firstChild];
        
        if (!rootDoctument)
        {
            
        }
        else
        {
            [arrList removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeGroupCalUserDetail"])
            {
                if ([doc valueWithPath:@"LogonID"] && [doc valueWithPath:@"FullName"]) {
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[doc valueWithPath:@"LogonID"],@"LogonID",[doc valueWithPath:@"FullName"],@"FullName", nil];
                    [arrList addObject:dic];
                }
                
            }
        }
        [self hideCustomProgressView];
        if (arrList.count > 0) {
            NSDictionary *dic = [arrList objectAtIndex:0];
            selUser = [dic objectForKey:@"LogonID"];
            [self.btnSelUser setTitle:[dic objectForKey:@"FullName"] forState:UIControlStateNormal];
        }
        
    }];
}

-(void)serviceForGroupCalendarEvent:(NSString *)LogonID and:(NSString *)duration and:(NSString *)durationDate
{
    if (LogonID == nil) {
        LogonID = @"";
    }
    if (duration == nil) {
        duration = @"";
    }
    
    if (durationDate == nil) {
        durationDate = @"";
    }
    if ([durationDate length] <= 0) {
        [dateFormatter setDateFormat:@"MMMM"];
        durationDate = [dateFormatter stringFromDate:[NSDate date]];
    }
    if ([duration length] <= 0) {
        duration = @"month";
    }
    [self showPopup:NO];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    _todayDate = [dateFormatter dateFromString:durationDate];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    self.lblMonYear.text = [dateFormatter stringFromDate:_todayDate];
    if ([duration isEqualToString:@"month"]) {
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        [comp setDay:1];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        durationDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:comp]];
    }
    NSMutableArray *tArray1=[[NSMutableArray alloc] initWithArray:@[@{@"LogonID":LogonID},@{@"CompanyID":WORKGROUP},@{@"Duration":duration},@{@"DurationDate":durationDate}]];

    [self showCustomProgressViewWithText:@"Wait..."];
    [BaseApplication executeRequestwithService:GET_GROUP_CALENDAR_CALL_BACK_EVENT arrPerameter:tArray1 withBlock:^(NSData *dictresponce, NSError *error){
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
            [_eventsByDate removeAllObjects];
            for (SMXMLElement *doc in [rootDoctument childrenNamed:@"TypeEventData"])
            {
                if([[doc valueWithPath:@"RECDNO"] integerValue]!=0)
                {
                    NSMutableDictionary *tmpDataDic=[[NSMutableDictionary alloc]init];
                    if([doc valueWithPath:@"EventName"])
                        [tmpDataDic setValue:[doc valueWithPath:@"EventName"] forKey:@"EventName"];
                    else if([doc valueWithPath:@"EventType"])
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
            [self.tblCal reloadData];
            if (arrEvent.count <= 0) {
                [self DayWeekEnable:YES];
                [self setViewDisplay:2];
            }
            else{
                [self.btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.btnWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self DayWeekEnable:NO];
                if ([duration isEqualToString:@"day"]) {
                    [self setButtonBack_Font:0];
                    [self setViewDisplay:0];
                }
                else if ([duration isEqualToString:@"week"]) {
                    [self setButtonBack_Font:1];
                    [self setViewDisplay:1];
                }
                else{
                    [self setButtonBack_Font:2];
                    [self setViewDisplay:2];
                }
            }
            
            
        }
        [self hideCustomProgressView];
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch ;
    touch = [[event allTouches] anyObject];
    if ([touch view] == self.viewBlue)
    {
        if (self.viewPopupList.hidden == NO) {
            self.viewPopupList.hidden = YES;
        }
        else
            [self showPopup:NO];
    }
}

@end
