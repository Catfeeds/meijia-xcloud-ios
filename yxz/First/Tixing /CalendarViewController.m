//
//  CalendarViewController.m
//  simi
//
//  Created by zrj on 14-12-14.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "CalendarViewController.h"
#import "Datetime.h"
#import "CalendarCell.h"
#import "BaiduMobStat.h"
@interface CalendarViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * dayArray;
    NSArray * lunarDayArray;
    int strMonth;
    int strYear;
    int today;
    bool timePacker;
    UIView * timePickerView;
    
    UILabel* calendarTitleLabel;  //nav 阳历lab
    UILabel* lunarTitleLabel;     //nav 农历lab
    UIButton * titleButten ;
    NSMutableArray *todayArr;    //点击日期后当天的闹钟
    UITableView *_mytableView;

    UIView *shang;
    UIView *xia;
    float _height;
}
@end

@implementation CalendarViewController


@synthesize titleView,pickerView;

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"日历", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"日历", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (id)init
{
    self = [super init];
    if (self) {
        strYear = [[Datetime GetYear] intValue];
        strMonth = [[Datetime GetMonth] intValue];
        dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
        lunarDayArray = [Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
        timePacker = YES;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self CreateTableView];
    [self AddNavigationBarToRootView];
    [self AddWeekLableToCalendarWatch];
    [self AddDaybuttenToCalendarWatch];
    [self AddHandleSwipe];
//    [self OtherTouchEvent];
    
    NSLog(@"什么情况");

}
//为view添加NavigationBar
-(void)AddNavigationBarToRootView{
    [self AddTimeLableToNavigationBar];
//    [self AddLeftButtenToNavigationBar];
    [self AddRightButtenArrayToNavigationBar];
}
//为NavigationBar添加中间的时间标题
-(void)AddTimeLableToNavigationBar{
    titleButten = [[UIButton alloc]initWithFrame:CGRectMake((SELF_VIEW_WIDTH-80)/2, 20, 80, 44)];
    [titleButten addSubview:[self CalendarTitleLabel]];
    [titleButten addSubview:[self LunarCalendarTitleLabel]];
    [titleButten addTarget:self action:@selector(titleButtenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButten];
}
//制作阳历lable
-(UILabel *)CalendarTitleLabel{
    calendarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 ,80, 24)];
    calendarTitleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    calendarTitleLabel.font = [UIFont boldSystemFontOfSize:13];  //设置文本字体与大小
    calendarTitleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha:1];  //设置文本颜色
    calendarTitleLabel.textColor = [UIColor whiteColor];
    if ((strYear == [[Datetime GetYear] intValue])&&(strMonth ==[[Datetime GetMonth] intValue])){
        calendarTitleLabel.text = [Datetime getDateTime];
    }else {
        if (strMonth < 10) {
            calendarTitleLabel.text = [NSString stringWithFormat:@"%d年  %d月",strYear,strMonth];
        }else{
            calendarTitleLabel.text = [NSString stringWithFormat:@"%d年%d月",strYear,strMonth];}
    }
    //设置标题
    
    //calendarTitleLabel.text = [Datetime getDateTime];  //设置标题
    calendarTitleLabel.hidden = NO;
    calendarTitleLabel.tag = 2001;
    calendarTitleLabel.adjustsFontSizeToFitWidth = YES;
    return calendarTitleLabel;
}
//制作阴历lable
-(UILabel *)LunarCalendarTitleLabel{
    lunarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 ,80, 20)];
    lunarTitleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    lunarTitleLabel.font = [UIFont boldSystemFontOfSize:10];  //设置文本字体与大小
    lunarTitleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha:1];  //设置文本颜色
    lunarTitleLabel.textColor = [UIColor whiteColor];
    if ((strYear == [[Datetime GetYear] intValue])&&(strMonth ==[[Datetime GetMonth] intValue])){
        lunarTitleLabel.text = [Datetime GetLunarDateTime];
    }else lunarTitleLabel.hidden = NO;//设置标题
    lunarTitleLabel.tag = 2002;
    lunarTitleLabel.adjustsFontSizeToFitWidth = YES;
    return lunarTitleLabel;
}
//时间标题点击事件
-(void)titleButtenAction:(id)sender{
    if (timePacker == YES){
        timePacker = NO;
        [self AddTimePickerToCalendarWatch];
    }else {
        timePacker = YES;
        [self reMoveTimePickerToCalendarWatch];
    }
}
//为NavigationBar添加左边的设置按钮
//-(void)AddLeftButtenToNavigationBar{
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"设置"
//                                   style:UIBarButtonItemStylePlain
//                                   target:self
//                                   action:@selector(LeftButtenAction)];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
//}
//左边的设置按钮Action
//-(void)LeftButtenAction{
//    NSLog(@"设置");
//}
//为NavigationBar添加右边的返回今天按钮和添加事件按钮
-(void)AddRightButtenArrayToNavigationBar{
    //返回今天butten
    UIButton *todayButten = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-47/2-20, 20+8, 47/2, 57/2) ];
                             
    [todayButten addTarget:self action:@selector(backTodayAction) forControlEvents:UIControlEventTouchUpInside ];

    [todayButten setImage:[UIImage imageNamed:@"today_@2x"] forState:UIControlStateNormal];
    
