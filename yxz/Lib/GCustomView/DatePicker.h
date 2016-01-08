//
//  DatePicker.h
//  simi
//
//  Created by zrj on 14-11-27.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol datePicDelegate <NSObject>

- (void)dateQuxiao;

- (void)dateQueding:(NSString *)date;

@end

@interface DatePicker : UIView
{
    __weak id<datePicDelegate>_delegate;
    
    UIDatePicker *datePicker;
}

@property (nonatomic ,weak) id<datePicDelegate>delegate;

@property (nonatomic ,retain) UIDatePicker *datePicker;

@end
