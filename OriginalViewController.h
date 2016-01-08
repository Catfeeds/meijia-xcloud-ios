//
//  OriginalViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/11.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "JTCalendar.h"
@interface OriginalViewController : FatherViewController<JTCalendarDataSource>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@end