//    [todayButten setImage:[UIImage imageNamed:@"today_click@2x"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:todayButten];
                             
    //添加事件butten
//    UIBarButtonItem *eventAddButton = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                       target:self
//                                       action:@selector(eventAddAction)];
//    NSArray *buttonArray = [[NSArray alloc]
//                            initWithObjects:eventAddButton,todayButten,
//                            nil];
//    self.navigationItem.rightBarButtonItems = buttonArray;
}
//返回今天按钮
-(void)backTodayAction{
    strYear = [[Datetime GetYear] intValue];
    strMonth = [[Datetime GetMonth] intValue];
    [self reloadDateForCalendarWatch];
    
    
    NSString *day;
    if (today<10) {
        day = [NSString stringWithFormat:@"0%i",today];
    }else{
        day = [NSString stringWithFormat:@"%i",today];
    }
    NSString *month;
    if (strMonth < 10) {
        month = [NSString stringWithFormat:@"0%i",strMonth];
    }else{
        month = [NSString stringWithFormat:@"%i",strMonth];
    }

    NSArray *arr = [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    todayArr = [[NSMutableArray alloc]init];
    for (int i = 0; i< arr.count; i++) {
        dic = [arr objectAtIndex:i];
        if ([[dic objectForKey:@"date"] isEqualToString:[NSString stringWithFormat:@"%i-%@-%@",strYear,month,day]]) {

            [todayArr addObject:dic];
            
        }
    }
    [self tableHeight];
    [_mytableView reloadData];
}
//添加事件按钮
-(void)eventAddAction{
    NSLog(@"添加");
}
//添加时间选择器
-(void)AddTimePickerToCalendarWatch{
    timePickerView = [[UIView alloc]initWithFrame:CGRectMake(-10, -30,320, 600)];
    timePickerView.hidden = timePacker;
    timePickerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    timePickerView.tag = 1000;
    UIView *timePicker = [[UIView alloc]init];
    timePicker.frame = CGRectMake(80, 88, 173, 240);
    timePicker.backgroundColor = HEX_TO_UICOLOR(NAV_COLOR, 1.0);
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 173, 40)];
    lable.text = @"选择日期";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = [UIColor blackColor];
    
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 173, 100)];
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    
    UIButton * ensureButten = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 173/2, 40)];
    [ensureButten addTarget:self action:@selector(ensureButtenAction:) forControlEvents:UIControlEventTouchUpInside];
    [ensureButten setTitle: @"确定" forState:UIControlStateNormal];
    [ensureButten setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ensureButten setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * backButten = [[UIButton alloc]initWithFrame:CGRectMake(173/2, 200, 173/2, 40)];
    [backButten setTitle:@"返回" forState:UIControlStateNormal];
    [backButten addTarget:self action:@selector(backButtenAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButten setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButten setBackgroundColor:[UIColor whiteColor]];
    
    [timePicker addSubview:lable];
    [timePicker addSubview:ensureButten];
    [timePicker addSubview:backButten];
    [timePicker addSubview:pickerView];
    
    [timePickerView addSubview:timePicker];
    [self.view addSubview:timePickerView];

}
//时间选择器的确定和返回按钮
-(void)ensureButtenAction:(id)sender{
    NSInteger rowYear=[pickerView selectedRowInComponent:0];
    strYear=[[[Datetime GetAllYearArray] objectAtIndex:(int)rowYear] intValue];
    NSInteger rowMonth=[pickerView selectedRowInComponent:1];
    strMonth=[[[Datetime GetAllMonthArray] objectAtIndex:(int)rowMonth] intValue];
    //NSLog(@"%d年%d",strYear,strMonth);
    timePacker = YES;
    [self reloadDateForCalendarWatch];
    [self reMoveTimePickerToCalendarWatch];
}
-(void)backButtenAction:(id)sender{
    timePacker = YES;
    [self reMoveTimePickerToCalendarWatch];
}

//时间选择器的栏数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//为时间选择器添加数据源
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [[Datetime GetAllYearArray] count];
    }else {
        return [[Datetime GetAllMonthArray] count];
    }
}
//将数据源显示在view上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return [[Datetime GetAllYearArray] objectAtIndex:row];
    }else {
        return [[Datetime GetAllMonthArray] objectAtIndex:row];
    }
}
//两栏宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == 0)
        return (100);
    return 55;
}
//移除时间选择器
-(void)reMoveTimePickerToCalendarWatch{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

//向日历中添加星期标号（周日到周六）
-(void)AddWeekLableToCalendarWatch{
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    for (int i = 0; i < 7; i++) {
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:array[i]];
        lable.textColor = [UIColor blackColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:13];
        lable.frame = CGRectMake(3+i*40+20, NAV_HEIGHT, 40, 38);
        lable.adjustsFontSizeToFitWidth = YES;
        //textAlignment = UITextAlignmentCenter;
        [self.view addSubview:lable];
        
    }
    UIView *xian = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+35, SELF_VIEW_WIDTH, 0.5)];
    xian.backgroundColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
    [self.view addSubview:xian];
}

