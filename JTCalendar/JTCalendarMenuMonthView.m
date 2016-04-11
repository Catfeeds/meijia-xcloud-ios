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
    UILabel *monthLabel;
    UILabel *yearLabel;
    UILabel *weekLabel;
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
        textLabel = [UILabel new];
        [self addSubview:textLabel];
       
        
        textLabel.textAlignment = NSTextAlignmentLeft;
//        textLabel.backgroundColor=[UIColor whiteColor];
        textLabel.numberOfLines = 1;
        
        
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    
//    NSString *  locationString=[dateformatter stringFromDate:currentDate];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:currentDate];
    
    NSDateFormatter  *yearformatter=[[NSDateFormatter alloc] init];
    
    [yearformatter setDateFormat:@"YYYY"];
    
    NSString *  yearString=[yearformatter stringFromDate:currentDate];
    
    NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
    
    [monthformatter setDateFormat:@"MM"];
    
    NSString *  monthString=[monthformatter stringFromDate:currentDate];
//    NSLog(@"时间%@",locationString);
    [monthLabel removeFromSuperview];
    [yearLabel removeFromSuperview];
    [weekLabel removeFromSuperview];
    int month=[monthString intValue];
    monthLabel = [UILabel new];
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
    
    
    
    yearLabel = [UILabel new];
    yearLabel.text=[NSString stringWithFormat:@"%@年",yearString];
    yearLabel.textColor=[UIColor whiteColor];
    yearLabel.textAlignment = NSTextAlignmentLeft;
    yearLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    yearLabel.numberOfLines = 1;
    [yearLabel sizeToFit];
    yearLabel.frame=CGRectMake(monthLabel.frame.size.width+10, (self.frame.size.height-30)/2+15, yearLabel.frame.size.width, 15);
    [textLabel addSubview:yearLabel];
    
    
    weekLabel = [UILabel new];
    weekLabel.text=[NSString stringWithFormat:@"%@",[weekdays objectAtIndex:theComponents.weekday]];
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.textAlignment = NSTextAlignmentLeft;
    weekLabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    weekLabel.numberOfLines = 1;
    [weekLabel sizeToFit];
    weekLabel.frame=CGRectMake(monthLabel.frame.size.width+10, (self.frame.size.height-30)/2, weekLabel.frame.size.width, 15);
    [textLabel addSubview:weekLabel];
    
    
    
    
    
    
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
