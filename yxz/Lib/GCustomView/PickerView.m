//
//  PickerView.m
//  simi
//
//  Created by zrj on 14-11-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "PickerView.h"
#import "ChoiceDefine.h"
@implementation PickerView
@synthesize HidDelegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 1, self_Width, 38)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
        quxiao.frame = FRAME(16, 10, 40, 20);
        quxiao.titleLabel.font = [UIFont systemFontOfSize:13];
        [quxiao setTitle:@"取消" forState:UIControlStateNormal];
        [quxiao setTitleColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0) forState:UIControlStateNormal];
        [quxiao addTarget:self action:@selector(quxiaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quxiao];
        
        UIButton *queding = [UIButton buttonWithType:UIButtonTypeCustom];
        queding.frame = FRAME(self_Width-16-25-14, 10, 40, 20);
        queding.titleLabel.font = [UIFont systemFontOfSize:13];
        [queding setTitle:@"确定" forState:UIControlStateNormal];
        [queding setTitleColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0) forState:UIControlStateNormal];
        [queding addTarget:self action:@selector(quedingAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:queding];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(16, 10, self_Width-32, 20)];
        lable.text = @"到达时间有半小时浮动";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        lable.font = [UIFont systemFontOfSize:13];
        [view addSubview:lable];
        
        
        pickerView = [[UIPickerView alloc]initWithFrame:FRAME(0, 40, self_Width, 180)];
        pickerView.backgroundColor = [UIColor whiteColor];
        //    指定Delegate
        pickerView.delegate= self;
        pickerView.dataSource = self;
        
        //    显示选中框
        pickerView.showsSelectionIndicator=YES;
        [self addSubview:pickerView];
        //  pickerView.hidden = YES;
        hoursArray = [[NSMutableArray alloc]initWithObjects:@"08点",@"09点",@"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点",nil];
        MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
        
        [self getDate];
        
        //判断大于13:30的时候去掉30分钟
        BOOL time13 = [self compareTimestring:@"13:30:00"];
        if (time13 == NO) {
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分", nil];
            [pickerView reloadComponent:2];
        }
        
        
        
        //判断大于14:00:00的时候
        BOOL night = [self compareTimestring:@"14:00:00"];
        BOOL ningt18 = [self compareTimestring:@"18:00:00"];
        if (night == NO) {
            NSLog(@"大于14:00");
            hoursArray = [[NSMutableArray alloc]initWithObjects:@"08点",@"09点",@"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
            [pickerView reloadComponent:1];
            
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView reloadComponent:2];
            
            [dateArray removeObjectAtIndex:0];
            [pickerView reloadComponent:0];
            
            if (ningt18 != NO) {
                return self;
            }
        }

        //判断大于18:00:00的时候只能下第二天12点以后的单子
        
        
        if (ningt18 == NO) {
            hoursArray = [[NSMutableArray alloc]initWithObjects:@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
            [pickerView reloadComponent:1];
            
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView reloadComponent:2];
            return self;
        }
        
        
        
        //判断时间小于凌晨8:00的时候
        BOOL AGO = [self compareTimeAGO];
        if (AGO == YES) {
            
            hoursArray = [[NSMutableArray alloc]initWithObjects:@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
            [pickerView reloadComponent:1];
            
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView reloadComponent:2];
            return self;
        }
        
        NSInteger row = (NSInteger )[self getTime];
        if ([pickerView viewForRow:0 forComponent:0]) {
            //不满足4小时派工条件的小时去掉
            NSMutableArray *timeArr = [[NSMutableArray alloc]init];
            
            timeArr = hoursArray;
            
            for (int i = 0; i < row; i++) {
                [timeArr removeObjectAtIndex:0];
                hoursArray = timeArr;
                
            }
            [pickerView reloadComponent:1];
        }
        
        //判断分钟
       NSInteger minuteRow = [self getMinute];
        
        if (minuteRow == 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        if (minuteRow <= 30) {
            [MinutesArray removeObjectAtIndex:0];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        if (minuteRow > 30) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [hoursArray removeObjectAtIndex:0];
            [pickerView reloadInputViews];
        }
        

    }
    
    

    return self;
}
- (NSInteger )getTime
{
    // 获得本地时间指定时区
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];
    
    NSInteger f = [[formatter stringFromDate:firstDate] intValue] - 4;
    NSLog(@"%d",f);
    
    return f;
}
- (NSInteger )getMinute
{
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];

    NSLog(@"firsdate: %@",firstDate);

    NSInteger minute = [[[NSString stringWithFormat:@"%@",firstDate] substringWithRange:NSMakeRange(14, 2)] intValue];
    
    return minute;
}
- (BOOL )compareTimestring:(NSString *)str
{
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];
    
    NSDate *secondDate = [self stringToDate:str];
    
    NSComparisonResult result = [firstDate compare:secondDate];
    
    if (result == 1) {
        return NO;
    }else{
        return YES;
    }

}
- (BOOL )compareTimeAGO
{
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];
    
    NSDate *secondDate = [self stringToDate:@"08:00:00"];
    
    NSComparisonResult result = [firstDate compare:secondDate];
    
    if (result == 1) {
        return NO;
    }else{
        return YES;
    }
    
}
- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
- (void)quxiaoAction:(UIButton *)sender
{
    [self.HidDelegate quxiao];

}
- (void)quedingAction:(UIButton *)sender
{
    NSInteger row =[pickerView selectedRowInComponent:0];
    
    NSInteger row1 = [pickerView selectedRowInComponent:1];
    
    NSInteger row2 = [pickerView selectedRowInComponent:2];
    
    
    
    BOOL ningt18 = [self compareTimestring:@"18:00:00"];
    if (ningt18 == NO) {
        [self getDate];
        [dateArray removeObjectAtIndex:0];
    }
    
    [self.HidDelegate queding:[dateArray objectAtIndex:row] hours:[hoursArray objectAtIndex:row1] minutes:[MinutesArray objectAtIndex:row2]];

}
-  (void)getDate
{
    //获取时间
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YY年MM月dd日"];
    
    today=[dateformatter stringFromDate:senddate];
    
    NSLog(@"今天:%@",today);
    
    //最近30天的日期
    dateArray = [NSMutableArray array];
    
    for (int i = 0; i < 30 ; i++) {
        NSTimeInterval  interval = 24*60*60*(i+0);
        
        NSDate *d = [[NSDate alloc] initWithTimeIntervalSinceNow:+interval];
        
        mingtian = [dateformatter stringFromDate:d];
        
        //    NSLog(@"日期%@",mingtian);
        [dateArray addObject:mingtian];
        
    }

}
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component){
        case 0:
            return [dateArray count];
        case 1:
            return [hoursArray count];
        case 2:
            return [MinutesArray count];
    }
    return 0;
}
#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component){
        case 0:
            return [dateArray objectAtIndex:row];
        case 1:
            return [hoursArray objectAtIndex:row];
        case 2:
            return [MinutesArray objectAtIndex:row];
    }
    return nil;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView1 viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)] ;
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [dateArray objectAtIndex:row];
        
        myView.textColor = [UIColor blackColor];
        
        myView.font = [UIFont systemFontOfSize:15];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
    
    
    }else if(component == 1){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [hoursArray objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.textColor = [UIColor blackColor];
        
        myView.font = [UIFont systemFontOfSize:16];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [MinutesArray objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.textColor = [UIColor blackColor];
        
        myView.font = [UIFont systemFontOfSize:16];
        
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
    
}
- (void)pickerView:(UIPickerView *)pickerView2 didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1 && row ==0) {
        //判断分钟
        NSInteger minuteRow = [self getMinute];
        
        if (minuteRow == 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        if (minuteRow <= 30) {
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"30分", nil];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        if (minuteRow > 30) {
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:1];
        }
    }else if(component == 1 && row !=0){
        MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
        [pickerView reloadComponent:2];
    }
    if (row == hoursArray.count-1) {
        MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分", nil];
        [pickerView reloadComponent:2];
    }
    [self getDate];
    
    if (component != 0) {
        return;
    }
    //判断大于14:00:00的时候
    BOOL night = [self compareTimestring:@"14:00:00"];
    BOOL ningt18 = [self compareTimestring:@"18:00:00"];
    if (night == NO) {
        NSLog(@"大于14:00");
        hoursArray = [[NSMutableArray alloc]initWithObjects:@"08点",@"09点",@"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
        [pickerView reloadComponent:1];
        
        MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
        [pickerView reloadComponent:2];
        
        [dateArray removeObjectAtIndex:0];
        [pickerView reloadComponent:0];
        
        if (ningt18 != NO) {
            return;
        }
    }
    
    //判断大于18:00:00的时候只能下第二天12点以后的单子
    
    if (component == 0 && row == 0) {
        if (ningt18 == NO) {
            hoursArray = [[NSMutableArray alloc]initWithObjects:@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
            [pickerView reloadComponent:1];
            
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView reloadComponent:2];
            return;
        }
        
        //判断时间小于凌晨8:00的时候
        BOOL AGO = [self compareTimeAGO];
        if (AGO == YES) {
            
            hoursArray = [[NSMutableArray alloc]initWithObjects:@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
            [pickerView reloadComponent:1];
            
            MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
            [pickerView reloadComponent:2];
            return;
        }
    }

    
    NSInteger row1 = (NSInteger )[self getTime];
    if (row1+4 >4 && row1+4 <19 && component == 0 && row == 0) {
        
        //不满足4小时派工条件的小时去掉
        NSMutableArray *timeArr = [[NSMutableArray alloc]init];
        
        timeArr = hoursArray;
        
        NSInteger hang = (NSInteger )[self getTime];
        for (int i = 0; i < hang; i++) {
            if (timeArr.count >1) {
                [timeArr removeObjectAtIndex:0];
            }
            
            hoursArray = timeArr;
            
        }
        [pickerView reloadComponent:1];
        
    
        //判断分钟
        NSInteger minuteRow = [self getMinute];
        
        if (minuteRow == 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        if (minuteRow <= 30) {
            [MinutesArray removeObjectAtIndex:0];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        if (minuteRow > 30) {
            
            
            [pickerView selectRow:0 inComponent:2 animated:NO];
            if (hoursArray.count >1) {
                [hoursArray removeObjectAtIndex:0];
            }
            
            [pickerView reloadComponent:1];
        }
        
        return;
    }
    
    if (component == 0 && row == 0) {

        
    }else if(component ==0 && row != 0){

        hoursArray = [[NSMutableArray alloc]initWithObjects:@"08点",@"09点",@"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点", nil];
        [pickerView reloadComponent:1];

        MinutesArray = [[NSMutableArray alloc]initWithObjects:@"00分",@"30分", nil];
        [pickerView reloadComponent:2];
    }
    
    
    
    if(component == 0 && row == 0){
        //判断分钟
        NSInteger minuteRow = [self getMinute];
        
        if (minuteRow == 0) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
        if (minuteRow <= 30) {
            [MinutesArray removeObjectAtIndex:0];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        if (minuteRow > 30) {

            
            [pickerView selectRow:0 inComponent:2 animated:NO];
            if (hoursArray.count >1) {
                [hoursArray removeObjectAtIndex:0];
            }
            
            [pickerView reloadInputViews];
        }

    }
    
}

@end