//向日历中添加指定月份的日历butten
-(void)AddDaybuttenToCalendarWatch{
    for (int i = 0; i < 42; i++) {
        UIButton * butten = [[UIButton alloc]init];
        butten.frame = CGRectMake((i%7)*40+20, (i/7)*50+(40+NAV_HEIGHT), 40, 40);
        [butten.layer setCornerRadius:20];

        //        UIImage *bgImg1 = [UIImage imageNamed:@"Selected.png"];
        //        UIImage *bgImg2 = [UIImage imageNamed:@"Unselected.png"];
        //        [butten setImage:bgImg2 forState:UIControlStateNormal];
        //        [butten setImage:bgImg1 forState:UIControlStateSelected];
        [butten setTag:i+301];
        //        [butten addTarget:self action:@selector(buttenTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [butten addTarget:self action:@selector(buttenTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        butten.showsTouchWhenHighlighted = YES;
        UILabel* lable = [[UILabel alloc]init];
        lable.tag = i + 500;
        lable.text = [NSString stringWithString:dayArray[i]];
        lable.textColor = [UIColor blackColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(10, -15, 47, 60);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.font = [UIFont systemFontOfSize:13];
        UILabel* lurLable = [[UILabel alloc]init];
        lurLable.text = [NSString stringWithString:lunarDayArray[i]];
        lurLable.textColor = [UIColor blackColor];
        lurLable.backgroundColor = [UIColor clearColor];
        lurLable.font = [UIFont systemFontOfSize:10];
        lurLable.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        lurLable.frame = CGRectMake(10, 20, 47, 20);
        lurLable.tag = i +1000;
        lurLable.adjustsFontSizeToFitWidth = YES;
        [butten addSubview:lable];
        [butten addSubview:lurLable];
        [self.view addSubview:butten];
        
        if (butten.tag < 308 || butten.tag > 301+35) {
            lable.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        }
        for (int i = 0 ; i < 6 ; i++) {
            if (butten.tag == 301 + 7*i ) {
                lable.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
            }
        }

//        NSLog(@"%@",dayArray[i]);
//        NSLog(@"%lu",(unsigned long)lable.text.length);
        if (([[Datetime GetDay] intValue]== [dayArray[i] intValue])&&(strMonth == [[Datetime GetMonth] intValue])&&(strYear == [[Datetime GetYear] intValue])) {
            butten.backgroundColor = HEX_TO_UICOLOR(NAV_COLOR, 1.0);
            lable.textColor = [UIColor whiteColor];
            lurLable.textColor = [UIColor whiteColor];
            today = [dayArray[i] intValue];
            
            NSString *day;
            if ([[Datetime GetDay] intValue]<10) {
                day = [NSString stringWithFormat:@"0%i",[[Datetime GetDay] intValue]];
            }else{
                day = [NSString stringWithFormat:@"%i",[[Datetime GetDay] intValue]];
            }
            NSString *month;
            if (strMonth < 10) {
                month = [NSString stringWithFormat:@"0%i",strMonth];
            }else{
                month = [NSString stringWithFormat:@"%i",strMonth];
            }
            
            NSArray *arr = [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
            NSDictionary *dic = [[NSDictionary alloc]init];
            todayArr = [[NSMutableArray alloc]init];
            for (int i = 0; i< arr.count; i++) {
                dic = [arr objectAtIndex:i];
                if ([[dic objectForKey:@"date"] isEqualToString:[NSString stringWithFormat:@"%i-%@-%@",strYear,month,day]]) {
                    
                    
                    [todayArr addObject:dic];

                    [_mytableView reloadData];
                    [self tableHeight];
                    
                }
            }

        }
        
        
        //一共42个按钮多余的不让点了
        if(dayArray[i] == nil||[dayArray[i] isEqualToString:@" "] ){
            butten.userInteractionEnabled = NO;
        }
        //加点
        NSString *day;
        if ([dayArray[i] intValue]<10) {
            day = [NSString stringWithFormat:@"0%i",[dayArray[i]intValue]];
        }else{
            day = [NSString stringWithFormat:@"%@",dayArray[i]];
        }
        NSString *month;
        if (strMonth < 10) {
            month = [NSString stringWithFormat:@"0%i",strMonth];
        }else{
            month = [NSString stringWithFormat:@"%i",strMonth];
        }
        NSArray *remindArr = [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
        NSDictionary *dic = [[NSDictionary alloc]init];
        for (int i = 0; i < remindArr.count; i++) {
            
            dic = [remindArr objectAtIndex:i];
            NSString *remDate = [dic objectForKey:@"date"];
            if ([remDate isEqualToString:[NSString stringWithFormat:@"%i-%@-%@",strYear,month,day]]) {
               
                UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(17.5, 42, 4.5, 4.5)];
                image.image = [UIImage imageNamed:@"dot_@2x"];
                [butten addSubview:image];
            }
            
        }

    }
}
-(void)reloadDaybuttenToCalendarWatch{
    for (int i = 0; i < 42; i++)
        [[self.view viewWithTag:301+i] removeFromSuperview];
    [self AddDaybuttenToCalendarWatch];
}
-(void)buttenTouchUpInsideAction:(id)sender{
    NSInteger t = [sender tag]-301;
    dayArray = nil,lunarDayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    lunarDayArray = [Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
    
    for (int i = 0; i < 42; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i +301];
        
        UILabel *lable = (UILabel *)[self.view viewWithTag:i + 500];
        
        UILabel *lunarLab = (UILabel *)[self.view viewWithTag:i+1000];
        
        if ([ sender tag] == i +301){
            
            [btn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
            
            lable.textColor = [UIColor whiteColor];
            
            lunarLab.textColor = [UIColor whiteColor];
            
        }else{
            
            [btn setBackgroundColor:DEFAULT_COLOR];

            lable.textColor = [UIColor blackColor];
            
            if (i < 7 || i > 35) {
                lable.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
            }
            for (int a = 0 ; a < 6 ; a++) {
                if (i ==  7*a ) {
                    lable.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
                }
            }

            lunarLab.textColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
        }
    }
    
    calendarTitleLabel.text = [NSString stringWithFormat:@"%d年%d月%@日",strYear,strMonth,dayArray[t]];
    lunarTitleLabel.text = [NSString stringWithFormat:@"%@",[Datetime GetLunarDateTimeForYear:strYear month:strMonth date:[dayArray[t] intValue]]];
//    [Datetime GetLunarDateTimeForYear:strYear month:strMonth date:[dayArray[t] intValue]]
    NSLog(@"%d年%d月%@日",strYear,strMonth,dayArray[t]);
    NSLog(@"%@",[Datetime GetLunarDateTimeForYear:strYear month:strMonth date:[dayArray[t] intValue]]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]);
    NSString *day;
    if ([dayArray[t] intValue]<10) {
        day = [NSString stringWithFormat:@"0%i",[dayArray[t]intValue]];
    }else{
        day = [NSString stringWithFormat:@"%@",dayArray[t]];
    }
    NSString *month;
    if (strMonth < 10) {
        month = [NSString stringWithFormat:@"0%i",strMonth];
    }else{
        month = [NSString stringWithFormat:@"%i",strMonth];
    }
    NSLog(@"day ** %@",day);
    NSArray *remindArr = [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TIXING"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    todayArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < remindArr.count; i++) {
        
        dic = [remindArr objectAtIndex:i];
        NSString *remDate = [dic objectForKey:@"date"];
        if ([remDate isEqualToString:[NSString stringWithFormat:@"%i-%@-%@",strYear,month,day]]) {
            [todayArr addObject:dic];
            NSLog(@"todayArr ************/ = %@",todayArr);
        }
        
    }
    [self tableHeight];
    [_mytableView reloadData];

    
}

//添加左右滑动手势
-(void)AddHandleSwipe{
    //声明和初始化手势识别器
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
    //对手势识别器进行属性设定
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //把手势识别器加到view中去
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}
//左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);
    strMonth = strMonth+1;
    if(strMonth == 13){
        strYear++;strMonth = 1;
    }
    NSLog(@"%d,%d",strYear,strMonth);
    [todayArr removeAllObjects];
    [self reloadDateForCalendarWatch];
    //
    
    [self tableHeight];
    [_mytableView reloadData];
}
//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);
    strMonth = strMonth-1;
    if(strMonth == 0){
        strYear--;strMonth = 12;
    }
    NSLog(@"%d,%d",strYear,strMonth);
    [todayArr removeAllObjects];
    [self reloadDateForCalendarWatch];
    
    [self tableHeight];
    [_mytableView reloadData];
}
//在CalendarWatch中重新部署数据
-(void)reloadDateForCalendarWatch{
    dayArray = nil,lunarDayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    lunarDayArray =
    [Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
    [titleButten removeFromSuperview];
    [self reloadDaybuttenToCalendarWatch];
    [self AddNavigationBarToRootView];
    
    
}

////识别其他手势，预留接口
//-(void)OtherTouchEvent{
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
//    
//    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
//    //UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    /* step2：对手势识别器进行属性设定 */
//    [doubleTap setNumberOfTapsRequired:2];
//    // 坑：twoFingerTap在模拟器上不灵敏，有时候会识别成singleTap
//    [twoFingerTap setNumberOfTouchesRequired:2];
//    /* step3：把手势识别器加到view中去 */
//    [self.view addGestureRecognizer:singleTap];
//    [self.view addGestureRecognizer:doubleTap];
//    [self.view addGestureRecognizer:twoFingerTap];
//    [self.view addGestureRecognizer:rotation];
//    //[self.view addGestureRecognizer:pan];
//    [self.view addGestureRecognizer:pinch];
//    [self.view addGestureRecognizer:longPress];
//    /* step4：出现冲突时，要设定优先识别顺序，目前只是doubleTap、swipe */
//    //    [singleTap requireGestureRecognizerToFail:doubleTap];
//    //    [singleTap requireGestureRecognizerToFail:twoFingerTap];
//    //    [pan requireGestureRecognizerToFail:swipeRight];
//    //    [pan requireGestureRecognizerToFail:swipeLeft];
//}
////实现处理扑捉到手势之后的动作
///* 识别单击 */
//- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
//}
///* 识别双击 */
//- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
//}
///* 识别两个手指击 */
//- (void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecognizer {
//}
///* 识别翻转 */
//- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer {
//}
///* 识别拖动 */
//- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
//}
///* 识别放大缩小 */
//- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer {
//}
///* 识别长按 */
//- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
//}

- (void)CreateTableView{

    _height = (_HEIGHT == 480) ? 85 : 0;
    _mytableView = [[UITableView alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT - 54*3+_height, SELF_VIEW_WIDTH, todayArr.count)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_mytableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_mytableView];

    shang = [[UIView alloc]init];
    shang.backgroundColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
    [self.view addSubview:shang];
    
    xia = [[UIView alloc]init];
    xia.backgroundColor = HEX_TO_UICOLOR(0xb1b1b1, 1.0);
    [self.view addSubview:xia];
}
- (void)tableHeight
{
    NSInteger table_height;
    if (todayArr.count < 3 || todayArr.count == 3) {
        table_height = 54*todayArr.count;
    }
    else{
        table_height = 3*54-_height;
    }
    _mytableView.frame = FRAME(0, SELF_VIEW_HEIGHT - 54*3 - 10+_height, SELF_VIEW_WIDTH, table_height);
    
    shang.frame = FRAME(0, SELF_VIEW_HEIGHT - 54*3 - 10+0.5+_height, SELF_VIEW_WIDTH, 0.5);

    
    xia.frame = FRAME(0, SELF_VIEW_HEIGHT - 54*3 - 10+0.5 + table_height+_height, SELF_VIEW_WIDTH, 0.5);

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return todayArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    CalendarCell *Cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (Cell == nil) {
        Cell = [[CalendarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
//    [_mytableView setDelaysContentTouches:NO];
//    Cell.backgroundView = nil;

    Cell.tag = indexPath.row;
    
    Cell.title.text = [[todayArr objectAtIndex:indexPath.row]objectForKey:@"biaoti"];
    Cell.detailLab.text = [NSString stringWithFormat:@"%@  %@",[[todayArr objectAtIndex:indexPath.row]objectForKey:@"time"],
                                                               [[todayArr objectAtIndex:indexPath.row]objectForKey:@"date"]];
    
    return Cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"23342345235");
}

@end
