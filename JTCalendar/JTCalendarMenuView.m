//
//  JTCalendarMenuView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuView.h"

#import "JTCalendar.h"
#import "JTCalendarMenuMonthView.h"

#define NUMBER_PAGES_LOADED 3 // Must be the same in JTCalendarView, JTCalendarMenuView, JTCalendarContentView

@interface JTCalendarMenuView(){
    NSMutableArray *monthsViews;
    int menuID;
}

@end

@implementation JTCalendarMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    monthsViews = [NSMutableArray new];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        JTCalendarMenuMonthView *monthView = [JTCalendarMenuMonthView new];
                
        [self addSubview:monthView];
        [monthsViews addObject:monthView];
    }
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegates.monthsViews=monthsViews;
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
        
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    self.contentOffset = CGPointMake(self.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if(self.calendarManager.calendarAppearance.ratioContentMenu != 1.){
        width = self.frame.size.width / self.calendarManager.calendarAppearance.ratioContentMenu;
        x = (self.frame.size.width - width) / 2.;
    }
    
    for(UIView *view in monthsViews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    self.contentSize = CGSizeMake(width * NUMBER_PAGES_LOADED, height);
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    self->_currentDate = currentDate;
 
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
    NSInteger currentMonthIndex = comps.month;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        JTCalendarMenuMonthView *monthView = monthsViews[i];
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2) + i;
        monthIndex = monthIndex % 12;

        
        if (i==1) {
            NSDateComponents *dayComponent = [NSDateComponents new];
            dayComponent.month =1-(NUMBER_PAGES_LOADED / 2);
            NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
            
            NSDateFormatter  *yerformatter=[[NSDateFormatter alloc] init];
            [yerformatter setDateFormat:@"yyyy"];
            NSString *  yearStr=[yerformatter stringFromDate:monthDate];
            
            NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
            [monthformatter setDateFormat:@"MM"];
            NSString *motStr=[monthformatter stringFromDate:monthDate];
            menuID=[motStr intValue];
            //        int mot=[motStr intValue]-1;
            //        NSString *  monthStr;
            //        if (mot<10) {
            //            if (mot<0) {
            //                monthStr=[NSString stringWithFormat:@"12"];
            //            }else{
            //                monthStr=[NSString stringWithFormat:@"0%d",mot];
            //            }
            //        }else{
            //            monthStr=[NSString stringWithFormat:@"0%d",mot];
            //        }
            
            
            ISLoginManager *_manager = [ISLoginManager shareManager];
            DownloadManager *download = [[DownloadManager alloc]init];
            NSDictionary *dict=@{@"user_id":_manager.telephone,@"year":yearStr,@"month":motStr};
            UIView *view=[[UIView alloc]init];
            [download requestWithUrl:@"simi/app/user/msg/total_by_month.json"  dict:dict view:view delegate:self finishedSEL:@selector(RiLiSuccess:) isPost:NO failedSEL:@selector(RiLiFailure:)];
        }
        [monthView setMonthIndex:currentDate];
//        }
    }
}
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

-(void)RiLiSuccess:(id)sender
{
    NSArray *array=[sender objectForKey:@"data"];
    
    AppDelegate *delegates=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [delegates.riliArray removeAllObjects];
    for (int i=0; i<array.count; i++) {
        if([delegates.riliArray containsObject:array[i]])
        {
            
        }else{
            [delegates.riliArray addObject:array[i]];
        }
    }
    
//    [delegates.eventsByDate removeAllObjects];
    for(int i = 0; i <delegates.riliArray.count; ++i){
        NSDictionary *dic=delegates.riliArray[i];
        NSString *riliStr=[NSString stringWithFormat:@"%@ 07:10:00",[dic objectForKey:@"service_date"]];
        NSString *theFirstTime1=[NSString stringWithFormat:@"%@",riliStr];
        NSDateFormatter *theFirstformatte1 = [[NSDateFormatter alloc] init];
        [theFirstformatte1 setDateStyle:NSDateFormatterMediumStyle];
        [theFirstformatte1 setTimeStyle:NSDateFormatterShortStyle];
        [theFirstformatte1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* theFirstdate1 = [theFirstformatte1 dateFromString:theFirstTime1];
        //        NSDate *randomDate = [theFirstformatte1 dateFromString:theFirstTime1];//[NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        NSString *key = [[self dateFormatter] stringFromDate:theFirstdate1];
        
        if(!delegates.eventsByDate[key]){
            delegates.eventsByDate[key] = [NSMutableArray new];
        }
        
        [delegates.eventsByDate[key] addObject:theFirstdate1];
    }
    
    //    delegates.riliArray=array;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RILIARRAY" object:nil];
}
-(void)RiLiFailure:(id)sender
{
    NSLog(@"日历布局失败返回:%@",sender);
}

#pragma mark - Load Month

- (void)loadPreviousMonth
{
    
    JTCalendarMenuMonthView *monthView = [monthsViews lastObject];
    
    [monthsViews removeLastObject];
    [monthsViews insertObject:monthView atIndex:0];
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    // Update currentDate
    {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.month = -1;
        self->_currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    }
    
    // Update monthView
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:self.currentDate];
        NSInteger currentMonthIndex = comps.month;
        
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2);
        monthIndex = monthIndex % 12;
        [monthView setMonthIndex:self.currentDate];
    }
    
    [self configureConstraintsForSubviews];
}

- (void)loadNextMonth
{
    JTCalendarMenuMonthView *monthView = [monthsViews firstObject];
    
    [monthsViews removeObjectAtIndex:0];
    [monthsViews addObject:monthView];
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    // Update currentDate
    {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.month = 1;
        self->_currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    }
    
    // Update monthView
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:self.currentDate];
        NSInteger currentMonthIndex = comps.month;
        
        NSInteger monthIndex = currentMonthIndex - (NUMBER_PAGES_LOADED / 2) + (NUMBER_PAGES_LOADED - 1);
        monthIndex = monthIndex % 12;
        [monthView setMonthIndex:self.currentDate];
    }
    
    [self configureConstraintsForSubviews];
}

#pragma mark - JTCalendarManager

- (void)setCalendarManager:(JTCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    for(JTCalendarMenuMonthView *view in monthsViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadAppearance
{
    self.scrollEnabled = !self.calendarManager.calendarAppearance.isWeekMode;
    
    [self configureConstraintsForSubviews];
    for(JTCalendarMenuMonthView *view in monthsViews){
        [view reloadAppearance];
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
