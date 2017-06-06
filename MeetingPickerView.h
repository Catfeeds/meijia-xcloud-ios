//
//  MeetingPickerView.h
//  simi
//
//  Created by 白玉林 on 15/8/13.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol meetingPickerDelegate <NSObject>

- (void)meetingDateQuxiao;

- (void)meetingDateQueding:(NSString *)date;

@end

@interface MeetingPickerView : UIView
{
    __weak id<meetingPickerDelegate>_delegate;
    
    UIDatePicker *datePicker;
}

@property (nonatomic ,weak) id<meetingPickerDelegate>delegate;

@property (nonatomic ,retain) UIDatePicker *meetingDatePicker;
@end
