//
//  TixingTimePicker.h
//  simi
//
//  Created by zrj on 15-1-15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TixingTimePic <NSObject>

- (void)timepicCanle;

- (void)TimePicSure:(NSString *)timeStr;

@end

@interface TixingTimePicker : UIView
{
    __weak id<TixingTimePic>_delegate;
    
     UIDatePicker *datePicker;
}

@property (nonatomic, weak) id<TixingTimePic>delegate;
@property (nonatomic ,retain) UIDatePicker *datePicker;

@end
