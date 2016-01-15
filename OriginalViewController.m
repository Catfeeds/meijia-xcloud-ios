//
//  OriginalViewController.m
//  simi
//
//  Created by 白玉林 on 15/9/11.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "OriginalViewController.h"

@interface OriginalViewController ()
{
    NSMutableDictionary *eventsByDate;
    UILabel *timeLabel;
    NSString *timeString;
}

@end

@implementation OriginalViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.backBtn.hidden=YES;
    self.backlable.hidden=YES;
    self.navlabel.hidden=YES;
    self.lineLable.hidden=YES;
//    self.calendarMenuView.hidden = NO;
//    self.calendarContentView.hidden = NO;
//    self.calendar = [JTCalendar new];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    {
        self.calendar = [JTCalendar new];
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self createRandomEvents];
    
    [self.calendar reloadData];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeString=locationString;
    //[dateformatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    [self timeLabelLayout];
    // Do any additional setup after loading the view.
}
//年月日显示lable显示
-(void)timeLabelLayout
{
    [timeLabel removeFromSuperview];
    timeLabel=[[UILabel alloc]init];
    timeLabel.text=timeString;
    timeLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME((WIDTH-timeLabel.frame.size.width)/2, 41, timeLabel.frame.size.width, 20);
    timeLabel.font=[UIFont fontWithName:@"Arial" size:15];
    [self.view addSubview:timeLabel];
}
- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    //    NSString *key = [[self dateFormatter] stringFromDate:date];
    //    NSArray *events = eventsByDate[key];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    NSLog(@"Date: %@ events", locationString);
    timeString=locationString;
    [self timeLabelLayout];
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
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
