//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"
#import <CoreText/CoreText.h>
@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
//    UILabel *monthLabel;
//    UILabel *yearLabel;
//    UILabel *weekLabel;
}

@end

@implementation JTCalendarMenuMonthView

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
    {
        [textLabel removeFromSuperview];
        textLabel = [[UILabel alloc]init];
        [self addSubview:textLabel];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setMonthIndex:(NSDate *)monthIndex
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:monthIndex];
    
    NSDateFormatter  *yearformatter=[[NSDateFormatter alloc] init];
    
    [yearformatter setDateFormat:@"yyyy"];
    
    NSString *  yearString=[yearformatter stringFromDate:monthIndex];
    
    NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
    
    [monthformatter setDateFormat:@"MM"];
    
    NSString *  monthString=[monthformatter stringFromDate:monthIndex];
    
    NSDateFormatter  *dayformatter=[[NSDateFormatter alloc] init];
    
    [dayformatter setDateFormat:@"dd"];
    NSString *  dayString=[dayformatter stringFromDate:monthIndex];
    //    NSLog(@"时间%@",locationString);
    [textLabel removeFromSuperview];
    textLabel = [[UILabel alloc]init];
    [self addSubview:textLabel];
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    int month=[monthString intValue];
    UILabel *monthLabel = [[UILabel alloc]init];
    monthLabel.text=[NSString stringWithFormat:@"%d月",month];
    monthLabel.textColor=[UIColor whiteColor];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.font=[UIFont fontWithName:@"Heiti SC" size:30];
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc]initWithString:monthLabel.text];
    long number = 0.1f;//间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    [monthLabel setAttributedText:attributedString];
    
    monthLabel.numberOfLines = 1;
    [monthLabel sizeToFit];
    monthLabel.frame=CGRectMake(10, 5, monthLabel.frame.size.width, self.frame.size.height-10);
    [textLabel addSubview:monthLabel];
    
    
    
    UILabel *yearLabel = [[UILabel alloc]init];
    yearLabel.text=[NSString stringWithFormat:@"%@年",yearString];
    yearLabel.textColor=[UIColor whiteColor];
    yearLabel.textAlignment = NSTextAlignmentLeft;
    yearLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    yearLabel.numberOfLines = 1;
    [yearLabel sizeToFit];
    yearLabel.frame=CGRectMake(monthLabel.frame.size.width+10, (self.frame.size.height-30)/2+15, yearLabel.frame.size.width, 15);
    [textLabel addSubview:yearLabel];
    
    
    UILabel *weekLabel = [[UILabel alloc]init];
    weekLabel.text=[NSString stringWithFormat:@"%@",[weekdays objectAtIndex:theComponents.weekday]];
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.textAlignment = NSTextAlignmentLeft;
    weekLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    weekLabel.numberOfLines = 1;
    [weekLabel sizeToFit];
    weekLabel.frame=CGRectMake(monthLabel.frame.size.width+10, (self.frame.size.height-30)/2, weekLabel.frame.size.width, 15);
    [textLabel addSubview:weekLabel];
    
    UILabel *dayLabel = [[UILabel alloc]init];
    dayLabel.text=[NSString stringWithFormat:@"%@日",dayString];
    dayLabel.textColor=[UIColor whiteColor];
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    dayLabel.numberOfLines = 1;
    [dayLabel sizeToFit];
    dayLabel.frame=CGRectMake(weekLabel.frame.size.width+weekLabel.frame.origin.x, (self.frame.size.height-30)/2, dayLabel.frame.size.width, 15);
//    [textLabel addSubview:dayLabel];
}

- (void)layoutSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{
    textLabel.textColor = self.calendarManager.calendarAppearance.menuMonthTextColor;
    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
    
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
