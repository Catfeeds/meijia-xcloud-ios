//
//  MeetingPickerView.m
//  simi
//
//  Created by 白玉林 on 15/8/13.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MeetingPickerView.h"
#import "ChoiceDefine.h"
@implementation MeetingPickerView
{
    NSDateFormatter *dateFormatter;
}
@synthesize meetingDatePicker,delegate =_delegate;

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
        lable.text = @"出发日期";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
        lable.font = [UIFont systemFontOfSize:13];
        [view addSubview:lable];
        
        NSDate *currentTime = [NSDate date];
        
        //创建时间选取器
        meetingDatePicker = [[UIDatePicker alloc]initWithFrame:FRAME(0, 40, self_Width, 230)];
        
        meetingDatePicker.backgroundColor = [UIColor whiteColor];
        
        //创建时间格式化实例对象
        dateFormatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //将时间字符串转换成NSDate类型的时间。dateFromString方法。
        //NSDate *tempDate = [dateFormatter dateFromString:[self.myDatabase getTaskDateByID:idFromCellTag]];
        
        //设置中文显示
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        [self.meetingDatePicker setLocale:locale];
        
        //显示任务的时间。
        //        [self.datePicker setDate:tempDate];
        
        //123 设置时间选取器的语言。
        //[self.m_pDatepicker setAccessibilityLanguage:@"Chinese"];
        
        
        [meetingDatePicker setTimeZone:[NSTimeZone defaultTimeZone]];
        
        [meetingDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
        
        //设置当前时间
        
        [meetingDatePicker setDate:currentTime animated:YES];
        NSLog(@"当前时间%@" ,currentTime);
        //设置最大显示时间
        
        [meetingDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        
        [meetingDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:meetingDatePicker];
        
    }
    return self;
}

-(void)datePickerValueChanged:(id)sender
{
    NSDate *selected = [meetingDatePicker date];
    
    NSLog(@"date = %@",selected);
}
- (void)quxiaoAction:(UIButton *)sender
{
    [self.delegate meetingDateQuxiao];
}
- (void)quedingAction:(UIButton *)btn
{
    NSDate *selected = [meetingDatePicker date];
    
    NSString *str = [dateFormatter stringFromDate:selected];
    
    NSString *str2 = [str substringToIndex:19];
    
    NSLog(@"确定  date = %@",str);
    
    [self.delegate meetingDateQueding:str2];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
